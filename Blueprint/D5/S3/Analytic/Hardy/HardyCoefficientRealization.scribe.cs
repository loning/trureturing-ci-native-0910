using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Analytic.Hardy;

internal sealed class HardyCoefficientRealizationDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Analytic/Hardy/HardyCoefficientRealization.";
    private static Formula C => Seq(Mathbb, Grp(F.Id("C")));
    private static Formula N => Seq(Mathbb, Grp(F.Id("N")));
    private static Formula R => Seq(Mathbb, Grp(F.Id("R")));
    private static Formula Hardy => Pow(F.Id("H"), D(2));
    private static Formula f => F.Id("f");
    private static Formula z => F.Id("z");
    private static Formula r => F.Id("r");
    private static Formula n => F.Id("n");
    private static Formula Eval => Call("evaluate", f, z);
    private static Formula Coeff => new Formula.Subscript(f, n);
    private static Formula Term => Seq(Coeff, Sp, Pow(z, n));
    private static Formula Radial => Call("R", f, r);
    private static Formula Weighted => SumN(Seq(Pow(Abs(Coeff), D(2)), Sp, Pow(r, Seq(D(2), n))));

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The full square-summable coefficient Hilbert space has convergent, bounded and "
            + "injective disk evaluation; normalized radial means recover its exact norm.",
        H("Native Disk Hardy Coefficients"),
        Blocks(
            Paragraph(Text("Throughout, H2 is lp(N, C, 2), with its complete complex Hilbert "
                + "space structure. Its vectors have arbitrary square-summable coefficients, "
                + "not necessarily finite support. The open disk is |z| < 1.")),
            Claim("carrier", "H2", "The full coefficient carrier",
                Seq(Hardy, Sp, Eq, Sp, Call("lp", N, C, D(2))),
                "The carrier inherits Mathlib's lp norm and Hilbert structure.", DescribeRole.Definition),
            Claim("evaluation", "evaluate", "Coefficient evaluation",
                Seq(Forall, Sp, f, InMacro, Sp, Hardy, Comma, Sp, z, InMacro, Sp, C, Comma, Sp,
                    Eval, Sp, Eq, Sp, SumN(Term)),
                "The total tsum expression is used as a function on C. Convergence is proved "
                    + "on the open disk; no boundary value is asserted for an arbitrary Hardy vector.",
                DescribeRole.Definition),
            Claim("summability", "summable_evaluate", "Interior convergence",
                Disk(Seq(Call("Summable", Seq(n, Mapsto, Sp, Term)))),
                "The coefficient bound |f_n| <= ||f|| and a convergent geometric majorant "
                    + "give absolute convergence at each interior point."),
            Claim("series-sum", "evaluate_hasSum", "The actual series sum",
                Disk(Call("HasSum", Seq(n, Mapsto, Sp, Term), Eval)),
                "Evaluation equals the sum of the convergent coefficient series."),
            Claim("bounded-evaluation", "norm_evaluate_le", "Bounded evaluation",
                Disk(Seq(Abs(Eval), Sp, Le, Sp,
                    new Formula.Fraction(Norm(f), Seq(D(1), Minus, Abs(z))))),
                "This geometric bound certifies continuity of evaluation; it is not claimed "
                    + "to be the sharp reproducing-kernel bound."),
            Claim("evaluation-functional", "eval", "A bounded complex-linear functional",
                Seq(Forall, Sp, z, InMacro, Sp, C, Comma, Sp, Abs(z), Lt, D(1), Rightarrow, Sp,
                    Call("eval", z), Colon, Sp, Hardy, To, C),
                "The displayed map is continuous and complex-linear. Its Lean parameter "
                    + "also carries the proof that |z| < 1.", DescribeRole.Definition),
            Claim("evaluation-functional-value", "eval_apply", "Functional evaluation agrees with the series",
                Disk(Seq(Call("eval", z, f), Eq, Eval)),
                "The bounded functional has precisely the coefficient-series value."),
            Claim("series-radius", "series_radius", "The radius includes the unit disk",
                Seq(Forall, Sp, f, InMacro, Sp, Hardy, Comma, Sp, D(1), Le,
                    Call("radius", Call("ofScalars", C, f))),
                "This is a lower bound for the extended nonnegative convergence radius."),
            Claim("analytic", "analytic_evaluate", "Analytic disk realization",
                Seq(Forall, Sp, f, InMacro, Sp, Hardy, Comma, Sp,
                    Call("AnalyticOnNhd", C, Call("evaluate", f), Call("ball", D(0), D(1)))),
                "The series is complex analytic at every point of the open unit disk."),
            Claim("injective", "evaluate_injective", "Evaluation determines the coefficient vector",
                Seq(Forall, Sp, f, Comma, F.Id("g"), InMacro, Sp, Hardy, Comma, Sp,
                    Open, Forall, Sp, z, InMacro, Sp, C, Comma, Sp, Abs(z), Lt, D(1), Rightarrow, Sp,
                    Eval, Eq, Call("evaluate", F.Id("g"), z), Close, Rightarrow, Sp,
                    f, Eq, F.Id("g")),
                "Local uniqueness of scalar analytic power series determines every coefficient."),
            Claim("coefficient-norm", "coefficient_norm_sq", "The full coefficient norm",
                Seq(Forall, Sp, f, InMacro, Sp, Hardy, Comma, Sp,
                    SumN(Pow(Abs(Coeff), D(2))), Eq, Pow(Norm(f), D(2))),
                "The sum ranges over every natural coefficient."),
            Claim("truncations", "coefficient_truncations", "Convergence of coefficient truncations",
                Seq(Forall, Sp, f, InMacro, Sp, Hardy, Comma, Sp,
                    Call("HasSum", Seq(n, Mapsto, Sp, Call("single", D(2), n, Coeff)), f)),
                "Finite sums of the coefficient singletons converge in the H2 norm."),
            Claim("radial-series", "radialSeries", "A continuous Fourier realization of each radial series",
                Seq(Call("radialSeries", f, r), Eq,
                    SumN(Seq(Coeff, Pow(r, n), Sp, Call("fourier", n)))),
                "The continuous functions live on AddCircle(2 pi). Fourier mode n has "
                    + "value exp(i n t). Convergence is supplied under 0 <= r < 1.", DescribeRole.Definition),
            Claim("radial-series-converges", "radialSeries_hasSum", "Uniform convergence on a radius",
                RadialScope(Call("HasSum", Seq(n, Mapsto, Sp, Coeff, Pow(r, n), Sp,
                    Call("fourier", n)), Call("radialSeries", f, r))),
                "HasSum holds in the continuous-function norm, hence uniformly on the circle."),
            Claim("radial-series-norm", "radialSeries_norm_sq", "The radial L2 norm",
                RadialScope(Seq(Pow(Norm(Call("toLp", Call("radialSeries", f, r))), D(2)), Eq, Weighted)),
                "The L2 space uses normalized Haar measure of total mass one."),
            Claim("radial-series-value", "radialSeries_evaluate", "The Fourier series is the disk evaluation",
                RadialScope(Seq(Forall, Sp, F.Id("t"), InMacro, Sp, R, Comma, Sp,
                    Call("radialSeries", f, r, F.Id("t")), Eq,
                    Call("evaluate", f, Seq(r, Pow(F.Id("e"), Seq(F.Id("i"), F.Id("t"))))))),
                "The circle coordinate is t modulo 2 pi; this equality identifies the "
                    + "Fourier construction with the original analytic evaluation."),
            Claim("radial-mean", "radialMean", "Normalized radial mean square",
                Seq(Radial, Eq, Integral()),
                "The normalization is exactly 1/(2 pi), and the integration interval is [0, 2 pi].",
                DescribeRole.Definition),
            Claim("radial-identity", "radial_mean_square", "Exact normalized radial identity",
                RadialScope(Seq(Integral(), Eq, Weighted)),
                "Orthogonality of the Fourier modes gives the norm identity, and integration "
                    + "of the continuous representative converts it to the actual radial integral."),
            Claim("radial-bound", "radialMean_le", "Radial means are bounded by the coefficient norm",
                RadialScope(Seq(Radial, Le, Pow(Norm(f), D(2)))),
                "Each coefficient weight r^(2n) is at most one."),
            Claim("radial-limit", "radialMean_tendsto", "Radial means converge to the full norm",
                Seq(Forall, Sp, f, InMacro, Sp, Hardy, Comma, Sp,
                    new Formula.Subscript(Lim, Seq(r, To, D(1), Minus)), Sp,
                    Radial, Eq, Pow(Norm(f), D(2))),
                "The limit is from below at r=1. Dominated convergence uses the summable "
                    + "squared coefficients as its bound."),
            Claim("hardy-norm", "hardy_norm", "The exact Hardy norm",
                Seq(Forall, Sp, f, InMacro, Sp, Hardy, Comma, Sp,
                    new Formula.Subscript(Seq(Operatorname, Grp(F.Id("sup"))), Seq(D(0), Le, Sp, r, Lt, D(1))),
                    Radial, Eq, Pow(Norm(f), D(2))),
                "Taking the supremum over every real radius 0 <= r < 1 recovers the full "
                    + "coefficient Hilbert norm squared."),
            Paragraph(Text("This module supplies the native disk Hardy realization. Finite "
                + "Blaschke multiplier isometry, model-space dimension, all-phase normalized "
                + "Clark kernels and the all-bounded-operator branch invariance remain "
                + "separate obligations. The source's statement that Lambda_B is not Tao is "
                + "an interpretive boundary, not a Lean proposition.")))));

    private static DocumentBlock Claim(string id, string declaration, string title, Formula formula,
        string narration, DescribeRole role = DescribeRole.Theorem) => Describe.Lean(
        DescribeId.Create(id), DeclarationHandle.Create(Owner + declaration), H(title),
        StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
        Blocks(Paragraph(Text(narration))), role);

    private static Formula Disk(Formula body) => Seq(Forall, Sp, f, InMacro, Sp, Hardy,
        Comma, Sp, z, InMacro, Sp, C, Comma, Sp, Abs(z), Lt, D(1), Rightarrow, Sp, body);
    private static Formula RadialScope(Formula body) => Seq(Forall, Sp, f, InMacro, Sp, Hardy,
        Comma, Sp, r, InMacro, Sp, R, Comma, Sp, D(0), Le, Sp, r, Lt, D(1), Rightarrow, Sp, body);
    private static Formula Norm(Formula value) => Seq(Vert, Sp, value, Sp, Vert);
    private static Formula Abs(Formula value) => Seq(Bar, value, Bar);
    private static Formula Pow(Formula value, Formula power) => new Formula.Power(value, power);
    private static Formula SumN(Formula body) => Seq(new Formula.Subscript(Sum,
        Seq(n, InMacro, Sp, N)), Sp, body);
    private static Formula Integral() => Seq(new Formula.Fraction(D(1), Seq(D(2), Pi)), Sp,
        Int, Underscore, Grp(D(0)), Caret, Grp(D(2), Pi), Sp,
        Pow(Abs(Call("evaluate", f, Seq(r, Pow(F.Id("e"), Seq(F.Id("i"), F.Id("t")))))), D(2)),
        Sp, F.Id("dt"));
    private static Formula Call(string name, params Formula[] args)
    {
        var items = new List<Formula> { Operatorname, Grp(F.Id(name)), Open };
        for (var i = 0; i < args.Length; i++)
        {
            if (i > 0) items.AddRange([Comma, Sp]);
            items.Add(args[i]);
        }
        items.Add(Close);
        return Seq([.. items]);
    }
}
