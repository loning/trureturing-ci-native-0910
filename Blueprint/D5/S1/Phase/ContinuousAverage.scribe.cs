using static StrataLint.Scribe.DefinitionDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Phase;

internal sealed class ContinuousAverageDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Continuous observables of an irrational rotation have normalized Haar average at every phase.",
        H("Continuous Averages of Irrational Rotations"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("continuous-average-tendsto-haar"),
                DeclarationHandle.Create(
                    "D5/S1/Phase/ContinuousAverage.continuous_average_tendsto_haar"),
                H("Convergence for every continuous observable and every initial phase"),
                StatementSource.FromAuthor(AverageStatement()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Let alpha be irrational, rho any real initial phase, and f any continuous "
                        + "complex-valued function on the additive circle R/Z. Its averages along "
                        + "rho + i alpha converge to its integral against AddCircle.haarAddCircle, "
                        + "the Haar measure normalized to have total mass one.")),
                    Paragraph(Text(
                        "The averaging maps are complex linear and their norms are at most one, "
                        + "uniformly in the sample size and initial phase. The integral functional "
                        + "is also Lipschitz with constant one. Consequently the observables with "
                        + "the asserted limit form a closed complex subspace.")),
                    Paragraph(Text(
                        "The zero Fourier character has average one for positive sample size. "
                        + "For every nonzero character the imported CharacterAverage theorem gives "
                        + "limit zero, which equals its Haar integral. Thus the closed subspace "
                        + "contains the Fourier span. Mathlib's span_fourier_closure_eq_top "
                        + "then puts every continuous observable in that subspace.")),
                    Paragraph(Text(
                        "This is step 2 of issue 6057. No restriction is imposed on rho. Total "
                        + "division gives average zero at sample size zero, which does not affect "
                        + "the limit. The theorem is stated as convergence of continuous-observable "
                        + "averages; it does not construct a ProbabilityMeasure sequence or prove "
                        + "interval-indicator sampling limits or the remaining prerequisites of "
                        + "issue 6057.")),
                    Paragraph(Text(
                        "This is a classical consequence of character cancellation and Fourier "
                        + "density. Repository provenance records this formal derivation, not "
                        + "a claim of mathematical novelty. Searches of pinned Mathlib v4.33.0 "
                        + "and the Lean ecosystem found no usable exact theorem; the retrieved "
                        + "external WeylEquidistribution.lean candidate has unfinished proofs."))),
                DescribeRole.Theorem))));

    private static Formula AverageStatement() =>
        F.Disp(F.Seq(
            F.Lim, F.Underscore, F.Grp(F.Id("N"), F.To, F.Infty), F.Sp,
            new Formula.Fraction(
                F.Seq(F.Sum, F.Underscore,
                    F.Grp(F.D(0), F.Leq, F.Sp, F.Id("i"), F.Lt, F.Id("N")), F.Sp,
                    F.Id("f"), F.Open, F.OpenBracket, F.Rho, F.Plus,
                    F.Id("i"), F.Alpha, F.CloseBracket, F.Close),
                F.Id("N")),
            F.Eq, F.Int, F.Sp, F.Id("f"), F.Sp, F.Id("d"), F.Mu,
            F.Underscore, F.Grp(F.Id("Haar"))));
}
