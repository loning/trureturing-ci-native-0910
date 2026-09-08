using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class TwinPrimeSigmaGcdDivisibilityDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Factorization/TwinPrimeSigmaGcdDivisibility.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Every twin-prime center with prime gcd(k, sigma(k)) is divisible by 18.",
        H("Twin-Prime Sigma-Gcd Divisibility"),
        Blocks(
            Paragraph(Text("Here sigma(k) is the sum of the positive divisors of k, "
                + "represented by ArithmeticFunction.sigma 1 k. Subtraction is natural-number "
                + "subtraction; the hypotheses ensure k is greater than one.")),
            Node("even_center", "Twin-prime centers are even",
                TwinFormula(Divides(D(2), K()), false, false),
                "If k were odd, both neighboring primes would be even, so both would equal "
                + "2. Their difference is 2, a contradiction."),
            Node("three_center", "Divisibility by three",
                TwinFormula(Divides(D(3), K()), true, true),
                "The proof treats k below 6 explicitly. At k=4, sigma(4)=7 and the gcd "
                + "is 1, contradicting its primality. Above this range both neighboring "
                + "primes exceed 3. Neither can be divisible by 3, so k must be."),
            Node("four_or_six_dvd_gcd", "A composite divisor of the sigma-gcd",
                CoreFormula(),
                "Write k=3m. Since 9 does not divide k, 3 does not divide m, and "
                + "multiplicativity gives sigma(k)=4 sigma(m). If 4 divides k, it divides "
                + "the gcd. Otherwise write k=2r with r odd. Multiplicativity now gives "
                + "sigma(k)=3 sigma(r). Thus both 2 and 3 divide the gcd, so 6 divides it. "
                + "This argument applies to every k satisfying the three divisibility "
                + "hypotheses, independently of the neighboring integers."),
            Node("sigma_gcd_divisibility", "Every A394757 term is divisible by 18",
                TwinFormula(Divides(D(1, 8), K()), true, false),
                "The first two results give 2 and 3 dividing k. If 9 did not divide k, "
                + "the preceding result would give a composite divisor of a prime gcd. "
                + "Hence 9 divides k, and coprimality of 2 and 9 gives 18 dividing k. "
                + "The result holds for all natural k; no finite search bound is used.",
                new OpenProblemResolutionClaim(
                    ProblemSlugRef.Create("oeis-a394757-twin-prime-sigma-gcd"),
                    ResolutionKind.Proved)))));

    private static DocumentBlock Node(string name, string title, Formula formula, string prose,
        OpenProblemResolutionClaim? claim = null) => Describe.Lean(
        DescribeId.Create(name.Replace('_', '-')), DeclarationHandle.Create(Prefix + name),
        H(title), StatementSource.FromAuthor(formula),
        AssessedProvenance.FromRepo(LibraryNoteRef.Create("D5/L/Arith/oeis2026a394757")),
        Blocks(Paragraph(Text(prose))), DescribeRole.Theorem, claim);

    private static Formula K() => F.Id("k");
    private static Formula Divides(Formula left, Formula right) =>
        Seq(left, Sp, Mid, Sp, right);
    private static Formula Call(string name, params Formula[] arguments)
    {
        var pieces = new List<Formula> { Operatorname, Grp(F.Id(name)), Open };
        for (int i = 0; i < arguments.Length; i++)
        {
            if (i > 0) pieces.Add(Comma);
            pieces.Add(arguments[i]);
        }
        pieces.Add(Close);
        return Seq(pieces.ToArray());
    }
    private static Formula Gcd() => Call("gcd", K(), Call("sigma", K()));
    private static Formula Universal(Formula body) => Disp(Seq(
        Forall, Sp, K(), Sp, InMacro, Sp, Mathbb, Grp(F.Id("N")), Comma, Sp, body));

    private static Formula TwinFormula(Formula conclusion, bool gcdPrime, bool even)
    {
        var pieces = new List<Formula>
        {
            D(1), Sp, Lt, Sp, K(), Sp, Implies, Sp,
            Call("Prime", Seq(K(), Minus, D(1))), Sp, Implies, Sp,
            Call("Prime", Seq(K(), Plus, D(1))), Sp, Implies, Sp
        };
        if (gcdPrime) pieces.AddRange([Call("Prime", Gcd()), Sp, Implies, Sp]);
        if (even) pieces.AddRange([Divides(D(2), K()), Sp, Implies, Sp]);
        pieces.Add(conclusion);
        return Universal(Seq(pieces.ToArray()));
    }

    private static Formula CoreFormula() => Universal(Seq(
        Divides(D(2), K()), Sp, Implies, Sp,
        Divides(D(3), K()), Sp, Implies, Sp,
        Neg, Sp, Open, Divides(D(9), K()), Close, Sp, Implies, Sp,
        Open, Divides(D(4), Gcd()), Sp, Lor, Sp, Divides(D(6), Gcd()), Close));
}
