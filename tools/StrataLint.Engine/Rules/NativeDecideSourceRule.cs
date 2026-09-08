using System.Collections.Immutable;

namespace StrataLint.Engine;

internal static class NativeDecideSourceRule
{
    internal static bool IsApplicable(RepositoryFile artifact, RuleApplicabilityContext context) =>
        IsD5Lean(artifact.Path);

    internal static bool IsAffectedBy(RuleEvaluationContext context) => SelectedPaths(context).Any();

    internal static ImmutableArray<RuleFinding> Evaluate(RuleEvaluationContext context)
    {
        var findings = ImmutableArray.CreateBuilder<RuleFinding>();
        foreach (var path in SelectedPaths(context).OrderBy(static path => path.Value, StringComparer.Ordinal))
        {
            try
            {
                var tokens = LeanSourceTokenizer.TokenizeIncludingInterpolationTerms(context.Current.Files[path].Text);
                foreach (var token in tokens.Where(static token => token.Text == "native_decide"))
                {
                    findings.Add(new RuleFinding(path.Value,
                        $"NATIVE_DECIDE_SOURCE line={token.Line}: bare native_decide token is forbidden in changed D5 Lean source"));
                }
            }
            catch (LeanSourceExtractionException exception)
            {
                findings.Add(new RuleFinding(path.Value,
                    $"NATIVE_DECIDE_LEXICAL_ERROR line={exception.Line ?? 1}: {exception.Message}"));
            }
        }

        return findings.ToImmutable();
    }

    private static IEnumerable<RepoPath> SelectedPaths(RuleEvaluationContext context) =>
        context.Changes.Paths.Distinct().Where(path =>
            IsD5Lean(path)
            && context.Current.Files.TryGetValue(path, out var current)
            && (!context.Baseline.Files.TryGetValue(path, out var baseline)
                || !current.RawBytes.AsSpan().SequenceEqual(baseline.RawBytes.AsSpan())));

    private static bool IsD5Lean(RepoPath path) =>
        path.Value.StartsWith("D5/", StringComparison.Ordinal)
        && path.Value.EndsWith(".lean", StringComparison.Ordinal);
}
