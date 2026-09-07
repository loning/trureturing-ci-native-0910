using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class TotientNondivisorRecordsDocument : IScribeDocumentDefinition
{
    private const string Root = "D5/S3/Factorization/TotientNondivisorRecords.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Totient nondivisor values are exactly consecutive-totient lcm jumps, and 1275120 "
            + "refutes the proposed exception set for equality with the power-sum sequence.",
        H("Totient Nondivisors and Consecutive-Totient Lcm Records"),
        Blocks(
            Paragraph(Text(
                "OEIS A378640 (Xausa, 2024-12-05) asks whether its values agree with "
                    + "A095366 outside numbers sixty times an odd number, and whether its "
                    + "distinct values are A076245 after the initial one. The first question "
                    + "is refuted here at N = 1275120; the second is answered affirmatively "
                    + "by a general range characterization derived in this repository.")),
            Paragraph(Text(
                "The counterexample and range theorem share the functions a and L, so they "
                    + "are placed in one module. Natural subtraction is truncated. For N >= 1, "
                    + "powerSum_eq_positive_index_sum identifies the Finset.range implementation "
                    + "with the atom's literal sum ∑_{1 ≤ j < k} j^N. The lcm over an empty range is one.")),
            Entry("BadTotient", "bad-totient", "Failure of totient divisibility",
                BadTotientFormula(), DescribeRole.Definition,
                "BadTotient(N,m) is exactly the conjunction that m is at least two and "
                    + "Euler's totient phi(m) does not divide N.", AssessedProvenance.FromRepo()),
            Entry("a", "least-bad-totient", "Least totient nondivisor",
                AFormula(), DescribeRole.Definition,
                "For positive N, a(N) is Nat.find applied to the existence of a BadTotient, "
                    + "hence the minimum displayed. The totalized value at N = 0 is zero; "
                    + "the OEIS A378640 sequence is used only on positive inputs.",
                AssessedProvenance.FromRepo()),
            Entry("powerSum", "power-sum", "Finite power sum",
                PowerSumFormula(), DescribeRole.Definition,
                "The range contains precisely 0 through k-1. The public theorem "
                    + "powerSum_eq_positive_index_sum proves that for N >= 1 its zeroth term "
                    + "vanishes, leaving the atom's sum ∑_{1 ≤ j < k} j^N.",
                AssessedProvenance.FromRepo()),
            Entry("powerSum_eq_positive_index_sum", "power-sum-positive-index-identity",
                "Range sum equals the positive-index sum", PowerSumPositiveIndexFormula(),
                DescribeRole.Theorem,
                "For every positive exponent, the j = 0 term is zero, so the range implementation "
                    + "equals ∑_{1 ≤ j < k} j^N. This is the exact power sum transcribed in the "
                    + "OEIS A095366 clause of the source atom.", AssessedProvenance.FromRepo()),
            Entry("PowerSumDivisor", "power-sum-divisor", "Power-sum divisor predicate",
                PowerSumDivisorFormula(), DescribeRole.Definition,
                "A power-sum divisor is at least two and divides the corresponding finite sum.",
                AssessedProvenance.FromRepo()),
            Entry("A095366", "a095366", "Least power-sum divisor",
                A095366Formula(), DescribeRole.Definition,
                "This is Nat.sInf of exactly the natural numbers satisfying PowerSumDivisor. "
                    + "A095366_eq_literal identifies it publicly with the least k > 1 dividing "
                    + "∑_{1 ≤ j < k} j^N, the A095366 definition cited by OEIS A378640 (Xausa, 2024); "
                    + "for exponent 1275120 the proof supplies 53 as an inhabitant.",
                AssessedProvenance.FromRepo()),
            Entry("A095366_eq_literal", "a095366-literal-positive-index-identity",
                "A095366 has the atom's literal definition", A095366LiteralFormula(),
                DescribeRole.Theorem,
                "For every positive exponent, A095366 is exactly the infimum of k > 1 that divide "
                    + "∑_{1 ≤ j < k} j^N. This transcribes the OEIS A095366 definition in the source "
                    + "atom and follows from powerSum_eq_positive_index_sum.",
                AssessedProvenance.FromRepo()),
            Entry("L", "consecutive-totient-lcm", "Consecutive-totient lcm",
                LFormula(), DescribeRole.Definition,
                "The finite range 0 <= i < t is shifted by one, so this is exactly the lcm "
                    + "of phi(1) through phi(t), the A076245 construction cited by OEIS A378640 "
                    + "(Xausa, 2024). The t = 0 range is empty.", AssessedProvenance.FromRepo()),
            Entry("L_zero", "consecutive-totient-lcm-zero", "The empty lcm",
                LZeroFormula(), DescribeRole.Theorem,
                "Finset.lcm over the empty range is one.", AssessedProvenance.FromRepo()),
            Entry("L_dvd_iff", "consecutive-totient-lcm-divisibility",
                "Divisibility by the consecutive-totient lcm", LDvdFormula(), DescribeRole.Theorem,
                "Finset.lcm_dvd_iff turns divisibility by L(t) into simultaneous divisibility "
                    + "by every phi(j) with 1 <= j <= t.", AssessedProvenance.FromRepo()),
            Entry("L_jump_iff_not_dvd", "consecutive-totient-lcm-jump",
                "Strict lcm jumps detect a new totient", LJumpFormula(), DescribeRole.Theorem,
                "Monotonicity gives L(m-1) dividing L(m). Equality holds exactly when the new "
                    + "factor phi(m) already divides L(m-1), yielding the stated strict-jump criterion.",
                AssessedProvenance.FromRepo()),
            Entry("range_iff_lcm_jump", "totient-nondivisor-range",
                "The value set is the strict-jump set", RangeFormula(), DescribeRole.Theorem,
                "Forward, minimality of a(N) makes every earlier totient divide N, so L(m-1) "
                    + "divides N while phi(m) does not. Reverse, the explicit positive witness "
                    + "N = L(m-1) has all earlier totients as divisors and excludes phi(m). "
                    + "Thus the value set for m >= 2 is A076245 without its initial one.",
                AssessedProvenance.FromRepo()),
            Entry("totients_lt_51_dvd_1275120", "totients-below-51-divide-1275120",
                "The lower totients divide the witness", TotientsLt51Formula(), DescribeRole.Theorem,
                "Kernel decide checks every finite index i below 51 and proves that phi(i.val) "
                    + "divides 1275120 whenever i.val is positive.", AssessedProvenance.FromRepo()),
            Entry("totient_51_eq_32", "totient-51-equals-32",
                "The totient at 51", Totient51Formula(), DescribeRole.Theorem,
                "Kernel decide computes phi(51) exactly as 32.", AssessedProvenance.FromRepo()),
            Entry("mod_1275120_32", "witness-1275120-modulo-32",
                "The witness modulo 32", Mod1275120By32Formula(), DescribeRole.Theorem,
                "Exact natural-number normalization computes the remainder as 16.",
                AssessedProvenance.FromRepo()),
            Entry("mod_1275120_120", "witness-1275120-modulo-120",
                "The witness modulo 120", Mod1275120By120Formula(), DescribeRole.Theorem,
                "Exact natural-number normalization computes the remainder as zero.",
                AssessedProvenance.FromRepo()),
            Entry("a_1275120", "least-bad-totient-1275120",
                "The least totient nondivisor at 1275120", A1275120Formula(), DescribeRole.Theorem,
                "Kernel decide certifies phi(j) dividing 1275120 for every 1 <= j <= 50. "
                    + "It also certifies phi(51) = 32, while 1275120 has remainder 16 modulo 32.",
                AssessedProvenance.FromRepo()),
            Entry("powerSum_1275120_mod_51", "power-sum-1275120-modulo-51",
                "The power sum modulo 51", PowerSumMod51Formula(), DescribeRole.Theorem,
                "Kernel-producing modular reduction computes the power sum as congruent to 31 "
                    + "modulo 51.", AssessedProvenance.FromRepo()),
            Entry("powerSum_1275120_mod_53", "power-sum-1275120-modulo-53",
                "The power sum modulo 53", PowerSumMod53Formula(), DescribeRole.Theorem,
                "Kernel-producing modular reduction computes the power sum as congruent to zero "
                    + "modulo 53.", AssessedProvenance.FromRepo()),
            Entry("A095366_1275120_ne_51", "a095366-1275120-not-51",
                "The power-sum value is not 51", A095366Not51Formula(), DescribeRole.Theorem,
                "A095366_eq_literal makes the certificate about the atom's sum "
                    + "∑_{1 ≤ j < k} j^1275120. Kernel-producing modular reduction gives its value "
                    + "at k = 51 congruent to 31 modulo 51 and its value at k = 53 congruent to "
                    + "zero modulo 53. Hence 53 inhabits the literal defining set but 51 does not.",
                AssessedProvenance.FromRepo()),
            Entry("not_exception_form", "witness-not-exception-form",
                "The witness lies outside the proposed exception family", NotExceptionFormula(),
                DescribeRole.Theorem,
                "Natural-number arithmetic proves that 1275120 is not sixty times an odd number; "
                    + "equivalently, it is zero rather than sixty modulo 120.",
                AssessedProvenance.FromRepo()),
            Entry("exception_set_claim_false", "exception-set-claim-false",
                "Counterexample to the proposed exception set", ExceptionFormula(),
                DescribeRole.Theorem,
                "All three certified clauses are stated together: a(1275120) is 51, the "
                    + "A095366 value is not 51, and 1275120 is outside the claimed exception "
                    + "form. Therefore the proposed equality-exception description is false.",
                AssessedProvenance.FromRepo()))));

    private static DocumentBlock.Describe Entry(string declaration, string id, string title,
        Formula formula, DescribeRole role, string prose, AssessedProvenance provenance) => Describe.Lean(
            DescribeId.Create(id), DeclarationHandle.Create(Root + declaration), H(title),
            StatementSource.FromAuthor(formula), provenance,
            Blocks(Paragraph(Text(prose))), role);

    private static Formula BadTotientFormula()
    {
        Formula n = F.Id("N"), m = F.Id("m");
        Formula body = IffFormula(
            Call("BadTotient", n, m),
            AndFormula(LeqFormula(D(2), m), NotFormula(DividesFormula(Totient(m), n))));
        return Disp(ForAllNaturals(body, "N", "m"));
    }

    private static Formula AFormula()
    {
        Formula n = F.Id("N"), m = F.Id("m");
        Formula candidates = SetOf(m, Call("BadTotient", n, m));
        Formula conditional = Seq(
            Named("if"), Sp, LtFormula(D(0), n), Sp,
            Named("then"), Sp, Call("min", candidates), Sp,
            Named("else"), Sp, D(0));
        return Disp(ForAllNaturals(EqualFormula(Call("a", n), conditional), "N"));
    }

    private static Formula PowerSumFormula()
    {
        Formula n = F.Id("N"), k = F.Id("k"), j = F.Id("j");
        Formula bounds = Seq(D(0), Sp, Le, Sp, j, Sp, Lt, Sp, k);
        Formula sum = Seq(new Formula.Subscript(Sum, Grp(bounds)), Sp,
            new Formula.Power(j, n));
        return Disp(ForAllNaturals(EqualFormula(Call("powerSum", n, k), sum), "N", "k"));
    }

    private static Formula PowerSumPositiveIndexFormula()
    {
        Formula n = F.Id("N"), k = F.Id("k");
        Formula assumption = LeqFormula(D(1), n);
        Formula identity = EqualFormula(Call("powerSum", n, k), PositiveIndexPowerSum(n, k));
        return Disp(ForAllNaturals(ImpliesFormula(
            Parenthesized(assumption), Parenthesized(identity)), "N", "k"));
    }

    private static Formula PowerSumDivisorFormula()
    {
        Formula n = F.Id("N"), k = F.Id("k");
        Formula body = IffFormula(
            Call("PowerSumDivisor", n, k),
            AndFormula(LeqFormula(D(2), k), DividesFormula(k, Call("powerSum", n, k))));
        return Disp(ForAllNaturals(body, "N", "k"));
    }

    private static Formula A095366Formula()
    {
        Formula n = F.Id("N"), k = F.Id("k");
        Formula candidates = SetOf(k, Call("PowerSumDivisor", n, k));
        return Disp(ForAllNaturals(
            EqualFormula(Call("A095366", n), Call("sInf", candidates)), "N"));
    }

    private static Formula A095366LiteralFormula()
    {
        Formula n = F.Id("N"), k = F.Id("k");
        Formula condition = Parenthesized(AndFormula(
            LtFormula(D(1), k), DividesFormula(k, PositiveIndexPowerSum(n, k))));
        Formula candidates = SetOf(k, condition);
        Formula identity = EqualFormula(Call("A095366", n), Call("sInf", candidates));
        return Disp(ForAllNaturals(ImpliesFormula(
            Parenthesized(LeqFormula(D(1), n)), Parenthesized(identity)), "N"));
    }

    private static Formula LFormula()
    {
        Formula t = F.Id("t"), i = F.Id("i");
        Formula bounds = Seq(D(0), Sp, Le, Sp, i, Sp, Lt, Sp, t);
        Formula lcm = Seq(new Formula.Subscript(Named("lcm"), Grp(bounds)), Sp,
            Totient(AddFormula(i, D(1))));
        return Disp(ForAllNaturals(EqualFormula(Call("L", t), lcm), "t"));
    }

    private static Formula LZeroFormula() =>
        Disp(EqualFormula(Call("L", D(0)), D(1)));

    private static Formula LDvdFormula()
    {
        Formula t = F.Id("t"), n = F.Id("N"), j = F.Id("j");
        Formula each = ForAllNaturals(
            ImpliesFormula(LeqFormula(D(1), j),
                ImpliesFormula(LeqFormula(j, t), DividesFormula(Totient(j), n))), "j");
        Formula body = IffFormula(DividesFormula(Call("L", t), n), each);
        return Disp(ForAllNaturals(body, "t", "N"));
    }

    private static Formula LJumpFormula()
    {
        Formula m = F.Id("m"), previous = SubtractFormula(m, D(1));
        Formula jump = LtFormula(Call("L", previous), Call("L", m));
        Formula newTotient = NotFormula(DividesFormula(Totient(m), Call("L", previous)));
        Formula body = ImpliesFormula(LeqFormula(D(2), m), IffFormula(jump, newTotient));
        return Disp(ForAllNaturals(body, "m"));
    }

    private static Formula RangeFormula()
    {
        Formula m = F.Id("m"), n = F.Id("N"), previous = SubtractFormula(m, D(1));
        Formula occurrence = ExistsNatural("N", AndFormula(
            LeqFormula(D(1), n), EqualFormula(Call("a", n), m)));
        Formula jump = LtFormula(Call("L", previous), Call("L", m));
        Formula body = ImpliesFormula(
            LeqFormula(D(2), m), IffFormula(occurrence, jump));
        return Disp(ForAllNaturals(body, "m"));
    }

    private static Formula A1275120Formula() =>
        Disp(EqualFormula(Call("a", Witness()), D(5, 1)));

    private static Formula TotientsLt51Formula()
    {
        Formula i = F.Id("i"), value = Call("val", i);
        Formula body = ImpliesFormula(LeqFormula(D(1), value),
            DividesFormula(Totient(value), Witness()));
        return Disp(new Formula.Bind(
            FormulaQuantifier.ForAll, FormulaIdentifier.Create("i"), Call("Fin", D(5, 1)), body));
    }

    private static Formula Totient51Formula() =>
        Disp(EqualFormula(Totient(D(5, 1)), D(3, 2)));

    private static Formula Mod1275120By32Formula() =>
        Disp(EqualFormula(new Formula.Modulo(Witness(), D(3, 2)), D(1, 6)));

    private static Formula Mod1275120By120Formula() =>
        Disp(EqualFormula(new Formula.Modulo(Witness(), D(1, 2, 0)), D(0)));

    private static Formula PowerSumMod51Formula() =>
        Disp(ModEqFormula(Call("powerSum", Witness(), D(5, 1)), D(3, 1), D(5, 1)));

    private static Formula PowerSumMod53Formula() =>
        Disp(ModEqFormula(Call("powerSum", Witness(), D(5, 3)), D(0), D(5, 3)));

    private static Formula A095366Not51Formula() =>
        Disp(NotEqualFormula(Call("A095366", Witness()), D(5, 1)));

    private static Formula NotExceptionFormula()
    {
        Formula k = F.Id("k");
        Formula odd = AddFormula(MultiplyFormula(D(2), k), D(1));
        Formula equation = EqualFormula(Witness(), MultiplyFormula(D(6, 0), odd));
        return Disp(NotFormula(ExistsNatural("k", equation)));
    }

    private static Formula ExceptionFormula()
    {
        Formula first = EqualFormula(Call("a", Witness()), D(5, 1));
        Formula second = NotEqualFormula(Call("A095366", Witness()), D(5, 1));
        Formula k = F.Id("k");
        Formula third = NotFormula(ExistsNatural("k", EqualFormula(
            Witness(), MultiplyFormula(D(6, 0), AddFormula(MultiplyFormula(D(2), k), D(1))))));
        return Disp(Seq(AndFormula(Parenthesized(first),
            AndFormula(Parenthesized(second), Parenthesized(third))), Dot));
    }

    private static Formula ForAllNaturals(Formula body, params string[] names) =>
        new Formula.BindMany(
            FormulaQuantifier.ForAll,
            [.. names.Select(name => NaturalBound(name))],
            body);

    private static Formula ExistsNatural(string name, Formula body) =>
        new Formula.Bind(
            FormulaQuantifier.Exists, FormulaIdentifier.Create(name), Naturals(), body);

    private static Formula.BoundVariable NaturalBound(string name) =>
        new(FormulaIdentifier.Create(name), Naturals());

    private static Formula SetOf(Formula variable, Formula condition) =>
        Seq(OpenBrace, variable, Colon, Sp, Naturals(), Sp, Mid, Sp, condition, CloseBrace);

    private static Formula PositiveIndexPowerSum(Formula exponent, Formula upperBound)
    {
        Formula j = F.Id("j");
        Formula bounds = Seq(D(1), Sp, Le, Sp, j, Sp, Lt, Sp, upperBound);
        return Seq(new Formula.Subscript(Sum, Grp(bounds)), Sp,
            new Formula.Power(j, exponent));
    }

    private static Formula Totient(Formula value) =>
        new Formula.Apply(Varphi, [value]);

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula Witness() => D(1, 2, 7, 5, 1, 2, 0);

    private static Formula AddFormula(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);

    private static Formula SubtractFormula(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Subtract, right);

    private static Formula MultiplyFormula(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula EqualFormula(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula NotEqualFormula(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.NotEqual, right);

    private static Formula LeqFormula(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula LtFormula(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula DividesFormula(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Divides, right);

    private static Formula AndFormula(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);

    private static Formula ImpliesFormula(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);

    private static Formula IffFormula(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Iff, right);

    private static Formula ModEqFormula(Formula left, Formula right, Formula modulus) =>
        Seq(left, Sp, Equiv, Sp, right, Sp,
            Parenthesized(Seq(Operatorname, Grp(F.Id("mod")), Sp, modulus)));

    private static Formula NotFormula(Formula value) => new Formula.Not(value);

    private static Formula Named(string name) => Seq(Operatorname, Grp(F.Id(name)));

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);
}
