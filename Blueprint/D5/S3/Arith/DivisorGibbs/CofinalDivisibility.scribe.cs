using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.DivisorGibbs;

internal sealed class CofinalDivisibilityDocument : IScribeDocumentDefinition
{
    private static Formula N => F.Id("n");
    private static Formula K => F.Id("k");
    private static Formula P => F.Id("p");
    private static Formula J => F.Id("j");

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "One explicit cutoff bounds both prime indices and valuations in the Fibonacci "
            + "prime-power divisibility ladder.",
        H("Cofinal Divisibility Ladder"),
        Blocks(
            Paragraph(Text(
                "All indices and products are natural-valued. Write p(j) for Nat.nth Nat.Prime j, "
                    + "S(n) for n.factorization.support, c(p) for Nat.count Nat.Prime p, and "
                    + "v(n,p) for n.factorization p. The finite maximum over an empty support "
                    + "is zero. The following M and K are local notation, not new global definitions.")),
            Paragraph(Math(Equal(Call("M", K), Seq(
                Prod, Underscore, Grp(Seq(J, Sp, Lt, Sp, K)), Sp,
                new Formula.Power(Call("p", J), Subtract(Call("fib", Add(K, D(2))), D(1))))))),
            Paragraph(Math(Equal(Call("K", N), Call("max", D(3), Add(D(1), Seq(
                Max, Underscore, Grp(Seq(P, Sp, InMacro, Sp, Call("S", N))), Sp,
                Call("max", Call("c", P), Call("v", N, P)))))))),
            Describe.Lean(
                DescribeId.Create("cofinal-divisibility-ladder"),
                DeclarationHandle.Create(
                    "D5/S3/Arith/DivisorGibbs/CofinalDivisibility.cofinal_divisibility_ladder"),
                H("Joint cutoff and successive divisibility"),
                StatementSource.FromAuthor(Disp(ForAll("n", Implies(Le(D(1), N), And(
                    ForAll("k", Implies(Le(Call("K", N), K), Divides(N, Call("M", K)))),
                    ForAll("k", Divides(Call("M", K), Call("M", Add(K, D(1)))))))))),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "The named cutoff_dvd construction uses the support supremum twice: "
                            + "c(p) is strictly below k, and v(n,p) is at most fib(k+2)-1. "
                            + "The latter uses k at least three and the library bound "
                            + "k+2 at most fib(k+2). Nat.nth_count locates p in the product; "
                            + "its single summand bounds the product valuation from below. "
                            + "Nat.factorization_le_iff_dvd turns these comparisons into divisibility.")),
                    Paragraph(Text(
                        "The step_dvd construction uses Fibonacci monotonicity on the old prime "
                            + "factors, then appends the next prime factor. It covers every natural "
                            + "k, including zero. The cutoff clause also covers n=1, whose support "
                            + "is empty. No infinite-sum convergence theorem is asserted here."))),
                DescribeRole.Theorem))));

    private static Formula ForAll(string name, Formula body) => new Formula.BindMany(
        FormulaQuantifier.ForAll,
        [new Formula.BoundVariable(FormulaIdentifier.Create(name), Seq(Mathbb, Grp(F.Id("N"))))],
        body);

    private static Formula Le(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.LessThanOrEqual, b);

    private static Formula Divides(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.Divides, b);

    private static Formula And(Formula a, Formula b) =>
        new Formula.Logic(a, FormulaLogicOperator.And, b);

    private static Formula Implies(Formula a, Formula b) =>
        new Formula.Logic(a, FormulaLogicOperator.Implies, b);
}
