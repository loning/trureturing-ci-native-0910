using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Factorization;

internal sealed class FactorDensityHighlyCompositeCounterexampleDocument : IScribeDocumentDefinition
{
    private const string Prefix =
        "D5/S3/Factorization/FactorDensityHighlyCompositeCounterexample.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "A finite exponent-profile certificate and an exact power inequality refute the expanded "
            + "factor-density coincidence claim at 73329656400.",
        H("Factor-Density and Highly Composite Counterexample"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("divisor-count"),
                DeclarationHandle.Create(Prefix + "tau"),
                H("Divisor-count function"),
                StatementSource.FromAuthor(TauDefinition()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For a natural number n, tau(n) is the cardinality of Nat.divisors n. "
                        + "This is the divisor-count function used in both record predicates."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("expanded-factor-density-score"),
                DeclarationHandle.Create(Prefix + "g"),
                H("Expanded factor-density score"),
                StatementSource.FromAuthor(ScoreDefinition()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The numerator and n are explicitly cast from natural numbers to real numbers. "
                        + "The displayed fraction is real division, matching tau(n)/log(n+1); no "
                        + "natural-number division occurs in this module. This repository formula "
                        + "transcribes Switkay's expanded score from the cited OEIS comment."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("factor-density-record"),
                DeclarationHandle.Create(Prefix + "FD"),
                H("Expanded factor-density record predicate"),
                StatementSource.FromAuthor(RecordDefinition("FD", "g")),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "FD(n) requires every natural m with 1 <= m and m < n to have strictly "
                        + "smaller expanded score g(m). The nested implications mirror the Lean definition."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("highly-composite-record"),
                DeclarationHandle.Create(Prefix + "HC"),
                H("Highly composite record predicate"),
                StatementSource.FromAuthor(RecordDefinition("HC", "tau")),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "HC(n) requires every natural m with 1 <= m and m < n to have strictly "
                        + "smaller divisor count tau(m)."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("counterexample-candidate"),
                DeclarationHandle.Create(Prefix + "N"),
                H("Counterexample candidate"),
                StatementSource.FromAuthor(Disp(Equal(F.Id("N"), Num(73329656400)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "N names the explicit highly composite candidate 73329656400."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("comparison-witness"),
                DeclarationHandle.Create(Prefix + "M"),
                H("Smaller comparison witness"),
                StatementSource.FromAuthor(Disp(Equal(F.Id("M"), Num(64250746560)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "M names the smaller integer whose factor-density score exceeds that of N."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("first-eleven-primes"),
                DeclarationHandle.Create(Prefix + "primes11"),
                H("First eleven primes"),
                StatementSource.FromAuthor(Disp(Equal(F.Id("primes11"), PrimeList(true)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This exact list supplies the coordinatewise lower bound for eleven sorted "
                        + "distinct prime factors. Its product is 200560490130, above 73329656400."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("first-ten-primes"),
                DeclarationHandle.Create(Prefix + "primes10"),
                H("First ten primes"),
                StatementSource.FromAuthor(PrimesTenDefinition()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "primes10 is List.take 10 primes11 and therefore has the displayed ten entries. "
                        + "These are the bases of every profile admitted by the checker."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("profile-checker"),
                DeclarationHandle.Create(Prefix + "profileCheck"),
                H("Pruned exponent-profile checker"),
                StatementSource.FromAuthor(ProfileCheckDefinition()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "The checker recurses on the prime-base list. Its empty branch tests t <= 3584. "
                            + "For p :: ps it first tests the same divisor-product bound, then checks every "
                            + "e in the consecutive range 1 through 36 while v*p^e < 73329656400, "
                            + "recursing at value v*p^e and divisor product t*(e+1).")),
                    Paragraph(Text(
                        "The takeWhile pruning is sound because the bases are positive and powers grow "
                            + "with the exponent. The subsequent proof maps arbitrary sorted prime factors "
                            + "coordinatewise onto these smaller prime bases."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("counterexample-factorization"),
                DeclarationHandle.Create(Prefix + "N_factorization"),
                H("Prime factorization of the counterexample candidate"),
                StatementSource.FromAuthor(FactorizationFormula("N", true)),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The displayed identity is the exact prime factorization of N."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("comparison-factorization"),
                DeclarationHandle.Create(Prefix + "M_factorization"),
                H("Prime factorization of the comparison witness"),
                StatementSource.FromAuthor(FactorizationFormula("M", false)),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The displayed identity is the exact prime factorization of M."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("counterexample-divisor-count"),
                DeclarationHandle.Create(Prefix + "tau_N"),
                H("Exact divisor count of the counterexample candidate"),
                StatementSource.FromAuthor(Disp(Equal(
                    Call("tau", F.Id("N")), Num(3600)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The factorization of N gives the exact divisor count tau(N)=3600."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("comparison-divisor-count"),
                DeclarationHandle.Create(Prefix + "tau_M"),
                H("Exact divisor count of the comparison witness"),
                StatementSource.FromAuthor(Disp(Equal(
                    Call("tau", F.Id("M")), Num(3584)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The factorization of M gives the exact divisor count tau(M)=3584."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("profile-certificate"),
                DeclarationHandle.Create(Prefix + "profile_certificate"),
                H("Kernel profile certificate"),
                StatementSource.FromAuthor(Disp(Equal(
                    Call("profileCheck", F.Id("primes10"), Num(1), Num(1)), F.Id("true")))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Lean's kernel evaluates the checker with maxRecDepth 100000 and unlimited "
                        + "heartbeats. A separate deterministic recount records 22091 reachable positive-"
                        + "exponent prefix profiles; the theorem itself is the exact Boolean equality."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("predecessor-divisor-bound"),
                DeclarationHandle.Create(Prefix + "tau_lt_N_bound"),
                H("Divisor-count bound below the candidate"),
                StatementSource.FromAuthor(TauBelowNFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The profile certificate proves tau(m) <= 3584 for every positive m below N."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("candidate-highly-composite"),
                DeclarationHandle.Create(Prefix + "hc_N"),
                H("The candidate is highly composite"),
                StatementSource.FromAuthor(Disp(Call("HC", F.Id("N")))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The predecessor bound and tau(N)=3600 prove that every positive predecessor "
                        + "has strictly fewer divisors than N."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("power-witness"),
                DeclarationHandle.Create(Prefix + "power_witness"),
                H("Exact power inequality"),
                StatementSource.FromAuthor(Disp(Less(
                    Pow(Num(64250746561), Num(225)),
                    Pow(Num(73329656401), Num(224))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This natural-number inequality is kernel reduced. Monotonicity and the power law "
                        + "for the real logarithm transport it to the strict comparison g(73329656400) "
                        + "< g(64250746560)."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("factor-density-comparison"),
                DeclarationHandle.Create(Prefix + "g_N_lt_g_M"),
                H("The candidate has smaller factor density"),
                StatementSource.FromAuthor(Disp(Less(
                    Call("g", F.Id("N")), Call("g", F.Id("M"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The power witness, tau(N)=3600, and tau(M)=3584 yield the strict score "
                        + "comparison g(N)<g(M)."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("candidate-not-factor-dense"),
                DeclarationHandle.Create(Prefix + "not_fd_N"),
                H("The candidate is not factor dense"),
                StatementSource.FromAuthor(Disp(Negated(Call("FD", F.Id("N"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Because M<N while g(N)<g(M), N fails the expanded factor-density record predicate."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("candidate-not-exception"),
                DeclarationHandle.Create(Prefix + "N_ne"),
                H("The candidate is not the exceptional value"),
                StatementSource.FromAuthor(Disp(NotEqual(F.Id("N"), Num(45360)))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Exact arithmetic separates N from the claimed exceptional value 45360."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-counterexample"),
                DeclarationHandle.Create(Prefix + "factor_density_highly_composite_counterexample"),
                H("Explicit factor-density counterexample"),
                StatementSource.FromAuthor(CounterexampleFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "The sorted-prime lower bound shows that every positive m below 73329656400 "
                            + "has at most ten distinct prime factors, each exponent lies from 1 through "
                            + "36, and the successful profile certificate bounds tau(m) by 3584. Exact "
                            + "factorization gives tau(73329656400)=3600, proving HC.")),
                    Paragraph(Text(
                        "The smaller witness M=64250746560 has tau(M)=3584. The power witness and real "
                            + "logarithm laws prove g(73329656400)<g(M), so 73329656400 is not an FD record. "
                            + "The remaining inequality 73329656400 != 45360 is exact arithmetic."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("switkay-expanded-claim-false"),
                DeclarationHandle.Create(Prefix + "switkay_expanded_claim_false"),
                H("Switkay's expanded coincidence claim is false"),
                StatementSource.FromAuthor(ExpandedClaimFalseFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Hal M. Switkay's OEIS A399133 comment dated 2026-08-19 states: \"All these "
                            + "numbers are highly composite (A002182) and even factor-dense (A210594) "
                            + "under the expanded definition of factor-density given in the comments. "
                            + "However, factor-density appears to coincide with being highly composite "
                            + "other than at 45360.\" The theorem refutes that expanded-definition assertion here.")),
                    Paragraph(Text(
                        "The expanded definition is g(n)=tau(n)/log(1+n), as stated in Switkay's "
                            + "2022-09-07 OEIS A210594 comment. The A210594 b-file already omits this N "
                            + "under the original (tau(n)-1)/log(n) definition; this result claims only "
                            + "the exact kernel refutation of the later expanded-definition assertion. "
                            + "First-publication priority is ASSUMED-UNVERIFIED."))),
                DescribeRole.Theorem)),
        []));

    private static Formula Call(string name, params Formula[] arguments)
    {
        if (name != "List.range'")
        {
            return DefinitionDsl.Call(name, arguments);
        }

        Formula qualifiedName = Seq(
            Operatorname, Grp(F.Id("List"), Dot, F.Id("range"), Apos));
        return new Formula.Apply(qualifiedName, [.. arguments]);
    }

    private static Formula TauDefinition()
    {
        Formula n = F.Id("n");
        return Disp(All([Bound("n", Naturals())], Equal(
            Call("tau", n), Call("card", Call("divisors", n)))));
    }

    private static Formula ScoreDefinition()
    {
        Formula n = F.Id("n");
        Formula numerator = Call("val", Call("tau", n));
        Formula denominator = Call("log", Add(Call("val", n), Num(1)));
        return Disp(All([Bound("n", Naturals())], Equal(
            Call("g", n), new Formula.Fraction(numerator, denominator))));
    }

    private static Formula RecordDefinition(string predicate, string value)
    {
        Formula n = F.Id("n");
        Formula m = F.Id("m");
        Formula body = Logic(LessEqual(Num(1), m), FormulaLogicOperator.Implies,
            Logic(Less(m, n), FormulaLogicOperator.Implies,
                Less(Call(value, m), Call(value, n))));
        return Disp(All([Bound("n", Naturals())], Logic(
            Call(predicate, n), FormulaLogicOperator.Iff,
            All([Bound("m", Naturals())], body))));
    }

    private static Formula PrimesTenDefinition() => Disp(new Formula.Aligned([
        Equal(F.Id("primes10"), Call("take", Num(10), F.Id("primes11"))),
        Equal(F.Id("primes10"), PrimeList(false)),
    ]));

    private static Formula ProfileCheckDefinition()
    {
        Formula ps = F.Id("ps");
        Formula p = F.Id("p");
        Formula v = F.Id("v");
        Formula t = F.Id("t");
        Formula e = F.Id("e");
        Formula bound = Call("decide", LessEqual(t, Num(3584)));
        Formula nextValue = Multiply(v, Pow(p, e));
        Formula allowedLambda = Parenthesized(Seq(
            e, Colon, Sp, Naturals(), Sp, Mapsto, Sp,
            Call("decide", Less(nextValue, Num(73329656400)))));
        Formula allowed = Call("takeWhile",
            Call("List.range'", Num(1), Num(36)), allowedLambda);
        Formula recursive = Call("profileCheck", ps, nextValue,
            Multiply(t, Add(e, Num(1))));
        Formula recursiveLambda = Parenthesized(Seq(
            e, Colon, Sp, Naturals(), Sp, Mapsto, Sp, recursive));
        Formula allChecked = Call("all", allowed, recursiveLambda);
        Formula signature = Seq(F.Id("profileCheck"), Colon, Sp,
            FunctionType(ListNaturals(), FunctionType(Naturals(),
                FunctionType(Naturals(), F.Id("Bool")))));
        return Disp(new Formula.Aligned([
            signature,
            All([Bound("v", Naturals()), Bound("t", Naturals())],
                Equal(Call("profileCheck", EmptyList(), v, t), bound)),
            All([
                    Bound("p", Naturals()),
                    Bound("ps", ListNaturals()),
                    Bound("v", Naturals()),
                    Bound("t", Naturals()),
                ],
                Equal(Call("profileCheck", Call("cons", p, ps), v, t),
                    Seq(bound, Sp, Land, Sp, allChecked))),
        ]));
    }

    private static Formula FactorizationFormula(string name, bool counterexample)
    {
        Formula factors = counterexample
            ? Product(Pow(Num(2), Num(4)), Pow(Num(3), Num(4)), Pow(Num(5), Num(2)),
                Pow(Num(7), Num(2)), Num(11), Num(13), Num(17), Num(19))
            : Product(Pow(Num(2), Num(6)), Pow(Num(3), Num(3)), Num(5), Num(7),
                Num(11), Num(13), Num(17), Num(19), Num(23));
        return Disp(Equal(F.Id(name), factors));
    }

    private static Formula TauBelowNFormula()
    {
        Formula m = F.Id("m");
        Formula body = Logic(Less(Num(0), m), FormulaLogicOperator.Implies,
            Logic(Less(m, F.Id("N")), FormulaLogicOperator.Implies,
                LessEqual(Call("tau", m), Num(3584))));
        return Disp(All([Bound("m", Naturals())], body));
    }

    private static Formula CounterexampleFormula()
    {
        Formula n = F.Id("N");
        return Disp(And(
            Call("HC", n),
            NotEqual(n, Num(45360)),
            Negated(Call("FD", n))));
    }

    private static Formula ExpandedClaimFalseFormula()
    {
        Formula n = F.Id("n");
        Formula equivalence = Logic(
            Call("FD", n), FormulaLogicOperator.Iff,
            And(Call("HC", n), NotEqual(n, Num(45360))));
        Formula claim = All([Bound("n", Naturals())], Logic(
            LessEqual(Num(1), n), FormulaLogicOperator.Implies, equivalence));
        return Disp(Negated(claim));
    }

    private static Formula PrimeList(bool eleven)
    {
        Formula[] entries = eleven
            ? [Num(2), Num(3), Num(5), Num(7), Num(11), Num(13), Num(17),
                Num(19), Num(23), Num(29), Num(31)]
            : [Num(2), Num(3), Num(5), Num(7), Num(11), Num(13), Num(17),
                Num(19), Num(23), Num(29)];
        return Seq(OpenBracket, Joined(entries, Comma), CloseBracket);
    }

    private static Formula EmptyList() => Seq(OpenBracket, CloseBracket);

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula ListNaturals() => Call("List", Naturals());

    private static Formula FunctionType(Formula domain, Formula codomain) =>
        Seq(domain, Sp, To, Sp, codomain);

    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);

    private static Formula All(Formula.BoundVariable[] variables, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. variables], body);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula NotEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.NotEqual, right);

    private static Formula Less(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula LessEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Logic(Formula left, FormulaLogicOperator operation, Formula right) =>
        new Formula.Logic(left, operation, right);

    private static Formula And(Formula first, params Formula[] rest)
    {
        Formula result = rest[^1];
        for (var index = rest.Length - 2; index >= 0; index--)
        {
            result = Logic(rest[index], FormulaLogicOperator.And, result);
        }
        return Logic(first, FormulaLogicOperator.And, result);
    }

    private static Formula Negated(Formula value) => Seq(Neg, Sp, Parenthesized(value));

    private static Formula Add(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Add, right);

    private static Formula Multiply(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula Product(Formula first, params Formula[] rest)
    {
        Formula result = first;
        foreach (var factor in rest)
        {
            result = Multiply(result, factor);
        }
        return result;
    }

    private static Formula Pow(Formula value, Formula exponent) =>
        new Formula.Power(value, exponent);

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);

    private static Formula Joined(Formula[] values, Formula separator)
    {
        List<Formula> items = [];
        for (var index = 0; index < values.Length; index++)
        {
            if (index > 0)
            {
                items.Add(separator);
                items.Add(Sp);
            }
            items.Add(values[index]);
        }
        return Seq([.. items]);
    }
}
