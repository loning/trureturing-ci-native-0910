using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class GoldenObservationLatticeDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/GoldenObservationLattice.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Golden observation preserves the gcd and lcm lattice operations, but it preserves "
            + "neither multiplication nor associativity of observed products on its fixed points.",
        H("The Lattice Boundary of Golden Observation"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("observation-preserves-gcd"),
                DeclarationHandle.Create(Prefix + "Gobs_gcd"),
                H("Observation preserves greatest common divisors"),
                StatementSource.FromAuthor(GcdFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("At every prime, the exponent of a greatest common divisor "
                    + "is the minimum of the two input exponents. The exponent-layering map is "
                    + "monotone, so it commutes with this minimum. Reassembling the prime "
                    + "exponents gives the stated identity."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("observation-preserves-lcm"),
                DeclarationHandle.Create(Prefix + "Gobs_lcm"),
                H("Observation preserves least common multiples"),
                StatementSource.FromAuthor(LcmFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("At every prime, the exponent of a least common multiple "
                    + "is the maximum of the two input exponents. Monotonicity of exponent "
                    + "layering makes it commute with this maximum, and prime factorization "
                    + "then gives the identity."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("multiplicative-or-associative-witness"),
                DeclarationHandle.Create(Prefix
                    + "goldenObservationMultiplicativeOrAssociativeAtWitness"),
                H("The false multiplicative-or-associative alternative"),
                StatementSource.FromAuthor(BoundaryClaimFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This proposition is the disjunction of global "
                    + "multiplicativity and equality of the two products obtained by associating "
                    + "the fixed-point inputs 2, 2, and 4 in opposite ways."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("observation-is-not-multiplicative"),
                DeclarationHandle.Create(Prefix + "Gobs_not_multiplicative"),
                H("Observation is not multiplicative"),
                StatementSource.FromAuthor(NonmultiplicativeFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The values G(2)=2, G(4)=4, and G(8)=4 give a direct "
                    + "counterexample: G(2 times 4) is 4, whereas G(2) times G(4) is 8."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("observed-product-is-not-associative"),
                DeclarationHandle.Create(Prefix
                    + "Gobs_product_not_associative_on_fixed_points"),
                H("Observed multiplication is not associative on fixed points"),
                StatementSource.FromAuthor(NonassociativeFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The positive integers 2, 4, and 16 are fixed by golden "
                    + "observation. For the product x star y = G(x times y), the left-associated "
                    + "value at 2, 2, and 4 is G(16)=16, while the right-associated value is "
                    + "G(8)=4. The two values are unequal."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("lattice-boundary-refutation"),
                DeclarationHandle.Create(Prefix + "Gobs_lattice_boundary_refutation"),
                H("The multiplicative extension is refuted"),
                StatementSource.FromAuthor(BoundaryRefutationFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Neither alternative in the displayed disjunction holds: "
                    + "the first is contradicted by 2 and 4, and the second by the two unequal "
                    + "associations of 2, 2, and 4."))),
                DescribeRole.Theorem))));

    private static Formula GcdFormula() => Disp(All(
        [Bound("m", Positives()), Bound("n", Positives())],
        Equal(Observation(Call("gcd", F.Id("m"), F.Id("n"))),
            Call("gcd", Observation(F.Id("m")), Observation(F.Id("n"))))));

    private static Formula LcmFormula() => Disp(All(
        [Bound("m", Positives()), Bound("n", Positives())],
        Equal(Observation(Call("lcm", F.Id("m"), F.Id("n"))),
            Call("lcm", Observation(F.Id("m")), Observation(F.Id("n"))))));

    private static Formula BoundaryClaimFormula() => Disp(Or(
        Parenthesized(MultiplicativeFormula()),
        Parenthesized(AssociativeWitnessEquality())));

    private static Formula NonmultiplicativeFormula() =>
        Disp(new Formula.Not(Parenthesized(MultiplicativeFormula())));

    private static Formula NonassociativeFormula()
    {
        Formula left = LeftAssociatedWitness();
        Formula right = RightAssociatedWitness();
        return Disp(And(
            Call("Golden", D(2)),
            Call("Golden", D(4)),
            Call("Golden", D(1, 6)),
            Equal(left, D(1, 6)),
            Equal(right, D(4)),
            NotEqual(left, right)));
    }

    private static Formula BoundaryRefutationFormula() =>
        Disp(new Formula.Not(Parenthesized(Or(
            Parenthesized(MultiplicativeFormula()),
            Parenthesized(AssociativeWitnessEquality())))));

    private static Formula MultiplicativeFormula() => All(
        [Bound("m", Positives()), Bound("n", Positives())],
        Equal(Observation(Multiply(F.Id("m"), F.Id("n"))),
            Multiply(Observation(F.Id("m")), Observation(F.Id("n")))));

    private static Formula AssociativeWitnessEquality() =>
        Equal(LeftAssociatedWitness(), RightAssociatedWitness());

    private static Formula LeftAssociatedWitness() =>
        Observation(Multiply(Observation(Multiply(D(2), D(2))), D(4)));

    private static Formula RightAssociatedWitness() =>
        Observation(Multiply(D(2), Observation(Multiply(D(2), D(4)))));

    private static Formula Observation(Formula argument) => Call("G", argument);

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);

    private static Formula All(Formula.BoundVariable[] variables, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. variables], body);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula NotEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.NotEqual, right);

    private static Formula Or(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Or, right);

    private static Formula And(Formula first, params Formula[] rest)
    {
        Formula result = rest[^1];
        for (int index = rest.Length - 2; index >= 0; index--)
        {
            result = new Formula.Logic(rest[index], FormulaLogicOperator.And, result);
        }
        return new Formula.Logic(first, FormulaLogicOperator.And, result);
    }

    private static Formula Multiply(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);

    private static Formula Positives() =>
        Seq(Mathbb, Grp(F.Id("N")), Underscore, Grp(Gt, D(0)));
}
