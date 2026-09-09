using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class SymmetricSigmaRepeatedPatternAbundancyDocument
    : IScribeDocumentDefinition
{
    private const string Prefix =
        "D5/S3/Factorization/SymmetricSigmaRepeatedPatternAbundancy.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Hoft's consecutive divisor-pair condition forces a strict abundancy interval.",
        H("A392096 Divisor-Pair Sigma Bounds"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("a392096-divisor-pairs"),
                DeclarationHandle.Create(Prefix + "DivisorPairs"),
                H("Consecutive gap-separated divisor pairs"),
                StatementSource.FromAuthor(DivisorPairsFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For natural D and q, DivisorPairs is a structure with fields D_pos, "
                            + "count, count_ge_two, lower, upper, lower_zero, upper_last, "
                            + "divisors_eq, within, and gap_succ. The first three fields make "
                            + "D positive and provide at least two pairs. The next four give "
                            + "the two natural-valued enumerating maps, start lower at one, and "
                            + "end upper at q.")),
                    Paragraph(Text(
                        "The divisors_eq field says that Nat.divisors(q) is exactly the union "
                            + "of the images of lower and upper over range(count). The within "
                            + "field says lower(i)<upper(i)<D*lower(i). The gap_succ field says "
                            + "D*upper(i)<lower(i+1) between successive pairs. The expression "
                            + "count-1 uses truncated natural subtraction.")),
                    Paragraph(Text(
                        "This is the divisor characterization stated by the OEIS A392096 entry. "
                            + "The positivity field is automatic at the Member scale "
                            + "D=2^(m+1), but is explicit so the general structure records every "
                            + "order argument used below."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("a392096-member"),
                DeclarationHandle.Create(Prefix + "Member"),
                H("Membership in the divisor-form version of A392096"),
                StatementSource.FromAuthor(MemberFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "A natural n is a Member exactly when natural m and q exist with m at "
                            + "least one, q odd, n=2^m*q, and nonempty divisor-pair data at "
                            + "D=2^(m+1). The conjunction is right-associated exactly as in the "
                            + "Lean definition.")),
                    Paragraph(Text(
                        "OEIS A392096 attributes this divisor characterization to Hartmut F. W. "
                            + "Hoft. The entry asserts that it is equivalent to the symmetric-"
                            + "representation width pattern 1,2,1,0,...,0,1,2,1. This module "
                            + "formalizes only the displayed divisor predicate. The asserted "
                            + "equivalence is ASSUMED-UNVERIFIED and is not formalized here."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("a392096-minfac-bound"),
                DeclarationHandle.Create(Prefix + "divisor_pairs_minFac_bound"),
                H("Least-prime bound and square exclusion"),
                StatementSource.FromAuthor(MinFacBoundFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For odd q with DivisorPairs data at scale D, the least prime factor "
                            + "minFac(q) is strictly below D and its square does not divide q. "
                            + "The least prime occupies the first upper position, while its "
                            + "square would have to occur after it and would violate the next "
                            + "separation gap."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a392096-upper-pair-shape"),
                DeclarationHandle.Create(Prefix + "divisor_pairs_upper_pair_shape"),
                H("Every divisor pair has least-prime ratio"),
                StatementSource.FromAuthor(UpperPairShapeFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For every index below count, the upper divisor is minFac(q) times the "
                            + "paired lower divisor. The proof uses divisor location, least-prime "
                            + "coprimality, and the separation gaps; it is a public prerequisite "
                            + "of the telescoping estimate and the final theorem."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a392096-gap-telescoping"),
                DeclarationHandle.Create(Prefix + "divisor_pairs_gap_telescoping"),
                H("The divisor gaps telescope strictly"),
                StatementSource.FromAuthor(GapTelescopingFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For odd q with DivisorPairs data, summing the successive gaps gives "
                            + "(D*minFac(q)-1)*S < D*minFac(q)*r, where S is the sum of the "
                            + "lower entries over range(count) and r is the last lower entry. "
                            + "This repository-derived estimate is used directly by the final "
                            + "upper sigma bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a392096-lower-coefficient"),
                DeclarationHandle.Create(Prefix + "lower_coefficient_bound"),
                H("Lower coefficient comparison"),
                StatementSource.FromAuthor(LowerCoefficientFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For natural D and p with p<D, the product D*p is at most "
                            + "(D-1)*(p+1). This named coefficient estimate is a direct public "
                            + "prerequisite of the final strict lower sigma bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a392096-upper-coefficient"),
                DeclarationHandle.Create(Prefix + "upper_coefficient_bound"),
                H("Upper coefficient comparison"),
                StatementSource.FromAuthor(UpperCoefficientFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For natural D and p with D at least four and p at least three, three "
                            + "times (D-1)*(p+1) is at most four times (D*p-1). This named "
                            + "coefficient estimate is a direct public prerequisite of the final "
                            + "strict upper sigma bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a392096-sigma-bounds-nat"),
                DeclarationHandle.Create(Prefix + "a392096_sigma_bounds_nat"),
                H("Division-free natural sigma bounds"),
                StatementSource.FromAuthor(SigmaBoundsNatFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For every natural n satisfying Member, twice n is strictly below "
                            + "ArithmeticFunction.sigma(1,n), and three times that divisor sum "
                            + "is strictly below eight times n. This is the division-free "
                            + "natural-number companion to the source-form rational bound.")),
                    Paragraph(Text(
                        "The proof lets p be minFac(q). Divisor location and the gap conditions "
                            + "force p<D, exclude p^2 dividing q, and identify every upper(i) as "
                            + "p*lower(i). Summing the successive gaps gives "
                            + "(D*p-1)*S<D*p*r, where S is the sum of all lower entries and r is "
                            + "the last one. This estimate and S>r yield the two strict bounds "
                            + "after sigma multiplicativity."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("a392096-sigma-bounds"),
                DeclarationHandle.Create(Prefix + "a392096_sigma_bounds"),
                H("Strict sigma bounds for every divisor-form member"),
                StatementSource.FromAuthor(SigmaBoundsFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "For every natural n satisfying Member, the conclusion over the rationals "
                            + "is written in the source's own form: 2*n<sigma(n)<8*n/3. It follows "
                            + "from the division-free natural theorem by casting both inequalities "
                            + "and dividing the upper inequality by three.")),
                    Paragraph(Text(
                        "This is a repository-derived conditional theorem. Its hypothesis is the "
                            + "divisor-form Member criterion transcribed from the OEIS A392096 "
                            + "comment by Hartmut F. W. Hoft dated 2025-12-30; the comment's "
                            + "symmetric-representation width-pattern equivalence is only scope-"
                            + "matched context, is ASSUMED-UNVERIFIED, and is not formalized. No "
                            + "claim is made for a number unless the divisor-form Member predicate "
                            + "has been supplied."))),
                DescribeRole.Theorem))));

    private static Formula DivisorPairsFormula()
    {
        Formula scale = F.Id("D"), q = F.Id("q"), count = F.Id("count");
        Formula lower = F.Id("lower"), upper = F.Id("upper"), i = F.Id("i");
        Formula range = Call("range", count);
        Formula divisorEnumeration = Equal(
            Call("divisors", q),
            Call("union", Call("image", lower, range), Call("image", upper, range)));
        Formula within = ForAll([Bound("i", Naturals())], Implies(
            Lt(i, count),
            AndMany(
                Lt(Call("lower", i), Call("upper", i)),
                Lt(Call("upper", i), Product(scale, Call("lower", i))))));
        Formula gap = ForAll([Bound("i", Naturals())], Implies(
            Lt(Add(i, D(1)), count),
            Lt(Product(scale, Call("upper", i)), Call("lower", Add(i, D(1))))));

        Formula fields = Seq(
            Field("D", "pos"), Colon, Sp, Lt(D(0), scale), SemiSpace,
            F.Id("count"), Colon, Sp, Naturals(), SemiSpace,
            Field("count", "ge_two"), Colon, Sp, Le(D(2), count), SemiSpace,
            F.Id("lower"), Colon, Sp, new Formula.TypeArrow(Naturals(), Naturals()), SemiSpace,
            F.Id("upper"), Colon, Sp, new Formula.TypeArrow(Naturals(), Naturals()), SemiSpace,
            Field("lower", "zero"), Colon, Sp, Equal(Call("lower", D(0)), D(1)), SemiSpace,
            Field("upper", "last"), Colon, Sp,
                Equal(Call("upper", Subtract(count, D(1))), q), SemiSpace,
            Field("divisors", "eq"), Colon, Sp, divisorEnumeration, SemiSpace,
            F.Id("within"), Colon, Sp, within, SemiSpace,
            Field("gap", "succ"), Colon, Sp, gap);

        return Disp(ForAll(
            [Bound("D", Naturals()), Bound("q", Naturals())],
            Equal(Call("DivisorPairs", scale, q), Seq(OpenBrace, fields, CloseBrace))));
    }

    private static Formula MemberFormula()
    {
        Formula n = F.Id("n"), m = F.Id("m"), q = F.Id("q");
        Formula scale = Power(D(2), Add(m, D(1)));
        Formula body = ExistsMany(
            [Bound("m", Naturals()), Bound("q", Naturals())],
            AndMany(
                Le(D(1), m),
                Call("Odd", q),
                Equal(n, Product(Power(D(2), m), q)),
                Call("Nonempty", Call("DivisorPairs", scale, q))));
        return Disp(ForAll(
            [Bound("n", Naturals())],
            IffFormula(Call("Member", n), body)));
    }

    private static Formula SigmaBoundsFormula()
    {
        Formula n = F.Id("n"), sigma = SigmaOne(n);
        Formula bounds = AndMany(
            Lt(Product(D(2), n), sigma),
            Lt(sigma, new Formula.Fraction(Product(D(8), n), D(3))));
        return Disp(ForAll(
            [Bound("n", Naturals())],
            Implies(Call("Member", n), bounds)));
    }

    private static Formula SigmaBoundsNatFormula()
    {
        Formula n = F.Id("n"), sigma = SigmaOne(n);
        Formula bounds = AndMany(
            Lt(Product(D(2), n), sigma),
            Lt(Product(D(3), sigma), Product(D(8), n)));
        return Disp(ForAll(
            [Bound("n", Naturals())],
            Implies(Call("Member", n), bounds)));
    }

    private static Formula MinFacBoundFormula()
    {
        Formula scale = F.Id("D"), q = F.Id("q"), pairs = F.Id("P");
        Formula prime = Call("minFac", q);
        Formula conclusion = AndMany(
            Lt(prime, scale),
            Seq(Neg, Sp, Divides(Product(prime, prime), q)));
        return Disp(ForAll(
            [Bound("D", Naturals()), Bound("q", Naturals()),
                Bound("P", Call("DivisorPairs", scale, q))],
            Implies(Call("Odd", q), conclusion)));
    }

    private static Formula UpperPairShapeFormula()
    {
        Formula scale = F.Id("D"), q = F.Id("q"), pairs = F.Id("P");
        Formula i = F.Id("i"), count = Call("count", pairs);
        Formula shape = Equal(
            Call("upper", pairs, i),
            Product(Call("minFac", q), Call("lower", pairs, i)));
        return Disp(ForAll(
            [Bound("D", Naturals()), Bound("q", Naturals()),
                Bound("P", Call("DivisorPairs", scale, q))],
            Implies(
                Call("Odd", q),
                ForAll([Bound("i", Naturals())], Implies(Lt(i, count), shape)))));
    }

    private static Formula GapTelescopingFormula()
    {
        Formula scale = F.Id("D"), q = F.Id("q"), pairs = F.Id("P");
        Formula i = F.Id("i"), count = Call("count", pairs);
        Formula prime = Call("minFac", q);
        Formula lowerSum = Seq(
            Sum, Underscore, Grp(Seq(i, Sp, InMacro, Sp, Call("range", count))), Sp,
            Call("lower", pairs, i));
        Formula lastLower = Call("lower", pairs, Subtract(count, D(1)));
        Formula conclusion = Lt(
            Product(Subtract(Product(scale, prime), D(1)), lowerSum),
            Product(Product(scale, prime), lastLower));
        return Disp(ForAll(
            [Bound("D", Naturals()), Bound("q", Naturals()),
                Bound("P", Call("DivisorPairs", scale, q))],
            Implies(Call("Odd", q), conclusion)));
    }

    private static Formula LowerCoefficientFormula()
    {
        Formula scale = F.Id("D"), prime = F.Id("p");
        Formula conclusion = Le(
            Product(scale, prime),
            Product(Subtract(scale, D(1)), Add(prime, D(1))));
        return Disp(ForAll(
            [Bound("D", Naturals()), Bound("p", Naturals())],
            Implies(Lt(prime, scale), conclusion)));
    }

    private static Formula UpperCoefficientFormula()
    {
        Formula scale = F.Id("D"), prime = F.Id("p");
        Formula left = Product(
            D(3), Product(Subtract(scale, D(1)), Add(prime, D(1))));
        Formula right = Product(
            D(4), Subtract(Product(scale, prime), D(1)));
        return Disp(ForAll(
            [Bound("D", Naturals()), Bound("p", Naturals())],
            Implies(Le(D(4), scale), Implies(Le(D(3), prime), Le(left, right)))));
    }

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);

    private static Formula ForAll(Formula.BoundVariable[] variables, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. variables], body);

    private static Formula ExistsMany(Formula.BoundVariable[] variables, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.Exists, [.. variables], body);

    private static Formula Field(string name, string suffix) =>
        new Formula.Subscript(
            F.Id(name),
            suffix == "ge_two"
                ? Seq(F.Id("ge"), Underscore, Grp(F.Id("two")))
                : F.Id(suffix));

    private static Formula SigmaOne(Formula value) =>
        new Formula.Apply(new Formula.Subscript(SigmaLower, D(1)), [value]);

    private static Formula Power(Formula value, Formula exponent) =>
        new Formula.Power(value, exponent);

    private static Formula Add(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);

    private static Formula Subtract(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Subtract, right);

    private static Formula Product(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Lt(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula Divides(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Divides, right);

    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(Parenthesized(left), FormulaLogicOperator.Implies, Parenthesized(right));

    private static Formula IffFormula(Formula left, Formula right) =>
        new Formula.Logic(Parenthesized(left), FormulaLogicOperator.Iff, Parenthesized(right));

    private static Formula AndMany(params Formula[] clauses)
    {
        Formula result = Parenthesized(clauses[^1]);
        for (int index = clauses.Length - 2; index >= 0; index--)
        {
            result = new Formula.Logic(
                Parenthesized(clauses[index]), FormulaLogicOperator.And, result);
        }
        return result;
    }

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);
    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));
}
