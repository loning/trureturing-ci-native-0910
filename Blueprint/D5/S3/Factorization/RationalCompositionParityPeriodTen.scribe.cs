using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class RationalCompositionParityPeriodTenDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Factorization/RationalCompositionParityPeriodTen.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "A characteristic-two reduction of the rational recurrence for OEIS A396093 "
            + "proves both published parity conjectures.",
        H("A396093 Parity Period Ten"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("a396093-denominator-expansion"),
                DeclarationHandle.Create(Prefix + "denominator_expansion"),
                H("Denominator expansion"),
                StatementSource.FromAuthor(DenominatorExpansionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every integer x, direct polynomial normalization identifies the "
                        + "squared quartic denominator with all nine displayed coefficients."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-numerator-expansion"),
                DeclarationHandle.Create(Prefix + "numerator_expansion"),
                H("Numerator expansion"),
                StatementSource.FromAuthor(NumeratorExpansionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every integer x, direct polynomial normalization identifies the "
                        + "factored numerator with all eight displayed coefficients."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-linear-recurrence"),
                DeclarationHandle.Create(Prefix + "recurrence"),
                H("Linear recurrence specification"),
                StatementSource.FromAuthor(RecurrenceDefinitionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The LinearRecurrence object has order eight and exactly the displayed "
                        + "inline recurrence coefficients."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("a396093-sequence"),
                DeclarationHandle.Create(Prefix + "a"),
                H("The A396093 integer sequence"),
                StatementSource.FromAuthor(SequenceDefinitionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The sequence is defined directly by the eight displayed initial values and "
                        + "the displayed order-eight integer recurrence. This fixes every term, "
                        + "rather than defining parity directly or naming a finite value table."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("a396093-is-solution"),
                DeclarationHandle.Create(Prefix + "a_is_solution"),
                H("The sequence satisfies the denominator recurrence"),
                StatementSource.FromAuthor(IsSolutionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This exposes the LinearRecurrence solution property used to obtain the "
                        + "coefficient equations of the rational generating function."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-rational-tail-equation"),
                DeclarationHandle.Create(Prefix + "rational_tail_equation"),
                H("Homogeneous coefficient equations"),
                StatementSource.FromAuthor(RationalTailFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every natural n, this is the coefficient equation in degree n+8 for "
                        + "denominator times A equals numerator. The numerator has degree seven, "
                        + "so every such coefficient is zero."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-initial-coefficient-equations"),
                DeclarationHandle.Create(Prefix + "initial_coefficient_equations"),
                H("Inhomogeneous coefficient equations"),
                StatementSource.FromAuthor(InitialEquationsFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "These eight clauses are the coefficients in degrees zero through seven of "
                        + "denominator times A equals numerator. Together with the tail equation "
                        + "they identify a coefficientwise with formula (2)."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-reduced-recurrence"),
                DeclarationHandle.Create(Prefix + "reduced_recurrence"),
                H("Characteristic-two recurrence"),
                StatementSource.FromAuthor(ReducedRecurrenceFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Casting the integer recurrence into ZMod(2) removes the even coefficients "
                        + "and turns subtraction into addition. Four even-indexed lags remain."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-parity-period-ten"),
                DeclarationHandle.Create(Prefix + "parity_period_ten"),
                H("Period ten modulo two"),
                StatementSource.FromAuthor(PeriodTenFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The displayed universal equality is Function.Periodic for the cast sequence "
                        + "with period ten. Applying the reduced recurrence at n and n+2 makes "
                        + "the three repeated middle terms cancel in characteristic two."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-odd-residue-characterization"),
                DeclarationHandle.Create(Prefix + "odd_iff_mod_ten"),
                H("Odd values exactly in four residue classes"),
                StatementSource.FromAuthor(OddIffFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every natural n, a(n) is odd exactly when the natural-number remainder "
                        + "n mod 10 belongs to {1,3,7,9}. Period ten reduces the assertion to the "
                        + "first ten residues 0,1,0,1,0,0,0,1,0,1."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-even-even-index"),
                DeclarationHandle.Create(Prefix + "even_at_even_index"),
                H("Even values at positive even indices"),
                StatementSource.FromAuthor(EvenIndexFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This is the first OEIS A396093 conjecture verbatim in mathematical content: "
                        + "a(2*n) is even for every n at least one. It is a directed companion "
                        + "from this theorem to odd_iff_mod_ten."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-even-odd-index-iff"),
                DeclarationHandle.Create(Prefix + "even_at_odd_index_iff"),
                H("Even values at odd indices"),
                StatementSource.FromAuthor(EvenOddIndexFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This is the second OEIS A396093 conjecture verbatim in mathematical content. "
                        + "For n at least one, a(2*n-1) is even exactly when some natural k at "
                        + "least one satisfies n=5*k-2. Both subtractions are natural subtraction, "
                        + "truncated at zero. The theorem points to odd_iff_mod_ten."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a396093-basic-rational-map"),
                DeclarationHandle.Create(Prefix + "B"),
                H("Basic rational map"),
                StatementSource.FromAuthor(BFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This transcribes the OEIS definition B(x)=x/(1-x)^2 over the rational "
                        + "numbers. Rational division is total in Lean."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("a396093-rational-formula-two"),
                DeclarationHandle.Create(Prefix + "rationalA"),
                H("Rational generating-function formula"),
                StatementSource.FromAuthor(RationalAFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This transcribes formula (2) of OEIS A396093 over the rational numbers. "
                        + "The coefficient equations above separately connect this expression "
                        + "to the integer sequence."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("a396093-triple-composition"),
                DeclarationHandle.Create(Prefix + "rationalA_eq_triple_B"),
                H("Formula (2) equals the third iterate of B"),
                StatementSource.FromAuthor(TripleCompositionFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every rational x, under exactly the two displayed non-pole assumptions, "
                        + "formula (2) equals B(B(B(x))). The assumptions name the denominators "
                        + "introduced by the first and second compositions; no additional pole "
                        + "hypothesis is required."))),
                DescribeRole.Theorem))));

    private static Formula DenominatorExpansionFormula()
    {
        Formula x = F.Id("x");
        Formula expanded = Subtract(D(1), Product(D(1, 4), x));
        expanded = Add(expanded, Product(D(7, 5), Power(x, 2)));
        expanded = Subtract(expanded, Product(D(1, 9, 6), Power(x, 3)));
        expanded = Add(expanded, Product(D(2, 6, 9), Power(x, 4)));
        expanded = Subtract(expanded, Product(D(1, 9, 6), Power(x, 5)));
        expanded = Add(expanded, Product(D(7, 5), Power(x, 6)));
        expanded = Subtract(expanded, Product(D(1, 4), Power(x, 7)));
        expanded = Add(expanded, Power(x, 8));
        return Disp(ForAll("x", Integers(), Equal(Power(DenominatorQuartic(x), 2), expanded)));
    }

    private static Formula NumeratorExpansionFormula()
    {
        Formula x = F.Id("x");
        Formula expanded = Subtract(x, Product(D(8), Power(x, 2)));
        expanded = Add(expanded, Product(D(2, 4), Power(x, 3)));
        expanded = Subtract(expanded, Product(D(3, 4), Power(x, 4)));
        expanded = Add(expanded, Product(D(2, 4), Power(x, 5)));
        expanded = Subtract(expanded, Product(D(8), Power(x, 6)));
        expanded = Add(expanded, Power(x, 7));
        return Disp(ForAll("x", Integers(), Equal(NumeratorFactored(x), expanded)));
    }

    private static Formula RecurrenceDefinitionFormula()
    {
        Formula recurrence = Named("recurrence");
        Formula clauses = And(
            Equal(Call("order", recurrence), D(8)),
            Equal(Call("coeffs", recurrence), Tuple(
                Negative(D(1)), D(1, 4), Negative(D(7, 5)), D(1, 9, 6),
                Negative(D(2, 6, 9)), D(1, 9, 6), Negative(D(7, 5)), D(1, 4))));
        return Disp(Seq(
            recurrence, Colon, Sp, Call("LinearRecurrence", Integers()), Comma, Sp,
            Parenthesized(clauses), Dot));
    }

    private static Formula SequenceDefinitionFormula()
    {
        Formula n = F.Id("n");
        Formula[] clauses =
        [
            Equal(A(D(0)), D(0)),
            Equal(A(D(1)), D(1)),
            Equal(A(D(2)), D(6)),
            Equal(A(D(3)), D(3, 3)),
            Equal(A(D(4)), D(1, 7, 4)),
            Equal(A(D(5)), D(8, 9, 2)),
            Equal(A(D(6)), D(4, 4, 8, 0)),
            Equal(A(D(7)), D(2, 2, 1, 4, 9)),
            ForAll("n", Naturals(), ARecurrenceEquation(n)),
        ];
        return Disp(Seq(
            F.Id("a"), Colon, Sp, FunctionType(Naturals(), Integers()), Comma, Sp,
            Parenthesized(AndMany(clauses)), Dot));
    }

    private static Formula IsSolutionFormula() =>
        Disp(Call("IsSolution", Named("recurrence"), F.Id("a")));

    private static Formula RationalTailFormula()
    {
        Formula n = F.Id("n");
        Formula expression = Add(
            Subtract(
                Add(
                    Subtract(
                        Add(
                            Subtract(
                                Add(
                                    Subtract(A(Add(n, D(8))), Product(D(1, 4), A(Add(n, D(7))))),
                                    Product(D(7, 5), A(Add(n, D(6))))),
                                Product(D(1, 9, 6), A(Add(n, D(5))))),
                            Product(D(2, 6, 9), A(Add(n, D(4))))),
                        Product(D(1, 9, 6), A(Add(n, D(3))))),
                    Product(D(7, 5), A(Add(n, D(2))))),
                Product(D(1, 4), A(Add(n, D(1))))),
            A(n));
        return Disp(ForAll("n", Naturals(), Equal(expression, D(0))));
    }

    private static Formula InitialEquationsFormula()
    {
        Formula[] equations =
        [
            Equal(A(D(0)), D(0)),
            Equal(Subtract(A(D(1)), Product(D(1, 4), A(D(0)))), D(1)),
            Equal(Add(Subtract(A(D(2)), Product(D(1, 4), A(D(1)))),
                Product(D(7, 5), A(D(0)))), Negative(D(8))),
            Equal(Subtract(Add(Subtract(A(D(3)), Product(D(1, 4), A(D(2)))),
                Product(D(7, 5), A(D(1)))), Product(D(1, 9, 6), A(D(0)))),
                D(2, 4)),
            Equal(Add(Subtract(Add(Subtract(A(D(4)), Product(D(1, 4), A(D(3)))),
                Product(D(7, 5), A(D(2)))), Product(D(1, 9, 6), A(D(1)))),
                Product(D(2, 6, 9), A(D(0)))), Negative(D(3, 4))),
            Equal(Subtract(Add(Subtract(Add(Subtract(A(D(5)), Product(D(1, 4), A(D(4)))),
                Product(D(7, 5), A(D(3)))), Product(D(1, 9, 6), A(D(2)))),
                Product(D(2, 6, 9), A(D(1)))), Product(D(1, 9, 6), A(D(0)))),
                D(2, 4)),
            Equal(Add(Subtract(Add(Subtract(Add(Subtract(A(D(6)),
                Product(D(1, 4), A(D(5)))), Product(D(7, 5), A(D(4)))),
                Product(D(1, 9, 6), A(D(3)))), Product(D(2, 6, 9), A(D(2)))),
                Product(D(1, 9, 6), A(D(1)))), Product(D(7, 5), A(D(0)))),
                Negative(D(8))),
            Equal(Subtract(Add(Subtract(Add(Subtract(Add(Subtract(A(D(7)),
                Product(D(1, 4), A(D(6)))), Product(D(7, 5), A(D(5)))),
                Product(D(1, 9, 6), A(D(4)))), Product(D(2, 6, 9), A(D(3)))),
                Product(D(1, 9, 6), A(D(2)))), Product(D(7, 5), A(D(1)))),
                Product(D(1, 4), A(D(0)))), D(1)),
        ];
        return Disp(AndMany(equations));
    }

    private static Formula ARecurrenceEquation(Formula n)
    {
        Formula right = Subtract(Product(D(1, 4), A(Add(n, D(7)))),
            Product(D(7, 5), A(Add(n, D(6)))));
        right = Add(right, Product(D(1, 9, 6), A(Add(n, D(5)))));
        right = Subtract(right, Product(D(2, 6, 9), A(Add(n, D(4)))));
        right = Add(right, Product(D(1, 9, 6), A(Add(n, D(3)))));
        right = Subtract(right, Product(D(7, 5), A(Add(n, D(2)))));
        right = Add(right, Product(D(1, 4), A(Add(n, D(1)))));
        right = Subtract(right, A(n));
        return Equal(A(Add(n, D(8))), right);
    }

    private static Formula ReducedRecurrenceFormula()
    {
        Formula n = F.Id("n");
        Formula right = SumMany(Cast(A(n)), Cast(A(Add(n, D(2)))), Cast(A(Add(n, D(4)))),
            Cast(A(Add(n, D(6)))));
        return Disp(ForAll("n", Naturals(), Equal(Cast(A(Add(n, D(8)))), right)));
    }

    private static Formula PeriodTenFormula()
    {
        Formula n = F.Id("n");
        return Disp(ForAll("n", Naturals(), Equal(Cast(A(Add(n, D(1, 0)))), Cast(A(n)))));
    }

    private static Formula OddIffFormula()
    {
        Formula n = F.Id("n");
        Formula residue = new Formula.Modulo(n, D(1, 0));
        Formula membership = Member(residue, new Formula.SetLiteral([D(1), D(3), D(7), D(9)]));
        return Disp(ForAll("n", Naturals(), Iff(Call("Odd", A(n)), membership)));
    }

    private static Formula EvenIndexFormula()
    {
        Formula n = F.Id("n");
        return Disp(ForAll("n", Naturals(), Implies(
            LessOrEqual(D(1), n), Call("Even", A(Product(D(2), n))))));
    }

    private static Formula EvenOddIndexFormula()
    {
        Formula n = F.Id("n");
        Formula k = F.Id("k");
        Formula witness = Exists("k", Naturals(), And(
            LessOrEqual(D(1), k), Equal(n, Subtract(Product(D(5), k), D(2)))));
        Formula conclusion = Iff(
            Call("Even", A(Subtract(Product(D(2), n), D(1)))), witness);
        return Disp(ForAll("n", Naturals(), Implies(LessOrEqual(D(1), n), conclusion)));
    }

    private static Formula BFormula()
    {
        Formula x = F.Id("x");
        return Disp(ForAll("x", Rationals(), Equal(Call("B", x),
            new Formula.Fraction(x, Power(Subtract(D(1), x), 2)))));
    }

    private static Formula RationalAFormula()
    {
        Formula x = F.Id("x");
        return Disp(ForAll("x", Rationals(), Equal(Call("rationalA", x),
            new Formula.Fraction(NumeratorFactored(x), Power(DenominatorQuartic(x), 2)))));
    }

    private static Formula TripleCompositionFormula()
    {
        Formula x = F.Id("x");
        Formula hypotheses = And(
            NotEqual(Subtract(D(1), x), D(0)),
            NotEqual(Add(Subtract(D(1), Product(D(3), x)), Power(x, 2)), D(0)));
        Formula conclusion = Equal(Call("rationalA", x),
            Call("B", Call("B", Call("B", x))));
        return Disp(ForAll("x", Rationals(), Implies(hypotheses, conclusion)));
    }

    private static Formula DenominatorQuartic(Formula x) =>
        Add(Subtract(Add(Subtract(D(1), Product(D(7), x)),
            Product(D(1, 3), Power(x, 2))), Product(D(7), Power(x, 3))), Power(x, 4));

    private static Formula NumeratorFactored(Formula x) =>
        Product(Product(x, Power(Subtract(D(1), x), 2)),
            Power(Add(Subtract(D(1), Product(D(3), x)), Power(x, 2)), 2));

    private static Formula A(Formula index) => Call("a", index);
    private static Formula Cast(Formula value) => Call("cast", value, Call("ZMod", D(2)));
    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);
    private static Formula Named(string name) => F.Id(name);
    private static Formula FunctionType(Formula domain, Formula codomain) =>
        new Formula.TypeArrow(domain, codomain);
    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));
    private static Formula Integers() => Seq(Mathbb, Grp(F.Id("Z")));
    private static Formula Rationals() => Seq(Mathbb, Grp(F.Id("Q")));
    private static Formula Power(Formula value, byte exponent) =>
        new Formula.Power(value, D(exponent));
    private static Formula Negative(Formula value) => new Formula.Negate(value);
    private static Formula Add(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);
    private static Formula Subtract(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Subtract, right);
    private static Formula Product(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);
    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);
    private static Formula NotEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.NotEqual, right);
    private static Formula LessOrEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);
    private static Formula Member(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.MemberOf, right);
    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);
    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);
    private static Formula Iff(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Iff, right);
    private static Formula ForAll(string variable, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(variable), domain, body);
    private static Formula Exists(string variable, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.Exists, FormulaIdentifier.Create(variable), domain, body);

    private static Formula SumMany(params Formula[] terms)
    {
        Formula result = terms[0];
        foreach (Formula term in terms[1..])
        {
            result = Add(result, term);
        }
        return result;
    }

    private static Formula AndMany(params Formula[] clauses)
    {
        Formula result = clauses[^1];
        for (int i = clauses.Length - 2; i >= 0; i--)
        {
            result = And(clauses[i], result);
        }
        return result;
    }

    private static Formula Joined(Formula[] values, Formula separator)
    {
        Formula[] items = new Formula[values.Length * 2 - 1];
        for (int i = 0; i < values.Length; i++)
        {
            items[2 * i] = values[i];
            if (i + 1 < values.Length)
            {
                items[2 * i + 1] = Seq(separator, Sp);
            }
        }
        return Seq(items);
    }

    private static Formula Tuple(params Formula[] values) => Parenthesized(Joined(values, Comma));
    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);
}
