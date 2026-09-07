using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Convolution;

internal sealed class RectangularHalfConvolutionDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Zeros/Convolution/RectangularHalfConvolution.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Assuming BB, rectangular convolution at alpha=-1/2 preserves nonnegative roots in every positive degree.",
        H("Rectangular Convolution at Alpha Minus One Half"),
        Blocks(
            Paragraph(Text(
                "This is the conditional formalization of arXiv:2502.00254v2 Corollary "
                    + "3.14, using the evenization identity in Proposition 3.12. BB is "
                    + "the explicit universal FiniteSymbolCriterion from FiniteAdditiveSymbol; "
                    + "that module records the upstream source and probe axiom readings. "
                    + "This does not prove BB at the current pin. The parameter is fixed "
                    + "at -1/2, while the degree is arbitrary. The weight is the PRODUCT "
                    + "prefactor from corrected Definition 3.10, not the erroneous ratio. "
                    + "The degree-two coefficient definitions are not used.")),
            Describe.Lean(
                DescribeId.Create("rectangular-definition"),
                DeclarationHandle.Create(Prefix + "rectangularBoxplus"),
                H("General Rectangular Coefficient Reconstruction"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Write F_m(k) for the product, over j=0,...,k-1, of "
                        + "(m-j)(m-1/2-j), with F_m(0)=1. The polynomial is reconstructed "
                        + "through degree m from signed elementary coefficients e_k. Its "
                        + "e_k is F_m(k) times the sum of e_i(p)e_(k-i)(q) divided by "
                        + "F_m(i)F_m(k-i), for i=0,...,k and 0<=k<=m."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("positive-weights"),
                DeclarationHandle.Create(Prefix + "weight_pos"),
                H("Positive Weights on the Definition Range"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For natural m,k with k<=m, F_m(k)>0. Thus every denominator "
                        + "used in the bounded convolution formula is nonzero."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("paired-falling-factors"),
                DeclarationHandle.Create(Prefix + "doubled_falling"),
                H("Pairing Descending Factors"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For all natural m,k, the descending factorial (2m)_(2k) equals "
                        + "4^k F_m(k). Induction pairs two successive factors at each step. "
                        + "The equality includes the zero products when k exceeds m."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("definition-consistency"),
                DeclarationHandle.Create(Prefix + "definition_consistency"),
                H("Exact Elementary Coefficients"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For arbitrary real p,q and k<=m, the reconstructed polynomial's "
                        + "signed coefficient e_k satisfies exactly the stated product-weight "
                        + "convolution formula. The leading coefficient is included at k=0."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("monic-degree"),
                DeclarationHandle.Create(Prefix + "monic_natDegree"),
                H("Monicity and Exact Degree"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For monic real p,q of exact degree m, rectangularBoxplus m p q "
                        + "is monic and has exact degree m. This is independent of BB "
                        + "and of any root assumptions."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("evenization-identity"),
                DeclarationHandle.Create(Prefix + "evenization_convolution"),
                H("Evenization Commutes with Convolution"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every natural m and all real p,q, expanding rectangularBoxplus "
                        + "m p q by two equals additiveConvolution (2m) of the two expanded "
                        + "inputs. Mathlib supplies the expansion coefficients. The odd "
                        + "terms vanish; paired descending factors and powers of four "
                        + "identify the even terms. This polynomial equality assumes no BB."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("conditional-nonnegative-roots"),
                DeclarationHandle.Create(Prefix + "preserves_nonnegative_roots"),
                H("Conditional Preservation for Every Positive Degree"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Assume the universal BB finite-symbol criterion and m>=1. Let p,q "
                        + "be monic real polynomials of exact degree m, each splitting "
                        + "over the reals and having every real root nonnegative. Then "
                        + "rectangularBoxplus m p q is monic, has exact degree m, splits "
                        + "over the reals, and has every real root nonnegative. The proof "
                        + "splits the expanded inputs, applies conditional additive "
                        + "preservation through the proved evenization identity, then "
                        + "descends using the geometry of real squares. All root "
                        + "multiplicities, including zero roots, are allowed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("uniqueness-from-coefficients"),
                DeclarationHandle.Create(Prefix + "eq_of_coefficients"),
                H("Uniqueness from the Bounded Formula"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Any real polynomial r of natural degree at most m satisfying the "
                        + "elementary-coefficient formula for all k<=m equals the constructed "
                        + "rectangularBoxplus. No monicity or splitting assumptions are needed."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("coefficient-specified-output"),
                DeclarationHandle.Create(Prefix + "preserves_of_coefficients"),
                H("The Coefficient-Specified Corollary"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Assume the universal BB criterion, m>=1, and monic real p,q,r "
                        + "of exact degree m. Assume that p,q split over the reals with "
                        + "every real root nonnegative, and that r satisfies the specified "
                        + "coefficient formula for every k<=m. Then r splits over the reals "
                        + "and every real root of r is nonnegative. This is the requested "
                        + "form for any output specified by its coefficients."))),
                DescribeRole.Theorem))));
}
