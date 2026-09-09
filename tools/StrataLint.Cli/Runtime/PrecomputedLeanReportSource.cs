using StrataLint.Engine;

namespace StrataLint.Cli;

internal sealed class PrecomputedLeanReportSource(string repositoryRoot) : ILeanReportSource
{
    private readonly string reportPath = LeanCompiledArtifactReports.ResolveReportPath(repositoryRoot);

    public LeanSourceContextInput LoadSourceContext(RepositorySnapshot current, RepositorySnapshot protectedBase) =>
        LeanSourceContextArtifact.ReadBundle(reportPath, current, protectedBase);

    public LeanAxiomReport Load(RepositorySnapshot snapshot) =>
        RawLeanReportArtifact.ReadFile(reportPath, snapshot);
}
