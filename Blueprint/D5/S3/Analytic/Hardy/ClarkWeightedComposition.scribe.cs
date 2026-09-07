using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Analytic.Hardy;

internal sealed class ClarkWeightedCompositionDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Analytic/Hardy/ClarkWeightedComposition.";
    private static Formula B => F.Id("B");
    private static Formula e => F.Id("e");
    private static Formula f => F.Id("f");
    private static Formula z => F.Id("z");
    private static Formula n => F.Id("n");
    private static Formula j => F.Id("j");
    private static Formula k => F.Id("k");
    private static Formula i => F.Id("i");
    private static Formula X => F.Id("X");
    private static Formula H2 => new Formula.Power(F.Id("H"), D(2));
    private static Formula K => Call("modelSpace", B);
    private static Formula C => Seq(Mathbb, Grp(F.Id("C")));
    private static Formula E(Formula index) => Call("E", index);
    private static Formula Beta(Formula index) => Call("F", index);
    private static Formula U(Formula row, Formula col) => Call("U", row, col);
    private static Formula S(Formula weight) => Call("branchOp", B, weight);
    private static Formula Eval(Formula vector, Formula point) => Call("evaluate", vector, point);
    private static Formula Power(Formula value, Formula exponent) => new Formula.Power(value, exponent);
    private static Formula Norm(Formula value) => Seq(Vert, Sp, value, Sp, Vert);
    private static Formula Star(Formula value) => Power(Seq(Open, value, Close), F.Star);
    private static Formula Sum(Formula index, Formula body) => Seq(new Formula.Subscript(F.Sum, index), Sp, body);

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Constructed Hardy weighted-composition branches preserve their complete bounded-operator map under model-basis changes.",
        H("Hardy Weighted Composition and Basis Changes"),
        Blocks(
            Paragraph(Text("Throughout, m is a natural number, B is FiniteBlaschkeData m, "
                + "K_B is the actual orthogonal complement of the multiplier range, e belongs to K_B, "
                + "and f belongs to the full complex lp2 Hardy space H2. No finite-dimensional "
                + "restriction is placed on H2. Products of bounded operators mean composition.")),
            Claim("power-embedding", "powerEmbedding", "Isometric multiplier powers on the model space",
                Seq(Call("powerEmbedding", B, n, e), Eq, Call("apply", Power(Call("mul", B), n), e)),
                "For every natural n this is a complex-linear isometry from K_B to H2, proved "
                    + "using the actual multiplier isometry.", DescribeRole.Definition),
            Claim("power-orthogonality", "powers_orthogonal", "Distinct powers of the defect are orthogonal",
                Call("OrthogonalFamily", C, Call("powerEmbedding", B)),
                "For all distinct natural i and j and all x,y in K_B, the inner product of "
                    + "M_B^i x and M_B^j y is zero. No completeness of their span is needed."),
            Claim("coefficient-tensor", "coefficientTensor", "Coefficient synthesis input",
                Seq(Call("coeff", Call("coefficientTensor", B, e, f), n), Eq,
                    Call("coeff", f, n), Sp, e),
                "This is a bounded complex-linear map from H2 to lp2 of copies of the actual "
                    + "model space. Square summability is proved from the coefficient norm identity.", DescribeRole.Definition),
            Claim("tensor-norm", "coefficientTensor_norm", "The coefficient input has the exact product norm",
                Seq(Norm(Call("coefficientTensor", B, e, f)), Eq, Norm(e), Sp, Norm(f)),
                "The norm identity holds for every e and f, including zero."),
            Claim("branch-operator", "branchOp", "The actual bounded Hardy branch operator",
                Seq(Call("apply", S(e), f), Eq, Call("tsum", n,
                    Seq(Call("coeff", f, n), Sp, Call("apply", Power(Call("mul", B), n), e)))),
                "The operator is the composition of the coefficient input map and the pinned "
                    + "orthogonal-family Hilbert-sum isometry.", DescribeRole.Definition),
            Claim("branch-convergence", "branch_hasSum", "The defining branch series converges in H2",
                Call("HasSum", Call("sequence", n,
                    Seq(Call("coeff", f, n), Sp, Call("apply", Power(Call("mul", B), n), e))),
                    Call("apply", S(e), f)),
                "This is unconditional norm convergence of the full series, not a formal coefficient identity."),
            Claim("branch-norm", "branch_norm", "The branch has the exact norm identity",
                Seq(Norm(Call("apply", S(e), f)), Eq, Norm(e), Sp, Norm(f)),
                "Consequently its squared norm is ||e|| squared times ||f|| squared, and "
                    + "the required boundedness estimate follows."),
            Claim("branch-evaluation", "branch_eval", "The branch is weighted composition by B",
                Seq(Eval(Call("apply", S(e), f), z), Eq, Eval(e, z), Sp,
                    Eval(f, Call("value", B, z))),
                "For every positive m and every complex z with |z| < 1, continuity of disk "
                    + "evaluation identifies the norm-convergent synthesis with e(z)f(B(z))."),
            Claim("branch-linearity", "branchLinear", "The operator depends complex-linearly on its weight",
                Seq(Call("branchLinear", B), Colon, Sp, K, To,
                    Call("BoundedComplexLinear", H2, H2)),
                "The linear map sends e to branchOp B e. Additivity and complex homogeneity "
                    + "are proved from uniqueness of the convergent series.", DescribeRole.Definition),
            Paragraph(Text("For the remaining statements, E and F are arbitrary orthonormal bases "
                + "indexed by Fin m of the actual K_B. Every choice of ordering and every "
                + "individual unit phase is included whenever represented by such a basis. "
                + "Inner products are conjugate-linear in the first argument.")),
            Claim("coordinate-transition", "coordinateTransition", "The coordinate transition",
                Seq(Call("C", k, j), Eq, Inner(Beta(k), E(j))),
                "This matrix has entries of the F coordinates of E(j).", DescribeRole.Definition),
            Claim("branch-transition", "branchTransition", "The basis expansion transition",
                Seq(U(k, j), Eq, Inner(E(j), Beta(k))),
                "This is the row expansion coefficient of F(k) in E. It has the opposite "
                    + "inner-product order from the coordinate matrix.", DescribeRole.Definition),
            Claim("conjugate-convention", "branch_transition_eq_conj_coordinates", "The two transitions are conjugate",
                Seq(U(k, j), Eq, Overline, Grp(Call("C", k, j))),
                "The equality holds for every pair of Fin m indices."),
            Claim("branch-mixing", "branch_basis_mix", "The actual branches obey the basis expansion law",
                Seq(S(Beta(k)), Eq, Sum(j, Seq(U(k, j), Sp, S(E(j))))),
                "This follows by applying the proved weight-to-operator linear map to the full basis expansion."),
            Claim("column-cancellation", "branch_transition_columns", "The exact scalar cancellation identity",
                Seq(Sum(k, Seq(U(k, i), Sp, Overline, Grp(U(k, j)))), Eq, Call("delta", i, j)),
                "Delta is one for equal indices and zero otherwise. The identity follows "
                    + "from orthonormal-basis inner-product reconstruction."),
            Claim("transition-unitary", "branch_transition_unitary", "The branch transition is unitary",
                Seq(Star(F.Id("U")), Sp, F.Id("U"), Eq, F.Id("I")),
                "Here star is conjugate transpose of the finite coefficient matrix."),
            Claim("all-operators-invariance", "branch_map_basis_invariant", "The complete branch map is basis independent",
                Seq(Forall, Sp, X, InMacro, Sp, Call("BoundedComplexLinear", H2, H2), Comma, Sp,
                    Sum(k, Seq(S(Beta(k)), Sp, X, Sp, Star(S(Beta(k))))), Eq,
                    Sum(j, Seq(S(E(j)), Sp, X, Sp, Star(S(E(j)))))),
                "This equality is in the bounded-operator algebra on full H2. It imposes "
                    + "no positivity, trace, finite-rank, state or finite-dimensional ambient hypothesis."),
            Claim("clark-source-invariance", "clark_branch_map_invariant", "The complete source Clark branch map is choice independent",
                Seq(Forall, Sp, F.Id("m"), InMacro, Sp, Mathbb, Grp(F.Id("N")), Comma, Sp,
                    B, InMacro, Sp, Call("FiniteBlaschkeData", F.Id("m")), Comma, Sp,
                    D(0), Lt, F.Id("m"), Land, Sp, Call("value", B, D(0)), Eq, D(0), Rightarrow, Sp,
                    Forall, Sp, F.Id("alpha"), Comma, F.Id("beta"), InMacro, Sp, Call("Circle"), Comma, Sp,
                    F.Id("oa"), Comma, F.Id("ob"), InMacro, Sp,
                    Call("Equiv", Call("Fin", F.Id("m")), Call("Fin", F.Id("m"))), Comma, Sp,
                    F.Id("ta"), Comma, F.Id("tb"), Colon, Call("Fin", F.Id("m")), To, Call("Circle"), Comma, Sp,
                    X, InMacro, Sp, Call("BoundedComplexLinear", H2, H2), Comma, Sp,
                    Sum(k, Seq(S(Clark("beta", "ob", "tb", k)), Sp, X, Sp, Star(S(Clark("beta", "ob", "tb", k))))), Eq,
                    Sum(j, Seq(S(Clark("alpha", "oa", "ta", j)), Sp, X, Sp, Star(S(Clark("alpha", "oa", "ta", j)))))),
                "Clark(alpha,order,theta,j) is exactly clarkBasis B hm h0 alpha order theta j, the "
                    + "normalized boundary kernel constructed in ClarkKernelRealization. The equality holds "
                    + "for every bounded X on full H2. The retained branch_eval gives its source law "
                    + "e_j(z)f(B(z)), and branch_basis_mix uses U[k,j]=inner(e_alpha[j],e_beta[k])."),
            Paragraph(Text("The statement that Lambda_B is not Tao remains an interpretive boundary only. "
                + "The source-facing equality concerns the complete bounded-operator map and all the "
                + "specified basis, phase and sheet choices; no metaphysical Lean proposition is asserted.")))));

    private static DocumentBlock Claim(string id, string declaration, string title, Formula formula,
        string narration, DescribeRole role = DescribeRole.Theorem) => Describe.Lean(
        DescribeId.Create(id), DeclarationHandle.Create(Owner + declaration), H(title),
        StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
        Blocks(Paragraph(Text(narration))), role);
    private static Formula Inner(Formula left, Formula right) => Seq(Langle, Sp, left, Comma, Sp, right, Sp, Rangle);
    private static Formula Clark(string phase, string order, string theta, Formula index) =>
        Call("Clark", F.Id(phase), F.Id(order), F.Id(theta), index);
    private static Formula Call(string name, params Formula[] args)
    {
        var items = new List<Formula> { Operatorname, Grp(F.Id(name)), Open };
        for (var q = 0; q < args.Length; q++)
        {
            if (q > 0) items.AddRange([Comma, Sp]);
            items.Add(args[q]);
        }
        items.Add(Close);
        return Seq([.. items]);
    }
}
