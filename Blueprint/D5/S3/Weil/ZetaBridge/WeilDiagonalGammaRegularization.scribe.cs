            Describe.Lean(DescribeId.Create("diagonal_gamma_endpoint_error"),
                DeclarationHandle.Create("D5/S3/Weil/ZetaBridge/WeilDiagonalGammaRegularization.diagonal_gamma_endpoint_error"),
                H("Certified endpoint-strip budget"), StatementSource.FromLean(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("For any delta in [0,L], the absolute integral over (0,delta] is bounded by delta times the explicit regularized majorant. This enables a justified finite evaluator to retain the singular endpoint contribution. It supplies neither an interior evaluator nor a new actual prolate error certificate."))), DescribeRole.Theorem)),
        [DocumentEdge.Dependency.Create(GidRef.Create("D5/S3/Weil/ZetaBridge/WeilWindowFourierConvolution"))]));
}
