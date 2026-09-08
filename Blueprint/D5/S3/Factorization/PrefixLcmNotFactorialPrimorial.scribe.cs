using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class PrefixLcmNotFactorialPrimorialDocument : IScribeDocumentDefinition
{
    private const string Prefix =
        "D5/S3/Factorization/PrefixLcmNotFactorialPrimorial.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The prefix least common multiple at 5^69 refutes the proposed decomposition into "
            + "a factorial product and a product of distinct primorials.",
        H("A Prefix Lcm Outside the Factorial-Primorial Products"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("factorial-product"),
                DeclarationHandle.Create(Prefix + "IsFactorialProduct"),
                H("Products of factorials"),
                StatementSource.FromAuthor(FactorialProductFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "A natural number J is a factorial product when some finite multiset of "
                        + "natural indices has J as the product of their factorials. Because the "
                        + "indices form a multiset, the same factorial may occur repeatedly, as "
                        + "required by the Jordan-Polya sequence A001013."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("distinct-primorial-product"),
                DeclarationHandle.Create(Prefix + "IsDistinctPrimorialProduct"),
                H("Products of distinct primorials"),
                StatementSource.FromAuthor(DistinctPrimorialProductFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "A natural number P is represented by a finite set S of prime indices, with "
                        + "one primorial factor for each q in S. Primorial values are constant "
                        + "between consecutive primes, for example primorial(3)=primorial(4)=6. "
                        + "Requiring every q in S to be prime therefore makes membership correspond "
                        + "exactly to a distinct primorial value, matching A129912."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("prefix-lcm-counterexample"),
                DeclarationHandle.Create(
                    Prefix + "prefixLcm_5_pow_69_not_factorial_mul_distinctPrimorial"),
                H("The prefix lcm at 5^69 is a counterexample"),
                StatementSource.FromAuthor(CounterexampleFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Let L be the least common multiple of the naturals through 5^69. Its "
                            + "valuations at 2,3,5,7,11,13,17,19,23,29,31,37 are respectively "
                            + "160,101,69,57,46,43,39,37,35,32,32,30. The weighted sum of "
                            + "successive valuation differences with weights "
                            + "3,1,-6,-7,-8,-5,-12,-12,-7,0,-6 is -65.")),
                    Paragraph(Text(
                        "Legendre's factorial valuation formula and a finite check through index "
                            + "163 show that every permitted factorial contributes a nonnegative "
                            + "weighted score. The valuation at 2 of 164! is 161, so no larger "
                            + "factorial can divide L. Each distinct primorial contributes at most "
                            + "one to each successive valuation gap, giving total score at least -63. "
                            + "Additivity would force -65 to be at least -63, a contradiction."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("prime-power-universal-refutation"),
                DeclarationHandle.Create(
                    Prefix + "not_forall_prime_pow_lcmUpto_factorial_mul_distinctPrimorial"),
                H("The universal prime-power decomposition is false"),
                StatementSource.FromAuthor(UniversalRefutationFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The number 5^69 is a positive power of the prime 5. The certified "
                        + "counterexample above therefore disproves the assertion that every "
                        + "prime power has the proposed factorial-primorial decomposition."))),
                DescribeRole.Theorem)),
        []));

    private static Formula FactorialProductFormula()
    {
        Formula j = F.Id("J");
        Formula ell = F.Id("ell");
        Formula k = F.Id("k");
        Formula naturals = Seq(Mathbb, Grp(F.Id("N")));
        Formula factorialProduct = Seq(
            Prod, Underscore, Grp(k, Sp, InMacro, Sp, ell), Sp, Grp(k), Bang);
        return Disp(Seq(
            Forall, Sp, j, Sp, InMacro, Sp, naturals, Comma, Sp,
            Call("IsFactorialProduct", j), Sp, Iff, Sp,
            Exists, Sp, ell, Colon, Sp, Call("Multiset", naturals), Comma, Sp,
            j, Sp, Eq, Sp, factorialProduct, Dot));
    }

    private static Formula DistinctPrimorialProductFormula()
    {
        Formula p = F.Id("P");
        Formula set = F.Id("S");
        Formula q = F.Id("q");
        Formula naturals = Seq(Mathbb, Grp(F.Id("N")));
        Formula primeIndices = Seq(
            Forall, Sp, q, Sp, InMacro, Sp, set, Comma, Sp, Call("Prime", q));
        Formula primorialProduct = Seq(
            Prod, Underscore, Grp(q, Sp, InMacro, Sp, set), Sp, Call("primorial", q));
        return Disp(Seq(
            Forall, Sp, p, Sp, InMacro, Sp, naturals, Comma, Sp,
            Call("IsDistinctPrimorialProduct", p), Sp, Iff, Sp,
            Exists, Sp, set, Colon, Sp, Call("Finset", naturals), Comma, Sp,
            Grp(primeIndices), Sp, Land, Sp, p, Sp, Eq, Sp, primorialProduct, Dot));
    }

    private static Formula CounterexampleFormula()
    {
        Formula j = F.Id("J");
        Formula p = F.Id("P");
        Formula naturals = Seq(Mathbb, Grp(F.Id("N")));
        Formula x = new Formula.Power(D(5), D(6, 9));
        Formula decomposition = Seq(
            Call("IsFactorialProduct", j), Sp, Land, Sp,
            Call("IsDistinctPrimorialProduct", p), Sp, Land, Sp,
            Call("lcmUpto", x), Sp, Eq, Sp, j, Sp, Cdot, Sp, p);
        return Disp(Seq(
            Neg, Sp, Exists, Sp, j, Comma, Sp, p, Sp, InMacro, Sp, naturals,
            Comma, Sp, Grp(decomposition), Dot));
    }

    private static Formula UniversalRefutationFormula()
    {
        Formula x = F.Id("X");
        Formula j = F.Id("J");
        Formula p = F.Id("P");
        Formula naturals = Seq(Mathbb, Grp(F.Id("N")));
        Formula decomposition = Seq(
            Call("IsFactorialProduct", j), Sp, Land, Sp,
            Call("IsDistinctPrimorialProduct", p), Sp, Land, Sp,
            Call("lcmUpto", x), Sp, Eq, Sp, j, Sp, Cdot, Sp, p);
        Formula witnesses = Seq(
            Exists, Sp, j, Comma, Sp, p, Sp, InMacro, Sp, naturals,
            Comma, Sp, Grp(decomposition));
        return Disp(Seq(
            Neg, Sp, Forall, Sp, x, Sp, InMacro, Sp, naturals, Comma, Sp,
            Call("IsPrimePow", x), Sp, Rightarrow, Sp, witnesses, Dot));
    }
}
