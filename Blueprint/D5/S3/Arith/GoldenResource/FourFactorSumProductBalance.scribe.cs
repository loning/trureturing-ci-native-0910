using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class FourFactorSumProductBalanceDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/FourFactorSumProductBalance.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Positive integer quadruples have equal sum and product exactly when they permute 4, 2, 1, 1; the common value is eight.",
        H("Four Positive Integers with Equal Sum and Product"),
        Blocks(
            Paragraph(Text("All four coordinates are natural numbers. Positivity excludes zero. Perm denotes the usual permutation relation on lists, including repeated entries. Subtraction is natural-number subtraction.")),
            Entry("lower-pair", "sorted_positive_sum_product_lower_pair_eq_one",
                "The two smallest coordinates",
                ForAll(Implies(SortedHypotheses(),
                    And(Equal(F.Id("c"), D(1)), Equal(F.Id("d"), D(1))))),
                "Suppose the coordinates are decreasing. If the smallest is at least two, the product is at least eight times the largest coordinate, whereas the sum is at most four times it. Thus the smallest is one. If the next smallest were at least two, the product would be at least four times the largest coordinate, whereas the sum would be at most three times it plus one. The largest is then at least two, so this is again impossible."),
            Entry("two-factor-reduction", "sorted_positive_sum_product_reduction",
                "The remaining two factors",
                ForAll(Implies(SortedHypotheses(),
                    And(Equal(Add(Add(F.Id("a"), F.Id("b")), D(2)),
                            Multiply(F.Id("a"), F.Id("b"))),
                        Equal(Multiply(Subtract(F.Id("a"), D(1)),
                            Subtract(F.Id("b"), D(1))), D(3))))),
                "Substituting the two unit coordinates gives the first equation. Both remaining coordinates are at least one, so expansion after subtracting one from each gives the second equation."),
            Entry("sorted-classification", "sorted_positive_sum_product_classification",
                "The decreasing solution",
                ForAll(Implies(SortedHypotheses(),
                    And(Equal(F.Id("a"), D(4)),
                        And(Equal(F.Id("b"), D(2)),
                            And(Equal(F.Id("c"), D(1)), Equal(F.Id("d"), D(1))))))),
                "The second coordinate cannot be one. If it were at least three, the remaining two-factor product would be at least three times the largest coordinate, exceeding the sum of those coordinates plus two. Hence the second coordinate is two and the largest is four."),
            Entry("permutation-classification", "positive_sum_product_iff_perm",
                "All positive solutions",
                ForAll(Implies(Positive(),
                    Iff(Equal(Sum(), Product()),
                        new Formula.Apply(F.Id("Perm"),
                            [Tuple(F.Id("a"), F.Id("b"), F.Id("c"), F.Id("d")),
                                Tuple(D(4), D(2), D(1), D(1))])))),
                "Sort the four coordinates in decreasing order. Sorting preserves the list length, positivity, sum, and product, so the decreasing classification applies. Conversely, a permutation of the stated list has the same sum and product."),
            Entry("common-value", "positive_sum_product_common_value",
                "The common value",
                ForAll(Implies(And(Positive(), Equal(Sum(), Product())),
                    And(Equal(Sum(), D(8)), Equal(Product(), D(8))))),
                "Permutation invariance makes both quantities equal to eight for every positive solution."),
            Paragraph(Text("At the decreasing solution this specializes to "),
                Math(Seq(D(4), Plus, D(2), Plus, D(1), Plus, D(1), Eq, D(8), Eq,
                    D(4), Cdot, D(2), Cdot, D(1), Cdot, D(1))), Text(".")))));

    private static DocumentBlock Entry(string id, string declaration, string title,
        Formula statement, string commentary) =>
        Describe.Lean(DescribeId.Create(id), DeclarationHandle.Create(Prefix + declaration),
            H(title), StatementSource.FromAuthor(Disp(statement)), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(commentary))), DescribeRole.Theorem);

    private static Formula ForAll(Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("a"), Bound("b"), Bound("c"), Bound("d")], body);

    private static Formula.BoundVariable Bound(string name) =>
        new(FormulaIdentifier.Create(name), Seq(Mathbb, Grp(F.Id("N"))));

    private static Formula Positive() =>
        And(Less(D(0), F.Id("a")), And(Less(D(0), F.Id("b")),
            And(Less(D(0), F.Id("c")), Less(D(0), F.Id("d")))));

    private static Formula SortedHypotheses() =>
        And(Less(D(0), F.Id("d")), And(Le(F.Id("d"), F.Id("c")),
            And(Le(F.Id("c"), F.Id("b")), And(Le(F.Id("b"), F.Id("a")),
                Equal(Sum(), Product())))));

    private static Formula Sum() =>
        Add(Add(Add(F.Id("a"), F.Id("b")), F.Id("c")), F.Id("d"));

    private static Formula Product() =>
        Multiply(Multiply(Multiply(F.Id("a"), F.Id("b")), F.Id("c")), F.Id("d"));

    private static Formula Tuple(Formula a, Formula b, Formula c, Formula d) =>
        Seq(OpenBracket, a, Comma, Sp, b, Comma, Sp, c, Comma, Sp, d, CloseBracket);

    private static Formula Less(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.LessThan, b);

    private static Formula Le(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.LessThanOrEqual, b);

    private static Formula And(Formula a, Formula b) =>
        new Formula.Logic(a, FormulaLogicOperator.And, b);

    private static Formula Implies(Formula a, Formula b) =>
        new Formula.Logic(a, FormulaLogicOperator.Implies, b);

    private static Formula Iff(Formula a, Formula b) =>
        new Formula.Logic(a, FormulaLogicOperator.Iff, b);
}
