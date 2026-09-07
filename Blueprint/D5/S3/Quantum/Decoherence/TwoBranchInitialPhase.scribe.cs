using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Decoherence;

internal sealed class TwoBranchInitialPhaseDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "The equal two-branch process has a local phase with initial slope -3 kappa / 2.",
        H("Two-Branch Initial Phase"),
        Blocks(Describe.Lean(
            DescribeId.Create("two-branch-initial-local-phase"),
            DeclarationHandle.Create(
                "D5/S3/Quantum/Decoherence/TwoBranchInitialPhase.two_branch_initial_local_phase"),
            H("Initial value, derivative, and a common nonzero polar neighborhood"),
            StatementSource.FromAuthor(TheoremFormula()),
            AssessedProvenance.FromRepo(),
            Blocks(
                Paragraph(Text(
                    "For every real kappa, chi is the equal average of the complex exponentials "
                    + "at frequencies kappa and twice kappa. The phase theta is the imaginary "
                    + "part of the principal complex logarithm of chi.")),
                Paragraph(Text(
                    "The proof differentiates both explicit exponentials, divides their sum by "
                    + "two, applies the real-domain complex logarithm chain rule at chi(0) = 1, "
                    + "and takes the imaginary part. Continuity supplies a positive radius on "
                    + "which chi is nonzero. The polar identity uses the same radius.")),
                Paragraph(Text(
                    "The radius may depend on kappa. This result concerns the initial local "
                    + "phase only; it makes no global nonvanishing, global phase, record-channel "
                    + "identification, or whole-atom coverage claim."))),
            DescribeRole.Theorem))));

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.FunctionCall(FormulaIdentifier.Create(name), [.. arguments]);

    private static Formula Equal(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.Equal, right);

    private static Formula Multiply(Formula left, Formula right) =>
        new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);

    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);

    private static Formula TheoremFormula()
    {
        Formula real = Seq(Mathbb, Grp(F.Id("R")));
        Formula kappa = F.Id("kappa"), t = F.Id("t"), epsilon = F.Id("epsilon");
        Formula chi = F.Id("chi"), theta = F.Id("theta"), imaginaryUnit = F.Id("I");
        Formula first = Call("exp", Multiply(Multiply(Seq(Minus, imaginaryUnit), kappa), t));
        Formula second = Call("exp",
            Multiply(Multiply(Multiply(Seq(Minus, imaginaryUnit), Num(2)), kappa), t));
        Formula average = Seq(Frac,
            Grp(new Formula.Binary(first, FormulaBinaryOperator.Add, second)), Grp(Num(2)));
        Formula definitions = Seq(
            Operatorname, Grp(F.Id("let")), Sp,
            chi, Colon, Sp, real, To, Seq(Mathbb, Grp(F.Id("C"))), Comma, Sp,
            Equal(Call("chi", t), average), Semi, Sp,
            theta, Colon, Sp, real, To, real, Comma, Sp,
            Equal(Call("theta", t), Call("im", Call("log", Call("chi", t)))), Semi, Sp);
        Formula slope = Multiply(Seq(Minus, Frac, Grp(Num(3)), Grp(Num(2))), kappa);
        Formula polar = Equal(Call("chi", t), Multiply(
            Call("ofReal", Seq(Vert, Call("chi", t), Vert)),
            Call("exp", Multiply(imaginaryUnit, Call("theta", t)))));
        Formula local = new Formula.Bind(FormulaQuantifier.Exists,
            FormulaIdentifier.Create("epsilon"), real,
            And(new Formula.Relation(epsilon, FormulaRelationOperator.GreaterThan, Num(0)),
                new Formula.Bind(FormulaQuantifier.ForAll,
                    FormulaIdentifier.Create("t"), real,
                    new Formula.Logic(
                        new Formula.Relation(new Formula.Absolute(t),
                            FormulaRelationOperator.LessThan, epsilon),
                        FormulaLogicOperator.Implies,
                        And(new Formula.Relation(Call("chi", t),
                            FormulaRelationOperator.NotEqual, Num(0)), polar)))));
        Formula result = And(Equal(Call("theta", Num(0)), Num(0)),
            And(Call("HasDerivAt", theta, slope, Num(0)), local));
        return Disp(new Formula.Bind(FormulaQuantifier.ForAll,
            FormulaIdentifier.Create("kappa"), real, Seq(definitions, result)));
    }
}
