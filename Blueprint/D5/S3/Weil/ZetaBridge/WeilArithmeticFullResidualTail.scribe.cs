using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilArithmeticFullResidualTailDocument : IScribeDocumentDefinition
{
    private const string Owner = "D5/S3/Weil/ZetaBridge/WeilArithmeticFullResidualTail.";
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Full arithmetic residual tail. Candidate proof scripts; compiler acceptance is not claimed.",
        H("Weil Arithmetic Full Residual Tail"),
        Blocks(
            Describe.Lean(
                DescribeId.Create("arithmetic-full-residual-arithmeticColumnTailBudget"),
                DeclarationHandle.Create(Owner + "arithmeticColumnTailBudget"),
                H("Entire exterior energy budget"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The explicit expression retains A0=sum v_n, B0=sum s_n*v_n, A1=sum n*v_n and B1=sum n*s_n*v_n. Its M^-1 and M^-3 contributions pay for the actual paired jet. The M^-5 contribution pays for its full omitted remainder. No moment is assumed zero."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("arithmetic-full-residual-arithmetic-column-full-tail"),
                DeclarationHandle.Create(Owner + "arithmetic_column_full_tail"),
                H("Square summability of the actual arithmetic column"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Reuse arithmetic_second_jet_pair_energy and arithmetic_coupling_second_jet_error. Compare the paired column with the retained jet plus its remainder. A telescoping reciprocal inequality and positive comparison sum every mode m=M+j+1 and -m. The actual prime-pole-Gamma symbol supplies its own envelope. No desired tail inequality, summability oracle, reality or parity of coefficients is an input."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("arithmetic-full-residual-arithmeticReadoutResidual"),
                DeclarationHandle.Create(Owner + "arithmeticReadoutResidual"),
                H("Specified Cauchy readout minus the arithmetic column"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("This coefficient is pref/(m^2-frequency^2)-couplingColumn. The physical prefactor and Fourier frequency remain explicit normalization data. It is a coefficient expression, not a redefinition of the Fourier transform or an assumed identification with the canonical operator."))),
                DescribeRole.Definition),
            Describe.Lean(
                DescribeId.Create("arithmetic-full-residual-arithmetic-full-residual-tail"),
                DeclarationHandle.Create(Owner + "arithmetic_full_residual_tail"),
                H("All omitted modes of the unweighted squared residual"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For norm(frequency)<=M/2, the reverse triangle inequality controls the Cauchy denominator. Combine its fourth-power tail with the previously proved full arithmetic column tail. The conclusion includes both signs, absolute square summability and an explicit residual budget. This differs from WeilArithmeticFourierDualTail, whose weighted pairing is not an unweighted residual norm. The numerical consumer separately matches its actual shifted operator, finite residual head and physical Fourier coefficients; those domain and Parseval identifications are stated analysis obligations."))),
                DescribeRole.Theorem))));
}
