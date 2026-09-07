namespace StrataLint.ArchitectureTests;

public sealed partial class ScriptTestGateClosureTests
{
    private const string DigestionOpenPath = "Meta/Digestion/backfill/source/residual-open/atom.yaml";
    private const string DigestionClosedPath = "Meta/Digestion/backfill/source/absorbed-closed/atom.yaml";
    private const string DigestionCasPath =
        "Meta/Digestion/atoms/sha256/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
    private const string DigestionFileMap = """
        [[files]]
        pattern = "Meta/Digestion/backfill/**"
        admission_plane = "content"
        [[files]]
        pattern = "Meta/Digestion/atoms/sha256/*"
        admission_plane = "content"
        [[files]]
        pattern = "Meta/Digestion/atomizers.toml"
        admission_plane = "judge"
        [[files]]
        pattern = "notes/**"
        admission_plane = "content"
        """;

    [Theory]
    [InlineData(DigestionOpenPath)]
    [InlineData(DigestionCasPath)]
    [InlineData("Meta/Digestion/backfill/source/source.toml")]
    public void DigestionDataWithoutEngineeringDependentsSelectsNoTests(string path)
    {
        var snapshot = DigestionPlanSnapshot();

        var plan = Evaluate([path], snapshot, snapshot);

        Assert.Equal(EngineeringTestPlanKind.None, plan.Kind);
        Assert.Empty(plan.Projects);
        Assert.Equal(path, Assert.Single(plan.ChangedPaths));
    }

    [Fact]
    public void DigestionStatusMoveSelectsNoEngineeringTests()
    {
        var snapshot = DigestionPlanSnapshot();

        var plan = Evaluate([DigestionOpenPath, DigestionClosedPath], snapshot, snapshot);

        Assert.Equal(EngineeringTestPlanKind.None, plan.Kind);
        Assert.Empty(plan.Projects);
        Assert.Equal(2, plan.ChangedPaths.Length);
    }

    [Theory]
    [InlineData("Meta/Digestion/atomizers.toml")]
    [InlineData("notes/unknown.txt")]
    [InlineData("Meta/Digestion/backfill/source/unknown/atom.yaml")]
    [InlineData("Meta/Digestion/atoms/sha256/not-a-hash")]
    public void NonDataAndUnknownDigestionPathsKeepEngineeringFallback(string path)
    {
        var snapshot = DigestionPlanSnapshot();

        var plan = Evaluate([path], snapshot, snapshot);

        Assert.NotEmpty(plan.Projects);
        Assert.Contains(TestSupportProject, plan.Projects);
    }

    [Theory]
    [InlineData("judge")]
    [InlineData("invalid")]
    public void DigestionExemptionRequiresContentOnlyAdmissionClassification(string plane)
    {
        var snapshot = WithFiles(DigestionPlanSnapshot(),
            (AdmissionPlanePolicy.FileMapPath, DigestionFileMap.Replace(
                "\"content\"", $"\"{plane}\"", StringComparison.Ordinal)));

        var plan = Evaluate([DigestionOpenPath], snapshot, snapshot);

        Assert.NotEmpty(plan.Projects);
    }

    [Fact]
    public void MissingFileMapDoesNotExemptDigestionData()
    {
        var snapshot = WithoutFiles(DigestionPlanSnapshot(), AdmissionPlanePolicy.FileMapPath);

        Assert.NotEmpty(Evaluate([DigestionOpenPath], snapshot, snapshot).Projects);
    }

    [Fact]
    public void MixedDigestionAndUnknownDeltaKeepsEngineeringFallback()
    {
        var snapshot = DigestionPlanSnapshot();

        Assert.NotEmpty(Evaluate([DigestionOpenPath, "notes/unknown.txt"], snapshot, snapshot).Projects);
    }

    [Fact]
    public void FullOverrideStillTestsDigestionData()
    {
        var snapshot = DigestionPlanSnapshot();

        var plan = Evaluate([DigestionOpenPath], snapshot, snapshot, full: true);

        Assert.Equal(EngineeringTestPlanKind.Full, plan.Kind);
        Assert.Contains(ScriptTestsProject, plan.Projects);
    }

    [Fact]
    public void DigestionCompileInputRetainsItsProjectAndReverseDependents()
    {
        var snapshot = WithFiles(DigestionPlanSnapshot(),
            (TruthProject, ProjectText(TruthProject).Replace(
                "<ItemGroup>",
                "<ItemGroup><Compile Include=\"../../Meta/Digestion/backfill/**/*.yaml\" />",
                StringComparison.Ordinal)));

        var plan = Evaluate([DigestionOpenPath], snapshot, snapshot);

        Assert.Contains(ScriptTestsProject, plan.Projects);
    }

    [Fact]
    public void DigestionDataInScriptControllerClosureStillSelectsScriptTests()
    {
        var snapshot = DigestionPlanSnapshot();

        var plan = EngineeringTestPlanPolicy.Evaluate(
            [DigestionCasPath], snapshot, snapshot, [DigestionCasPath], []);

        Assert.Equal(EngineeringTestPlanKind.Selected, plan.Kind);
        Assert.Equal(ScriptTestsProject, Assert.Single(plan.Projects));
    }

    private static RepositorySnapshot DigestionPlanSnapshot() => WithFiles(CurrentSnapshot(),
        (AdmissionPlanePolicy.FileMapPath, DigestionFileMap),
        (DigestionOpenPath, "synthetic data\n"),
        (DigestionCasPath, "synthetic CAS\n"));
}
