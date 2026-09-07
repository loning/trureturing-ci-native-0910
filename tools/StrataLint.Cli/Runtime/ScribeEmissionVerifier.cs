using System.Reflection;
using StrataLint.Engine;
using StrataLint.Scribe;
using StrataLint.Scribe.Documents;

namespace StrataLint.Cli;

internal sealed class MaterializedRepositorySnapshot : IDisposable
{
    private MaterializedRepositorySnapshot(string root) => Root = root;

    internal string Root { get; }

    internal static MaterializedRepositorySnapshot Create(RepositorySnapshot snapshot)
    {
        ArgumentNullException.ThrowIfNull(snapshot);
        var root = Path.Combine(
            Path.GetTempPath(),
            "stratalint-snapshot-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(root);
        try
        {
            foreach (var (path, file) in snapshot.Files
                .OrderBy(static item => item.Key.Value, StringComparer.Ordinal))
            {
                var destination = Path.Combine(
                    root,
                    path.Value.Replace('/', Path.DirectorySeparatorChar));
                Directory.CreateDirectory(Path.GetDirectoryName(destination)
                    ?? throw new InvalidOperationException("snapshot path has no parent directory"));
                File.WriteAllBytes(destination, file.RawBytes.AsSpan());
            }

            return new MaterializedRepositorySnapshot(root);
        }
        catch
        {
            Directory.Delete(root, recursive: true);
            throw;
        }
    }

    public void Dispose() => Directory.Delete(Root, recursive: true);
}

internal interface IScribeEmissionVerifier
{
    VerifiedScribeEmissions Verify(
        RepositorySnapshot snapshot,
        LeanAxiomReport report,
        RawChangeSet? changes = null,
        FrozenStateCatalog? frozenState = null,
        FrozenStatementIndex? frozenStatements = null,
        BackfillInventoryDocument? inventory = null);
}

internal sealed class ProductionScribeEmissionVerifier : IScribeEmissionVerifier
{
    private readonly Func<string, LeanAxiomReport, FrozenStateCatalog?, FrozenStatementIndex?, BackfillInventoryDocument?, VerifiedScribeEmissions> verifyMaterialized;

    internal ProductionScribeEmissionVerifier()
        : this(typeof(DocumentAssembly).Assembly)
    {
    }

    internal ProductionScribeEmissionVerifier(Assembly documentsAssembly)
        : this((root, report, frozenState, frozenStatements, inventory) =>
            VerifyMaterialized(documentsAssembly, root, report, frozenState, frozenStatements, inventory))
    {
    }

    internal ProductionScribeEmissionVerifier(
        Func<string, LeanAxiomReport, FrozenStateCatalog?, FrozenStatementIndex?, BackfillInventoryDocument?, VerifiedScribeEmissions> verifyMaterialized) =>
        this.verifyMaterialized = verifyMaterialized
            ?? throw new ArgumentNullException(nameof(verifyMaterialized));

    public VerifiedScribeEmissions Verify(
        RepositorySnapshot snapshot,
        LeanAxiomReport report,
        RawChangeSet? changes = null,
        FrozenStateCatalog? frozenState = null,
        FrozenStatementIndex? frozenStatements = null,
        BackfillInventoryDocument? inventory = null)
    {
        ArgumentNullException.ThrowIfNull(snapshot);
        ArgumentNullException.ThrowIfNull(report);
        using var materialized = MaterializedRepositorySnapshot.Create(snapshot);
        if (StatementProjectionReconciliation.IsAffectedBy(changes))
        {
            StatementProjectionReconciliation.Verify(
                materialized.Root,
                DeclarationCatalog.Create(report));
        }
        return verifyMaterialized(materialized.Root, report, frozenState, frozenStatements, inventory);
    }

    private static VerifiedScribeEmissions VerifyMaterialized(
        Assembly documentsAssembly,
        string repositoryRoot,
        LeanAxiomReport report,
        FrozenStateCatalog? frozenState,
        FrozenStatementIndex? frozenStatements,
        BackfillInventoryDocument? inventory)
    {
        var error = new StringWriter(System.Globalization.CultureInfo.InvariantCulture);
        return ScribeEmitter.Verify(documentsAssembly, repositoryRoot, error, report,
                frozenState, frozenStatements, inventory)
            ?? throw new InvalidOperationException(
                "Scribe emission verification failed: " + error.ToString().Trim());
    }

}
