using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith;

internal sealed class RecursiveModulusZeroPowerOfTwoDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/RecursiveModulusZeroPowerOfTwo.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "A coprime modular accumulator reaches zero exactly when its modulus is a power of two.",
        H("Recursive Modular Zeros and Powers of Two"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("recursive-modulus-accumulator"),
                DeclarationHandle.Create(Prefix + "S"),
                H("The modular accumulator"),
                StatementSource.FromAuthor(AccumulatorFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For natural numbers i and j, define S(i,j,0) = i and "
                        + "S(i,j,t+1) = S(i,j,t) + (S(i,j,t) mod j)."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("recursive-modulus-sequence"),
                DeclarationHandle.Create(Prefix + "b"),
                H("The modular sequence"),
                StatementSource.FromAuthor(SequenceFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Set b(i,j,t) = S(i,j,t) mod j. The index is zero-based: "
                        + "t = 0 is the source value b(i,j,1), so t corresponds to "
                        + "the source time minus one."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("recursive-modulus-doubling-identity"),
                DeclarationHandle.Create(Prefix + "doubling_identity"),
                H("The doubling identity"),
                StatementSource.FromAuthor(DoublingIdentityFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every t, the accumulator satisfies "
                        + "S(i,j,t) mod j = (2^t i) mod j. This follows by induction: "
                        + "the recurrence replaces the residue by twice the preceding "
                        + "residue modulo j."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("recursive-modulus-power-two-sufficiency"),
                DeclarationHandle.Create(Prefix + "exists_zero_of_eq_pow_two"),
                H("A power-of-two modulus gives a zero"),
                StatementSource.FromAuthor(PowerTwoSufficiencyFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "If j = 2^m, choose the zero-based time t = m. The doubling "
                        + "identity then gives b(i,j,m) = (2^m i) mod 2^m = 0."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("recursive-modulus-power-two-necessity"),
                DeclarationHandle.Create(Prefix + "eq_pow_two_of_exists_zero"),
                H("A zero forces a power-of-two modulus"),
                StatementSource.FromAuthor(PowerTwoNecessityFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For a positive i and a coprime pair (i,j), if some b(i,j,t) is "
                        + "zero, the doubling identity gives j dividing 2^t i. "
                        + "Coprimality cancels i, so j divides 2^t; the prime-power "
                        + "divisor characterization yields j = 2^m for some m."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("recursive-modulus-zero-equivalence"),
                DeclarationHandle.Create(Prefix + "zero_iff_power_of_two"),
                H("Zeros and powers of two are equivalent"),
                StatementSource.FromAuthor(ZeroIffPowerTwoFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For i >= 1, 1 <= j <= i, and gcd(i,j) = 1, the existence of a "
                        + "zero in the zero-based sequence is equivalent to j being a "
                        + "power of two. Translating t back by one gives the stated "
                        + "one-based source quantifier."))),
                DescribeRole.Theorem))));

    private static Formula AccumulatorFormula()
    {
        Formula i = F.Id("i");
        Formula j = F.Id("j");
        Formula t = F.Id("t");
        Formula current = Call("S", i, j, t);
        Formula clauses = And(
            Equal(Call("S", i, j, D(0)), i),
            Equal(
                Call("S", i, j, Add(t, D(1))),
                Add(current, Parenthesized(Modulo(current, j)))));
        return Display(ForAll([Bound("i"), Bound("j"), Bound("t")], clauses));
    }

    private static Formula SequenceFormula()
    {
        Formula i = F.Id("i");
        Formula j = F.Id("j");
        Formula t = F.Id("t");
        return Display(ForAll(
            [Bound("i"), Bound("j"), Bound("t")],
            Equal(Call("b", i, j, t), Modulo(Call("S", i, j, t), j))));
    }

    private static Formula DoublingIdentityFormula()
    {
        Formula i = F.Id("i");
        Formula j = F.Id("j");
        Formula t = F.Id("t");
        Formula doubled = Parenthesized(Multiply(Power(D(2), t), i));
        return Display(ForAll(
            [Bound("i"), Bound("j"), Bound("t")],
            Equal(Modulo(Call("S", i, j, t), j), Modulo(doubled, j))));
    }

    private static Formula PowerTwoSufficiencyFormula()
    {
        Formula i = F.Id("i");
        Formula j = F.Id("j");
        Formula m = F.Id("m");
        return Display(ForAll(
            [Bound("i"), Bound("j"), Bound("m")],
            Implies(Equal(j, Power(D(2), m)), ExistsZero(i, j))));
    }

    private static Formula PowerTwoNecessityFormula()
    {
        Formula i = F.Id("i");
        Formula j = F.Id("j");
        Formula hypotheses = AndMany(
            LessThan(D(0), i),
            LessOrEqual(D(1), j),
            LessOrEqual(j, i),
            Call("Coprime", i, j),
            ExistsZero(i, j));
        return Display(ForAll(
            [Bound("i"), Bound("j")],
            Implies(hypotheses, ExistsPowerOfTwo(j))));
    }

    private static Formula ZeroIffPowerTwoFormula()
    {
        Formula i = F.Id("i");
        Formula j = F.Id("j");
        Formula hypotheses = AndMany(
            LessThan(D(0), i),
            LessOrEqual(D(1), j),
            LessOrEqual(j, i),
            Call("Coprime", i, j));
        return Display(ForAll(
            [Bound("i"), Bound("j")],
            Implies(hypotheses, Iff(ExistsZero(i, j), ExistsPowerOfTwo(j)))));
    }

    private static Formula ExistsZero(Formula i, Formula j) =>
        new Formula.Bind(
            FormulaQuantifier.Exists,
            FormulaIdentifier.Create("t"),
            Naturals(),
            Equal(Call("b", i, j, F.Id("t")), D(0)));

    private static Formula ExistsPowerOfTwo(Formula j) =>
        new Formula.Bind(
            FormulaQuantifier.Exists,
            FormulaIdentifier.Create("m"),
            Naturals(),
            Equal(j, Power(D(2), F.Id("m"))));

    private static Formula Display(Formula statement) => Disp(Seq(statement, Dot));
    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);
    private static Formula Modulo(Formula value, Formula modulus) =>
        new Formula.Modulo(value, modulus);
    private static Formula Power(Formula value, Formula exponent) =>
        new Formula.Power(value, exponent);
    private static Formula Add(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);
    private static Formula Multiply(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);
    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);
    private static Formula LessThan(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);
    private static Formula LessOrEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);
    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);
    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);
    private static Formula Iff(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Iff, right);

    private static Formula ForAll(Formula.BoundVariable[] variables, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. variables], body);

    private static Formula.BoundVariable Bound(string name) =>
        new(FormulaIdentifier.Create(name), Naturals());

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula AndMany(params Formula[] clauses)
    {
        Formula result = clauses[^1];
        for (int index = clauses.Length - 2; index >= 0; index--)
        {
            result = And(clauses[index], result);
        }
        return result;
    }

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);
}
