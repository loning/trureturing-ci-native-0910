using System.Collections.Immutable;
using System.Text;
using System.Text.Json;
using StrataLint.Engine;

namespace StrataLint.Cli;

internal static partial class CoverBatchCommand
{
    internal static CommandResult Run(
        string repositoryRoot,
        IRepositoryGateway repository,
        ILeanReportSource leanReportSource,
        IScribeEmissionVerifier? scribeEmissionVerifier,
        DateTimeOffset recordedAtUtc,
        IReadOnlyList<string> arguments,
        Func<CommandResult>? emit = null,
        Func<RawRepositorySnapshot>? readInputs = null)
    {
        BatchArguments options;
        try
        {
            options = Parse(repositoryRoot, arguments);
        }
        catch (Exception exception) when (exception is not OutOfMemoryException)
        {
            return new(false, string.Empty, $"COVER_BATCH_INPUT_INVALID {exception.Message}\n", 2);
        }

        CoverAtomCommand.Session session;
        BatchPlan plan;
        try
        {
            if (scribeEmissionVerifier is null)
                throw new InvalidOperationException("Scribe emission verifier is unavailable");
            session = new CoverAtomCommand.Session(repositoryRoot, repository, leanReportSource,
                scribeEmissionVerifier, recordedAtUtc, options.BaseRevision, options.Items[0].Gids[0]);
            plan = Plan(options.Items, session.Document);
            var expected = Inputs(session.CurrentRaw);
            readInputs ??= () => GitRepositorySnapshotReader.ReadCurrent(repositoryRoot,
                static path => !IngestCommand.IsLedgerPath(path));
            session.ValidateInputs = () => RequireSameInputs(expected, Inputs(readInputs()));
        }
        catch (BatchInputException exception)
        {
            return new(false, string.Empty, $"COVER_BATCH_INPUT_INVALID {exception.Message}\n", 2);
        }
        catch (Exception exception) when (exception is not OutOfMemoryException)
        {
            var output = new StringBuilder();
            foreach (var item in options.Items)
                Render(output, item, "blocked", "shared context unavailable: " + exception.Message);
            return new(false, output.ToString(), $"COVER_BATCH_ABORTED {exception.Message}\n", 1);
        }

        var results = new StringBuilder();
        var failures = new Dictionary<string, string>(StringComparer.Ordinal);
        string? aborted = null;
        var successful = true;
        foreach (var atomId in plan.Order)
        {
            var dependencyFailure = plan.Children[atomId].Select(child => failures.GetValueOrDefault(child))
                .FirstOrDefault(reason => reason is not null);
            if (!plan.Items.TryGetValue(atomId, out var item))
            {
                if (dependencyFailure is not null) failures[atomId] = dependencyFailure;
                continue;
            }

            if (aborted is not null || dependencyFailure is not null)
            {
                successful = false;
                var reason = aborted is not null ? "batch aborted: " + aborted : "dependency failed: " + dependencyFailure;
                failures[atomId] = dependencyFailure ?? atomId;
                Render(results, item, "blocked", reason);
                continue;
            }

            var existing = session.Document.RequireDigestionEntries()
                .Where(entry => entry.AtomId == atomId).ToArray();
            var alreadyApplied = existing.Length == 1 && item.Gids.All(existing[0].CoverageGids.Contains);
            var result = session.Apply(atomId, item.Gids);
            var reasonText = result.Error.Trim();
            if (!result.Success)
            {
                successful = false;
                failures[atomId] = atomId;
                if (!session.Invalidated)
                {
                    try { session.RequireUnchanged(); }
                    catch (Exception exception) when (exception is not OutOfMemoryException)
                    {
                        reasonText += "; " + exception.Message;
                    }
                }
                if (session.Invalidated) aborted = reasonText;
            }
            Render(results, item, result.Success ? alreadyApplied ? "already_applied" : "applied" : "failed",
                result.Success ? alreadyApplied ? "coverage bindings validated" : "coverage committed" : reasonText);
        }

        if (aborted is not null)
            return new(false, results.ToString(), $"COVER_BATCH_ABORTED {aborted}\n", 1);

        CommandResult emission;
        try { emission = (emit ?? (() => Emit(repositoryRoot)))(); }
        catch (Exception exception) when (exception is not OutOfMemoryException)
        {
            emission = new(false, string.Empty, $"COVER_BATCH_EMIT_FAILED {exception.Message}\n");
        }
        successful &= emission.Success;
        return new(successful, results + emission.Output, emission.Error, successful ? 0 : 1);
    }

    private static Dictionary<string, RawRepositoryEntry> Inputs(RawRepositorySnapshot snapshot) =>
        snapshot.Entries.Where(static entry => !IngestCommand.IsLedgerPath(entry.Path))
            .ToDictionary(static entry => entry.Path, StringComparer.Ordinal);

    private static void RequireSameInputs(IReadOnlyDictionary<string, RawRepositoryEntry> expected,
        IReadOnlyDictionary<string, RawRepositoryEntry> actual)
    {
        var mismatch = expected.Keys.Union(actual.Keys, StringComparer.Ordinal)
            .Order(StringComparer.Ordinal).FirstOrDefault(path =>
                !expected.TryGetValue(path, out var before) || !actual.TryGetValue(path, out var after)
                || !before.Bytes.AsSpan().SequenceEqual(after.Bytes.AsSpan()));
        if (mismatch is not null)
            throw new InvalidOperationException($"shared cover context changed: {mismatch}");
    }

    private static void Render(StringBuilder output, BatchItem item, string status, string reason) =>
        output.Append("COVER_BATCH ").Append(JsonSerializer.Serialize(new
        {
            atom_id = item.AtomId,
            status,
            lines = item.Lines,
            reason,
        })).Append('\n');

    private static CommandResult Emit(string root)
    {
        var result = BoundedProcessRunner.Run("make", ["emit"], root,
            BoundedProcessRunner.HangDetectionBudget, 64 * 1024 * 1024);
        return new(result.ExitCode == 0, Encoding.UTF8.GetString(result.StandardOutput),
            Encoding.UTF8.GetString(result.StandardError));
    }
}
