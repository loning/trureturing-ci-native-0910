using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.ExponentExchange;

internal sealed class IntegerSwapDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/ExponentExchange/IntegerSwap.";
    private static readonly LibraryNoteRef AlaogluErdos =
        LibraryNoteRef.Create("D5/L/Arith/alaoglu1944highly");

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Prime exponent exchange lowers the integer and raises normalized sigma.",
        H("Integer Prime Exponent Exchange"),
        Blocks(Describe.Lean(
            DescribeId.Create("integer-prime-exponent-exchange"),
            DeclarationHandle.Create(Prefix + "prime_exponent_swap"),
            H("A smaller integer with a larger normalized divisor sum"),
            StatementSource.FromAuthor(SwapFormula()),
            AssessedProvenance.FromLiterature(AlaogluErdos),
            Blocks(
                Paragraph(Text(
                    "For every positive natural number m and primes p < q, let a and b be "
                        + "Nat.factorization m evaluated at p and q. Assume a < b, with no "
                        + "positivity assumption on a. In the display, div denotes natural "
                        + "number division, v denotes Nat.factorization, and z is the "
                        + "integer obtained by swapping the two exponents.")),
                Paragraph(Text(
                    "The conclusion contains five assertions: the quotient t is at least "
                        + "one; its gcd with pq is one; the original integer has the stated "
                        + "factorization; z is positive and smaller than m; and the normalized "
                        + "divisor sum strictly increases. The symbol sigma1 means "
                        + "ArithmeticFunction.sigma 1, with the final two ratios cast to the "
                        + "real numbers before division.")),
                Paragraph(Text(
                    "The construction uses divisibility of both full prime powers and "
                        + "coprimality of distinct primes. Subtracting their factorizations "
                        + "leaves valuation zero at each selected prime, proving the "
                        + "cofactor coprimality needed by sigma multiplicativity. Factoring "
                        + "out the shared powers reduces integer size to p^(b-a) < q^(b-a). "
                        + "The normalized sigma factors are reciprocal geometric sums; "
                        + "the imported strict real exchange inequality is multiplied by "
                        + "the positive common factor sigma1(t)/t.")),
                Paragraph(Text(
                    "This is the integer construction underlying the classical prime "
                        + "exponent ordering argument. It establishes neither a record-point "
                        + "theorem nor a hypothesis concerning zeros of the zeta function. "
                        + "Repository and pinned Mathlib searches found the scalar comparison "
                        + "and the arithmetic primitives used here. External Lean ecosystem "
                        + "searches found no matching full exchange declaration in the "
                        + "searched results; no global novelty claim is made."))),
            DescribeRole.Theorem))));

    private static Formula SwapFormula() => Disp(new Formula.Aligned([
        Seq(Forall, Sp, F.Id("m"), Comma, Sp, F.Id("p"), Comma, Sp, F.Id("q"),
            Sp, InMacro, Sp, Mathbb, Grp(F.Id("N")), Comma),
        Seq(D(1), Sp, Le, Sp, F.Id("m"), Comma, Sp,
            Call("Prime", F.Id("p")), Comma, Sp, Call("Prime", F.Id("q")), Comma, Sp,
            F.Id("p"), Sp, Lt, Sp, F.Id("q"), Comma),
        Seq(F.Id("a"), Sp, Eq, Sp, Call("v", F.Id("m"), F.Id("p")), Comma, Sp,
            F.Id("b"), Sp, Eq, Sp, Call("v", F.Id("m"), F.Id("q")), Comma, Sp,
            F.Id("a"), Sp, Lt, Sp, F.Id("b"), Comma),
        Seq(F.Id("t"), Sp, Eq, Sp, Call("div", F.Id("m"),
            Product(Power("p", "a"), Power("q", "b"))), Comma, Sp,
            F.Id("z"), Sp, Eq, Sp,
            Product(Product(F.Id("t"), Power("p", "b")), Power("q", "a")),
            Sp, Rightarrow),
        Seq(D(1), Sp, Le, Sp, F.Id("t"), Sp, Land, Sp,
            Call("gcd", F.Id("t"), Product(F.Id("p"), F.Id("q"))), Sp, Eq, Sp, D(1)),
        Seq(Land, Sp, F.Id("m"), Sp, Eq, Sp,
            Product(Product(F.Id("t"), Power("p", "a")), Power("q", "b"))),
        Seq(Land, Sp, D(0), Sp, Lt, Sp, F.Id("z"), Sp, Lt, Sp, F.Id("m")),
        Seq(Land, Sp, Ratio("m"), Sp, Lt, Sp, Ratio("z"), Dot)
    ]));

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula Power(string value, string exponent) =>
        new Formula.Power(F.Id(value), F.Id(exponent));

    private static Formula Product(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula Ratio(string value) =>
        new Formula.Fraction(Call("sigma1", F.Id(value)), F.Id(value));
}
