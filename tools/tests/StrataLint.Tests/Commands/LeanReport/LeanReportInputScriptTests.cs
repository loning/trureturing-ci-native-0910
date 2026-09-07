namespace StrataLint.Tests;

public sealed class LeanReportInputScriptTests
{
    [Fact]
    public void ProducerClosureFollowsExecutableDependencies() =>
        LeanSeedProcessContract.Run("PairTests.test_input_follows_transitive_program_dependencies_without_workflow");

    [Fact]
    public void MetadataAndSemanticInputsHaveDistinctBehavior() =>
        LeanSeedProcessContract.Run("PairTests.test_metadata_keeps_attestation_but_semantic_and_source_drift_are_stale");

    [Fact]
    public void CompilerOwnedProducerInputsInvalidateReportReuse() =>
        LeanSeedProcessContract.Run("ProducerClosureTests", TestBudgets.LongWorkflowProcessHangGuard);
}
