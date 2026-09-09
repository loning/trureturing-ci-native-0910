using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Entanglement;

internal sealed class BoundedProfileCardinalityDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Finite bounded occupation profiles have a product cardinality.",
        H("Bounded Profile Cardinality"),
        Blocks(
            Paragraph(Text(
                "Let I be a finite index type and let a assign a natural capacity to each index. "
                + "A bounded profile chooses, at every index i, a value in Fin(a(i)+1), so its "
                + "coordinates range from zero through a(i).")),
            Theorem("bounded-profile-cardinality", "card_bounded_profiles",
                "The number of bounded profiles is the product of the coordinate cardinalities.",
                All("I", Id("Type"),
                    Imp(And(Call("Fintype", Id("I")), Call("DecidableEq", Id("I"))),
                        All("a", Call("Function", Id("I"), N),
                            Eq(Call("FintypeCard", Call("Profile", Id("a"))),
                                ProdAt("i", Id("I"), Add(Call("a", Id("i")), D(1))))))),
                "The dependent finite product cardinality is the product of the cardinalities "
                + "of the coordinate types. Each coordinate type Fin(a(i)+1) has cardinality "
                + "a(i)+1."))));

    private static DocumentBlock Theorem(string id, string name, string title, Formula formula, string text,
        DescribeRole role = DescribeRole.Theorem) =>
        Describe.Lean(DescribeId.Create(id), DeclarationHandle.Create(
            "D5/S3/Quantum/Entanglement/BoundedProfileCardinality." + name), H(title),
            StatementSource.FromAuthor(Disp(formula)),
            AssessedProvenance.FromLiterature(LibraryNoteRef.Create("D5/L/Quantum/raveh2024dicke")),
            Blocks(Paragraph(Text(text))), role);

    private static Formula Id(string name) => F.Id(name);
    private static Formula N => Seq(Mathbb, Grp(Id("N")));
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Id(name), [.. args]);
    private static Formula All(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name), domain, body);
    private static Formula Imp(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.Implies, y);
    private static Formula And(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.And, y);
    private static Formula Eq(Formula x, Formula y) => new Formula.Relation(x, FormulaRelationOperator.Equal, y);
    private static Formula Add(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Add, y);
    private static Formula ProdAt(string name, Formula domain, Formula body) =>
        Seq(new Formula.Subscript(Prod, Seq(Id(name), Colon, domain)), Grp(body));
}
