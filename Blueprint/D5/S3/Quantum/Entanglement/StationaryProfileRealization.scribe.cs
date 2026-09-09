using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Entanglement;

internal sealed class StationaryProfileRealizationDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create()
    {
        Formula i = F.Id("i");
        Formula I = F.Id("I");
        Formula A = F.Id("A");
        Formula a = F.Id("a");
        Formula h = F.Id("h");
        Formula x = F.Id("x");
        Formula b = F.Id("b");
        Formula tail = Call("TailBox", a);
        Formula occupation = Call("capacityOccupation", A, a);
        Formula time = Add(Call("val", h), Call("tailSum", x));
        Formula boundary = Call("Boundary", occupation, time);
        Formula counts = And(
            Eq(Call("count", Call("val", b), Call("none")), Call("val", h)),
            All("i", I, Eq(Call("count", Call("val", b), Call("some", i)),
                Call("val", Call("apply", x, i)))));
        Formula statement = All("I", Id("Type"),
            Imp(And(Call("Fintype", I), Call("DecidableEq", I)),
                All("A", N, All("a", Call("Function", I, N),
                    All("h", Call("Fin", Add(A, D(1))),
                        All("x", tail, Exists("b", boundary, counts)))))));

        return DocumentDefinition.Create(ScribeNode.Create(
            "Every bounded tail profile with a legal head is realized by an occupation boundary.",
            H("Stationary Profile Realization"),
            Blocks(
                Paragraph(Text(
                    "For finite I, capacities a, a head h in Fin(A+1), and a tail profile "
                    + "x in TailBox(a), the bounded occupation construction supplies a boundary "
                    + "at time h.val + tailSum(x). Its none and some coordinates recover h and x.")),
                Describe.Lean(DescribeId.Create("stationary-profile-realization"),
                    DeclarationHandle.Create(
                        "D5/S3/Quantum/Entanglement/StationaryProfileRealization.boundary_profile_realization"),
                    H("A bounded profile is realized by a boundary"),
                    StatementSource.FromAuthor(Disp(statement)),
                    AssessedProvenance.FromRepo(),
                    Blocks(Paragraph(Text(
                        "The proof transports the explicit profile (h,x) through the existing "
                        + "boundaryTimeSliceEquiv and reads back its coordinates. This is a "
                        + "typed realization interface for later support and block arguments; "
                        + "it does not assert a Gram rank or a stationary minimum.")))))));
    }

    private static Formula Id(string name) => F.Id(name);
    private static Formula N => Seq(Mathbb, Grp(Id("N")));
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Id(name), [.. args]);
    private static Formula All(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name), domain, body);
    private static Formula Exists(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.Exists, FormulaIdentifier.Create(name), domain, body);
    private static Formula Imp(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.Implies, y);
    private static Formula And(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.And, y);
    private static Formula Eq(Formula x, Formula y) => new Formula.Relation(x, FormulaRelationOperator.Equal, y);
    private static Formula Add(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Add, y);
}
