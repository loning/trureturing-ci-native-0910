using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.PrimeAddress;

internal sealed class VonMangoldtRecurrenceDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Arbitrarily late von Mangoldt zero windows rule out eventual linear recurrences with real or complex constant coefficients.",
        H("Von Mangoldt Recurrence Obstruction"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("two-prime-factor-window"),
                DeclarationHandle.Create("D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_two_prime_factor_window"),
                H("Arbitrarily late windows with two distinct prime factors"),
                StatementSource.FromAuthor(FactorWindow()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The indices i and j range over Fin r, coerced to natural numbers in sums. "
                    + "The Boolean selector takes b at true and a at false. Increasing enumeration "
                    + "of the infinite prime set supplies disjoint pairs. For the product modulus "
                    + "at j, choose the residue minus j. The finite CRT realizes these "
                    + "residues; adding B times the positive product of all moduli makes the "
                    + "representative at least B. Two distinct prime divisors exclude a prime power. "
                    + "All statements include r equal to zero, with empty families and product one."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("von-mangoldt-zero-window"),
                DeclarationHandle.Create("D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_vonMangoldt_zero_window"),
                H("Arbitrarily late zero windows"),
                StatementSource.FromAuthor(ZeroWindow()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Lambda denotes the real-valued singleAddressReading, definitionally "
                    + "ArithmeticFunction.vonMangoldt. Apply the non-prime-power conjunct of "
                    + "single_address_reading_spec to every position of the constructed window."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("late-positive-prime"),
                DeclarationHandle.Create("D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.arbitrarily_late_prime_reading_positive"),
                H("Explicit positive prime readings above every bound"),
                StatementSource.FromAuthor(PositivePrime()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Prime infinitude supplies p above B. The prime-power reading law at exponent "
                    + "one gives log p; vonMangoldt_pos_iff proves its strict positivity. "
                    + "The logarithm and Lambda in this statement are real-valued."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("no-complex-recurrence"),
                DeclarationHandle.Create("D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.vonMangoldt_no_eventual_complex_linear_recurrence"),
                H("No eventual complex linear recurrence"),
                StatementSource.FromAuthor(NoRecurrence("C")),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Choose a zero window starting at N at least N0. The shifted complex sequence "
                    + "is a solution of LinearRecurrence with order r and coefficients c. Its "
                    + "initial r values agree with zero, so eq_iff_eqOn_range_order makes the whole "
                    + "shifted sequence zero. A prime at least N plus one contradicts the "
                    + "nonzero prime-address theorem at exponent one. For r equal to zero the "
                    + "range and sum are empty, and the same uniqueness theorem applies."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("no-real-recurrence"),
                DeclarationHandle.Create("D5/S3/Weil/PrimeAddress/VonMangoldtRecurrence.vonMangoldt_no_eventual_real_linear_recurrence"),
                H("No eventual real linear recurrence"),
                StatementSource.FromAuthor(NoRecurrence("R")),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Apply the canonical embedding of the reals into the complex numbers to "
                    + "each coefficient and each value. It preserves the finite sum and products, "
                    + "so a real recurrence would contradict the complex obstruction."))),
                DescribeRole.Theorem)),
        []));

    private static Formula NatType => Seq(Mathbb, Grp(F.Id("N")));
    private static Formula FinR => Call("Fin", F.Id("r"));
    private static Formula Val(string name, Formula index) => Call(name, index);
    private static Formula Modulus(Formula index) =>
        Seq(Val("a", index), Sp, Cdot, Sp, Val("b", index));
    private static Formula Offset(Formula index) => Seq(F.Id("N"), Sp, Plus, Sp, index);
    private static Formula AllJ(Formula body) => Seq(Open, Forall, Sp, F.Id("j"), Sp,
        InMacro, Sp, FinR, Comma, Sp, body, Close);

    private static Formula FactorWindow()
    {
        var i = F.Id("i");
        var j = F.Id("j");
        var x = F.Id("x");
        var first = Seq(x, Underscore, D(1));
        var second = Seq(x, Underscore, D(2));
        var selector = Seq(x, Sp, InMacro, Sp, FinR, Sp, Times, Sp,
            Call("Bool"), Sp, Mapsto, Sp,
            Call("ite", second, Val("b", first), Val("a", first)));
        return Disp(Seq(
            Forall, Sp, F.Id("r"), Comma, Sp, F.Id("B"), Sp, InMacro, Sp, NatType,
            Comma, Sp, Exists, Sp, F.Id("N"), Sp, Ge, Sp, F.Id("B"), Comma, Sp,
            Exists, Sp, F.Id("a"), Comma, Sp, F.Id("b"), Sp, Colon, Sp,
            FinR, Sp, To, Sp, NatType, Comma,
            RowBreak, Grp(),
            AllJ(Seq(Call("Prime", Val("a", j)), Sp, Land, Sp,
                Call("Prime", Val("b", j)))), Sp, Land, Sp,
            Call("Injective", selector), Sp, Land, Sp,
            AllJ(Seq(Modulus(j), Sp, Neq, Sp, D(0))),
            RowBreak, Grp(), Sp, Land, Sp,
            Open, Forall, Sp, i, Comma, Sp, j, Sp, InMacro, Sp, FinR, Comma, Sp,
            i, Sp, Neq, Sp, j, Sp, Rightarrow, Sp,
            Call("Coprime", Modulus(i), Modulus(j)), Close,
            RowBreak, Grp(), Sp, Land, Sp,
            AllJ(Seq(Modulus(j), Sp, Mid, Sp, Offset(j))), Sp, Land, Sp,
            AllJ(Seq(Neg, Sp, Call("IsPrimePow", Offset(j))))));
    }

    private static Formula ZeroWindow() => Disp(Seq(
        Forall, Sp, F.Id("r"), Comma, Sp, F.Id("B"), Sp, InMacro, Sp, NatType,
        Comma, Sp, Exists, Sp, F.Id("N"), Sp, Ge, Sp, F.Id("B"), Comma, Sp,
        Forall, Sp, F.Id("j"), Sp, Lt, Sp, F.Id("r"), Comma, Sp,
        Lambda, Open, Offset(F.Id("j")), Close, Sp, Eq, Sp, D(0)));

    private static Formula PositivePrime() => Disp(Seq(
        Forall, Sp, F.Id("B"), Sp, InMacro, Sp, NatType, Comma, Sp,
        Exists, Sp, F.Id("p"), Sp, Ge, Sp, F.Id("B"), Comma, Sp,
        Call("Prime", F.Id("p")), Sp, Land, Sp,
        Lambda, Open, F.Id("p"), Close, Sp, Eq, Sp,
        Log, Open, F.Id("p"), Close, Sp, Land, Sp,
        D(0), Sp, Lt, Sp, Log, Open, F.Id("p"), Close));

    private static Formula Reading(Formula index, string field) => field == "C"
        ? Seq(Open, Lambda, Open, index, Close, Sp, Colon, Sp, Mathbb, Grp(F.Id("C")), Close)
        : Seq(Lambda, Open, index, Close);

    private static Formula NoRecurrence(string field)
    {
        var n = F.Id("n");
        var j = F.Id("j");
        var start = Seq(F.Id("N"), Underscore, D(0));
        return Disp(Seq(
            Neg, Sp, Exists, Sp, F.Id("r"), Sp, InMacro, Sp, NatType, Comma, Sp,
            F.Id("c"), Sp, Colon, Sp, FinR, Sp, To, Sp, Mathbb, Grp(F.Id(field)), Comma, Sp,
            start, Sp, InMacro, Sp, NatType, Comma, Sp,
            Forall, Sp, n, Sp, Ge, Sp, start, Comma,
            RowBreak, Grp(),
            Reading(Seq(n, Sp, Plus, Sp, F.Id("r")), field), Sp, Eq, Sp,
            Sum, Underscore, Grp(j, Sp, InMacro, Sp, FinR), Sp,
            Val("c", j), Sp, Cdot, Sp, Reading(Seq(n, Sp, Plus, Sp, j), field)));
    }
}
