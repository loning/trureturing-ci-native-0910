using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Convolution;

internal sealed class GribinskiDegreeTwoDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Zeros/Convolution/GribinskiDegreeTwo.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The degree-two generalized rectangular convolution preserves nonnegative real "
            + "roots exactly for alpha greater than minus one on its definition domain.",
        H("Gribinski Convolution in Degree Two"),
        Blocks(
            Paragraph(Text(
                "The target is Conjecture 3.13 of Even Hypergeometric Polynomials and Finite "
                    + "Free Commutators, arXiv:2502.00254v2, at m=2. Definition 3.10 has "
                    + "the product of the two falling factorials as prefactor. The source "
                    + "paper also proves the special parameter alpha=-1/2. The present "
                    + "formalization covers every real alpha>-1 at degree two; no claim "
                    + "about larger degrees or worldwide priority is made.")),
            Describe.Lean(
                DescribeId.Create("coefficient-convolution"),
                DeclarationHandle.Create(Prefix + "boxplus"),
                H("Definition from General Coefficients"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The signed degree-two coefficients are divided by the product of "
                        + "Mathlib's two descending Pochhammer values. Their finite convolution "
                        + "is multiplied by the same weight, and the three coefficients "
                        + "are reconstructed into a polynomial. This definition precedes "
                        + "the specialization to real input roots."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("definition-consistency"),
                DeclarationHandle.Create(Prefix + "normalized_coefficient_convolution"),
                H("Agreement with Definition 3.10"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For alpha different from -1 and -2, each normalized output coefficient "
                        + "at k=0,1,2 is the sum of products of normalized input coefficients "
                        + "over i+j=k. Both prefactors are nonzero on precisely this domain."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("explicit-coefficients"),
                DeclarationHandle.Create(Prefix + "g1_explicit_coefficients"),
                H("G1: Explicit Coefficients"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For input roots a,b and c,d, the output is X^2-(a+b+c+d)X "
                        + "+ab+cd+kappa*(a+b)*(c+d), where kappa=(alpha+1)/(2*(alpha+2)). "
                        + "The identity holds for arbitrary real input roots."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("discriminant-bound"),
                DeclarationHandle.Create(Prefix + "g2_discriminant_bound"),
                H("G2: Discriminant Bound and Equality"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Writing P=a+b and Q=c+d, the discriminant is at least "
                        + "2*P*Q*(1-2*kappa). The difference is (a-b)^2+(c-d)^2. "
                        + "Equality holds when a=b and c=d. This algebraic bound even "
                        + "holds without assuming nonnegative input roots."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("nonnegative-roots"),
                DeclarationHandle.Create(Prefix + "g3_nonnegative_roots"),
                H("G3: Preservation for Every Real Alpha Greater Than -1"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For nonnegative input roots and alpha>-1, kappa lies strictly between "
                        + "zero and one half. The sum, product and discriminant have the "
                        + "required signs. Mathlib's quadratic root existence theorem "
                        + "gives a real root; its complementary root and Vieta's identities "
                        + "give the required factorization with both roots nonnegative."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("negative-product"),
                DeclarationHandle.Create(Prefix + "g4_negative_product"),
                H("G4: The Interval Between -2 and -1"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The explicit inputs (a,b,c,d)=(1,0,1,0) have output constant "
                        + "coefficient kappa<0. Hence no two nonnegative roots can factor it."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("negative-discriminant"),
                DeclarationHandle.Create(Prefix + "g4_negative_discriminant"),
                H("G4: Alpha Below -2"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "The explicit inputs (a,b,c,d)=(1,1,1,1) have discriminant "
                        + "8*(1-2*kappa)=8/(alpha+2)<0. Mathlib's nonsquare-discriminant "
                        + "theorem proves that the polynomial has no real root at all."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("sharp-parameter-range"),
                DeclarationHandle.Create(Prefix + "preservation_iff"),
                H("The Exact Parameter Range"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "On the domain alpha different from -1 and -2, preservation for every "
                        + "nonnegative input-root quadruple is equivalent to alpha>-1. "
                        + "The two explicit counterexample families cover the whole "
                        + "remaining domain."))),
                DescribeRole.Theorem))));
}
