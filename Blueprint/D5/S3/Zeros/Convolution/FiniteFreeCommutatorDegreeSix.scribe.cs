using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Convolution;

internal sealed class FiniteFreeCommutatorDegreeSixDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Zeros/Convolution/FiniteFreeCommutatorDegreeSix.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The finite free commutator of any two monic real-rooted sextics has six real roots.",
        H("Finite Free Commutators in Degree Six"),
        Blocks(
            Paragraph(Text(
                "This is the degree-six case of Conjecture 5.3 in Campbell, Morales, and Perales, "
                + "Even Hypergeometric Polynomials and Finite Free Commutators, "
                + "arXiv:2502.00254v2, SIGMA 21 (2025), 108, DOI 10.3842/SIGMA.2025.108. "
                + "The operation is Sym(p) boxtimes_6 Sym(q) boxtimes_6 z(6). "
                + "Both inputs range over all products of six real linear factors. "
                + "No simplicity or nonzero-root hypothesis is imposed.")),
            Describe.Lean(
                DescribeId.Create("sextic-commutator-expansion"),
                DeclarationHandle.Create(Prefix + "centered_expansion"),
                H("Coefficients in the squared variable"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Write p=X^6+uX^4+vX^3+wX^2+tX+s and "
                    + "Cp=2s+2uw/15-v^2/20, with capital letters for q. "
                    + "Then Sym(p)=X^6+2uX^4+(2w+2u^2/5)X^2+Cp and "
                    + "z(6)=X^6-(270/7)X^4+(375/14)X^2-4/7. "
                    + "The commutator is X^6-aX^4+bX^2-c, where a=24uU/35, "
                    + "b=2(u^2+5w)(U^2+5W)/105, and c=4CpCq/7."))), DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("alternating-cubic-nonnegative-factorization"),
                DeclarationHandle.Create(Prefix + "cubic_nonnegative_factorization"),
                H("Three nonnegative cubic roots"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Suppose a,b,c and a^2b^2-4b^3-4a^3c-27c^2+18abc are nonnegative. "
                    + "The intermediate value theorem gives a nonnegative root x of "
                    + "Y^3-aY^2+bY-c. Put d=a^2+2ax-3x^2-4b and R=3x^2-2ax+b. "
                    + "The cubic discriminant equals dR^2. When R is nonzero this yields d>=0; "
                    + "when R=0 one has d=(a-3x)^2. The other roots are "
                    + "(a-x+sqrt(d))/2 and (a-x-sqrt(d))/2. Every negative argument makes "
                    + "the cubic strictly negative, so all three roots are nonnegative."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("centered-sextic-commutator-data"),
                DeclarationHandle.Create(Prefix + "centered_data"),
                H("Signs and discriminant"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For each centered input, the sextic envelope gives A=-u>=0, "
                    + "B=u^2+5w>=0, and Z=-Cp>=0. Thus a=24AA'/35, "
                    + "b=2BB'/105, and c=4ZZ'/7 are nonnegative. "
                    + "The sextic discriminant bound supplies the remaining cubic hypothesis. "
                    + "Each sign follows from the input envelope independently of the discriminant."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("centered-sextic-commutator-real-rooted"),
                DeclarationHandle.Create(Prefix + "centered_real_rooted"),
                H("Six real factors"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Substituting X^2 into the cubic factorization gives "
                    + "(X^2-x)(X^2-y)(X^2-z). Taking the real square roots gives "
                    + "sqrt(x),-sqrt(x),sqrt(y),-sqrt(y),sqrt(z),-sqrt(z), indexed by Fin(6). "
                    + "Coincident values and zero values retain their multiplicities."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sextic-symmetrization-translation"),
                DeclarationHandle.Create(Prefix + "symmetrize_translation"),
                H("Translation invariance"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every real h, Sym(p(X+h))=Sym(p). Writing "
                    + "p=X^6+aX^5+uX^4+vX^3+wX^2+tX+s gives the three even coefficients "
                    + "2u-5a^2/6, 2w-av+2u^2/5, and 2s-at/3+2uw/15-v^2/20. "
                    + "Substitution of the translated coefficients leaves all three unchanged."))),
                DescribeRole.Lemma),
            Describe.Lean(
                DescribeId.Create("sextic-commutator-real-rooted"),
                DeclarationHandle.Create(Prefix + "real_rooted"),
                H("Arbitrary monic sextics"), StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Translation by -a/6 removes the coefficient of X^5 and translates every "
                    + "real input root by a/6. Apply the centered result to both translated inputs. "
                    + "Their symmetrizations are unchanged, so their commutator equals the "
                    + "original commutator. The conclusion holds for all pairs of monic "
                    + "real-rooted sextics, including repeated roots and zero roots."))),
                DescribeRole.Theorem))));
}
