            Describe.Lean(DescribeId.Create("coupling-column-kernel-integral"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral.coupling_column_kernel_integral"),
                H("The existing exterior column has the integral representation"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For m outside the trial support, substitute the identified symbol into the original couplingColumn, use justified integral subtraction and constant division, and retain both the finite prime sum and the complex trial coefficients. This is a companion adapter of the analytic identity. The diagonal Fourier matrix elements, actual convolution of zero-extended basis functions and canonical operator-domain realization still require separate proofs; this theorem does not assert them or a new spectral error bound."))),
                DescribeRole.Theorem),
            Describe.Lean(DescribeId.Create("gamma-exponential-kernel-hasSum"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilBoundaryKernelIntegral.gamma_exponential_kernel_hasSum"),
                H("Reuse the original exponential kernel series"),
                StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Exposes the already-proved geometric kernel identity as a companion for the diagonal series consumer. The existing private proof is reused without alteration. No new independent geometric-series theorem or novelty claim is made."))),
                DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilArithmeticCouplingJet"))]));
}
