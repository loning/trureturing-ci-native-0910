using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Words.Complexity;

internal sealed class VivionBinomialConverseFailsDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "An explicit binary word answers Vivion's restricted converse question negatively: "
            + "its second binomial complexity equals factor complexity at every length, "
            + "its 1-binomial complexity is smaller at length two, and it is not 1-balanced.",
        H("A Counterexample Inside Vivion's Restricted Class"),
        Blocks(
            Paragraph(Text(
                "Section 7, Question 3 of Leo Vivion, New examples of words for which binomial "
                + "complexities and subword complexity coincide, arXiv:2509.11172v2, asks whether "
                + "a word with b_2 = p outside the class covered by Proposition 6 must still be "
                + "balanced. Proposition 6 says that a binary 1-balanced word has b_2 = p; "
                + "Question 3 asks about the converse restricted to words with b_1 < p. "
                + "Here b_k(n) denotes binomialComplexity(word,k,n), and p(n) is the cardinality "
                + "of the existing wordFactorSet(word,n).")),
            Paragraph(Text(
                "Immediately after Proposition 6, the paper itself notes that the plain converse "
                + "is false, using the eventually constant words 1^m 2^omega. The witness here "
                + "is also eventually constant; that is not the distinction. For those earlier "
                + "words, factors are determined by their letter counts, so b_1 = p. In particular, "
                + "their length-two factors 11, 12, 22, when present, have pairwise distinct "
                + "letter counts. Question 3 excludes them. Our witness has b_1(2) = 2 < 3 = p(2) "
                + "and therefore lies inside the restricted class. The failure of the plain "
                + "converse is the paper's own observation, not a new claim here.")),
            Paragraph(Text(
                "The general definitions use a finite alphabet A with decidable equality. "
                + "wordFactor, wordFactorSet, and mem_wordFactorSet are the existing upstream "
                + "notions from D5/S1/Words/Complexity/MorseHedlund; none is redefined here. "
                + "Factors have natural starting indices and are functions from Fin n to A.")),
            Describe.Lean(
                DescribeId.Create("scattered-subword-count"),
                DeclarationHandle.Create(
                    "D5/S1/Words/Complexity/VivionBinomialConverseFails.scatteredCount"),
                H("Scattered-subword counts"),
                StatementSource.FromAuthor(Disp(Seq(
                    F.Id("scatteredCount"), Colon, Sp,
                    new Formula.TypeArrow(Call("List", F.Id("A")),
                        new Formula.TypeArrow(Call("List", F.Id("A")), F.Id("Nat")))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "scatteredCount(pattern,source) counts strictly increasing selections of "
                    + "positions in the source spelling the pattern. Positions need not be "
                    + "consecutive: this is the scattered-subword, or binomial, coefficient. "
                    + "The empty pattern has count one; a nonempty pattern in an empty source "
                    + "has count zero. For two nonempty lists, discard the leading source position, "
                    + "and also count selections using it exactly when the two leading letters agree."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("binomial-count-profile"),
                DeclarationHandle.Create(
                    "D5/S1/Words/Complexity/VivionBinomialConverseFails.binomialProfile"),
                H("All pattern counts through length k"),
                StatementSource.FromAuthor(Disp(Seq(
                    Call("binomialProfile", F.Id("k"), F.Id("factor"), F.Id("length"),
                        F.Id("pattern")), Sp, Eq, Sp,
                    Call("scatteredCount", Call("ofFn", F.Id("pattern")),
                        Call("ofFn", F.Id("factor")))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For an implicit natural n and factor : Fin n -> A, binomialProfile k factor "
                    + "has dependent type (length : Fin (k+1)) -> (Fin length.val -> A) -> Nat. "
                    + "The displayed equation holds for every such length and pattern. It includes "
                    + "every pattern length from zero through k, including the empty pattern. "
                    + "ofFn denotes List.ofFn."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("binomial-equivalence"),
                DeclarationHandle.Create(
                    "D5/S1/Words/Complexity/VivionBinomialConverseFails.BinomialEquivalent"),
                H("k-binomial equivalence is equality of profiles"),
                StatementSource.FromAuthor(Disp(Seq(
                    Call("BinomialEquivalent", F.Id("k"), F.Id("left"), F.Id("right")),
                    Sp, Iff, Sp, Open,
                    Call("binomialProfile", F.Id("k"), F.Id("left")), Sp, Eq, Sp,
                    Call("binomialProfile", F.Id("k"), F.Id("right")), Close))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For k : Nat and left,right : Fin n -> A with the same implicit length n, "
                    + "BinomialEquivalent is the proposition that the two dependent count "
                    + "profiles are equal. Thus all scattered-subword counts through k agree."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("binomial-factor-complexity"),
                DeclarationHandle.Create(
                    "D5/S1/Words/Complexity/VivionBinomialConverseFails.binomialComplexity"),
                H("Count the distinct profiles of occurring factors"),
                StatementSource.FromAuthor(Disp(Seq(
                    Call("binomialComplexity", F.Id("word"), F.Id("k"), F.Id("n")), Sp, Eq, Sp,
                    Open, Open, F.Id("wordFactorSet"), Sp, F.Id("word"), Sp, F.Id("n"), Close,
                    Dot, F.Id("image"), Sp, Open, F.Id("binomialProfile"), Sp, F.Id("k"), Close,
                    Close, Dot, F.Id("card")))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This noncomputable natural-valued definition takes word : Nat -> A and "
                    + "k,n : Nat. It forms the image of the upstream finite factor set under "
                    + "binomialProfile k and takes its cardinality: the number of k-binomial "
                    + "equivalence classes of length-n factors."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("additive-letter-balance"),
                DeclarationHandle.Create(
                    "D5/S1/Words/Complexity/VivionBinomialConverseFails.Balanced"),
                H("Balance compares equally long factors"),
                StatementSource.FromAuthor(Disp(Seq(
                    Call("Balanced", F.Id("word"), F.Id("c")), Sp, Iff, Sp, Open,
                    Forall, Sp, F.Id("n"), Comma, F.Id("i"), Comma, F.Id("j"), Comma,
                    F.Id("letter"), Comma, Sp,
                    Call("scatteredCount", Seq(OpenBracket, F.Id("letter"), CloseBracket),
                        Call("ofFn", Call("wordFactor", F.Id("word"), F.Id("n"), F.Id("i")))),
                    Sp, Leq, Sp,
                    Call("scatteredCount", Seq(OpenBracket, F.Id("letter"), CloseBracket),
                        Call("ofFn", Call("wordFactor", F.Id("word"), F.Id("n"), F.Id("j")))),
                    Sp, Plus, Sp, F.Id("c"), Close))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For word : Nat -> A and c : Nat, quantify over all n,i,j : Nat and "
                    + "letter : A. Both factors have the same length n. Since both orders of "
                    + "i and j occur, their letter counts differ by at most c. The additive "
                    + "bound avoids truncated natural subtraction. Balanced word 1 is 1-balance."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("two-zero-binary-witness"),
                DeclarationHandle.Create(
                    "D5/S1/Words/Complexity/VivionBinomialConverseFails.witness"),
                H("The binary word 010111..."),
                StatementSource.FromAuthor(Disp(Seq(
                    F.Id("witness"), Colon, Sp,
                    new Formula.TypeArrow(F.Id("Nat"), F.Id("Bool"))))),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Exactly, witness(index) is false if index = 0 or index = 2, and true "
                    + "otherwise. With false written 0 and true written 1, this is 010111...: "
                    + "precisely two zero positions and an all-one tail starting at index 3."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("vivion-restricted-converse-fails"),
                DeclarationHandle.Create(
                    "D5/S1/Words/Complexity/VivionBinomialConverseFails.restricted_converse_fails"),
                H("The restricted converse fails"),
                StatementSource.FromAuthor(Disp(Seq(
                    Open, Forall, Sp, F.Id("n"), Sp, Colon, Sp, F.Id("Nat"), Comma, Sp,
                    F.Id("binomialComplexity"), Sp, F.Id("witness"), Sp, D(2), Sp, F.Id("n"),
                    Sp, Eq, Sp, Open, F.Id("wordFactorSet"), Sp, F.Id("witness"), Sp,
                    F.Id("n"), Close, Dot, F.Id("card"), Close, Sp, Land, Sp,
                    F.Id("binomialComplexity"), Sp, F.Id("witness"), Sp, D(1), Sp, D(2),
                    Sp, Lt, Sp, Open, F.Id("wordFactorSet"), Sp, F.Id("witness"), Sp, D(2),
                    Close, Dot, F.Id("card"), Sp, Land, Sp,
                    Neg, Sp, F.Id("Balanced"), Sp, F.Id("witness"), Sp, D(1)))),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "There are no hypotheses. The universally quantified conjunct holds at every "
                        + "natural length, including zero, not just finitely many checked lengths. Every "
                        + "factor has a representative at one of starts 0, 1, 2, 3. For lengths "
                        + "at least three, the counts of patterns 0 and 10 separate these "
                        + "representatives and remain unchanged on appending ones. The shorter "
                        + "lengths are checked directly.")),
                    Paragraph(Text(
                        "At length two the factors are 01, 10, 11, with only two 1-binomial "
                        + "profiles, proving b_1(2) = 2 < 3 = p(2). The equally long factors "
                        + "010 and 111 at starts 0 and 3 have zero counts two and zero, "
                        + "contradicting 1-balance.")),
                    Paragraph(Text(
                        "Proposition 6 itself is neither formalized nor assumed. All three "
                        + "properties are proved directly from scattered-subword counts and "
                        + "the existing factor set. Only a witness inside Question 3's restricted "
                        + "class is established: no classification of such words is claimed, "
                        + "and nothing is claimed about larger k or non-binary alphabets. "
                        + "The private proof lemmas are not separate public nodes."))),
                DescribeRole.Theorem)),
        [
            DocumentEdge.Dependency.Create(
                GidRef.Create("D5/S1/Words/Complexity/MorseHedlund")),
        ]));

    private static Formula Call(string name, params Formula[] arguments)
    {
        var items = new List<Formula> { Operatorname, Grp(F.Id(name)), Open };
        for (var index = 0; index < arguments.Length; index++)
        {
            if (index > 0) items.AddRange([Comma, Sp]);
            items.Add(arguments[index]);
        }

        items.Add(Close);
        return Seq([.. items]);
    }
}
