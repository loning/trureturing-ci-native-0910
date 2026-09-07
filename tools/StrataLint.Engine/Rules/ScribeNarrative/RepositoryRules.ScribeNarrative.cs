using System.Collections.Immutable;

namespace StrataLint.Engine;

internal static partial class RepositoryRules
{
    private static ImmutableArray<RuleFinding> ScribeNarrativeProvenance(RuleEvaluationContext context)
    {
        // Keep this local: IsBaseFactAffected includes every file when the judge changes.
        var paths = context.Changes.Paths
            .Where(path => IsBlueprintPath(path.Value, ".scribe.cs") && context.Current.Files.ContainsKey(path))
            .ToImmutableArray();
        var moves = ScribeNarrativeMoves(context);
        return paths.Where(path => !moves.Contains(path))
            .SelectMany(path => ScribeNarrativeScanner.Scan(context.Current.Files[path].Text)
                .Select(finding => new RuleFinding(path.Value, finding.Message)))
            .ToImmutableArray();
    }

    private static ImmutableHashSet<RepoPath> ScribeNarrativeMoves(RuleEvaluationContext context)
    {
        var deleted = context.Changes.Entries
            .Where(entry => entry.Kind is RawChangeKind.Deleted
                && IsBlueprintPath(entry.Path.Value, ".scribe.cs")
                && context.Baseline.Files.ContainsKey(entry.Path))
            .GroupBy(entry => context.Baseline.Files[entry.Path].Text, StringComparer.Ordinal)
            .ToDictionary(group => group.Key, group => group.Count(), StringComparer.Ordinal);
        // Ambiguous equal-text groups are judged in full, including one deletion and two adds.
        return context.Changes.Entries
            .Where(entry => entry.Kind is RawChangeKind.Added
                && IsBlueprintPath(entry.Path.Value, ".scribe.cs")
                && context.Current.Files.ContainsKey(entry.Path))
            .GroupBy(entry => context.Current.Files[entry.Path].Text, StringComparer.Ordinal)
            .Where(group => group.Count() == 1 && deleted.GetValueOrDefault(group.Key) == 1)
            .Select(group => group.Single().Path)
            .ToImmutableHashSet();
    }
}
