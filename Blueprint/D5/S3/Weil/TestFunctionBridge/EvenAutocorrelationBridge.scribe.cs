using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.TestFunctionBridge;

internal sealed class EvenAutocorrelationBridgeDocument : IScribeDocumentDefinition
{
    private const string Prefix =
        "D5/S3/Weil/TestFunctionBridge/EvenAutocorrelationBridge.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The real part of a smooth compact autocorrelation is an even Weil test function.",
        H("Even Autocorrelation"),
        Blocks(
            Paragraph(Text(
                "Write W for the space of even smooth compactly supported complex functions "
                    + "on the real line. Write iota for the inclusion of the reals "
                    + "into the complexes. "
                    + "The autocorrelation input may be complex valued and need not be even.")),
            Item("complex-autocorrelation", "autocorrelation", "Complex autocorrelation",
                Disp(Seq(F.Id("A"), Open, F.Id("f"), Close, Open, F.Id("x"), Close,
                    Sp, Eq, Sp, CorrelationIntegral())),
                DescribeRole.Definition,
                "For every function f from the reals to the complexes, A(f)(x) is the "
                    + "Lebesgue integral of f(t) times the conjugate of f(t-x)."),
            Item("autocorrelation-conjugate-symmetry", "autocorrelation_conj_symm",
                "Reversing the lag conjugates the value",
                Disp(Seq(Forall, Sp, F.Id("f"), Colon, Sp, Mathbb, Grp(F.Id("R")),
                    Sp, To, Sp, Mathbb, Grp(F.Id("C")), Comma, Sp,
                    Forall, Sp, F.Id("x"), Sp, InMacro, Sp, Mathbb, Grp(F.Id("R")), Comma,
                    Sp, F.Id("A"), Open, F.Id("f"), Close, Open, Minus, F.Id("x"), Close,
                    Sp, Eq, Sp, Overline,
                    Grp(F.Id("A"), Open, F.Id("f"), Close, Open, F.Id("x"), Close))),
                DescribeRole.Theorem,
                "Translation by minus x changes the integrand at lag minus x to "
                    + "f(t-x) times the conjugate of f(t). Conjugation of the integral and "
                    + "commutativity of complex multiplication give the identity. "
                    + "Mathlib's integral conventions make it valid for arbitrary f."),
            Item("even-autocorrelation", "evenAutocorrelation", "The even Weil test",
                Disp(Seq(F.Id("f"), Sp, InMacro, Sp, F.Id("C"), Underscore, Grp(F.Id("c")),
                    Caret, Grp(Infty), Open, Mathbb, Grp(F.Id("R")), Semi, Sp,
                    Mathbb, Grp(F.Id("C")), Close, Sp, Rightarrow, Sp,
                    F.Id("E"), Open, F.Id("f"), Close, Sp, Eq, Sp, Iota, Sp, Circ, Sp, Re,
                    Sp, Circ, Sp, F.Id("A"), Open, F.Id("f"), Close, Sp, InMacro, Sp,
                    F.Id("W"))),
                DescribeRole.Definition,
                "For smooth compactly supported f, convolution with its conjugate reflection "
                    + "is smooth and compactly supported by mathlib's convolution theorems. "
                    + "Taking the real part and including it in the complexes preserves those "
                    + "properties. Conjugate symmetry supplies evenness."),
            Item("even-autocorrelation-evaluation", "evenAutocorrelation_apply",
                "Evaluation of the even test",
                Disp(Seq(F.Id("E"), Open, F.Id("f"), Close, Open, F.Id("x"), Close,
                    Sp, Eq, Sp, Iota, Open, Re, Open, CorrelationIntegral(), Close, Close)),
                DescribeRole.Theorem,
                "For every smooth compactly supported f and every real x, the bundled test "
                    + "evaluates to the complex inclusion of the real part of the integral."),
            Item("even-autocorrelation-convolution-square",
                "evenAutocorrelation_eq_convolutionSquare", "Agreement on even inputs",
                Disp(Seq(Forall, Sp, F.Id("g"), Sp, InMacro, Sp, F.Id("W"), Comma, Sp,
                    F.Id("E"), Open, F.Id("g"), Close, Sp, Eq, Sp, Operatorname,
                    Grp(F.Id("convolutionSquare")), Open, F.Id("g"), Close)),
                DescribeRole.Theorem,
                "For an even Weil test g, the existing convolution square equals A(g) and "
                    + "is even. Combined with conjugate symmetry, this makes A(g) real valued. "
                    + "Its real part therefore recovers the same function, and extensionality "
                    + "gives equality in W. "
                    + "This comparison asserts no sign for a Weil reading."))));

    private static DocumentBlock.Describe Item(string id, string declaration,
        string heading, Formula formula, DescribeRole role, string prose) =>
        Describe.Lean(DescribeId.Create(id), DeclarationHandle.Create(Prefix + declaration),
            H(heading), StatementSource.FromAuthor(formula), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(prose))), role);

    private static Formula CorrelationIntegral() => Seq(
        Int, Underscore, Grp(Mathbb, Grp(F.Id("R"))), Sp,
        F.Id("f"), Open, F.Id("t"), Close, Sp, Cdot, Sp,
        Overline, Grp(F.Id("f"), Open, F.Id("t"), Minus, F.Id("x"), Close),
        Sp, Mathrm, Grp(F.Id("d")), F.Id("t"));
}
