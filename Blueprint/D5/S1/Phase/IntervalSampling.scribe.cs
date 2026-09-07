using static StrataLint.Scribe.DefinitionDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Phase;

internal sealed class IntervalSamplingDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Every irrational rotation samples each half-open unit interval with its length as frequency.",
        H("Interval Sampling of Irrational Rotations"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("irrational-rotation-interval-sampling"),
                DeclarationHandle.Create(
                    "D5/S1/Phase/IntervalSampling.irrational_rotation_interval_sampling"),
                H("Sampling frequency for every initial phase"),
                StatementSource.FromAuthor(SamplingStatement()),
                AssessedProvenance.FromRepo(),
                Blocks(
                    Paragraph(Text(
                        "Let alpha be any irrational real number, rho any real initial phase, "
                        + "and 0 <= a <= b <= 1. Count the natural indices i < N for which "
                        + "a <= Int.fract(rho + i alpha) < b. The count divided by N tends "
                        + "to b - a. This includes a = b, a = 0, and b = 1.")),
                    Paragraph(Text(
                        "The proof imports continuous_average_tendsto_haar from ContinuousAverage. "
                        + "Normalized finite sums of Dirac measures at the orbit points are "
                        + "probability measures for positive sample sizes. Mathlib's integral "
                        + "criterion turns the imported continuous averages into weak convergence.")),
                    Paragraph(Text(
                        "The representatives in [0,1) identify the half-open interval with a "
                        + "measurable subset of the circle. Its Haar measure is b - a, and its "
                        + "frontier is contained in the two endpoint classes, each of measure zero. "
                        + "Mathlib's Portmanteau implication gives convergence of interval masses. "
                        + "Evaluating the finite Dirac sum produces exactly Finset.filter.card / N. "
                        + "Using N + 1 during the measure construction avoids a zero normalization; "
                        + "the natural-index shift lemma restores the stated sequence.")),
                    Paragraph(Text(
                        "proof_shape: bind-only. admission_basis: atom-required-bridge. "
                        + "The common uniform-sampling target of the two preregistered pzg-v170 "
                        + "atoms requires this prerequisite in issue 6057. The added typed edge "
                        + "connects rotation averages from steps 1 and 2 to integer sampling counts. "
                        + "The named consumers are atoms "
                        + "21b616460d1cbeb9eb537fc7690b238fac8686bf16105e677278cc0928d58d15 and "
                        + "6b3a506b859ed4693724adaecee87fdcface331a251b9b9e1fd300a50fc2250b; "
                        + "the dependency direction is atom sampling goals -> this theorem -> "
                        + "ContinuousAverage.")),
                    Paragraph(Text(
                        "This is a classical consequence of weak convergence and Portmanteau, "
                        + "implemented by binding existing Mathlib results to the imported average "
                        + "theorem. No escape witness or mathematical novelty is claimed. "
                        + "This proves the interval-sampling prerequisite of issue 6057; it does "
                        + "not prove the two-dimensional deficit distribution or its three "
                        + "golden-ratio frequencies, and does not assert atom absorption or freezing."))),
                DescribeRole.Theorem))));

    private static Formula SamplingStatement() =>
        F.Disp(F.Seq(
            F.Lim, F.Underscore, F.Grp(F.Id("N"), F.To, F.Infty), F.Sp,
            new Formula.Fraction(
                F.Seq(F.Operatorname, F.Grp(F.Id("card")), F.OpenBrace,
                    F.Id("i"), F.InMacro, F.Mathbb, F.Grp(F.Id("N")), F.Mid, F.Sp,
                    F.Id("i"), F.Lt, F.Id("N"), F.Comma, F.Sp,
                    F.Id("a"), F.Leq, F.Operatorname, F.Grp(F.Id("fract")),
                    F.Open, F.Rho, F.Plus, F.Id("i"), F.Alpha, F.Close,
                    F.Lt, F.Id("b"), F.CloseBrace),
                F.Id("N")),
            F.Eq, F.Id("b"), F.Minus, F.Id("a")));
}
