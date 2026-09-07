using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class DeeplyCompositeNotPrimeExponentRecordDocument : IScribeDocumentDefinition
{
    private const string Prefix =
        "D5/S3/Factorization/DeeplyCompositeNotPrimeExponentRecord.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The deeply composite number 25200 is never a strict prime-exponent-score record.",
        H("A Deeply Composite Number Outside B-Infinity"),
        Blocks(
            Paragraph(Text(
                "The OEIS A385722 attachment asks whether all deeply composite numbers from "
                    + "A095848 occur in B-infinity, the union of the strict record sequences "
                    + "from A384669 over real parameters strictly between zero and one. "
                    + "A384669 states the score on positive integer factorizations and its strict "
                    + "record sequences; A095848 states the extended-divisor-list order; A385722 "
                    + "states the union over 0 < x < 1 and the all-or-infinitely-many question. "
                    + "The Lean declarations quantify n and m over all naturals with explicit "
                    + "positivity guards and x over all reals. DivPlusPrecedes and DC are the "
                    + "repository's least-differing-divisor encoding of the A095848 order, and the "
                    + "25200 certificates and counterexample are proved in the repository.")),
            Node(
                "prime-exponent-score",
                "fx",
                "Prime-exponent score",
                FxFormula(),
                AssessedProvenance.FromRepo(),
                "A384669 states f_x(k) for a positive integer factorization k as the sum of "
                    + "the x-th powers of its exponents. The repository extends the formula to "
                    + "every natural n and real x using Nat.primeFactors and coerces each natural "
                    + "factorization value to the reals via the displayed toReal operation.",
                DescribeRole.Definition),
            Node(
                "div-plus-precedes",
                "DivPlusPrecedes",
                "First differing divisor order",
                DivPlusFormula(),
                AssessedProvenance.FromRepo(),
                "A095848 states its order through the infinite extended divisor lists Div+(n). "
                    + "DivPlusPrecedes is the repository encoding: for natural n and m, a positive "
                    + "d divides n but not m while the divisibility predicates agree at every "
                    + "positive natural e below d, so the first difference favors n.",
                DescribeRole.Definition),
            Node(
                "deeply-composite-record",
                "DC",
                "Deeply composite record predicate",
                DcFormula(),
                AssessedProvenance.FromRepo(),
                "A095848 gives the deeply composite sequence through successive records of its "
                    + "extended divisor-list order. The repository predicate DC(n) quantifies over "
                    + "all natural m with 1 <= m < n and uses DivPlusPrecedes as the equivalent "
                    + "least-differing-divisor record formulation required by the source atom.",
                DescribeRole.Definition),
            Node(
                "strict-prime-exponent-record",
                "StrictRecord",
                "Strict score record",
                StrictRecordFormula(),
                AssessedProvenance.FromRepo(),
                "A384669 defines A_x by strict score records among positive integers. The "
                    + "repository predicate quantifies x over all reals and m over all naturals, "
                    + "with the explicit guards m < n and 1 <= m, and preserves the strict "
                    + "inequality fx(m,x) < fx(n,x).",
                DescribeRole.Definition),
            Node(
                "b-infinity",
                "Binfty",
                "The union B-infinity",
                BinftyFormula(),
                AssessedProvenance.FromRepo(),
                "A385722 defines B-infinity as the union of the A_x values for 0 < x < 1 and "
                    + "asks whether infinitely many, or all, A095848 terms occur. The repository "
                    + "set uses an existential real x in that open interval together with the "
                    + "strict record predicate; A385722 notes the equivalent rational-parameter "
                    + "form by continuity. StrictRecord x 0 holds vacuously, so 0 ∈ Binfty under "
                    + "this definition; the source sequence is over positive integers and every "
                    + "covered clause concerns 25200, unaffected by the convention.",
                DescribeRole.Definition),
            Node(
                "literal-factorizations",
                "literal_factorizations",
                "Literal factorizations used by the certificate",
                LiteralFactorizationsFormula(),
                AssessedProvenance.FromRepo(),
                "The repository verifies all three literal prime factorizations used to evaluate "
                    + "the scores. Consumer-to-prerequisite paths: fx_25200 -> "
                    + "factorization_25200 -> literal_factorizations; fx_18480 -> "
                    + "factorization_18480 -> literal_factorizations; and fx_20160 -> "
                    + "factorization_20160 -> literal_factorizations. The intermediate "
                    + "factorization declarations are private Lean helpers.",
                DescribeRole.Theorem),
            Node(
                "score-25200-normal-form",
                "fx_25200",
                "Normalized score of 25200",
                Fx25200Formula(),
                AssessedProvenance.FromRepo(),
                "The repository normalizes the score from the certified factorization "
                    + "25200 = 2^4*3^2*5^2*7. Dependency path: fx_25200 -> "
                    + "factorization_25200 -> literal_factorizations.",
                DescribeRole.Theorem),
            Node(
                "score-18480-normal-form",
                "fx_18480",
                "Normalized score of 18480",
                Fx18480Formula(),
                AssessedProvenance.FromRepo(),
                "The repository normalizes the first competitor's score from the certified "
                    + "factorization 18480 = 2^4*3*5*7*11. Dependency path: fx_18480 -> "
                    + "factorization_18480 -> literal_factorizations.",
                DescribeRole.Theorem),
            Node(
                "score-20160-normal-form",
                "fx_20160",
                "Normalized score of 20160",
                Fx20160Formula(),
                AssessedProvenance.FromRepo(),
                "The repository normalizes the second competitor's score from the certified "
                    + "factorization 20160 = 2^6*3^2*5*7. Dependency path: fx_20160 -> "
                    + "factorization_20160 -> literal_factorizations.",
                DescribeRole.Theorem),
            Node(
                "score-gap-identity",
                "score_gap_identity",
                "Positive score-gap identity",
                ScoreGapIdentityFormula(),
                AssessedProvenance.FromRepo(),
                "After substituting z = t - 3/2, the repository proves this polynomial identity "
                    + "by ring normalization; nonnegativity of its right side supplies the strict "
                    + "gap used above the threshold.",
                DescribeRole.Theorem),
            Node(
                "deeply-composite-25200",
                "dc_25200",
                "25200 is deeply composite",
                Disp(Call("DC", Number25200())),
                AssessedProvenance.FromRepo(),
                "The finite certificate first treats a challenger divisible by 2520 as "
                    + "2520*j for 1 <= j <= 9; the first difference is 16 for odd j and "
                    + "25 for even j. Otherwise the first missing divisor among 2 through "
                    + "10 favors 25200. This proves the universal record condition.",
                DescribeRole.Theorem),
            Node(
                "score-25200-bounded-by-competitors",
                "score_25200_le_competitors",
                "Two smaller competitors dominate every parameter",
                ScoreFormula(),
                AssessedProvenance.FromRepo(),
                "For every real x, the score of 25200 is bounded by the larger score of "
                    + "18480 and 20160. With t=2^x and u=3^x, the three scores normalize "
                    + "to t^2+2t+1, t^2+4, and tu+t+2. The first competitor handles "
                    + "t <= 3/2; above that threshold, monotonicity of real powers and the "
                    + "positive polynomial identity in z=t-3/2 make the second competitor win. "
                    + "Dependency directions: score_25200_le_competitors -> fx_25200, "
                    + "fx_18480, fx_20160, and score_gap_identity.",
                DescribeRole.Theorem),
            Node(
                "not-strict-record-25200",
                "not_strictRecord_25200",
                "25200 is never a strict score record",
                NotStrictFormula(),
                AssessedProvenance.FromRepo(),
                "Both competitors are positive naturals smaller than 25200. If 25200 were "
                    + "a strict record, both scores would be strictly below its score, "
                    + "contradicting score_25200_le_competitors. Dependency direction: "
                    + "not_strictRecord_25200 -> score_25200_le_competitors.",
                DescribeRole.Theorem),
            Node(
                "deeply-composite-25200-not-in-b-infinity",
                "deeply_composite_25200_not_in_Binfty",
                "The complete 25200 counterexample",
                MainFormula(),
                AssessedProvenance.FromRepo(),
                "The whole candidate theorem combines the certified deeply-composite fact "
                    + "with exclusion from strict records for every real parameter. Dependency "
                    + "directions: deeply_composite_25200_not_in_Binfty -> dc_25200 and "
                    + "deeply_composite_25200_not_in_Binfty -> not_strictRecord_25200.",
                DescribeRole.Theorem),
            Node(
                "number-25200-not-in-b-infinity",
                "not_mem_Binfty_25200",
                "25200 is outside B-infinity",
                NotMemFormula(),
                AssessedProvenance.FromRepo(),
                "Unfolding membership in Binfty would supply a real parameter and a strict "
                    + "record witness, which not_strictRecord_25200 excludes. Dependency "
                    + "direction: not_mem_Binfty_25200 -> not_strictRecord_25200. This answers "
                    + "the all-deeply-composite branch negatively; the infinitely-many branch "
                    + "is not asserted or resolved here.",
                DescribeRole.Theorem)),
        []));

    private static DocumentBlock.Describe Node(
        string id,
        string declaration,
        string title,
        Formula formula,
        AssessedProvenance provenance,
        string prose,
        DescribeRole role) => Describe.Lean(
            Id(id), Handle(declaration), H(title), StatementSource.FromAuthor(formula), provenance,
            Blocks(Paragraph(Text(prose))), role);

    private static DescribeId Id(string value) => DescribeId.Create(value);

    private static DeclarationHandle Handle(string name) =>
        DeclarationHandle.Create(Prefix + name);

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.FunctionCall(FormulaIdentifier.Create(name), [.. arguments]);

    private static Formula Nats() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula Reals() => Seq(Mathbb, Grp(F.Id("R")));

    private static Formula Number25200() => D(2, 5, 2, 0, 0);

    private static Formula Dvd(Formula left, Formula right) =>
        Seq(left, Sp, Mid, Sp, right);

    private static Formula Not(Formula body) => Seq(Neg, Sp, Parenthesized(body));

    private static Formula FxFormula()
    {
        var n = F.Id("n");
        var x = F.Id("x");
        var p = F.Id("p");
        return Disp(Seq(
            Forall, Sp, n, Sp, InMacro, Sp, Nats(), Comma, Sp,
            Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Call("fx", n, x), Sp, Eq, Sp,
            new Formula.Subscript(
                Sum,
                new Formula.Relation(
                    p,
                    FormulaRelationOperator.MemberOf,
                    Call("primeFactors", n))), Sp,
            Parenthesized(Call("toReal", Call("factorization", n, p))), Caret, Grp(x)));
    }

    private static Formula DivPlusFormula()
    {
        var n = F.Id("n");
        var m = F.Id("m");
        var d = F.Id("d");
        var e = F.Id("e");
        var prefix = Seq(
            Forall, Sp, e, Sp, InMacro, Sp, Nats(), Comma, Sp,
            D(1), Sp, Leq, Sp, e, Sp, Rightarrow, Sp,
            e, Sp, Lt, Sp, d, Sp, Rightarrow, Sp,
            Parenthesized(Seq(Dvd(e, n), Sp, Iff, Sp, Dvd(e, m))));
        return Disp(Seq(
            Forall, Sp, n, Comma, Sp, m, Sp, InMacro, Sp, Nats(), Comma, Sp,
            Call("DivPlusPrecedes", n, m), Sp, Iff, Sp,
            Exists, Sp, d, Sp, InMacro, Sp, Nats(), Comma, Sp,
            Parenthesized(Seq(
                D(1), Sp, Leq, Sp, d, Sp, Land, Sp,
                Dvd(d, n), Sp, Land, Sp,
                Not(Dvd(d, m)), Sp, Land, Sp,
                prefix))));
    }

    private static Formula DcFormula()
    {
        var n = F.Id("n");
        var m = F.Id("m");
        return Disp(Seq(
            Forall, Sp, n, Sp, InMacro, Sp, Nats(), Comma, Sp,
            Call("DC", n), Sp, Iff, Sp,
            Parenthesized(Seq(
                D(1), Sp, Leq, Sp, n, Sp, Land, Sp,
                Parenthesized(Seq(
                    Forall, Sp, m, Sp, InMacro, Sp, Nats(), Comma, Sp,
                    D(1), Sp, Leq, Sp, m, Sp, Rightarrow, Sp,
                    m, Sp, Lt, Sp, n, Sp, Rightarrow, Sp,
                    Call("DivPlusPrecedes", n, m)))))));
    }

    private static Formula StrictRecordFormula()
    {
        var x = F.Id("x");
        var n = F.Id("n");
        var m = F.Id("m");
        return Disp(Seq(
            Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Forall, Sp, n, Sp, InMacro, Sp, Nats(), Comma, Sp,
            Call("StrictRecord", x, n), Sp, Iff, Sp,
            Parenthesized(Seq(
                Forall, Sp, m, Sp, InMacro, Sp, Nats(), Comma, Sp,
                m, Sp, Lt, Sp, n, Sp, Rightarrow, Sp,
                D(1), Sp, Leq, Sp, m, Sp, Rightarrow, Sp,
                Call("fx", m, x), Sp, Lt, Sp, Call("fx", n, x)))));
    }

    private static Formula BinftyFormula()
    {
        var n = F.Id("n");
        var x = F.Id("x");
        return Disp(Seq(
            F.Id("Binfty"), Sp, Eq, Sp,
            OpenBrace, n, Sp, InMacro, Sp, Nats(), Sp, Mid, Sp,
            Exists, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Parenthesized(Seq(
                D(0), Sp, Lt, Sp, x, Sp, Land, Sp,
                x, Sp, Lt, Sp, D(1), Sp, Land, Sp,
                Call("StrictRecord", x, n))),
            CloseBrace));
    }

    private static Formula Fx25200Formula()
    {
        var x = F.Id("x");
        return Disp(Seq(
            Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Equal(
                Call("fx", Number25200(), x),
                Add(
                    Add(
                        Power(D(2), Parenthesized(Multiply(D(2), x))),
                        Multiply(D(2), Power(D(2), x))),
                    D(1)))));
    }

    private static Formula Fx18480Formula()
    {
        var x = F.Id("x");
        return Disp(Seq(
            Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Equal(
                Call("fx", D(1, 8, 4, 8, 0), x),
                Add(Power(D(2), Parenthesized(Multiply(D(2), x))), D(4)))));
    }

    private static Formula Fx20160Formula()
    {
        var x = F.Id("x");
        return Disp(Seq(
            Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Equal(
                Call("fx", D(2, 0, 1, 6, 0), x),
                Add(
                    Add(Multiply(Power(D(2), x), Power(D(3), x)), Power(D(2), x)),
                    D(2)))));
    }

    private static Formula LiteralFactorizationsFormula()
    {
        var factorization25200 = Equal(
            Number25200(),
            Multiply(
                Multiply(
                    Multiply(Power(D(2), D(4)), Power(D(3), D(2))),
                    Power(D(5), D(2))),
                D(7)));
        var factorization18480 = Equal(
            D(1, 8, 4, 8, 0),
            Multiply(
                Multiply(
                    Multiply(Multiply(Power(D(2), D(4)), D(3)), D(5)),
                    D(7)),
                D(1, 1)));
        var factorization20160 = Equal(
            D(2, 0, 1, 6, 0),
            Multiply(
                Multiply(Multiply(Power(D(2), D(6)), Power(D(3), D(2))), D(5)),
                D(7)));
        return Disp(new Formula.Logic(
            Parenthesized(factorization25200),
            FormulaLogicOperator.And,
            new Formula.Logic(
                Parenthesized(factorization18480),
                FormulaLogicOperator.And,
                Parenthesized(factorization20160))));
    }

    private static Formula ScoreGapIdentityFormula()
    {
        var t = F.Id("t");
        var z = F.Id("z");
        var squareBase = Parenthesized(Subtract(Add(Power(t, D(2)), t), D(1)));
        var left = Multiply(
            D(3, 2),
            Parenthesized(Subtract(Power(t, D(5)), Power(squareBase, D(2)))));
        var right = Add(
            Add(
                Add(
                    Add(
                        Add(Multiply(D(3, 2), Power(z, D(5))),
                            Multiply(D(2, 0, 8), Power(z, D(4)))),
                        Multiply(D(4, 6, 4), Power(z, D(3)))),
                    Multiply(D(3, 9, 2), Power(z, D(2)))),
                Multiply(D(1, 0, 6), z)),
            D(1));
        var substitution = Equal(z, Subtract(t, new Formula.Fraction(D(3), D(2))));
        var identity = Equal(left, right);
        return Disp(Seq(
            Forall, Sp, t, Comma, Sp, z, Sp, InMacro, Sp, Reals(), Comma, Sp,
            new Formula.Logic(
                Parenthesized(substitution),
                FormulaLogicOperator.Implies,
                Parenthesized(identity))));
    }

    private static Formula ScoreFormula()
    {
        var x = F.Id("x");
        return Disp(Seq(
            Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Call("fx", Number25200(), x), Sp, Leq, Sp,
            Call("max", Call("fx", D(1, 8, 4, 8, 0), x),
                Call("fx", D(2, 0, 1, 6, 0), x))));
    }

    private static Formula NotStrictFormula()
    {
        var x = F.Id("x");
        return Disp(Seq(
            Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
            Not(Call("StrictRecord", x, Number25200()))));
    }

    private static Formula MainFormula()
    {
        var x = F.Id("x");
        return Disp(Seq(
            Call("DC", Number25200()), Sp, Land, Sp,
            Parenthesized(Seq(
                Forall, Sp, x, Sp, InMacro, Sp, Reals(), Comma, Sp,
                Not(Call("StrictRecord", x, Number25200()))))));
    }

    private static Formula NotMemFormula() => Disp(Not(Seq(
        Number25200(), Sp, InMacro, Sp, F.Id("Binfty"))));

    private static Formula Add(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);

    private static Formula Subtract(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Subtract, right);

    private static Formula Multiply(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula Power(Formula @base, Formula exponent) =>
        new Formula.Power(@base, exponent);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);
}
