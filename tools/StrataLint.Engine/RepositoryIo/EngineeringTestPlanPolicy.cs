using System.Collections.Immutable;
using System.Xml.Linq;

namespace StrataLint.Engine;

internal static class EngineeringTestPlanPolicy
{
    // Dev retired this project's CI admission role; make -C tools test retains it locally.
    private const string ScriptTestsProject = "tools/tests/StrataLint.ScriptTests/StrataLint.ScriptTests.csproj";

    internal static ImmutableArray<string> Evaluate(TestProjectTopologySnapshot candidate) =>
        candidate.Projects.Where(IsTestProject)
            .Select(static project => project.Path)
            .Where(static path => path != ScriptTestsProject)
            .Distinct(StringComparer.Ordinal)
            .Order(StringComparer.Ordinal)
            .ToImmutableArray();

    private static bool IsTestProject(TestProjectTopologyProject project)
    {
        var document = XDocument.Parse(project.Content, LoadOptions.None);
        var declarations = document.Descendants()
            .Where(static element => element.Name.LocalName == "IsTestProject")
            .Select(static element => element.Value.Trim())
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToArray();
        // Explicit false excludes xUnit-based support libraries (#5516).
        return declarations switch
        {
            [] => ScribeProjectCompilationContext.IsXunitProject(project.Content),
            [var value] when value.Equals("true", StringComparison.OrdinalIgnoreCase) => true,
            [var value] when value.Equals("false", StringComparison.OrdinalIgnoreCase) => false,
            _ => throw new InvalidDataException(
                $"project has no unambiguous literal IsTestProject classification: {project.Path}"),
        };
    }
}
