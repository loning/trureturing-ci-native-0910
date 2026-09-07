namespace StrataLint.Tests;

public sealed class LeanInspectorScriptTests
{
    [Fact]
    public void ExactSeedStillEntersLakeAndIncrementalProducer() =>
        LeanSeedProcessContract.Run("InspectorTests.test_inspector_runs_lake_on_exact_seed_with_zero_reinspection");

    [Fact]
    public void LakeAndInspectorFailuresKeepTheirRealExitCodes() =>
        LeanSeedProcessContract.Run("InspectorTests.test_inspector_real_failure_blocks_even_when_report_seed_exists");

    [Fact]
    public void DeltaReinspectionPreservesDependencyAndMaterialContracts() => LeanSeedProcessContract.Run("DeltaTests");

    [Fact]
    public void ReportStagingDoesNotPreemptColdCacheProvisioning() =>
        LeanSeedProcessContract.Run("InspectorTests.test_report_staging_does_not_preempt_cold_cache_provisioning");

    [Fact]
    public void LoadedRuntimeDependenciesInvalidateModuleResults() =>
        LeanSeedProcessContract.Run("InspectorTests.test_actual_runtime_dependency_change_reinspects_inside_same_partition");
}
