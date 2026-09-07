using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Zeros.Convolution;

internal sealed class FiniteAdditiveSymbolDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Zeros/Convolution/FiniteAdditiveSymbol.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The BB finite-symbol criterion, as an explicit hypothesis, implies additive preservation.",
        H("Conditional Finite Additive Preservation"),
        Blocks(
            Paragraph(Text(
                "Borcea-Branden is an explicit hypothesis. Upstream RealRooted at "
                    + "https://github.com/PerAlexandersson/RealRooted, commit "
                    + "acd0ec31118a155b083c8dd45af2015492ce0c10, proves "
                    + "RealRooted.BorceaBranden.finiteSymbolTheorem and "
                    + "RealRooted.BorceaBranden.finiteSymbol_preservesRealRootedUpTo "
                    + "without a BB hypothesis parameter. The cited probe "
                    + "r13-probe-0907/attempt-1/upstream-axioms.log reports the axiom "
                    + "closure [propext, Classical.choice, Quot.sound] for each. "
                    + "Its compatibility build failed at this repository's pin. The "
                    + "implementation seat read the upstream signatures; this work "
                    + "does not import or transplant that proof.")),
            Describe.Lean(
                DescribeId.Create("finite-symbol-criterion"),
                DeclarationHandle.Create(Prefix + "FiniteSymbolCriterion"),
                H("The Explicit BB Hypothesis"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every natural n and real linear polynomial map T, assume that "
                        + "nonvanishing of its finite algebraic symbol at all complex z,w "
                        + "with positive imaginary parts implies the following: for every "
                        + "real-split p of natural degree at most n, T(p) is zero or "
                        + "real-split. The symbol is the sum of choose(n,k) T(X^k)(z) "
                        + "w^(n-k), for k=0,...,n, expressed in R[x][y]. This hypothesis "
                        + "is universal over operators; it does not assume that the "
                        + "target convolution output is stable or real-split."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("symbol-is-translation"),
                DeclarationHandle.Create(Prefix + "finiteSymbol_eq_translation"),
                H("The Symbol Is Q(x+y)"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "If q has natural degree at most n, the symbol of convolutionOperator "
                        + "n q equals Mathlib's Taylor translation of q, namely q(x+y). "
                        + "The operator sends X^k to HasseDeriv(n-k,q)/choose(n,k) for "
                        + "k<=n. The identity follows from the Taylor coefficient theorem "
                        + "and bounded coefficient reconstruction, without BB."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("operator-is-additive-convolution"),
                DeclarationHandle.Create(Prefix + "operator_eq_additiveConvolution"),
                H("Agreement with the Existing Convolution"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For every real p and q with q of natural degree at most n, the "
                        + "constructed linear operator applied to p equals the existing "
                        + "additiveConvolution n p q. A coefficient calculation using "
                        + "binomial and descending-factorial identities proves this equality."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("conditional-additive-splitting"),
                DeclarationHandle.Create(Prefix + "additive_splits"),
                H("Conditional Preservation in Every Degree"),
                StatementSource.WithoutFormula(),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "Assuming FiniteSymbolCriterion, if p and q are monic real "
                        + "polynomials of exact degree n and both split over the reals, "
                        + "their additive convolution splits over the reals. Splitting "
                        + "of the nonzero q makes q(z+w) nonzero when z and w have "
                        + "positive imaginary parts. BB applies, and output monicity "
                        + "excludes zero. No output-stability hypothesis is supplied."))),
                DescribeRole.Theorem))));
}
