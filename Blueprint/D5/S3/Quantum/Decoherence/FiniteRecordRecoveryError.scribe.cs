using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Decoherence;

internal sealed class FiniteRecordRecoveryErrorDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Quantum/Decoherence/FiniteRecordRecoveryError.";
    private static Formula Integer => Seq(Mathbb, Grp(F.Id("Z")));
    private static Formula Complex => Seq(Mathbb, Grp(F.Id("C")));

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Every CPTP recovery has the finite-record worst-case trace-distance lower bound.",
        H("Finite Record Recovery Error"),
        Blocks(
            Item("coefficient_gamma_neg", "Signed coefficient conjugation", GammaFormula()),
            Item("pair_matrix_sqrt", "The exact complex two-coordinate square root", PairFormula(true)),
            Item("pair_matrix_traceNorm", "The exact complex two-coordinate trace norm", PairFormula(false)),
            Item("finite_record_pair_witnesses", "Actual plus and minus density states", SourceFormula(false)),
            Item("finite_record_recovery_error_lower_bound", "Uniform recovery lower bound", SourceFormula(true)),
            Paragraph(Text(
                "N is any natural number, including zero; c is an arbitrary complex "
                + "sequence with exactly the stated support and integer-tsum normalization. "
                + "The finite coordinate type has decidable equality, and other labels may repeat. "
                + "The nonzero gap can have either sign. All unbounded sums denote Lean tsum.")),
            Paragraph(Text(
                "DensityState and QuantumChannel are the actual canonical FiniteStateChannel "
                + "carriers. raw applies CStarMatrix.ofMatrix.symm to a state's value. act applies "
                + "the channel's completely positive map in matrix coordinates, and traceDistance "
                + "is one half of the actual trace norm from FiniteTraceDistance. The channel C "
                + "is obtained from the frozen shifted-record recording and partial-trace theorem; "
                + "its multiplier identity holds for every complex matrix.")),
            Paragraph(Text(
                "The displayed vectors define the pure-state projectors via vecMulVec with "
                + "pointwise conjugation. Positive semidefiniteness, trace one, original distance "
                + "one, and channel-image distance equal to the norm of gamma are proved. "
                + "The pair square-root identity includes zero and arbitrary complex phase.")),
            Paragraph(Text(
                "Every pair of density states has trace distance between zero and one. "
                + "Trace-norm nonnegativity supplies the lower endpoint, and the triangle "
                + "inequality with unit trace supplies the upper endpoint. The theorem delivers "
                + "this entire interval and uses its upper endpoint to bound every recovery error. "
                + "The error range is over all density states. Its equality with the canonical "
                + "composed-channel error range, nonemptiness, and upper bound one are proved. "
                + "Both witness errors lie below its real supremum. Canonical CPTP contraction "
                + "and the triangle inequality give the lower bound. No compactness, attainment, "
                + "cosine bound, sharpness, Hamiltonian implementation, recovery algorithm, or "
                + "physical cost conclusion is asserted.")))));

    private static DocumentBlock Item(string name, string title, Formula formula) =>
        Describe.Lean(DescribeId.Create(name.Replace('_', '-').ToLowerInvariant()), DeclarationHandle.Create(Owner + name),
            H(title), StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(Explanation(name)))), DescribeRole.Theorem);
    private static string Explanation(string name) => name switch
    {
        "coefficient_gamma_neg" => "Reindex the integer sum by translation and commute the scalar factors after conjugation.",
        "pair_matrix_sqrt" => "The two diagonal norm entries form a positive semidefinite matrix whose square is the Gram matrix; uniqueness identifies the positive square root.",
        "pair_matrix_traceNorm" => "Take the real trace of the explicit two-coordinate square root.",
        "finite_record_pair_witnesses" => "Finite support converts the integer normalization to the frozen channel theorem's finite sum. The displayed projectors have trace one, and the exact pair norm computes both distances.",
        "finite_record_recovery_error_lower_bound" => "Deliver the all-density distance interval from nonnegative trace norm and the unit-trace upper bound. Identify the coefficient error range with the actual composed-channel range and bound it by the interval's upper endpoint. Both witness errors are below its supremum, and two triangle inequalities with CPTP contraction give the bound.",
        _ => throw new System.ArgumentOutOfRangeException(nameof(name))
    };
    private static Formula Call(string name, params Formula[] args) =>
        new Formula.FunctionCall(FormulaIdentifier.Create(name), [.. args]);
    private static Formula Apply(Formula f, params Formula[] args) => new Formula.Apply(f, [.. args]);
    private static Formula.BoundVariable Bound(string name, Formula type) => new(FormulaIdentifier.Create(name), type);
    private static Formula All(Formula.BoundVariable[] vars, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. vars], body);
    private static Formula Exists(Formula.BoundVariable[] vars, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.Exists, [.. vars], body);
    private static Formula Rel(Formula a, FormulaRelationOperator op, Formula b) => new Formula.Relation(a, op, b);
    private static Formula Eqn(Formula a, Formula b) => Rel(a, FormulaRelationOperator.Equal, b);
    private static Formula Ne(Formula a, Formula b) => Rel(a, FormulaRelationOperator.NotEqual, b);
    private static Formula Lt(Formula a, Formula b) => Rel(a, FormulaRelationOperator.LessThan, b);
    private static Formula Le(Formula a, Formula b) => Rel(a, FormulaRelationOperator.LessThanOrEqual, b);
    private static Formula Implies(Formula a, Formula b) => new Formula.Logic(a, FormulaLogicOperator.Implies, b);
    private static Formula Both(params Formula[] terms) => terms.Aggregate(
        (a, b) => new Formula.Logic(a, FormulaLogicOperator.And, b));
    private static Formula Add(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Add, b);
    private static Formula Sub(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Subtract, b);
    private static Formula Mul(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Multiply, b);
    private static Formula Div(Formula a, Formula b) => new Formula.Fraction(a, b);
    private static Formula Conj(Formula a) => Call("conj", a);
    private static Formula Adjoint(Formula a) => Seq(Left, Open, a, Right, Close, Caret, Grp(Star));
    private static Formula Norm(Formula a) => Call("norm", a);
    private static Formula SumOver(Formula k, Formula domain, Formula body) =>
        Seq(Sum, Underscore, Grp(k, Sp, InMacro, Sp, domain), Sp, Grp(body));
    private static Formula Let(Formula body) => Seq(Operatorname, Grp(F.Id("let")), Sp, body, Semi, Sp);

    private static Formula GammaFormula()
    {
        Formula c = F.Id("c"), ell = F.Id("ell"), k = F.Id("k");
        return All([Bound("c", new Formula.TypeArrow(Integer, Complex)), Bound("ell", Integer)],
            Eqn(SumOver(k, Integer, Mul(Apply(c, Sub(k, ell)), Conj(Apply(c, k)))),
                Conj(SumOver(k, Integer, Mul(Apply(c, Add(k, ell)), Conj(Apply(c, k)))))));
    }

    private static Formula PairFormula(bool squareRoot)
    {
        Formula n = F.Id("n"), i = F.Id("i"), j = F.Id("j"), z = F.Id("z");
        Formula pair = Add(Call("single", i, j, z), Call("single", j, i, Conj(z)));
        Formula result = squareRoot
            ? Eqn(Call("sqrt", Mul(Adjoint(pair), pair)),
                Add(Call("single", i, i, Norm(z)), Call("single", j, j, Norm(z))))
            : Eqn(Call("traceNorm", pair), Mul(Num(2), Norm(z)));
        return All([Bound("n", F.Id("FiniteType")), Bound("i", n), Bound("j", n), Bound("z", Complex)],
            Implies(Ne(i, j), result));
    }

    private static Formula SourceFormula(bool endpoint)
    {
        Formula n = F.Id("n"), nmax = F.Id("N"), c = F.Id("c"), q = F.Id("q");
        Formula i = F.Id("i"), j = F.Id("j"), k = F.Id("k"), l = F.Id("l"), ell = F.Id("ell");
        Formula gamma = GammaLower, lambda = Lambda, a = F.Id("A"), channel = F.Id("C"), recovery = F.Id("R");
        Formula rho = F.Id("rho"), sigma = F.Id("sigma"), vp = F.Id("vp"), vm = F.Id("vm");
        Formula matrix = Call("Matrix", n, n, Complex), state = Call("DensityState", n);
        Formula gap = Sub(Apply(q, i), Apply(q, j));
        Formula support = All([Bound("k", Integer)], Implies(
            new Formula.Logic(Lt(k, Num(0)), FormulaLogicOperator.Or, Lt(nmax, k)), Eqn(Apply(c, k), Num(0))));
        Formula hypotheses = Both(support,
            Eqn(SumOver(k, Integer, Seq(Norm(Apply(c, k)), Caret, Grp(Num(2)))), Num(1)),
            endpoint ? Ne(gap, Num(0)) : Ne(i, j));
        Formula definitions = Let(All([Bound("ell", Integer)], Eqn(Apply(gamma, ell),
            SumOver(k, Integer, Mul(Apply(c, Add(k, ell)), Conj(Apply(c, k)))))));
        Formula Entry(Formula x) => Call("entry", x, k, l);
        Formula multiplier = Mul(Apply(gamma, Sub(Apply(q, k), Apply(q, l))), Entry(a));
        Formula result;
        if (endpoint)
        {
            Formula error = F.Id("error"), errors = F.Id("errors");
            Formula densityInterval = All([Bound("rho", state), Bound("sigma", state)],
                Both(Le(Num(0), Call("traceDistance", rho, sigma)),
                    Le(Call("traceDistance", rho, sigma), Num(1))));
            definitions = Seq(definitions,
                Let(All([Bound("A", matrix), Bound("k", n), Bound("l", n)],
                    Eqn(Entry(Apply(lambda, a)), multiplier))),
                Let(All([Bound("rho", state)], Eqn(Apply(error, rho), Div(Call("traceNorm",
                    Sub(Call("act", recovery, Apply(lambda, Call("raw", rho))), Call("raw", rho))), Num(2))))),
                Let(Eqn(errors, Call("range", error))));
            result = All([Bound("R", Call("QuantumChannel", n, n))], Seq(definitions,
                Both(densityInterval, Call("Nonempty", errors), Call("BddAbove", errors),
                    Le(Div(Sub(Num(1), Norm(Apply(gamma, gap))), Num(2)), Call("sSup", errors)))));
        }
        else
        {
            Formula di = Call("ite", Eqn(k, i), Num(1), Num(0));
            Formula dj = Call("ite", Eqn(k, j), Num(1), Num(0));
            definitions = Seq(definitions,
                Let(All([Bound("k", n)], Eqn(Apply(vp, k), Div(Add(di, dj), Call("sqrt", Num(2)))))),
                Let(All([Bound("k", n)], Eqn(Apply(vm, k), Div(Sub(di, dj), Call("sqrt", Num(2)))))));
            Formula action = All([Bound("A", matrix), Bound("k", n), Bound("l", n)],
                Eqn(Entry(Call("act", channel, a)), multiplier));
            Formula states = Exists([Bound("rho", state), Bound("sigma", state)], Both(
                Eqn(Call("raw", rho), Call("vecMulVec", vp, Conj(vp))),
                Eqn(Call("raw", sigma), Call("vecMulVec", vm, Conj(vm))),
                Eqn(Call("traceDistance", rho, sigma), Num(1)),
                Eqn(Call("traceDistance", Call("mapState", channel, rho), Call("mapState", channel, sigma)),
                    Norm(Apply(gamma, gap)))));
            result = Seq(definitions, Exists([Bound("C", Call("QuantumChannel", n, n))], Both(action, states)));
        }
        return All([Bound("n", F.Id("FiniteType")), Bound("N", F.Id("Nat")),
            Bound("c", new Formula.TypeArrow(Integer, Complex)), Bound("q", new Formula.TypeArrow(n, Integer)),
            Bound("i", n), Bound("j", n)], Implies(hypotheses, result));
    }
}
