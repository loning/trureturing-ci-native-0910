using static StrataLint.Scribe.DefinitionDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Weil.ZetaBridge;

internal sealed class WeilBoundarySymbolEnclosureDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Finite arithmetic-symbol evaluation is connected to the original infinite symbol by explicit, accelerated tail bounds.",
        H("Finite Arithmetic Symbol Enclosures"),
        Blocks(
            Describe.Lean(DescribeId.Create("finite-expression"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.boundarySymbolPartial"), H("Finite expression with K+1 Gamma terms"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Retains the original pole and every finite prime term, plus Gamma indices zero through K inclusive. It is an analytic finite expression; its elementary-function evaluation still requires enclosures."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("uncorrected-tail"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.boundary_symbol_partial_error"), H("Complete uncorrected Gamma remainder"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Reuses absolute convergence of the original arithmetic symbol, splits the actual infinite sum, and bounds all omitted terms by the absolute frequency divided by 4*K+1. No finite terminal tail is substituted."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("plain-enclosure"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.boundary_symbol_enclosure_of_partial"), H("Finite evaluation plus actual infinite tail"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Combines a certified finite-expression error and a frequency upper bound. It does not accept an assumed full-symbol enclosure."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("accelerated-expression"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.boundarySymbolAccelerated"), H("Exactly summed rational tail correction"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Subtracts omega/(4*K+3) from the finite expression. This is the exact infinite sum of omega/((2*j+1/2)^2-1) for j>K. The target arithmetic symbol is unchanged."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("accelerated-tail"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.boundary_symbol_accelerated_error"), H("Cubic and rational-exponential remainder"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Derives the complete error bound 4*abs(omega)*(omega squared+1)/(3*(4*K+3)^3) plus abs(omega)/(c^(2*K+2)*(4*K+1)). A positive rational telescoping remainder controls the kernel difference; the damped term is bounded using the actual log(c). This is evaluator convergence at fixed physical parameters, not a spectral-scale theorem."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("rational-radii"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.rationalSymbolRadii"), H("Computed rational enclosure radii"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Uses the finite-evaluation radii, frequency upper bounds, physical integer cutoff and Gamma truncation counts. The correction radius uses exact rational powers and arithmetic. This definition evaluates no transcendental function."))), DescribeRole.Definition),
            Describe.Lean(DescribeId.Create("radius-soundness"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.rational_symbol_radii_sound"), H("Soundness for the actual arithmetic symbol"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The certified accelerated finite evaluations and frequency bounds imply every actual infinite symbol lies in the computed complex ball. No interval software or external success flag supplies the analytic premises."))), DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("repaired-consumer"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundarySymbolEnclosure.repaired_trial_from_finite_symbols"), H("Finite symbols to the same repaired residual"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Consumes the exact rational repaired trial and generated symbol radii through the existing moment and full-tail checker. The same output has finite support, exact candidate orthogonality and a complete two-sided residual bound. Canonical operator realization, interior residuals, global coercivity and the physical scale rate remain separate."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticCouplingJet")),
         DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilRepairedTrialCertificate"))]));
}
