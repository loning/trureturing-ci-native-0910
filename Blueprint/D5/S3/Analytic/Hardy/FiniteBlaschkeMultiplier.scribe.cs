using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Analytic.Hardy;

internal sealed class FiniteBlaschkeMultiplierDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Analytic/Hardy/FiniteBlaschkeMultiplier.";
    private static Formula f => F.Id("f");
    private static Formula a => F.Id("a");
    private static Formula z => F.Id("z");
    private static Formula m => F.Id("m");
    private static Formula j => F.Id("j");
    private static Formula B => F.Id("B");
    private static Formula Alpha => F.Id("alpha");
    private static Formula Zeta => F.Id("zeta");
    private static Formula Q => F.Id("Q");
    private static Formula H2 => new Formula.Power(F.Id("H"), D(2));
    private static Formula C => Seq(Mathbb, Grp(F.Id("C")));
    private static Formula Factor => new Formula.Fraction(Seq(z, Minus, a),
        Seq(D(1), Minus, Overline, Grp(a), Sp, z));
    private static Formula Scope => Seq(Forall, Sp, a, InMacro, Sp, C, Comma, Sp,
        Abs(a), Lt, D(1), Rightarrow, Sp);
    private static Formula DataScope => Seq(Forall, Sp, m, InMacro, Sp, Mathbb, Grp(F.Id("N")),
        Comma, Sp, B, InMacro, Sp, Call("FiniteBlaschkeData", m), Comma, Sp);
    private static Formula PhaseScope => Seq(DataScope, Forall, Sp, Alpha, InMacro, Sp, Call("Circle"), Comma, Sp);
    private static Formula CircleScope => Seq(DataScope, Forall, Sp, Zeta, InMacro, Sp, Call("Circle"), Comma, Sp);
    private static Formula ZeroAtOrigin => Seq(Call("value", B, D(0)), Eq, D(0));
    private static Formula PositiveNormalized => Seq(D(0), Lt, m, Land, Sp, ZeroAtOrigin);
    private static Formula PolyEval(string name, Formula point) => Call("eval", Call(name, B), point);
    private static Formula Fibre => Call("fibrePolynomial", B, Alpha);
    private static Formula PWeight => Call("poissonWeight", B, Zeta);

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Zeros in the disk and a unit phase construct the actual bounded isometric Blaschke "
            + "multiplier on the full Hardy coefficient space.",
        H("Finite Disk Blaschke Multipliers"),
        Blocks(
            Paragraph(Text("H2 is the full complex lp2 coefficient space constructed in "
                + "HardyCoefficientRealization. Operator multiplication means composition. "
                + "Complex inner products are conjugate-linear in their first argument.")),
            Claim("shift", "shift", "The unilateral coefficient shift",
                Seq(Q, Colon, Sp, H2, To, Sp, H2, Comma, Sp,
                    Forall, Sp, f, InMacro, Sp, H2, Comma, Sp, F.Id("n"), InMacro, Sp,
                    Mathbb, Grp(F.Id("N")), Comma, Sp,
                    Call("coeff", Call("apply", Q, f), D(0)), Eq, D(0), Comma, Sp,
                    Call("coeff", Call("apply", Q, f), Seq(F.Id("n"), Plus, D(1))), Eq,
                    Call("coeff", f, F.Id("n"))),
                "Q is a complex-linear isometry. The zero and successor coefficient "
                    + "equations are also exposed as shift_zero and shift_succ.", DescribeRole.Definition),
            Claim("shift-evaluation", "shift_evaluate", "The shift multiplies evaluation by z",
                Seq(Forall, Sp, f, InMacro, Sp, H2, Comma, Sp, z, InMacro, Sp, C,
                    Comma, Sp, Abs(z), Lt, D(1), Rightarrow, Sp,
                    Eval(Call("apply", Q, f)), Eq, z, Sp, Eval(f)),
                "This is equality of the actual convergent coefficient-series evaluations."),
            Claim("denominator", "denominatorUnit", "The Neumann denominator is a unit",
                Seq(Scope, Call("denominatorUnit", a), Eq, F.Id("I"), Minus,
                    Overline, Grp(a), Sp, Q),
                "The value is I-conjugate(a)Q in the bounded-operator algebra. Mathlib's "
                    + "Units.oneSub constructs its inverse from the norm-convergent geometric "
                    + "series. No inverse is assumed for an arbitrary bounded operator.", DescribeRole.Definition),
            Claim("factor", "factor", "The concrete single-factor multiplier",
                Seq(Scope, Call("factor", a), Eq, Open, Q, Minus, a, Sp, F.Id("I"), Close,
                    Sp, new Formula.Power(Seq(Open, F.Id("I"), Minus, Overline, Grp(a), Sp, Q, Close), Seq(Minus, D(1)))),
                "The inverse is the already constructed unit inverse.", DescribeRole.Definition),
            Claim("factor-evaluation", "factor_evaluate", "Single-factor analytic multiplication",
                Seq(Scope, Forall, Sp, f, InMacro, Sp, H2, Comma, Sp, z, InMacro, Sp, C,
                    Comma, Sp, Abs(z), Lt, D(1), Rightarrow, Sp,
                    Eval(Call("apply", Call("factor", a), f)), Eq, Factor, Sp, Eval(f)),
                "The operator evaluates as multiplication by (z-a)/(1-conjugate(a)z)."),
            Claim("factor-isometry", "factor_isometry", "Every disk factor is isometric",
                Seq(Scope, Call("Isometry", Call("factor", a))),
                "The proof expands ||Qy-ay|| squared and ||y-conjugate(a)Qy|| squared, "
                    + "then applies the constructed inverse denominator."),
            Claim("data", "FiniteBlaschkeData", "Only zeros and phase are data",
                Seq(F.Id("a"), Colon, Call("Fin", m), To, Sp, Call("UnitDisc"),
                    Comma, Sp, F.Id("c"), InMacro, Sp, Call("Circle")),
                "The zeros may repeat. The fields contain no isometry, model dimension, "
                    + "kernel normalization, orthonormality or invariance assumption.", DescribeRole.Definition),
            Claim("value", "value", "The finite Blaschke product",
                Seq(DataScope, Call("value", B, z), Eq, Call("phase", B), Sp,
                    new Formula.Subscript(Prod, Seq(j, InMacro, Sp, Call("Fin", m))), Sp,
                    new Formula.Fraction(Seq(z, Minus, Call("zero", B, j)),
                        Seq(D(1), Minus, Overline, Grp(Call("zero", B, j)), Sp, z))),
                "Lean evaluates the product using List.ofFn in canonical Fin order.", DescribeRole.Definition),
            Claim("multiplier", "mul", "The bounded finite-product operator",
                Seq(DataScope, Call("mul", B), Eq, Call("phase", B), Sp,
                    new Formula.Subscript(Prod, Seq(j, InMacro, Sp, Call("Fin", m))), Sp,
                    Call("factor", Call("zero", B, j))),
                "This is the ordered operator product from List.ofFn, scaled by the unit phase.", DescribeRole.Definition),
            Claim("multiplier-evaluation", "mul_eval", "The actual multiplication law",
                Seq(DataScope, Forall, Sp, f, InMacro, Sp, H2, Comma, Sp, z, InMacro, Sp, C,
                    Comma, Sp, Abs(z), Lt, D(1), Rightarrow, Sp,
                    Eval(Call("apply", Call("mul", B), f)), Eq, Call("value", B, z), Sp, Eval(f)),
                "The constructed continuous linear map is actual analytic multiplication by B."),
            Claim("multiplier-isometry", "mul_isometry", "The finite multiplier is isometric",
                Seq(DataScope, Call("Isometry", Call("mul", B))),
                "Composition of the proved factor isometries and a unit scalar preserves the full H2 norm."),
            Claim("disk-map", "maps_unitDisc", "Positive degree maps the disk strictly into itself",
                Seq(DataScope, D(0), Lt, m, Rightarrow, Sp, Forall, Sp, z, InMacro, Sp, C,
                    Comma, Sp, Abs(z), Lt, D(1), Rightarrow, Sp, Abs(Call("value", B, z)), Lt, D(1)),
                "The strict factor bound follows from the positive defect "
                    + "(1-|a| squared)(1-|z| squared). Positive degree makes the product nonempty."),
            Claim("numerator", "numerator", "The zero polynomial product",
                Seq(DataScope, Call("numerator", B), Eq,
                    new Formula.Subscript(Prod, Seq(j, InMacro, Sp, Call("Fin", m))), Sp,
                    Open, F.Id("T"), Minus, Call("C", Call("zero", B, j)), Close),
                "T is the polynomial indeterminate and C embeds a complex constant.", DescribeRole.Definition),
            Claim("polynomial-denominator", "denominator", "The denominator polynomial",
                Seq(DataScope, Call("denominator", B), Eq,
                    new Formula.Subscript(Prod, Seq(j, InMacro, Sp, Call("Fin", m))), Sp,
                    Open, D(1), Minus, Call("C", Seq(Overline, Grp(Call("zero", B, j)))), Sp, F.Id("T"), Close),
                "This polynomial is distinct from the coefficient-shift operator Q above.", DescribeRole.Definition),
            Claim("fibre-polynomial", "fibrePolynomial", "The actual phase polynomial",
                Seq(PhaseScope, Fibre, Eq, Call("C", Call("phase", B)), Sp, Call("numerator", B),
                    Minus, Call("C", Alpha), Sp, Call("denominator", B)),
                "Every alpha on the circle is permitted.", DescribeRole.Definition),
            Claim("poisson-weight", "poissonWeight", "The boundary Poisson weight",
                Seq(CircleScope, PWeight, Eq,
                    new Formula.Subscript(Sum, Seq(j, InMacro, Sp, Call("Fin", m))), Sp,
                    new Formula.Fraction(Seq(D(1), Minus, new Formula.Power(Abs(Call("zero", B, j)), D(2))),
                        new Formula.Power(Abs(Seq(Zeta, Minus, Call("zero", B, j))), D(2)))),
                "The weight is real and uses the actual disk zeros, including multiplicities.", DescribeRole.Definition),
            Claim("closed-factor-denominator", "factor_denominator_ne_zero_closed", "No factor pole on the closed disk",
                Seq(Forall, Sp, a, InMacro, Sp, Call("UnitDisc"), Comma, Sp, z, InMacro, Sp, C,
                    Comma, Sp, Abs(z), Le, D(1), Rightarrow, Sp,
                    D(1), Minus, Overline, Grp(a), Sp, z, Neq, D(0)),
                "The strict zero-parameter norm and closed-disk bound imply nonvanishing."),
            Claim("closed-denominator", "denominator_ne_zero_closed", "The full denominator has no closed-disk zero",
                Seq(DataScope, Forall, Sp, z, InMacro, Sp, C, Comma, Sp, Abs(z), Le, D(1),
                    Rightarrow, Sp, PolyEval("denominator", z), Neq, D(0)),
                "This supplies the analytic extension domain used by the actual model space."),
            Claim("polynomial-value", "value_eq_polynomial_div", "The finite product is the polynomial quotient",
                Seq(DataScope, Forall, Sp, z, InMacro, Sp, C, Comma, Sp, Call("value", B, z), Eq,
                    new Formula.Fraction(Seq(Call("phase", B), Sp, PolyEval("numerator", z)), PolyEval("denominator", z))),
                "The equality holds for every complex z under Lean's total division convention."),
            Claim("zero-parameter", "zero_parameter", "Origin normalization forces a zero parameter",
                Seq(DataScope, ZeroAtOrigin, Rightarrow, Sp, Exists, Sp, j, InMacro, Sp, Call("Fin", m),
                    Comma, Sp, Call("zero", B, j), Eq, D(0)),
                "The zero parameter is derived from B(0)=0, not added as an assumption."),
            Claim("numerator-degree", "numerator_natDegree", "The numerator has degree m",
                Seq(DataScope, Call("natDegree", Call("numerator", B)), Eq, m),
                "Pinned Mathlib's monic product theorem supplies the exact degree."),
            Claim("denominator-degree", "denominator_natDegree_lt", "The normalized denominator has smaller degree",
                Seq(DataScope, ZeroAtOrigin, Rightarrow, Sp, Call("natDegree", Call("denominator", B)), Lt, m),
                "The derived zero parameter removes one linear denominator factor."),
            Claim("fibre-degree", "fibrePolynomial_natDegree", "Every phase polynomial has degree m",
                Seq(PhaseScope, ZeroAtOrigin, Rightarrow, Sp, Call("natDegree", Fibre), Eq, m),
                "The unit numerator coefficient cannot cancel against a denominator of smaller degree."),
            Claim("fibre-root", "fibre_root", "Every phase-polynomial root is an actual circle preimage",
                Seq(PhaseScope, Forall, Sp, z, InMacro, Sp, C, Comma, Sp, PositiveNormalized, Land, Sp,
                    Call("eval", Fibre, z), Eq, D(0), Rightarrow, Sp, Abs(z), Eq, D(1), Land, Sp,
                    Call("value", B, z), Eq, Alpha),
                "Poles are excluded first. Strict factor modulus estimates exclude exterior roots; "
                    + "the proved disk mapping excludes interior roots."),
            Claim("positive-poisson", "poissonWeight_pos", "The Poisson weight is positive",
                Seq(CircleScope, D(0), Lt, m, Rightarrow, Sp, D(0), Lt, PWeight),
                "Positive degree supplies a nonempty sum of strictly positive terms."),
            Claim("boundary-derivative", "value_hasDerivAt_circle", "The exact analytic boundary derivative",
                Seq(CircleScope, Call("HasDerivAt", Call("value", B),
                    Seq(new Formula.Fraction(Call("value", B, Zeta), Zeta), Sp, PWeight), Zeta)),
                "This is a complex derivative in a neighborhood of the circle point. The real Poisson weight "
                    + "is coerced to the complex field."),
            Claim("fibre-derivative", "fibre_derivative", "The phase-polynomial derivative at a fibre point",
                Seq(PhaseScope, Forall, Sp, Zeta, InMacro, Sp, Call("Circle"), Comma, Sp,
                    Call("value", B, Zeta), Eq, Alpha, Rightarrow, Sp,
                    Call("eval", Call("derivative", Fibre), Zeta), Eq, PolyEval("denominator", Zeta), Sp,
                    new Formula.Fraction(Alpha, Zeta), Sp, PWeight),
                "This is R'(zeta)=Q(zeta)B'(zeta), with the exact positive Poisson expression substituted."),
            Claim("all-phase-fibre", "phase_fibre", "Every phase has exactly m distinct simple circle preimages",
                Seq(PhaseScope, PositiveNormalized, Rightarrow, Sp, Exists, Sp, Zeta, Colon,
                    Call("Fin", m), To, Call("Circle"), Comma, Sp, Call("Injective", Zeta), Land, Sp,
                    Open, Forall, Sp, z, InMacro, Sp, C, Comma, Sp,
                    Open, Call("value", B, z), Eq, Alpha, Land, Sp, Abs(z), Eq, D(1), Close,
                    Iff, Open, Exists, Sp, j, InMacro, Sp, Call("Fin", m), Comma, Sp,
                    z, Eq, Call("apply", Zeta, j), Close, Close, Land, Sp,
                    Open, Forall, Sp, j, InMacro, Sp, Call("Fin", m), Comma, Sp,
                    Call("eval", Call("derivative", Fibre), Call("apply", Zeta, j)), Neq, D(0), Close),
                "The finite family exhausts the fibre, is injective, and every root is simple. "
                    + "Complex polynomial splitting and separability supply the exact cardinality."),
            Paragraph(Text("The source normalization B(0)=0 remains explicit. ClarkKernelRealization uses "
                + "these actual all-phase fibres and positive derivatives for its analytic boundary kernels and normalization.")))));

    private static DocumentBlock Claim(string id, string declaration, string title, Formula formula,
        string narration, DescribeRole role = DescribeRole.Theorem) => Describe.Lean(
        DescribeId.Create(id), DeclarationHandle.Create(Owner + declaration), H(title),
        StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
        Blocks(Paragraph(Text(narration))), role);
    private static Formula Eval(Formula vector) => Call("evaluate", vector, z);
    private static Formula Abs(Formula value) => Seq(Bar, value, Bar);
    private static Formula Call(string name, params Formula[] args)
    {
        if (args.Length == 0) return Seq(Operatorname, Grp(F.Id(name)));
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
