using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class GoldenDivisorLanguageDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/GoldenDivisorLanguage.";
    private static Formula N => Seq(Mathbb, Grp(F.Id("N")));
    private static Formula PositiveN => Call("PNat");
    private static Formula P => F.Id("p");
    private static Formula S => F.Id("S");
    private static Formula L => F.Id("L");
    private static Formula Window => Call("fullWindow", S, L);
    private static Formula Size => Call("fib", Add(Call("L", P), Num(2)));
    private static Formula Divisors => Call("Div", Window);
    private static Formula Exponents => PiOver(Call("Fin", Size));
    private static Formula Names => PiOver(Call("GoldenName", Call("L", P)));
    private static Formula FourNames => Seq(Call("GoldenName", Num(3)), Times, Sp,
        Call("GoldenName", Num(2)), Times, Sp, Call("GoldenName", Num(1)), Times, Sp,
        Call("GoldenName", Num(1)));

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Prime exponents identify full-window divisors with golden names and distinguish the 5040 observation fiber.",
        H("Golden Divisor Languages"),
        Blocks(
            Paragraph(Text("Let S be a finite set of natural primes and L a natural-valued "
                + "function on S. A divisor is a positive natural number whose value divides "
                + "the specified integer. Length zero and the empty prime set are allowed.")),
            Entry("Div", "Positive divisors",
                ForAll([Bound("m", N)], Equal(Call("Div", F.Id("m")),
                    Seq(OpenBrace, F.Id("d"), Colon, PositiveN, Bar,
                        Divides(Call("val", F.Id("d")), F.Id("m")), CloseBrace))),
                "The carrier includes the divisor's positivity and divisibility proofs.",
                DescribeRole.Definition),
            Entry("fullWindow", "The full Fibonacci window",
                ForAll([Bound("S", Call("Finset", N)), Bound("L", Arrow(S, N))],
                    Equal(Window, ProductOver(Power(P, Subtract(Size, Num(1)))))),
                "The exponent at p is fib(L(p)+2)-1.", DescribeRole.Definition),
            Entry("full_window_divisor_exponent_equiv", "Divisors in prime coordinates",
                General(ExistsOver("e", Equivalent(Divisors, Exponents),
                    ForAll([Bound("d", Divisors), Bound("p", S)],
                        Equal(Call("val", Call("e", F.Id("d"), P)),
                            Call("factorization", Call("val", Call("val", F.Id("d"))), P))))),
                "The forward map reads each prime multiplicity. The inverse multiplies "
                    + "the corresponding prime powers. Factorization uniqueness proves "
                    + "both inverse identities, including vanishing outside S."),
            Entry("full_window_divisor_card", "The number of divisors",
                General(Equal(Call("card", Divisors), ProductOver(Size))),
                "Each prime contributes fib(L(p)+2) independent choices."),
            Entry("full_window_divisor_golden_equiv", "The golden-name language",
                General(Call("Nonempty", Equivalent(Divisors, Names))),
                "The finite Zeckendorf interval bijection is applied independently to "
                    + "every exponent coordinate."),
            Paragraph(Text("For the concrete window, primes5040 is the set {2,3,5,7}. "
                + "The function lengths5040 has values 3 at 2, 2 at 3, and 1 at both 5 and 7.")),
            Entry("primes5040", "The active primes",
                Equal(Call("primes5040"), Seq(OpenBrace, Num(2), Comma, Num(3), Comma,
                    Num(5), Comma, Num(7), CloseBrace)),
                "All four members are prime.", DescribeRole.Definition),
            Entry("lengths5040", "The four window lengths",
                ForAll([Bound("p", Call("primes5040"))],
                    Equal(Call("lengths5040", P), Call("ite", Equal(Call("val", P), Num(2)),
                        Num(3), Call("ite", Equal(Call("val", P), Num(3)), Num(2), Num(1))))),
                "The conditional expression fixes the lengths without an ordering choice.",
                DescribeRole.Definition),
            Entry("full_window_5040", "The window integer",
                Equal(Call("fullWindow", Call("primes5040"), Call("lengths5040")), Num(5040)),
                "The Fibonacci exponents are 4, 2, 1, and 1, respectively."),
            Entry("divisor_5040_golden_equiv", "Four golden-name factors",
                Call("Nonempty", Equivalent(Call("Div", Num(5040)), FourNames)),
                "Evaluation at the ordered primes 2, 3, 5, and 7 splits the dependent "
                    + "product into the four displayed factors."),
            Entry("divisor_5040_card", "Sixty divisor states",
                Equal(Call("card", Call("Div", Num(5040))), Num(60)),
                "The four factor sizes are 5, 3, 2, and 2."),
            Entry("b", "Rounded exponents",
                ForAll([Bound("a", N)], Equal(Call("b", F.Id("a")),
                    Subtract(Call("fib", Call("greatestFib", Add(F.Id("a"), Num(1)))), Num(1)))),
                "The largest Fibonacci number not exceeding a+1 determines the rounded exponent.",
                DescribeRole.Definition),
            Entry("b_zero", "The zero exponent", Equal(Call("b", Num(0)), Num(0)),
                "An absent prime remains absent."),
            Entry("b_le", "Exponent contraction", ForAll([Bound("a", N)],
                LessEqual(Call("b", F.Id("a")), F.Id("a"))),
                "Rounding down cannot increase a prime multiplicity."),
            Entry("b_monotone", "Monotone rounding", Call("Monotone", F.Id("b")),
                "Increasing an exponent cannot decrease its rounded value."),
            Entry("b_idempotent", "Stable window endpoints", ForAll([Bound("a", N)],
                Equal(Call("b", Call("b", F.Id("a"))), Call("b", F.Id("a")))),
                "A second rounding leaves each endpoint unchanged."),
            Entry("Gobs", "Integer observation",
                ForAll([Bound("n", PositiveN)], Equal(Call("Gobs", F.Id("n")),
                    Seq(Prod, Underscore, Grp(Member(P, Call("support",
                        Call("factorization", Call("val", F.Id("n")))))), Sp,
                        Power(P, Call("b", Call("factorization", Call("val", F.Id("n")), P)))))),
                "Observation multiplies the prime powers with rounded multiplicities.",
                DescribeRole.Definition),
            Entry("Gobs_pos", "Positive observation", ForAll([Bound("n", PositiveN)],
                Less(Num(0), Call("Gobs", F.Id("n")))),
                "Every factor is a positive prime power."),
            Entry("Gobs_factorization", "Observed prime multiplicities",
                ForAll([Bound("n", PositiveN), Bound("p", N)],
                    Equal(Call("factorization", Call("Gobs", F.Id("n")), P),
                        Call("b", Call("factorization", Call("val", F.Id("n")), P)))),
                "Prime factorization reconstructs exactly the rounded exponent family."),
            Entry("Gobs_dvd", "Observation is a divisor", ForAll([Bound("n", PositiveN)],
                Divides(Call("Gobs", F.Id("n")), Call("val", F.Id("n")))),
                "The coordinatewise exponent inequalities are precisely divisibility."),
            Entry("Gobs_idempotent", "Stable integer observations",
                ForAll([Bound("n", PositiveN)],
                    Equal(Call("Gobs", Call("Gobs", F.Id("n"))), Call("Gobs", F.Id("n")))),
                "The inner observation is regarded as a positive natural using Gobs_pos. "
                    + "Idempotence holds at every prime coordinate."),
            Entry("golden_fiber_5040_decode_image", "Two free exponent coordinates",
                Equal(Call("image", Seq(F.Id("r"), Mapsto,
                    Product(Product(Num(5040), Power(Num(2), Call("val", Call("fst", F.Id("r"))))),
                        Power(Num(3), Call("val", Call("snd", F.Id("r")))))),
                    Call("univ", Seq(Call("Fin", Num(3)), Times, Call("Fin", Num(2))))), FiberValues),
                "For r in Fin(3) times Fin(2), decode(r) is 5040 times 2 raised to the "
                    + "first coordinate times 3 raised to the second coordinate. The image "
                    + "is the displayed six-element set."),
            Entry("Gobs_5040_fixed", "A stable target value",
                Equal(Call("Gobs", Num(5040)), Num(5040)),
                "The target occurs as an observation, so observation idempotence fixes it."),
            Entry("golden_fiber_5040", "The full observation fiber",
                ForAll([Bound("n", PositiveN)],
                    new Formula.Logic(Equal(Call("Gobs", F.Id("n")), Num(5040)),
                        FormulaLogicOperator.Iff, Member(Call("val", F.Id("n")), FiberValues))),
                "The exponents at 2 range from 4 through 6, those at 3 from 2 through 3, "
                    + "and the exponents at 5 and 7 equal 1. Every other exponent is zero. "
                    + "Monotonicity gives the upper bounds, and factorization uniqueness "
                    + "reconstructs the six integers. These six observation states are "
                    + "distinct from the sixty positive divisor states."))));

    private static Formula FiberValues => Seq(OpenBrace, Num(5040), Comma, Num(10080), Comma,
        Num(15120), Comma, Num(20160), Comma, Num(30240), Comma, Num(60480), CloseBrace);

    private static DocumentBlock Entry(string selector, string title, Formula statement,
        string prose, DescribeRole role = DescribeRole.Theorem) => Describe.Lean(
            DescribeId.Create(selector.Replace('_', '-').ToLowerInvariant()),
            DeclarationHandle.Create(Prefix + selector), H(title),
            StatementSource.FromAuthor(Disp(statement)), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(DefinitionDsl.Text(prose))), role);

    private static Formula General(Formula body) =>
        ForAll([Bound("S", Call("Finset", N)), Bound("L", Arrow(S, N))],
            Imply(ForAll([Bound("p", S)], Call("Prime", P)), body));

    private static Formula PiOver(Formula body) =>
        Seq(Prod, Underscore, Grp(Member(P, S)), Sp, body);
    private static Formula ProductOver(Formula body) => PiOver(body);
    private static Formula Product(Formula a, Formula b) => Seq(a, Times, Sp, b);
    private static Formula Power(Formula value, Formula exponent) => Seq(value, Caret, Grp(exponent));
    private static Formula Arrow(Formula a, Formula b) => Seq(a, To, Sp, b);
    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);
    private static Formula ForAll(Formula.BoundVariable[] variables, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. variables], body);
    private static Formula ExistsOver(string name, Formula domain, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.Exists, [Bound(name, domain)], body);
    private static Formula Equivalent(Formula a, Formula b) =>
        Call("Equiv", a, b);
    private static Formula Member(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.MemberOf, b);
    private static Formula LessEqual(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.LessThanOrEqual, b);
    private static Formula Less(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.LessThan, b);
    private static Formula Divides(Formula a, Formula b) =>
        new Formula.Relation(a, FormulaRelationOperator.Divides, b);
    private static Formula Imply(Formula a, Formula b) =>
        new Formula.Logic(a, FormulaLogicOperator.Implies, b);
}
