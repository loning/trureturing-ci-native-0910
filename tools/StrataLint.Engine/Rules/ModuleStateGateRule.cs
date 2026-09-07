using System.Collections.Immutable;

namespace StrataLint.Engine;

// SL-034. New closed content modules must enter the frozen-state graph together
// with their source declaration. Baseline modules are intentionally outside this
// transition check so existing debt does not become a new admission failure.
internal static class ModuleStateGateRule
{
    internal static bool IsApplicable(RepositoryFile artifact, RuleApplicabilityContext context) =>
        IsD5Lean(artifact.Path.Value);

    internal static bool IsAffectedBy(RuleEvaluationContext context) =>
        context.Changes.Entries.Any(change => IsCandidateAddition(context, change));

    internal static ImmutableArray<RuleFinding> Evaluate(RuleEvaluationContext context)
    {
        var states = LeanTruthStates.Resolve(context.Current, context.Lean);
        var findings = ImmutableArray.CreateBuilder<RuleFinding>();
        foreach (var change in context.Changes.Entries
                     .Where(change => IsCandidateAddition(context, change))
                     .OrderBy(static change => change.Path.Value, StringComparer.Ordinal))
        {
            if (change.Path.Value.StartsWith("D5/X_Frontier/", StringComparison.Ordinal)
                || !states.TryGetValue(change.Path, out var state)
                || state is not TruthState.Closed)
            {
                continue;
            }

            if (!FrozenStatePath.TryFromModulePath(change.Path, out var statePath))
            {
                findings.Add(new RuleFinding(
                    change.Path.Value,
                    $"MODULE_STATE_INPUT_INVALID module={change.Path.Value}: "
                    + "path does not encode a canonical repository Lean module",
                    AdmissionEffect.Block));
                continue;
            }

            if (!context.Current.Files.ContainsKey(statePath))
            {
                findings.Add(new RuleFinding(
                    change.Path.Value,
                    $"MODULE_STATE_MISSING module={change.Path.Value}: "
                    + $"Closed module requires {statePath.Value}"));
            }
        }

        return findings.ToImmutable();
    }

    private static bool IsCandidateAddition(RuleEvaluationContext context, RawChange change) =>
        change.Kind is RawChangeKind.Added
        && IsD5Lean(change.Path.Value)
        && context.Current.Files.ContainsKey(change.Path)
        && !context.Baseline.Files.ContainsKey(change.Path);

    private static bool IsD5Lean(string path) =>
        path.StartsWith("D5/", StringComparison.Ordinal)
        && path.EndsWith(".lean", StringComparison.Ordinal);
}
