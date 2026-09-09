using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.Paths;

internal sealed class MonotoneOnePathsDocument : IScribeDocumentDefinition
{
    private static readonly LibraryNoteRef Source =
        LibraryNoteRef.Create("D5/L/Words/rascoe2025a380392");

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The exact average number of all-one monotone paths in binary square matrices.",
        H("The average-path conjecture of A380392"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("mean-monotone-one-paths"),
                DeclarationHandle.Create(
                    "D5/S3/Arith/Paths/MonotoneOnePaths.mean_monotone_one_paths"),
                H("Mean number of paths"),
                StatementSource.FromLean(),
                AssessedProvenance.FromRepo(Source),
                Blocks(
                    Paragraph(Text(
                        "For n at least 1, a binary matrix assigns a Boolean to each of its "
                        + "n squared cells. Every matrix receives equal weight. The function "
                        + "pathCount counts paths from the top left to the bottom right whose "
                        + "visited cells are all true. Every step moves exactly one cell east "
                        + "or south; both endpoints are included.")),
                    Paragraph(Text(
                        "For a square of side k+1, a path is encoded by the k east-step "
                        + "positions among 2k steps. At time t its coordinates count the east "
                        + "and south steps in the prefix. Their sum is t, so different times "
                        + "give different cells. Each path therefore visits 2k+1 cells.")),
                    Paragraph(Text(
                        "Fix a path. Arbitrary Boolean assignments on the remaining k squared "
                        + "cells extend uniquely to matrices supporting that path, by filling "
                        + "its cells with true. Exchanging the finite sums over matrices and "
                        + "paths gives the binomial number of paths times the number of such "
                        + "assignments. Dividing by the number of all matrices gives the formula. "
                        + "At n=1 the only path visits the single cell. The theorem makes no "
                        + "claim about the zero-size row or the full distribution of path counts."))),
                DescribeRole.Theorem))));
}
