using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Convolution;

internal sealed class FiniteConvolutionCoefficientsDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Zeros/Convolution/FiniteConvolutionCoefficients.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Coefficient and degree companions for the existing arbitrary-degree additive convolution.",
        H("Finite Convolution Coefficients"),
        Blocks(
            Paragraph(Text(
                "The elementaryCoeff and additiveConvolution definitions are reused from "
                    + "FiniteFreeCommutatorDegreeFour, whose definitions accept arbitrary n. "
                    + "The results here supply the finite-symbol operator identity and the "
                    + "rectangular evenization identity. They do not use the degree-four "
                    + "preservation endpoint.")),
            Describe.Lean(
                DescribeId.Create("reverse-sum-coefficient"),
                DeclarationHandle.Create(Prefix + "coeff_reverse_sum"),
                H("Bounded Coefficient Reconstruction"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Over any commutative ring, the coefficient of X^(n-k) in the sum "
                        + "of a(i) X^(n-i), for i from zero through n, is a(k) when k<=n. "
                        + "The bound prevents ambiguity from truncated natural subtraction."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("reverse-sum-above"),
                DeclarationHandle.Create(Prefix + "coeff_reverse_sum_above"),
                H("Coefficients Above the Bound Vanish"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Over any commutative ring, every coefficient above n in this "
                        + "descending reconstruction is zero. This supplies both degree bounds."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("signed-coefficient-product"),
                DeclarationHandle.Create(Prefix + "signed_coefficient_product"),
                H("Cancellation of the Three Signs"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For i<=k and real a,b, multiplying the signed input product "
                        + "((-1)^i a)((-1)^(k-i) b) by (-1)^k gives ab."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("additive-coefficient"),
                DeclarationHandle.Create(Prefix + "coeff_additiveConvolution"),
                H("Unsigned Additive Coefficient Formula"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For any real p,q and k<=n, coefficient n-k of their additive "
                        + "convolution equals (n)_k times the sum over i=0,...,k of "
                        + "p[n-i] q[n-(k-i)] divided by (n)_i (n)_(k-i). Here (n)_j "
                        + "is the descending factorial. No monicity assumption is needed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("additive-degree-bound"),
                DeclarationHandle.Create(Prefix + "additive_natDegree_le"),
                H("Additive Degree Bound"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The reconstructed additive convolution of any two real polynomials "
                        + "has natural degree at most its parameter n."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("additive-monic-degree"),
                DeclarationHandle.Create(Prefix + "additive_monic_natDegree"),
                H("Monicity and Exact Additive Degree"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "If p and q are monic real polynomials of exact degree n, their "
                        + "additive convolution is monic and has exact degree n. Its "
                        + "nonzeroness eliminates the zero-output alternative in BB."))),
                DescribeRole.Theorem))));
}
