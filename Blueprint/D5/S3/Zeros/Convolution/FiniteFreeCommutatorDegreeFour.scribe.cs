using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Convolution;

internal sealed class FiniteFreeCommutatorDegreeFourDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeFour.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The finite free commutator of any two centered monic real-rooted quartics has four real roots.",
        H("Finite Free Commutators in Degree Four"),
        Blocks(
            Paragraph(Text(
                "The operation is defined by Definition 2.9 and Notations 2.2, 3.7 and 5.1 of "
                + "Campbell, Morales and Perales, arXiv:2502.00254v2. Sym is additive convolution "
                + "with dilation by minus one. The commutator then uses two multiplicative "
                + "convolutions, the second with the source finite sum z(4). The coefficient "
                + "formula below is proved from those definitions. Conjecture 5.3 is treated "
                + "here only for centered monic quartics. No premise from Theorem 5.6 is assumed.")),
            Describe.Lean(
                DescribeId.Create("quartic-commutator-source-expansion"),
                DeclarationHandle.Create(Prefix + "centered_expansion"),
                H("Coefficient identity"), StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "This normalization companion holds for arbitrary real coefficients. Its "
                    + "consumer is centered_factorization. For p=X^4+uX^2+vX+w and "
                    + "q=X^4+UX^2+VX+W, the output is X^4-(16uU/15)X^2 "
                    + "+(u^2+12w)(U^2+12W)/60. For the input with coefficients "
                    + "u=-5, v=0, w=4, both definition and formula paths yield constant 5329/60 "
                    + "and quadratic coefficient -80/3."))), DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("centered-quartic-invariant-bounds"),
                DeclarationHandle.Create(Prefix + "centered_quartic_invariant_bounds"),
                H("Invariant bounds from real roots"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Writing the four real roots as a,b,c,d, their sum is zero. Three "
                    + "squared-sum identities imply u is nonpositive and the invariant "
                    + "u squared plus 12w lies between zero and four times u squared. "
                    + "Each identity is used: the first controls the root sum in the squared "
                    + "variable, the second its product, and the third its discriminant."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("centered-quartic-commutator-factorization"),
                DeclarationHandle.Create(Prefix + "centered_factorization"),
                H("Two nonnegative squared roots"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The two input factorizations are the only hypotheses. The invariant "
                    + "bounds give a nonnegative discriminant, including all zero cases. "
                    + "Mathlib's quadratic formula and Vieta theorem yield nonnegative "
                    + "s and t and the factorization into X squared minus s and X squared "
                    + "minus t. The named coefficient identity is used here."))), DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("centered-quartic-commutator-real-rooted"),
                DeclarationHandle.Create(Prefix + "centered_real_rooted"),
                H("Real-rootedness"), StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The four exhibited roots are sqrt(s), -sqrt(s), sqrt(t), -sqrt(t). "
                    + "RealRooted4 is an equality to a product indexed by Fin(4), so repeated "
                    + "and zero roots are retained. Translation invariance for arbitrary "
                    + "monic quartics and the all-degree conjecture are outside this module. "
                    + "The proof is a repository derivation; the bounded literature search "
                    + "does not certify worldwide priority."))), DescribeRole.Theorem))));
}
