using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Recurrence.Parity;

internal sealed class A385590Document : IScribeDocumentDefinition
{
    private static readonly LibraryNoteRef Source =
        LibraryNoteRef.Create("D5/L/Words/schulte2025a385590");

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The Fibonacci triangle satisfies the alternating binomial sum in OEIS A385590.",
        H("The Alternating Binomial Sum of OEIS A385590"),
        Blocks(
            Paragraph(Text(
                "Werner Schulte's OEIS entry, dated July 3, 2025, states the sum as a "
                + "conjecture. The statement and triangle are from that entry; the proof "
                + "below is derived in this repository. The other conjecture in the entry, "
                + "that the triangle permutes the natural numbers, is a separate question.")),
            Paragraph(Text(
                "All indices are natural numbers, F is the Fibonacci sequence with F(0)=0 "
                + "and F(1)=1, and g(n) denotes Nat.greatestFib(n). Subtraction inside an "
                + "index of F or a binomial coefficient is natural subtraction. The "
                + "triangle values, their differences, products, and sums are integers. "
                + "The remainder in A is the natural remainder modulo two.")),
            Node("T", "The triangle and its row constants", TriangleFormula(),
                "The lower Fibonacci inverse g chooses the row's interval. Its constant "
                + "term A and slope B depend on n and i, and neither depends on k.",
                DescribeRole.Definition, AssessedProvenance.FromLiterature(Source)),
            Node("row_index_spec", "The unique Fibonacci interval", IndexFormula(),
                "Mathlib's greatestFib inequalities give the two interval bounds. Any "
                + "other index satisfying them is both at most g(n) and greater than "
                + "g(n)-1, so it equals g(n). For n at least one, g(n) is at least two.",
                DescribeRole.Lemma, AssessedProvenance.FromRepo()),
            Node("row_affine", "Each row is affine", AffineFormula(),
                "Substitution of the fixed row index gives the displayed affine expression "
                + "with the explicit A and B above.",
                DescribeRole.Lemma, AssessedProvenance.FromRepo(Source)),
            Node("alternating_binomial_sum", "The full conjectured sum", SumFormula(),
                "Put m=n-1 and j=k-1. The sum becomes the negative of the alternating "
                + "binomial transform of A+jB. For m at least two, the constant moment "
                + "is zero by Mathlib's alternating_sum_range_choose_of_ne. The identity "
                + "(j+1) choose(m,j+1) = m choose(m-1,j) reduces the linear moment "
                + "to another such zero sum. The first row is [1] and the second is "
                + "[2,3], giving -1 and 1 respectively. This proves the assertion for "
                + "every positive n.", DescribeRole.Theorem, AssessedProvenance.FromRepo(Source),
                new OpenProblemResolutionClaim(
                    ProblemSlugRef.Create("oeis-a385590-alternating-binomial"),
                    ResolutionKind.Proved)))));

    private static DocumentBlock Node(string name, string title, Formula formula,
        string prose, DescribeRole role, AssessedProvenance provenance,
        OpenProblemResolutionClaim? resolution = null) => Describe.Lean(
        DescribeId.Create("a385590-" + name.Replace('_', '-').ToLowerInvariant()),
        DeclarationHandle.Create("D5/S1/Recurrence/Parity/A385590." + name),
        H(title), StatementSource.FromAuthor(formula), provenance,
        Blocks(Paragraph(Text(prose))), role, resolution);

    private static Formula TriangleFormula() => Disp(new Formula.Aligned([
        Seq(Bound("n", "k"), Sp, Call("T", N(), K()), Sp, Eq, Sp,
            Add(Call("A", N(), Call("g", N())),
                Mul(Subtract(K(), D(1)), Call("B", Call("g", N()))))),
        Seq(Bound("n", "i"), Sp, Call("A", N(), I()), Sp, Eq, Sp,
            Add(Subtract(Add(Power(Fib(Subtract(I(), D(1))), D(2)), D(1)),
                new Formula.Modulo(Subtract(I(), D(1)), D(2))),
                Mul(Subtract(N(), Fib(I())), Fib(Subtract(I(), D(2)))))),
        Seq(Bound("i"), Sp, Call("B", I()), Sp, Eq, Sp, Fib(Subtract(I(), D(1))))
    ]));

    private static Formula IndexFormula() => Disp(new Formula.Aligned([
        Seq(Bound("n"), Sp, D(1), Sp, Le, Sp, N(), Sp, Implies, Sp),
        Seq(D(1), Sp, Lt, Sp, Call("g", N()), Sp, Land, Sp,
            Fib(Call("g", N())), Sp, Le, Sp, N(), Sp, Land, Sp,
            N(), Sp, Lt, Sp, Fib(Add(Call("g", N()), D(1))), Sp, Land, Sp),
        Seq(Open, Bound("i"), Sp, D(1), Sp, Lt, Sp, I(), Sp, Implies, Sp,
            Fib(I()), Sp, Le, Sp, N(), Sp, Implies, Sp,
            N(), Sp, Lt, Sp, Fib(Add(I(), D(1))), Sp, Implies, Sp,
            I(), Sp, Eq, Sp, Call("g", N()), Close)
    ]));

    private static Formula AffineFormula() => Disp(Seq(Bound("n", "k", "i"), Sp,
        I(), Sp, Eq, Sp, Call("g", N()), Sp, Implies, Sp,
        Call("T", N(), K()), Sp, Eq, Sp,
        Add(Call("A", N(), I()), Mul(Subtract(K(), D(1)), Call("B", I())))));

    private static Formula SumFormula()
    {
        var summand = Mul(Mul(Power(Seq(Open, Minus, D(1), Close), K()),
            Call("choose", Subtract(N(), D(1)), Subtract(K(), D(1)))), Call("T", N(), K()));
        return Disp(new Formula.Aligned([
            Seq(Bound("n"), Sp, D(1), Sp, Le, Sp, N(), Sp, Implies, Sp),
            Seq(new Formula.Subscript(F.Sum,
                    Seq(K(), Sp, InMacro, Sp, Call("Icc", D(1), N()))), Sp,
                Open, summand, Close, Sp, Eq, Sp),
            Seq(Named("if"), Sp, N(), Sp, Lt, Sp, D(3), Sp, Named("then"), Sp,
                Power(Seq(Open, Minus, D(1), Close), N()), Sp, Named("else"), Sp, D(0))
        ]));
    }

    private static Formula N() => F.Id("n");
    private static Formula K() => F.Id("k");
    private static Formula I() => F.Id("i");
    private static Formula Fib(Formula index) => Call("F", index);
    private static Formula Named(string name) => Seq(Operatorname, Grp(F.Id(name)));
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Named(name), [.. args]);
    private static Formula Power(Formula x, Formula y) => new Formula.Power(x, y);
    private static Formula Add(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Add, y);
    private static Formula Subtract(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Subtract, y);
    private static Formula Mul(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Multiply, y);
    private static Formula Bound(params string[] names)
    {
        List<Formula> variables = [];
        foreach (var name in names)
        {
            if (variables.Count > 0) variables.AddRange([Comma, Sp]);
            variables.Add(F.Id(name));
        }
        return Seq(Forall, Sp, Seq([.. variables]), Colon, Sp, Mathbb, Grp(F.Id("N")), Comma);
    }
}
