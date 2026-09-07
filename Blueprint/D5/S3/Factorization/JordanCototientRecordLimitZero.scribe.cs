using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class JordanCototientRecordLimitZeroDocument
    : IScribeDocumentDefinition
{
    private const string Prefix =
        "D5/S3/Factorization/JordanCototientRecordLimitZero.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Small-parameter Jordan-cototient records are 1, 2, 4, and non-prime-powers.",
        H("Jordan-Cototient Records Near Zero"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("multi-prime-cototient-derivative"),
                DeclarationHandle.Create(Prefix + "hasDerivAt_CoJ_of_two_le_card"),
                H("The derivative for at least two distinct prime factors"),
                StatementSource.FromAuthor(MultiPrimeDerivativeFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every positive natural n with at least two distinct prime factors, "
                        + "the real function k mapping to CoJ(k,n) has derivative log(val(n)) "
                        + "at zero. Here val is the coercion from naturals to reals. The proof "
                        + "uses two zero factors in the finite prime-factor product, forcing "
                        + "the derivative of the Jordan-totient term to vanish."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("prime-power-cototient-derivative"),
                DeclarationHandle.Create(Prefix +
                    "hasDerivAt_CoJ_of_primeFactors_eq_singleton"),
                H("The derivative for a singleton prime-factor set"),
                StatementSource.FromAuthor(SinglePrimeDerivativeFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "If the prime-factor set of a positive natural n is the singleton p, "
                        + "then k mapping to CoJ(k,n) has derivative "
                        + "log(val(n))-log(val(p)) at zero. This is the prime-power derivative "
                        + "log(n/p) written without introducing field division into the Lean "
                        + "statement."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("multi-prime-eventual-record"),
                DeclarationHandle.Create(Prefix +
                    "eventual_record_of_two_le_primeFactors_card"),
                H("Inputs with two prime factors are eventual records"),
                StatementSource.FromAuthor(MultiPrimeRecordFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For each positive natural n having at least two distinct prime factors, "
                        + "there is a positive real epsilon such that n is a strict record for "
                        + "every real k with 0<k<epsilon. Every predecessor gives a strict "
                        + "derivative gap at zero; finite intersection over the predecessor "
                        + "interval supplies one epsilon for this fixed n."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("one-eventual-record"),
                DeclarationHandle.Create(Prefix + "eventual_record_one"),
                H("One is an eventual record"),
                StatementSource.FromAuthor(EventualRecordFormula(D(1))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "One is a strict record for every parameter because it has no positive "
                        + "predecessor. The stated positive epsilon is therefore immediate. "
                        + "This bind-only companion feeds the exceptional-value branch of the "
                        + "final characterization."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("two-eventual-record"),
                DeclarationHandle.Create(Prefix + "eventual_record_two"),
                H("Two is an eventual record"),
                StatementSource.FromAuthor(EventualRecordFormula(D(2))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Two is a strict record because the sibling module gives CoJ(k,1)=0 and "
                        + "CoJ(k,2)=1 for every real k. This bind-only companion supplies the "
                        + "second exceptional-value branch of the final characterization."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("four-eventual-record"),
                DeclarationHandle.Create(Prefix + "eventual_record_four"),
                H("Four is an eventual record"),
                StatementSource.FromAuthor(EventualRecordFormula(D(4))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For positive k, CoJ(k,4)=2^k is strictly larger than the value one at "
                        + "the prime predecessors two and three, and larger than the value zero "
                        + "at one. This companion supplies the third exceptional-value branch."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("odd-prime-power-exclusion"),
                DeclarationHandle.Create(Prefix + "not_eventual_record_odd_prime_pow"),
                H("Odd prime powers are excluded"),
                StatementSource.FromAuthor(OddPrimePowerExclusionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "No positive power p^a of an odd prime is an eventual strict record near "
                        + "zero. When a=1, p ties the preceding prime two. When a>=2, the "
                        + "explicit predecessor 2*p^(Nat.sub(a,1)) has the larger derivative "
                        + "at zero and therefore beats p^a throughout a right neighborhood."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("two-power-exclusion"),
                DeclarationHandle.Create(Prefix + "not_eventual_record_two_pow"),
                H("Large powers of two are excluded"),
                StatementSource.FromAuthor(TwoPowerExclusionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every natural a>=3, the power 2^a is not an eventual strict record "
                        + "near zero. The explicit smaller predecessor "
                        + "3*2^(Nat.sub(a,2)) has a strictly larger cototient derivative at "
                        + "zero, so it beats 2^a for all sufficiently small positive k."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a387335-eventual-record-characterization"),
                DeclarationHandle.Create(Prefix + "a387335_eventual_record_iff"),
                H("The eventual record classification near zero"),
                StatementSource.FromAuthor(MainFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For every natural n>=1, there is a positive real epsilon such that n "
                            + "is a strict Jordan-cototient record for every real 0<k<epsilon "
                            + "exactly when n is 1, 2, 4, or has at least two distinct prime "
                            + "factors. The same n occurs in the outer binder, record predicate, "
                            + "exceptional equalities, and prime-factor-cardinality clause.")),
                    Paragraph(Text(
                        "The OEIS A387335 comment presents this classification as an apparent "
                            + "pattern. The proof here is pointwise in n: epsilon may depend on "
                            + "n. Computations at fixed k=0.1, 0.01, and 0.001 through n=500 do "
                            + "not stabilize to the predicted finite prefix, so no uniform-epsilon "
                            + "claim is made.")),
                    Paragraph(Text(
                        "The forward direction classifies a remaining input as a prime power, "
                            + "then invokes the explicit odd-prime-power or power-of-two "
                            + "defeater. The reverse direction uses the three exact exceptional "
                            + "cases and the derivative-gap finite-intersection theorem."))),
                DescribeRole.Theorem))));

    private static Formula MultiPrimeDerivativeFormula()
    {
        Formula n = F.Id("n"), k = F.Id("k");
        Formula derivative = Call(
            "HasDerivAt", Lambda(k, Call("CoJ", k, n)), LogOf(n), D(0));
        return Disp(ForAllMany(
            [Bound("n", Naturals())],
            Implies(
                LessThanOrEqual(D(1), n),
                Implies(CardAtLeastTwo(n), derivative))));
    }

    private static Formula SinglePrimeDerivativeFormula()
    {
        Formula n = F.Id("n"), p = F.Id("p"), k = F.Id("k");
        Formula singleton = new Formula.SetLiteral([p]);
        Formula derivative = Call(
            "HasDerivAt",
            Lambda(k, Call("CoJ", k, n)),
            Subtract(LogOf(n), LogOf(p)),
            D(0));
        return Disp(ForAllMany(
            [Bound("n", Naturals()), Bound("p", Naturals())],
            Implies(
                LessThanOrEqual(D(1), n),
                Implies(Equal(PrimeFactors(n), singleton), derivative))));
    }

    private static Formula MultiPrimeRecordFormula()
    {
        Formula n = F.Id("n");
        return Disp(ForAllMany(
            [Bound("n", Naturals())],
            Implies(
                LessThanOrEqual(D(1), n),
                Implies(CardAtLeastTwo(n), EventualRecord(n)))));
    }

    private static Formula OddPrimePowerExclusionFormula()
    {
        Formula p = F.Id("p"), a = F.Id("a");
        return Disp(ForAllMany(
            [Bound("p", Naturals()), Bound("a", Naturals())],
            Implies(
                Call("Prime", p),
                Implies(
                    Call("Odd", p),
                    Implies(
                        LessThan(D(0), a),
                        new Formula.Not(EventualRecord(Power(p, a))))))));
    }

    private static Formula TwoPowerExclusionFormula()
    {
        Formula a = F.Id("a");
        return Disp(ForAllMany(
            [Bound("a", Naturals())],
            Implies(
                LessThanOrEqual(D(3), a),
                new Formula.Not(EventualRecord(Power(D(2), a))))));
    }

    private static Formula MainFormula()
    {
        Formula n = F.Id("n");
        Formula classification = Or(
            Equal(n, D(1)),
            Or(Equal(n, D(2)), Or(Equal(n, D(4)), CardAtLeastTwo(n))));
        return Disp(ForAllMany(
            [Bound("n", Naturals())],
            Implies(
                LessThanOrEqual(D(1), n),
                Iff(Parenthesized(EventualRecord(n)), Parenthesized(classification)))));
    }

    private static Formula EventualRecordFormula(Formula n) =>
        Disp(EventualRecord(n));

    private static Formula EventualRecord(Formula n)
    {
        Formula epsilon = F.Id("epsilon"), k = F.Id("k");
        Formula parameterClause = ForAllMany(
            [Bound("k", Reals())],
            Implies(
                LessThan(D(0), k),
                Implies(LessThan(k, epsilon), Call("StrictRecord", k, n))));
        return ExistsMany(
            [Bound("epsilon", Reals())],
            And(LessThan(D(0), epsilon), parameterClause));
    }

    private static Formula CardAtLeastTwo(Formula n) =>
        LessThanOrEqual(D(2), Call("card", PrimeFactors(n)));

    private static Formula PrimeFactors(Formula n) => Call("primeFactors", n);

    private static Formula LogOf(Formula natural) => Call("log", Call("val", natural));

    private static Formula Lambda(Formula variable, Formula body) =>
        Parenthesized(Seq(variable, Colon, Sp, Reals(), Sp, Mapsto, Sp, body));

    private static Formula Reals() => Seq(Mathbb, Grp(F.Id("R")));

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula Power(Formula value, Formula exponent) =>
        new Formula.Power(value, exponent);

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);

    private static Formula.BoundVariable Bound(string name, Formula type) =>
        new(FormulaIdentifier.Create(name), type);

    private static Formula ForAllMany(
        Formula.BoundVariable[] variables,
        Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. variables], body);

    private static Formula ExistsMany(
        Formula.BoundVariable[] variables,
        Formula body) =>
        new Formula.BindMany(FormulaQuantifier.Exists, [.. variables], body);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula LessThan(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula LessThanOrEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);

    private static Formula Iff(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Iff, right);

    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);

    private static Formula Or(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Or, right);
}
