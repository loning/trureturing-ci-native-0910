namespace StrataLint.ArchitectureTests;

public sealed class EngineeringPathFilterTests
{
    [Fact]
    public void CurrentPlanPreservesTheRetiredScriptTestCiSurface()
    {
        const string scripts = "tools/tests/StrataLint.ScriptTests/StrataLint.ScriptTests.csproj";
        var topology = new TestProjectTopologySnapshot([
            Project(scripts, "<IsTestProject>true</IsTestProject>"),
            Project("tools/tests/A/A.csproj", "<IsTestProject>true</IsTestProject>"),
        ]);
        Assert.Equal(new[] { "tools/tests/A/A.csproj" }, EngineeringTestPlanPolicy.Evaluate(topology));
    }

    [Fact]
    public void EveryCurrentTestProjectIsSelectedRegardlessOfReferences()
    {
        var topology = new TestProjectTopologySnapshot([
            Project("tools/tests/A/A.csproj", "<IsTestProject>true</IsTestProject>"),
            Project("tools/tests/B/B.csproj", "<IsTestProject>true</IsTestProject>"),
            Project("tools/Support/Support.csproj", "<IsTestProject>false</IsTestProject>", xunit: true),
            Project("tools/tests/StrataLint.ScriptTests/StrataLint.ScriptTests.csproj", "<IsTestProject>true</IsTestProject>", xunit: true),
        ]);
        Assert.Equal(new[] { "tools/tests/A/A.csproj", "tools/tests/B/B.csproj" }, EngineeringTestPlanPolicy.Evaluate(topology));
    }

    [Fact]
    public void MissingLiteralUsesXunitClassification()
    {
        var topology = new TestProjectTopologySnapshot([Project("tools/tests/A/A.csproj", "", xunit: true)]);
        Assert.Single(EngineeringTestPlanPolicy.Evaluate(topology));
    }

    [Theory]
    [InlineData("<IsTestProject>$(Dynamic)</IsTestProject>")]
    [InlineData("<IsTestProject>true</IsTestProject><IsTestProject>false</IsTestProject>")]
    public void AmbiguousClassificationRejectsExistingAndNewProjects(string properties) =>
        Assert.Throws<InvalidDataException>(() => EngineeringTestPlanPolicy.Evaluate(
            new TestProjectTopologySnapshot([Project("tools/tests/A/A.csproj", properties, xunit: true)])));

    private static TestProjectTopologyProject Project(string path, string properties, bool xunit = false) =>
        new(path, "<Project><PropertyGroup>" + properties + "</PropertyGroup><ItemGroup>"
            + (xunit ? "<PackageReference Include=\"xunit\" />" : "") + "</ItemGroup></Project>");
}
