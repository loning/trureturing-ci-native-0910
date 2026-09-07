using static StrataLint.Scribe.DefinitionDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.QuantumBounds;

internal sealed class AffineEndpointPathDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/QuantumBounds/AffineEndpointPath.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Finite complex paths with fixed endpoints correspond bijectively to compatible differences.",
        H("Affine Endpoint Paths"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("affine-endpoint-path-equivalence"),
                DeclarationHandle.Create(Prefix + "affine_endpoint_path_equivalence"),
                H("Endpoint-constrained difference equivalence"),
                StatementSource.FromAuthor(EquivalenceFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Write P for EndpointPath and V for CompatibleDifference. "
                            + "EndpointPath consists of complex-valued functions on Fin (a + 2), "
                            + "with value xi at zero and eta at the last vertex. "
                            + "CompatibleDifference consists of functions v on Fin (a + 1) "
                            + "whose sum of r^(a-j) v(j) is eta - r^(a+1) xi.")),
                    Paragraph(Text(
                        "The displayed equivalence has a specified map in each direction. "
                            + "Its two inverse identities recover the entire path and the "
                            + "entire difference vector. In particular, equal difference "
                            + "vectors determine equal endpoint-constrained paths.")),
                    Paragraph(Text(
                        "The construction is valid for every complex r. A real r strictly "
                            + "between zero and one is covered by its usual complex coercion. "
                            + "No positivity, division, norm estimate, or optimization argument "
                            + "is needed; the case a = 0 is included."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("affine-endpoint-path-forward-computation"),
                DeclarationHandle.Create(Prefix + "affine_endpoint_path_equiv_apply"),
                H("Forward coordinate law"),
                StatementSource.FromAuthor(F.Disp(ForwardFormula())),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Here e is affineEndpointPathEquiv. For each edge j, "
                        + "Fin.succ selects vertex j + 1 and Fin.castSucc "
                        + "selects vertex j. Thus the map is exactly x(j+1) - r x(j)."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("affine-endpoint-path-inverse-computation"),
                DeclarationHandle.Create(Prefix + "affine_endpoint_path_equiv_symm_apply"),
                H("Explicit inverse coordinate law"),
                StatementSource.FromAuthor(F.Disp(InverseFormula())),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "At vertex i the inverse is r^i xi plus the sum of "
                            + "r^(i-1-j) v(j) over exactly those edges with j < i. "
                            + "At zero this sum is empty; at a + 1 the compatibility "
                            + "equation gives the prescribed terminal value.")),
                    Paragraph(Text(
                        "The prefix sum satisfies the forced one-step recurrence. "
                            + "Induction over the finite vertices proves reconstruction "
                            + "after differentiation is the identity; substituting that "
                            + "one-step recurrence proves the other composite identity. "
                            + "This supplies reconstruction and uniqueness for later path "
                            + "arguments, without claiming any action bound or equality-case "
                            + "optimization result here."))),
                DescribeRole.Theorem))));

    private static Formula EquivalenceFormula() => F.Disp(F.Seq(
        F.Begin, F.Grp(F.Id("gathered")),
        F.Exists, F.Sp, F.Id("e"), F.Colon, F.Sp,
        F.Operatorname, F.Grp(F.Id("Equiv")), F.Open,
        F.Id("P"), F.Comma, F.Id("V"), F.Close, F.Comma, F.RowBreak,
        ForwardFormula(), F.Comma, F.RowBreak, InverseFormula(),
        F.End, F.Grp(F.Id("gathered"))));

    private static Formula ForwardFormula() => F.Seq(
        F.Forall, F.Sp, F.Id("x"), F.InMacro, F.Sp, F.Id("P"), F.Comma, F.Quad,
        F.Forall, F.Sp, F.D(0), F.Leq, F.Sp, F.Id("j"),
        F.Leq, F.Sp, F.Id("a"), F.Comma, F.Quad, F.Sp,
        F.Id("e"), F.Open, F.Id("x"), F.Close, F.Open, F.Id("j"), F.Close,
        F.Eq, F.Id("x"), F.Open, F.Id("j"), F.Plus, F.D(1), F.Close,
        F.Minus, F.Id("r"), F.Id("x"), F.Open, F.Id("j"), F.Close);

    private static Formula InverseFormula() => F.Seq(
        F.Forall, F.Sp, F.Id("v"), F.InMacro, F.Sp, F.Id("V"), F.Comma, F.Quad,
        F.Forall, F.Sp, F.D(0), F.Leq, F.Sp, F.Id("i"), F.Leq, F.Sp,
        F.Id("a"), F.Plus, F.D(1), F.Comma, F.Quad, F.Sp,
        F.Id("e"), F.Caret, F.Grp(F.Minus, F.D(1)),
        F.Open, F.Id("v"), F.Close, F.Open, F.Id("i"), F.Close,
        F.Eq, F.Id("r"), F.Caret, F.Grp(F.Id("i")),
        F.Mathrm, F.Grp(F.Id("xi")), F.Plus,
        F.Sum, F.Underscore, F.Grp(F.D(0), F.Leq, F.Sp, F.Id("j"), F.Lt, F.Id("i")),
        F.Id("r"), F.Caret, F.Grp(F.Id("i"), F.Minus, F.D(1), F.Minus, F.Id("j")),
        F.Id("v"), F.Open, F.Id("j"), F.Close);
}
