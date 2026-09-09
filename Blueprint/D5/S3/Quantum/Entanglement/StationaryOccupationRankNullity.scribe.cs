using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Entanglement;

internal sealed class StationaryOccupationRankNullityDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create()
    {
        Formula i = Id("i");
        Formula I = Id("I");
        Formula K = Id("K");
        Formula G = Id("G");
        Formula C = Id("C");
        Formula q = Id("q");
        Formula a = Id("a");

        Formula finiteTypes = And(Call("Fintype", I), Call("Fintype", K));
        Formula matrix = Call("Matrix", I, K, Complex());
        Formula kernelFinrank = Call("finrank", Complex(), Call("ker", Call("mulVecLin", G)));
        Formula rankNullity = All("I", Id("Type"),
            All("K", Id("Type"),
                Imp(finiteTypes,
                    All("G", matrix,
                        Eq(Add(Call("rank", G), kernelFinrank), Call("FintypeCard", K))))));
        Formula rankLower = All("I", Id("Type"),
            All("K", Id("Type"),
                Imp(finiteTypes,
                    All("G", matrix,
                        All("q", N,
                            Imp(Le(kernelFinrank, q),
                                Le(Sub(Call("FintypeCard", K), q), Call("rank", G))))))));
        Formula profileMatrix = Call("Matrix", Call("Profile", a), Call("Profile", a), Complex());
        Formula profileLower = All("I", Id("Type"),
            Imp(And(Call("Fintype", I), Call("DecidableEq", I)),
                All("a", Call("Function", I, N),
                    All("G", profileMatrix,
                        All("q", N,
                            Imp(Le(Call("finrank", Complex(), Call("ker", Call("mulVecLin", G))), q),
                                Le(Sub(ProdAt("i", I, Add(Call("a", i), D(1))), q),
                                    Call("rank", G))))))));
        Formula factorUpper = All("I", Id("Type"),
            All("K", Id("Type"),
                Imp(And(Call("Fintype", I), Call("Fintype", K)),
                    All("C", Call("Matrix", K, I, Complex()),
                        Le(Call("rank", Call("mul", Call("conjTranspose", C), C)),
                                        Call("FintypeCard", K))))));
        Formula factorHermitian = All("I", Id("Type"),
            All("K", Id("Type"),
                Imp(And(Call("Fintype", I), Call("Fintype", K)),
                    All("C", Call("Matrix", K, I, Complex()),
                        Call("IsHermitian", Call("mul", Call("conjTranspose", C), C))))));
        Formula factorPsd = All("I", Id("Type"),
            All("K", Id("Type"),
                Imp(And(Call("Fintype", I), Call("Fintype", K)),
                    All("C", Call("Matrix", K, I, Complex()),
                        Call("PosSemidef", Call("mul", Call("conjTranspose", C), C))))));
        Formula factorKernel = All("I", Id("Type"),
            All("K", Id("Type"),
                Imp(And(Call("Fintype", I), Call("Fintype", K)),
                    All("C", Call("Matrix", K, I, Complex()),
                        Eq(Call("ker", Call("mulVecLin", Call("mul", Call("conjTranspose", C), C))),
                            Call("ker", Call("mulVecLin", C)))))));
        Formula memoryLower = All("I", Id("Type"),
            All("K", Id("Type"),
                Imp(And(Call("Fintype", I), And(Call("DecidableEq", I), Call("Fintype", K))),
                    All("a", Call("Function", I, N),
                        All("C", Call("Matrix", K, Call("Profile", a), Complex()),
                            All("q", N,
                                Imp(Le(Call("finrank", Complex(),
                                        Call("ker", Call("mulVecLin", Call("mul",
                                            Call("conjTranspose", C), C)))), q),
                                    Le(Sub(ProdAt("i", I, Add(Call("a", i), D(1))), q),
                                        Call("FintypeCard", K)))))))));

        return DocumentDefinition.Create(ScribeNode.Create(
            "Finite Gram matrices convert kernel bounds into rank lower bounds.",
            H("Stationary Occupation Rank Nullity"),
            Blocks(
                Paragraph(Text(
                    "For finite row and column types, rank-nullity turns a bound on the "
                    + "kernel dimension into a lower bound on rank. The profile-specific "
                    + "form uses the finite carrier Profile(a).")),
                Theorem("gram-rank-add-nullity", "gram_rank_add_nullity", rankNullity,
                    "This finite-dimensional identity uses no Gram positivity or realization."),
                Theorem("gram-rank-ge-card-sub-nullity", "gram_rank_ge_card_sub_nullity", rankLower,
                    "The model-specific input is an explicit upper bound on kernel finrank."),
                Theorem("bounded-profile-rank-ge", "bounded_profile_rank_ge", profileLower,
                    "The profile cardinality theorem supplies the product term; no stationary-minimum claim is included."),
                Theorem("gram-factor-rank-le-memory-card", "gram_factor_rank_le_memory_card", factorUpper,
                    "A Gram factor through a finite memory carrier has rank at most that carrier's cardinality."),
                Theorem("gram-factor-is-hermitian", "gram_factor_is_hermitian", factorHermitian,
                    "A complex Gram factor is Hermitian; positivity of the physical stationary factor remains a separate obligation."),
                Theorem("gram-factor-pos-semidef", "gram_factor_pos_semidef", factorPsd,
                    "With the ComplexOrder scope, a finite complex Gram factor is positive semidefinite."),
                Theorem("gram-factor-kernel-eq", "gram_factor_kernel_eq", factorKernel,
                    "The Gram factor and its coefficient matrix have the same linear kernel, so kernel estimates transport exactly."),
                Theorem("bounded-profile-memory-ge", "bounded_profile_memory_ge", memoryLower,
                    "Combining the profile lower bound with the factor upper bound yields a conditional memory lower bound."))));
    }

    private static DocumentBlock Theorem(string id, string name, Formula formula, string text) =>
        Describe.Lean(DescribeId.Create(id), DeclarationHandle.Create(
            "D5/S3/Quantum/Entanglement/StationaryOccupationRankNullity." + name), H(name),
            StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(text))));

    private static Formula Id(string name) => F.Id(name);
    private static Formula N => Seq(Mathbb, Grp(Id("N")));
    private static Formula Complex() => Seq(Mathbb, Grp(Id("C")));
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Id(name), [.. args]);
    private static Formula All(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name), domain, body);
    private static Formula Imp(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.Implies, y);
    private static Formula And(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.And, y);
    private static Formula Eq(Formula x, Formula y) => new Formula.Relation(x, FormulaRelationOperator.Equal, y);
    private static Formula Le(Formula x, Formula y) => new Formula.Relation(x, FormulaRelationOperator.LessThanOrEqual, y);
    private static Formula Add(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Add, y);
    private static Formula Sub(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Subtract, y);
    private static Formula ProdAt(string name, Formula domain, Formula body) =>
        Seq(new Formula.Subscript(Prod, Seq(Id(name), Colon, domain)), Grp(body));
}
