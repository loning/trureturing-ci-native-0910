using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Analytic.Hardy;

internal sealed class ClarkKernelRealizationDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Analytic/Hardy/ClarkKernelRealization.";
    private static Formula B => F.Id("B");
    private static Formula z => F.Id("z");
    private static Formula w => F.Id("w");
    private static Formula g => F.Id("g");
    private static Formula H2 => new Formula.Power(F.Id("H"), D(2));
    private static Formula K => Call("modelSpace", B);
    private static Formula Kernel => Call("modelKernel", B, w);
    private static Formula HardyKernel => Call("hardyKernel", w);
    private static Formula m => F.Id("m");
    private static Formula f => F.Id("f");
    private static Formula p => F.Id("p");
    private static Formula Zeta => F.Id("zeta");
    private static Formula Alpha => F.Id("alpha");
    private static Formula Order => F.Id("order");
    private static Formula Theta => F.Id("theta");
    private static Formula j => F.Id("j");
    private static Formula ClosedDisk => Call("closedBall", D(0), D(1));
    private static Formula OpenDisk => Call("ball", D(0), D(1));
    private static Formula DataScope => Seq(Forall, Sp, m, InMacro, Sp, Mathbb, Grp(F.Id("N")), Comma, Sp,
        B, InMacro, Sp, Call("FiniteBlaschkeData", m), Comma, Sp);
    private static Formula VectorScope => Seq(DataScope, Forall, Sp, g, InMacro, Sp, K, Comma, Sp);
    private static Formula BoundaryScope => Seq(DataScope, Forall, Sp, Zeta, InMacro, Sp, Call("Circle"), Comma, Sp);
    private static Formula BoundaryKernel => Call("boundaryKernel", B, Zeta);
    private static Formula SourceScope => Seq(DataScope, D(0), Lt, m, Land, Sp,
        Call("value", B, D(0)), Eq, D(0), Rightarrow, Sp, Forall, Sp,
        Alpha, InMacro, Sp, Call("Circle"), Comma, Sp,
        Order, InMacro, Sp, Call("Equiv", Call("Fin", m), Call("Fin", m)), Comma, Sp,
        Theta, Colon, Call("Fin", m), To, Call("Circle"), Comma, Sp);
    private static Formula Points => Call("phasePoints", B, Alpha);
    private static Formula Point => Call("apply", Points, Call("apply", Order, j));
    private static Formula Family => Call("normalizedClarkFamily", B, Alpha, Order, Theta);
    private static Formula Clark => Call("clarkBasis", B, Alpha, Order, Theta);
    private static Formula NormalizedWeight => Seq(new Formula.Fraction(Call("apply", Theta, j),
        Call("sqrt", Call("poissonWeight", B, Point))), Sp, Call("boundaryKernel", B, Point));
    private static Formula Scope => Seq(Forall, Sp, F.Id("m"), InMacro, Sp, Mathbb, Grp(F.Id("N")),
        Comma, Sp, B, InMacro, Sp, Call("FiniteBlaschkeData", F.Id("m")), Comma, Sp,
        w, InMacro, Sp, Call("UnitDisc"), Comma, Sp);

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Actual finite Blaschke model vectors extend analytically across the circle, and "
            + "their normalized boundary kernels construct all phase Clark bases.",
        H("Disk Model Kernels and Clark Bases"),
        Blocks(
            Paragraph(Text("H2 is the full complex coefficient Hardy space. The bounded "
                + "multiplier M_B is constructed from the disk zeros and unit phase in "
                + "FiniteBlaschkeMultiplier. Inner products are conjugate-linear in the first argument.")),
            Claim("hardy-kernel", "hardyKernel", "The native Hardy evaluation kernel",
                Seq(Forall, Sp, w, InMacro, Sp, Call("UnitDisc"), Comma, Sp,
                    F.Id("n"), InMacro, Sp, Mathbb, Grp(F.Id("N")), Comma, Sp,
                    Call("coeff", HardyKernel, F.Id("n")), Eq,
                    new Formula.Power(Seq(Overline, Grp(w)), F.Id("n"))),
                "The full geometric coefficient sequence is square-summable because |w| < 1.", DescribeRole.Definition),
            Claim("hardy-reproduction", "hardyKernel_reproduces", "The Hardy kernel reproduces evaluation",
                Seq(Forall, Sp, w, InMacro, Sp, Call("UnitDisc"), Comma, Sp,
                    F.Id("f"), InMacro, Sp, H2, Comma, Sp,
                    Inner(HardyKernel, F.Id("f")), Eq, Call("evaluate", F.Id("f"), w)),
                "The identity uses the convergent coefficient series, with the kernel in the first argument."),
            Claim("hardy-kernel-value", "hardyKernel_evaluate", "The Hardy kernel formula",
                Seq(Forall, Sp, w, InMacro, Sp, Call("UnitDisc"), Comma, Sp,
                    z, InMacro, Sp, Call("UnitDisc"), Comma, Sp,
                    Call("evaluate", HardyKernel, z), Eq,
                    new Formula.Fraction(D(1), Seq(D(1), Minus, z, Sp, Overline, Grp(w)))),
                "The Lean signature permits a complex z together with |z| < 1."),
            Claim("model-space", "modelSpace", "The actual orthogonal model space",
                Seq(K, Eq, new Formula.Power(Call("range", Call("mul", B)), Perp)),
                "This is the existing frozen modelSpace definition supplied with the actual "
                    + "bounded Blaschke multiplier. No finite-dimensional substitute is introduced.", DescribeRole.Definition),
            Claim("model-kernel", "model_kernel", "The explicit interior model kernel",
                Seq(Scope, Kernel, Eq, HardyKernel, Minus,
                    Overline, Grp(Call("value", B, w)), Sp,
                    Call("apply", Call("mul", B), HardyKernel)),
                "The kernel is constructed in H2; membership in the orthogonal model space is proved next.",
                DescribeRole.Definition),
            Claim("model-membership", "model_kernel_mem", "The kernel belongs to the actual model space",
                Seq(Scope, Kernel, InMacro, Sp, K),
                "The proved multiplier isometry and its evaluation law show orthogonality to every vector in its range."),
            Claim("model-kernel-value", "model_kernel_evaluate", "The native disk model-kernel formula",
                Seq(Scope, Forall, Sp, z, InMacro, Sp, Call("UnitDisc"), Comma, Sp,
                    Call("evaluate", Kernel, z), Eq,
                    new Formula.Fraction(Seq(D(1), Minus, Call("value", B, z), Sp,
                        Overline, Grp(Call("value", B, w))),
                        Seq(D(1), Minus, z, Sp, Overline, Grp(w)))),
                "Both evaluation points are interior disk points. The numerator and denominator retain the native disk convention."),
            Claim("model-reproduction", "model_kernel_reproduces", "Reproduction on the orthogonal model space",
                Seq(Scope, Forall, Sp, g, InMacro, Sp, K, Comma, Sp,
                    Inner(Kernel, g), Eq, Call("evaluate", g, w)),
                "The inner product is computed after including g in the full H2 carrier."),
            Claim("factor-range", "factor_range", "The resolvent preserves the factor range",
                Seq(Call("range", Call("factor", F.Id("a"))), Eq,
                    Call("range", Seq(F.Id("Q"), Minus, F.Id("a"), Sp, F.Id("I")))),
                "For every complex a with |a| < 1, the invertible denominator gives "
                    + "range(factor a) = range(Q-aI). Q is the actual unilateral coefficient shift."),
            Claim("factor-recurrence", "factor_model_recurrence", "The one-factor defect recurrence",
                Seq(new Formula.Subscript(g, Seq(F.Id("n"), Plus, D(1))), Eq,
                    Overline, Grp(F.Id("a")), Sp, new Formula.Subscript(g, F.Id("n"))),
                "For |a| < 1, every g in range(factor a) orthogonal complement and every "
                    + "natural n satisfy this recurrence, obtained by pairing against coefficient singletons."),
            Claim("factor-finite", "factor_model_finite", "The one-factor defect is finite dimensional",
                Call("FiniteDimensional", MathbbC(), Defect(Call("factor", F.Id("a")))),
                "For |a| < 1, coefficient-zero evaluation is injective on the defect."),
            Claim("product-defect", "defectProductEquiv", "The product defect decomposition",
                Call("LinearEquiv", MathbbC(), Defect(Seq(F.Id("V"), Sp, F.Id("W"))),
                    Seq(Defect(F.Id("V")), Times, Defect(F.Id("W")))),
                "For bounded complex-linear V and W on H2 with V isometric, the complex-linear "
                    + "equivalence sends x to (x-V(V* x), V* x). Its inverse sends (u,v) to u+Vv. "
                    + "W needs no additional isometry assumption for this decomposition.", DescribeRole.Definition),
            Claim("factor-rank", "factor_model_finrank", "The one-factor defect has rank one",
                Seq(Call("finrank", MathbbC(), Defect(Call("factor", F.Id("a")))), Eq, D(1)),
                "For |a| < 1, the geometric Hardy kernel at a proves that coefficient-zero "
                    + "evaluation is also surjective."),
            Claim("model-finite", "modelSpace_finite", "The actual finite Blaschke model space is finite dimensional",
                Call("FiniteDimensional", MathbbC(), K),
                "For every natural m and every FiniteBlaschkeData m, induction uses the product "
                    + "defect equivalence. The unit phase does not change the multiplier range."),
            Claim("model-rank", "modelSpace_finrank", "The model-space dimension equals the degree",
                Seq(Call("finrank", MathbbC(), K), Eq, F.Id("m")),
                "For every natural m and every FiniteBlaschkeData m, the exact rank is m, including "
                    + "repeated zeros. The source endpoints will additionally retain m > 0 and B(0)=0."),
            Claim("factor-model-value", "factor_model_evaluate", "Every one-factor model vector is geometric",
                Seq(Forall, Sp, F.Id("a"), InMacro, Sp, Call("UnitDisc"), Comma, Sp,
                    g, InMacro, Sp, Defect(Call("factor", F.Id("a"))), Comma, Sp,
                    z, InMacro, Sp, OpenDisk, Comma, Sp, Call("evaluate", g, z), Eq,
                    new Formula.Fraction(Call("coeff", g, D(0)),
                        Seq(D(1), Minus, Overline, Grp(F.Id("a")), Sp, z))),
                "Lean quantifies over complex a and z with their strict norm bounds. The actual defect recurrence determines every coefficient."),
            Claim("model-rational", "modelSpace_rational", "Every actual model vector has a rational representation",
                Seq(VectorScope, Exists, Sp, p, InMacro, Sp, Call("Polynomial", MathbbC()), Comma, Sp,
                    Forall, Sp, z, InMacro, Sp, OpenDisk, Comma, Sp, Call("evaluate", g, z), Eq,
                    new Formula.Fraction(Call("eval", p, z), Call("eval", Call("denominator", B), z))),
                "The numerator is constructed through the actual defect decomposition. No polynomial numerator or boundary behavior is assumed."),
            Claim("model-extension", "modelSpace_analytic_extension", "Every model vector extends across the closed disk",
                Seq(VectorScope, Exists, Sp, f, Colon, MathbbC(), To, MathbbC(), Comma, Sp,
                    Call("AnalyticOnNhd", MathbbC(), f, ClosedDisk), Land, Sp,
                    Call("EqOn", f, Call("evaluate", g), OpenDisk)),
                "AnalyticOnNhd means analytic in a neighborhood of each closed-disk point. Evaluation of arbitrary H2 vectors on the circle is not asserted."),
            Claim("boundary-value", "boundaryValue", "The chosen analytic extension of a model vector",
                Seq(VectorScope, Call("boundaryValue", B, g), Colon, MathbbC(), To, MathbbC()),
                "This chooses the function supplied by modelSpace_analytic_extension. It is uniquely determined on the closed disk.", DescribeRole.Definition),
            Claim("boundary-interior", "boundaryValue_interior", "The extension agrees with actual Hardy evaluation",
                Seq(VectorScope, Forall, Sp, z, InMacro, Sp, OpenDisk, Comma, Sp,
                    Call("boundaryValue", B, g, z), Eq, Call("evaluate", g, z)),
                "The equality is with the convergent coefficient series on the open disk."),
            Claim("boundary-analytic", "boundaryValue_analytic", "The selected extension is analytic near the closed disk",
                Seq(VectorScope, Call("AnalyticOnNhd", MathbbC(), Call("boundaryValue", B, g), ClosedDisk)),
                "The closed-disk denominator nonvanishing supplies the analytic neighborhoods."),
            Claim("boundary-unique", "boundaryValue_unique", "Continuous extensions are unique on the closed disk",
                Seq(VectorScope, Forall, Sp, f, Colon, MathbbC(), To, MathbbC(), Comma, Sp,
                    Call("ContinuousOn", f, ClosedDisk), Land, Sp,
                    Call("EqOn", f, Call("evaluate", g), OpenDisk), Rightarrow, Sp,
                    Call("EqOn", Call("boundaryValue", B, g), f, ClosedDisk)),
                "Density of the open disk in its closure makes the choice immaterial at every circle point."),
            Claim("boundary-eval", "boundaryEval", "Boundary evaluation is a bounded complex-linear functional",
                Seq(BoundaryScope, Call("boundaryEval", B, Zeta), Colon, K, To,
                    MathbbC()),
                "The continuous linear map is constructed from the actual model extension. Linearity follows from uniqueness, and boundedness from the proved finite dimension.", DescribeRole.Definition),
            Claim("boundary-eval-apply", "boundaryEval_apply", "The bounded functional evaluates the analytic extension",
                Seq(BoundaryScope, Forall, Sp, g, InMacro, Sp, K, Comma, Sp,
                    Call("apply", Call("boundaryEval", B, Zeta), g), Eq, Call("boundaryValue", B, g, Zeta)),
                "This is the exact application law of the constructed bounded functional."),
            Claim("boundary-kernel", "boundaryKernel", "The boundary reproducing kernel belongs to actual K_B",
                Seq(BoundaryScope, BoundaryKernel, Eq,
                    Call("RieszInverse", Call("boundaryEval", B, Zeta))),
                "Pinned Hilbert-space Riesz representation supplies a vector in the actual model-space subtype, whose completeness follows from the proved finite dimension.", DescribeRole.Definition),
            Claim("boundary-reproduction", "boundaryKernel_reproduces", "The boundary kernel reproduces the extension",
                Seq(BoundaryScope, Forall, Sp, g, InMacro, Sp, K, Comma, Sp,
                    Inner(BoundaryKernel, g), Eq, Call("boundaryValue", B, g, Zeta)),
                "The kernel is in the conjugate-linear first argument, matching the source convention."),
            Claim("boundary-kernel-value", "boundaryKernel_evaluate", "The exact boundary kernel formula in the disk",
                Seq(BoundaryScope, Forall, Sp, z, InMacro, Sp, OpenDisk, Comma, Sp,
                    Call("evaluate", BoundaryKernel, z), Eq,
                    new Formula.Fraction(Seq(D(1), Minus, Call("value", B, z), Sp, Overline, Grp(Call("value", B, Zeta))),
                        Seq(D(1), Minus, z, Sp, Overline, Grp(Zeta)))),
                "Conjugating the pairing with the existing interior kernel identifies the actual boundary Riesz vector with the source formula."),
            Claim("boundary-kernel-identity", "boundaryKernel_identity", "The multiplied kernel identity holds on the closed disk",
                Seq(BoundaryScope, Forall, Sp, z, InMacro, Sp, ClosedDisk, Comma, Sp,
                    Call("boundaryValue", B, BoundaryKernel, z), Sp,
                    Open, D(1), Minus, z, Sp, Overline, Grp(Zeta), Close, Eq,
                    D(1), Minus, Call("value", B, z), Sp, Overline, Grp(Call("value", B, Zeta))),
                "The identity includes the boundary kernel's own point, without dividing by a zero denominator there."),
            Claim("boundary-kernel-norm", "boundaryKernel_normSq", "The exact squared kernel norm is the Poisson weight",
                Seq(BoundaryScope, Forall, Sp, Alpha, InMacro, Sp, Call("Circle"), Comma, Sp,
                    Call("value", B, Zeta), Eq, Alpha, Rightarrow, Sp,
                    Inner(BoundaryKernel, BoundaryKernel), Eq, Call("poissonWeight", B, Zeta)),
                "The right side is the real Poisson weight coerced to Complex. Differentiating the multiplied identity within the closed disk proves this norm, using the actual boundary derivative."),
            Paragraph(Text("In the source-facing declarations below, m>0 and B(0)=0. Alpha is any circle phase, "
                + "order is any permutation of Fin m, and theta gives any independent circle-valued phase for each kernel. "
                + "Proof arguments hm and h0 are suppressed in displayed applications.")),
            Claim("phase-points", "phasePoints", "A certified enumeration of the full phase fibre",
                Seq(DataScope, D(0), Lt, m, Land, Sp, Call("value", B, D(0)), Eq, D(0), Rightarrow, Sp,
                    Forall, Sp, Alpha, InMacro, Sp, Call("Circle"), Comma, Sp, Points, Colon,
                    Call("Fin", m), To, Call("Circle")),
                "The enumeration is chosen from phase_fibre, retaining injectivity, exact exhaustiveness, and simple roots.", DescribeRole.Definition),
            Claim("normalized-family", "normalizedClarkFamily", "The normalized Clark kernel family",
                Seq(SourceScope, Forall, Sp, j, InMacro, Sp, Call("Fin", m), Comma, Sp,
                    Call("apply", Family, j), Eq, NormalizedWeight),
                "The square root is the positive real square root of the strictly positive Poisson norm; theta supplies the optional individual unit phase.", DescribeRole.Definition),
            Claim("normalized-family-apply", "normalizedClarkFamily_apply", "The exact normalized family application law",
                Seq(SourceScope, Forall, Sp, j, InMacro, Sp, Call("Fin", m), Comma, Sp,
                    Call("apply", Family, j), Eq, NormalizedWeight),
                "This records the full scalar, ordering and source boundary-kernel convention."),
            Claim("normalized-orthonormal", "normalizedClarkFamily_orthonormal", "The normalized source family is orthonormal",
                Seq(SourceScope, Call("Orthonormal", MathbbC(), Family)),
                "Distinct points in the same fibre give zero cross inner products. The exact Poisson norm gives unit diagonal entries, including arbitrary order and individual unit phases."),
            Claim("clark-basis", "clarkBasis", "Every phase yields the actual Clark orthonormal basis",
                Seq(SourceScope, Clark, InMacro, Sp, Call("OrthonormalBasis", Call("Fin", m), MathbbC(), K)),
                "The frozen phase_fibre_is_orthonormal_basis theorem packages the newly proved family and actual finrank m. No orthonormality or dimension hypothesis is added.", DescribeRole.Definition),
            Claim("clark-basis-apply", "clarkBasis_apply", "The basis vectors are exactly the normalized boundary kernels",
                Seq(SourceScope, Forall, Sp, j, InMacro, Sp, Call("Fin", m), Comma, Sp,
                    Call("apply", Clark, j), Eq, Call("apply", Family, j)),
                "The constructed basis is identified pointwise with the normalized source family, not merely named Clark."),
            Paragraph(Text("ClarkWeightedComposition specializes the actual Hardy branches to these bases. "
                + "No metaphysical proposition is encoded by these analytic constructions.")))));

    private static DocumentBlock Claim(string id, string declaration, string title, Formula formula,
        string narration, DescribeRole role = DescribeRole.Theorem) => Describe.Lean(
        DescribeId.Create(id), DeclarationHandle.Create(Owner + declaration), H(title),
        StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
        Blocks(Paragraph(Text(narration))), role);
    private static Formula Inner(Formula left, Formula right) => Seq(Langle, Sp, left, Comma, Sp, right, Sp, Rangle);
    private static Formula MathbbC() => Seq(Mathbb, Grp(F.Id("C")));
    private static Formula Defect(Formula op) => new Formula.Power(Call("range", op), Perp);
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
