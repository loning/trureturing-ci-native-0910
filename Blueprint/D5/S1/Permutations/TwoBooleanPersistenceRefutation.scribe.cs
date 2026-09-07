using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Permutations;

internal sealed class TwoBooleanPersistenceRefutationDocument : IScribeDocumentDefinition
{
    private const string Root = "D5/S1/Permutations/TwoBooleanPersistenceRefutation.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The longest signed permutation in B2 is 2-boolean but globally contains 4321.",
        H("2-Boolean Persistence Refutation"),
        Blocks(
            Paragraph(Text(
                "Levens, Lewis, and Tenner, arXiv:2504.13108v1, Section 6.1 ask whether "
                    + "2-booleanity is persistent in the sense of their Definition 4.1. "
                    + "Their Definition 2.4 permits both negative and positive indices in "
                    + "global pattern containment. The paper poses the question but does not "
                    + "state the counterexample proved here, so the counterexample declarations "
                    + "have repository provenance.")),
            Paragraph(Text(
                "The mirror carrier Fin(2n) is ordered as -n through -1, then 1 through n. "
                    + "Its involution rev represents sign change. For B2, positions 0, 1, 2, 3 "
                    + "therefore represent -2, -1, 1, 2.")),
            Definition("SignedPerm", "signed-permutation", "Concrete signed permutations",
                SignedPermFormula(),
                "This record consists of a permutation of Fin(2n) and the displayed commuting "
                    + "law with rev. Thus it is exactly a permutation w satisfying w(-i)=-w(i)."),
            Definition("Generator", "type-b2-generator", "The B2 generators",
                GeneratorFormula(),
                "The concrete generator type has exactly the constructors s0 and s1."),
            Definition("simple0", "simple-generator-zero", "The sign-change generator",
                Simple0Formula(),
                "The equivalence swaps mirror positions 1 and 2 and fixes 0 and 3. Its record "
                    + "proof certifies commutation with rev."),
            Definition("simple1", "simple-generator-one", "The adjacent-swap generator",
                Simple1Formula(),
                "The equivalence first swaps positions 0 and 1 and then positions 2 and 3. "
                    + "Its record proof certifies commutation with rev."),
            Definition("evalWord", "evaluate-generator-word", "Evaluation of B2 words",
                EvalWordFormula(),
                "The empty word is the identity. The two successor equations inline the private "
                    + "generator dispatch and composition used by Lean."),
            Definition("IsReducedWord", "reduced-word", "Reduced decompositions",
                IsReducedWordFormula(),
                "Equality of signed permutations is tested pointwise on the whole mirror "
                    + "carrier. Minimality quantifies over every generator word, not over the "
                    + "finite certificate table."),
            Definition("TwoBoolean", "two-boolean", "2-boolean signed permutations",
                TwoBooleanFormula(),
                "Every reduced word must use each of the two generators at most twice."),
            Definition("longest", "longest-b2-element", "The longest B2 element",
                LongestFormula(),
                "The equivalence rev sends the window (1,2) to (-1,-2)."),
            Definition("mirrorValue", "mirror-value", "Signed value of a mirror position",
                MirrorValueFormula(),
                "In the first branch both subtractions are in the integers. In the second branch "
                    + "i.val-n+1 is computed in the naturals and only then coerced to the integers; "
                    + "this matches the Lean definition exactly."),
            Definition("valueAt", "signed-permutation-value", "Evaluation at a signed index",
                ValueAtFormula(),
                "Apply the underlying equivalence, then translate the resulting mirror position "
                    + "to its signed integer value."),
            Definition("OrderIsomorphic", "order-isomorphic-strings",
                "Relative-order isomorphism", OrderIsomorphicFormula(),
                "Every pair of coordinates has the same strict-order comparison in both strings."),
            Describe.Lean(
                DescribeId.Create("global-pattern-containment"),
                DeclarationHandle.Create(Root + "GloballyContains"),
                H("Global unsigned-pattern containment"),
                StatementSource.FromAuthor(GloballyContainsFormula()),
                AssessedProvenance.FromLiterature(LibraryNoteRef.Create(
                    "D5/L/Permutations/levens2025global")),
                Blocks(Paragraph(Text(
                    "The selected indices are strictly increasing in the full signed order. Their "
                        + "values under w must have the same relative order as p, exactly as in "
                        + "Levens-Lewis-Tenner Definition 2.4."))),
                DescribeRole.Definition),
            Definition("pattern3421", "pattern-3421", "The pattern 3421",
                PatternFormula("pattern3421", 3, 4, 2, 1),
                "The displayed vector gives this Fin(4)-indexed integer function in index order."),
            Definition("pattern4312", "pattern-4312", "The pattern 4312",
                PatternFormula("pattern4312", 4, 3, 1, 2),
                "The displayed vector gives this Fin(4)-indexed integer function in index order."),
            Definition("pattern4321", "pattern-4321", "The pattern 4321",
                Pattern4321Formula(),
                "For i in Fin(4), the value is the integer 4 minus the natural coordinate i.val "
                    + "coerced to the integers."),
            Definition("pattern456123", "pattern-456123", "The pattern 456123",
                PatternFormula("pattern456123", 4, 5, 6, 1, 2, 3),
                "The displayed vector gives this Fin(6)-indexed integer function in index order."),
            Definition("AvoidsTwoBooleanPatterns", "global-two-boolean-avoiders",
                "Global avoidance of the four type-A patterns", AvoidanceFormula(),
                "This conjunction is global avoidance of 3421, 4312, 4321, and 456123."),
            Theorem("reduced_words_longest_iff", "longest-reduced-words",
                "All reduced words of the longest element", ReducedWordsFormula(),
                "A private bounded enumeration checks all 31 words of length at most four: none "
                    + "of the 15 shorter words reaches longest, and exactly the two displayed "
                    + "length-four words do. Minimality still ranges over all words."),
            Theorem("longest_twoBoolean", "longest-is-two-boolean",
                "The longest element is 2-boolean", LongestTwoBooleanFormula(),
                "The reduced-word classification shows that each displayed word contains s0 "
                    + "twice and s1 twice."),
            Theorem("longest_globallyContains_4321", "longest-contains-4321",
                "The longest element globally contains 4321", LongestContainsFormula(),
                "The identity index embedding selects -2<-1<1<2. The corresponding values are "
                    + "2,1,-1,-2, whose relative order is 4321; Lean's kernel decides the finite "
                    + "comparison table."),
            Theorem("twoBoolean_persistence_refutation", "two-boolean-persistence-refutation",
                "A 2-boolean global-pattern counterexample", RefutationFormula(),
                "The witness is longest=(-1,-2). The preceding two theorems are both on the live "
                    + "proof path: it is 2-boolean and globally contains the forbidden pattern 4321."),
            Theorem("twoBoolean_set_differs_from_global_avoiders",
                "two-boolean-set-differs-from-global-avoiders",
                "2-booleanity is not global avoidance", SetDifferenceFormula(),
                "At longest, 2-booleanity holds while the 4321 conjunct of global avoidance fails. "
                    + "Therefore the two predicates are not equal on SignedPerm(2), answering the "
                    + "Section 6.1 persistence question in the negative."))));

    private static DocumentBlock Definition(string declaration, string id, string title,
        Formula formula, string prose) => Describe.Lean(
            DescribeId.Create(id), DeclarationHandle.Create(Root + declaration), H(title),
            StatementSource.FromAuthor(formula), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(prose))), DescribeRole.Definition);

    private static DocumentBlock Theorem(string declaration, string id, string title,
        Formula formula, string prose) => Describe.Lean(
            DescribeId.Create(id), DeclarationHandle.Create(Root + declaration), H(title),
            StatementSource.FromAuthor(formula), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(prose))), DescribeRole.Theorem);

    private static Formula Parenthesized(Formula value) => Seq(Open, value, Close);

    private static Formula Separated(params Formula[] values)
    {
        var items = new List<Formula>();
        for (var index = 0; index < values.Length; index++)
        {
            if (index > 0) items.AddRange([Comma, Sp]);
            items.Add(values[index]);
        }
        return Seq([.. items]);
    }

    private static Formula Call(string name, params Formula[] values) =>
        Seq(Operatorname, Grp(F.Id(name)), Parenthesized(Separated(values)));

    private static Formula List(params Formula[] values) =>
        Seq(OpenBracket, Separated(values), CloseBracket);
    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));
    private static Formula Integers() => Seq(Mathbb, Grp(F.Id("Z")));
    private static Formula Fin(Formula n) => Call("Fin", n);
    private static Formula SignedPerm(Formula n) => Call("SignedPerm", n);
    private static Formula Act(Formula w, Formula i) => Call("toEquiv", w, i);
    private static Formula Subscripted(string name, Formula subscript) =>
        new Formula.Subscript(F.Id(name), subscript);

    private static Formula SignedPermFormula()
    {
        Formula n = F.Id("n"), sigma = F.Id("sigma"), i = F.Id("i");
        Formula carrier = Fin(Seq(D(2), Sp, Times, Sp, n));
        Formula equiv = Call("Equiv", carrier, carrier);
        Formula law = Parenthesized(Seq(
            Forall, Sp, i, Colon, Sp, carrier, Comma, Sp,
            Call("sigma", Call("rev", i)), Sp, Eq, Sp, Call("rev", Call("sigma", i))));
        return Disp(Seq(
            Forall, Sp, n, Colon, Sp, Naturals(), Comma, Sp,
            SignedPerm(n), Sp, Eq, Sp,
            OpenBrace, sigma, Colon, Sp, equiv, Sp, Mid, Sp, law, CloseBrace, Dot));
    }

    private static Formula GeneratorFormula() => Disp(Seq(
        F.Id("Generator"), Sp, Eq, Sp,
        OpenBrace, Subscripted("s", D(0)), Comma, Sp, Subscripted("s", D(1)), CloseBrace, Dot));

    private static Formula Simple0Formula() => Disp(Seq(
        Call("toEquiv", F.Id("simple0")), Sp, Eq, Sp,
        Call("swap", D(1), D(2)), Dot));

    private static Formula Simple1Formula() => Disp(Seq(
        Call("toEquiv", F.Id("simple1")), Sp, Eq, Sp,
        Call("trans", Call("swap", D(0), D(1)), Call("swap", D(2), D(3))), Dot));

    private static Formula EvalWordFormula()
    {
        Formula u = F.Id("u");
        return Disp(new Formula.Aligned([
            Seq(Call("toEquiv", Call("evalWord", List())),
                Sp, Eq, Sp, Call("id", Fin(D(4))), Comma),
            Seq(Call("toEquiv", Call("evalWord", Call("cons", Subscripted("s", D(0)), u))),
                Sp, Eq, Sp,
                Call("trans", Call("toEquiv", F.Id("simple0")),
                    Call("toEquiv", Call("evalWord", u))), Comma),
            Seq(Call("toEquiv", Call("evalWord", Call("cons", Subscripted("s", D(1)), u))),
                Sp, Eq, Sp,
                Call("trans", Call("toEquiv", F.Id("simple1")),
                    Call("toEquiv", Call("evalWord", u))), Dot),
        ]));
    }

    private static Formula PointwiseEvaluation(Formula word, Formula w)
    {
        Formula i = F.Id("i");
        return Parenthesized(Seq(
            Forall, Sp, i, Colon, Sp, Fin(D(4)), Comma, Sp,
            Act(Call("evalWord", word), i), Sp, Eq, Sp, Act(w, i)));
    }

    private static Formula IsReducedWordFormula()
    {
        Formula word = F.Id("word"), other = F.Id("other"), w = F.Id("w");
        Formula minimal = Parenthesized(Seq(
            Forall, Sp, other, Colon, Sp, Call("List", F.Id("Generator")), Comma, Sp,
            PointwiseEvaluation(other, w), Sp, Rightarrow, Sp,
            Call("length", word), Sp, Leq, Sp, Call("length", other)));
        return Disp(Seq(
            Forall, Sp, word, Colon, Sp, Call("List", F.Id("Generator")), Comma, Sp,
            Forall, Sp, w, Colon, Sp, SignedPerm(D(2)), Comma, Sp,
            Call("IsReducedWord", word, w), Sp, Iff, Sp,
            PointwiseEvaluation(word, w), Sp, Land, Sp, minimal, Dot));
    }

    private static Formula TwoBooleanFormula()
    {
        Formula w = F.Id("w"), word = F.Id("word"), g = F.Id("g");
        return Disp(Seq(
            Forall, Sp, w, Colon, Sp, SignedPerm(D(2)), Comma, Sp,
            Call("TwoBoolean", w), Sp, Iff, Sp,
            Parenthesized(Seq(
                Forall, Sp, word, Colon, Sp, Call("List", F.Id("Generator")), Comma, Sp,
                Call("IsReducedWord", word, w), Sp, Rightarrow, Sp,
                Forall, Sp, g, Colon, Sp, F.Id("Generator"), Comma, Sp,
                Call("count", word, g), Sp, Leq, Sp, D(2))), Dot));
    }

    private static Formula LongestFormula() => Disp(Seq(
        Call("toEquiv", F.Id("longest")), Sp, Eq, Sp, F.Id("revPerm"), Dot));

    private static Formula MirrorValueFormula()
    {
        Formula n = F.Id("n"), i = F.Id("i"), val = Call("val", i);
        Formula integerBranch = Seq(
            Call("int", val), Sp, Minus, Sp, Call("int", n));
        Formula naturalBranch = Call("int", Parenthesized(Seq(
            val, Sp, Minus, Sp, n, Sp, Plus, Sp, D(1))));
        return Disp(Seq(
            Forall, Sp, n, Colon, Sp, Naturals(), Comma, Sp,
            Forall, Sp, i, Colon, Sp, Fin(Seq(D(2), Sp, Times, Sp, n)), Comma, Sp,
            Call("mirrorValue", i), Sp, Eq, Sp,
            Call("if", Seq(val, Sp, Lt, Sp, n), integerBranch, naturalBranch), Dot));
    }

    private static Formula ValueAtFormula()
    {
        Formula n = F.Id("n"), w = F.Id("w"), i = F.Id("i");
        return Disp(Seq(
            Forall, Sp, n, Colon, Sp, Naturals(), Comma, Sp,
            Forall, Sp, w, Colon, Sp, SignedPerm(n), Comma, Sp,
            Forall, Sp, i, Colon, Sp, Fin(Seq(D(2), Sp, Times, Sp, n)), Comma, Sp,
            Call("valueAt", w, i), Sp, Eq, Sp,
            Call("mirrorValue", Act(w, i)), Dot));
    }

    private static Formula OrderIsomorphicFormula()
    {
        Formula k = F.Id("k"), a = F.Id("a"), b = F.Id("b");
        Formula i = F.Id("i"), j = F.Id("j");
        Formula functionType = Seq(Fin(k), Sp, To, Sp, Integers());
        return Disp(Seq(
            Forall, Sp, k, Colon, Sp, Naturals(), Comma, Sp,
            Forall, Sp, a, Comma, Sp, b, Colon, Sp, functionType, Comma, Sp,
            Call("OrderIsomorphic", a, b), Sp, Iff, Sp,
            Parenthesized(Seq(
                Forall, Sp, i, Comma, Sp, j, Colon, Sp, Fin(k), Comma, Sp,
                Call("a", i), Sp, Lt, Sp, Call("a", j), Sp, Iff, Sp,
                Call("b", i), Sp, Lt, Sp, Call("b", j))), Dot));
    }

    private static Formula GloballyContainsFormula()
    {
        Formula n = F.Id("n"), k = F.Id("k"), w = F.Id("w"), p = F.Id("p");
        Formula indices = F.Id("indices"), i = F.Id("i"), j = F.Id("j");
        Formula increasing = Parenthesized(Seq(
            Forall, Sp, i, Comma, Sp, j, Colon, Sp, Fin(k), Comma, Sp,
            i, Sp, Lt, Sp, j, Sp, Rightarrow, Sp,
            Call("indices", i), Sp, Lt, Sp, Call("indices", j)));
        Formula selectedValues = Seq(i, Sp, Mapsto, Sp,
            Call("valueAt", w, Call("indices", i)));
        return Disp(Seq(
            Forall, Sp, n, Comma, Sp, k, Colon, Sp, Naturals(), Comma, Sp,
            Forall, Sp, w, Colon, Sp, SignedPerm(n), Comma, Sp,
            Forall, Sp, p, Colon, Sp, Fin(k), Sp, To, Sp, Integers(), Comma, Sp,
            Call("GloballyContains", w, p), Sp, Iff, Sp,
            Parenthesized(Seq(
                Exists, Sp, indices, Colon, Sp,
                Fin(k), Sp, To, Sp, Fin(Seq(D(2), Sp, Times, Sp, n)), Comma, Sp,
                increasing, Sp, Land, Sp,
                Call("OrderIsomorphic", Parenthesized(selectedValues), p))), Dot));
    }

    private static Formula PatternFormula(string name, params byte[] entries)
    {
        var values = entries.Select(entry => D(entry)).ToArray();
        return Disp(Seq(F.Id(name), Sp, Eq, Sp, List(values), Dot));
    }

    private static Formula Pattern4321Formula()
    {
        Formula i = F.Id("i");
        return Disp(Seq(
            Forall, Sp, i, Colon, Sp, Fin(D(4)), Comma, Sp,
            Call("pattern4321", i), Sp, Eq, Sp,
            Call("int", D(4)), Sp, Minus, Sp, Call("int", Call("val", i)), Dot));
    }

    private static Formula AvoidanceFormula()
    {
        Formula w = F.Id("w");
        return Disp(Seq(
            Forall, Sp, w, Colon, Sp, SignedPerm(D(2)), Comma, Sp,
            Call("AvoidsTwoBooleanPatterns", w), Sp, Iff, Sp,
            Parenthesized(Seq(
                Neg, Sp, Parenthesized(Call("GloballyContains", w, F.Id("pattern3421"))), Sp,
                Land, Sp,
                Neg, Sp, Parenthesized(Call("GloballyContains", w, F.Id("pattern4312"))), Sp,
                Land, Sp,
                Neg, Sp, Parenthesized(Call("GloballyContains", w, F.Id("pattern4321"))), Sp,
                Land, Sp,
                Neg, Sp, Parenthesized(Call("GloballyContains", w, F.Id("pattern456123"))))), Dot));
    }

    private static Formula ReducedWordsFormula()
    {
        Formula word = F.Id("word");
        Formula first = List(Subscripted("s", D(0)), Subscripted("s", D(1)),
            Subscripted("s", D(0)), Subscripted("s", D(1)));
        Formula second = List(Subscripted("s", D(1)), Subscripted("s", D(0)),
            Subscripted("s", D(1)), Subscripted("s", D(0)));
        return Disp(Seq(
            Forall, Sp, word, Colon, Sp, Call("List", F.Id("Generator")), Comma, Sp,
            Call("IsReducedWord", word, F.Id("longest")), Sp, Iff, Sp,
            Parenthesized(Seq(
                word, Sp, Eq, Sp, first, Sp, Lor, Sp,
                word, Sp, Eq, Sp, second)), Dot));
    }

    private static Formula LongestTwoBooleanFormula() => Disp(Seq(
        Call("TwoBoolean", F.Id("longest")), Dot));

    private static Formula LongestContainsFormula() => Disp(Seq(
        Call("GloballyContains", F.Id("longest"), F.Id("pattern4321")), Dot));

    private static Formula RefutationFormula()
    {
        Formula w = F.Id("w");
        return Disp(Seq(
            Exists, Sp, w, Colon, Sp, SignedPerm(D(2)), Comma, Sp,
            Parenthesized(Call("TwoBoolean", w)), Sp, Land, Sp,
            Parenthesized(Call("GloballyContains", w, F.Id("pattern4321"))), Dot));
    }

    private static Formula SetDifferenceFormula()
    {
        Formula w = F.Id("w");
        return Disp(Seq(
            Neg, Sp, Parenthesized(Seq(
                Forall, Sp, w, Colon, Sp, SignedPerm(D(2)), Comma, Sp,
                Call("TwoBoolean", w), Sp, Iff, Sp,
                Call("AvoidsTwoBooleanPatterns", w))), Dot));
    }
}
