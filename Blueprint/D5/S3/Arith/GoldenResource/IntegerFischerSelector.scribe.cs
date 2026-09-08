using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Arith.GoldenResource;

internal sealed class IntegerFischerSelectorDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S3/Arith/GoldenResource/IntegerFischerSelector.";
    private static readonly LibraryNoteRef FischerSource =
        LibraryNoteRef.Create("D5/L/Arith/hornjohnson2012matrixanalysis");

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Fischer's determinant inequality gives a positive logarithmic loss independent of matrix dimension.",
        H("Integer Fischer Selector"),
        Blocks(
            Paragraph(Text("All index types are finite. Positive definiteness includes symmetry. "
                + "For an integer matrix T, let R(T) denote its entrywise inclusion into the real "
                + "matrices, let card(n) denote the number of indices, and let tr denote the trace. "
                + "The selected integer k is at least two and the price p lies strictly between "
                + "log((k+1)/k) and log(k/(k-1)). Write delta(k, p) for the minimum of the two "
                + "endpoint margins log(k/(k-1))-p and p-log((k+1)/k) together with the "
                + "two-coordinate loss log(k squared)-log(k squared minus one). Empty products "
                + "equal one.")),
            Describe.Lean(
                DescribeId.Create("fischer-two-coordinate-block"),
                DeclarationHandle.Create(Prefix + "fischer_two_block"),
                H("A two-coordinate principal block"),
                StatementSource.FromAuthor(FischerFormula()),
                AssessedProvenance.FromLiterature(FischerSource),
                Blocks(Paragraph(Text("For distinct indices i and j, retain their two by two "
                    + "principal determinant and multiply by the other diagonal entries. "
                    + "This bounds the full determinant from above. An elementary shear has "
                    + "determinant one and changes only one diagonal entry under congruence. "
                    + "Hadamard's inequality applied after this shear gives the stated bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("integer-fischer-multiplicative-gap"),
                DeclarationHandle.Create(Prefix + "integer_fischer_gap"),
                H("A nonzero integer entry forces a loss"),
                StatementSource.FromAuthor(IntegerGapFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The square of a nonzero integer is at least one. "
                    + "Symmetry therefore lowers the two-coordinate determinant by at least one "
                    + "relative to its diagonal product. Multiplication by the positive "
                    + "diagonal entries yields the integer form of the bound."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("fischer-selector-gap-two-margins"),
                DeclarationHandle.Create(Prefix + "selectorGap_eq_min"),
                H("Only the endpoint margins determine the gap"),
                StatementSource.FromAuthor(GapMinimumFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The two endpoint margins add to log(k squared) "
                    + "minus log(k squared minus one), since (k-1)(k+1) equals k squared "
                    + "minus one. Both margins are positive on the price interval, so their "
                    + "minimum does not exceed their sum. Thus delta(k, p) equals the "
                    + "minimum of the two endpoint margins."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("fischer-selector-gap-positive"),
                DeclarationHandle.Create(Prefix + "selectorGap_pos"),
                H("A positive margin depending on k and p"),
                StatementSource.FromAuthor(GapPositiveFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("Each of the three terms is positive on the strict price "
                    + "interval: the first two because the interval endpoints are strict, the "
                    + "third because the logarithm is strictly increasing and k squared exceeds "
                    + "k squared minus one. The margin contains no matrix dimension."))),
                DescribeRole.Theorem),
            Describe.Lean(
                DescribeId.Create("integer-log-selector-uniform-gap"),
                DeclarationHandle.Create(Prefix + "integer_log_unique_maximum"),
                H("The scalar matrix is uniformly isolated"),
                StatementSource.FromAuthor(SelectorFormula()),
                AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text("The objective log(det(T))-p tr(T) is bounded above "
                    + "by the number of indices times log(k)-p k. Every matrix distinct from k times "
                    + "the identity loses at least the margin. If a diagonal entry "
                    + "differs from k, sum the scalar selector inequalities and retain that "
                    + "entry's loss. If every diagonal entry equals k, a nonzero off-diagonal "
                    + "entry gives the two-coordinate loss. Taking logarithms cancels "
                    + "the remaining diagonal product, so this loss is independent of dimension."))),
                DescribeRole.Theorem))));

    private static Formula FischerFormula()
    {
        Formula body = Implies(
            And(PosDefReal(), NotEqual(F.Id("i"), F.Id("j"))),
            Le(Det(),
                Mul(Group(Sub(Mul(Entry("i", "i"), Entry("j", "j")),
                        Mul(Entry("i", "j"), Entry("j", "i")))),
                    ComplementProduct())));
        return QuantifiedMatrix(Reals(), new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("i", F.Id("n")), Bound("j", F.Id("n"))], body));
    }

    private static Formula IntegerGapFormula()
    {
        Formula body = Implies(
            And(PosDefInteger(),
                And(NotEqual(F.Id("i"), F.Id("j")), NotEqual(Entry("i", "j"), D(0)))),
            Le(Mul(Det(), Group(Mul(Entry("i", "i"), Entry("j", "j")))),
                Mul(Group(Sub(Mul(Entry("i", "i"), Entry("j", "j")), D(1))),
                    FullProduct())));
        return QuantifiedMatrix(Integers(), new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("i", F.Id("n")), Bound("j", F.Id("n"))], body));
    }

    private static Formula GapPositiveFormula() =>
        Disp(new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("k", Naturals()), Bound("p", Reals())],
            Implies(PriceWindow(), Lt(D(0), MarginBody()))));

    private static Formula GapMinimumFormula() =>
        Disp(new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("k", Naturals()), Bound("p", Reals())],
            Implies(PriceWindow(),
                new Formula.Relation(Margin(), FormulaRelationOperator.Equal,
                    Call("min", Sub(RatioPrev(), F.Id("p")), Sub(F.Id("p"), RatioNext()))))));

    private static Formula SelectorFormula()
    {
        Formula optimum = Mul(Group(Call("card", F.Id("n"))),
            Group(Sub(Call("log", F.Id("k")), Mul(F.Id("p"), F.Id("k")))));
        Formula objective = Sub(Call("log", Det()), Mul(F.Id("p"), Call("tr", F.Id("T"))));
        Formula body = Implies(And(PriceWindow(), PosDefInteger()),
            And(Lt(D(0), Margin()),
                And(Le(objective, optimum),
                    Implies(NotEqual(F.Id("T"), Mul(F.Id("k"), Identity())),
                        Le(objective, Sub(optimum, Margin()))))));
        return QuantifiedMatrix(Integers(), new Formula.BindMany(FormulaQuantifier.ForAll,
            [Bound("k", Naturals()), Bound("p", Reals())], body));
    }

    private static Formula QuantifiedMatrix(Formula scalars, Formula body) => Disp(Seq(
        Begin, Grp(F.Id("gathered")),
        Forall, Sp, F.Id("n"), Colon, Sp, F.Id("Type"), Comma, Sp,
        OpenBracket, Call("Fintype", F.Id("n")), CloseBracket, Sp,
        OpenBracket, Call("DecidableEq", F.Id("n")), CloseBracket, Comma, RowBreak,
        Forall, Sp, F.Id("T"), Colon, Sp,
        Call("Matrix", F.Id("n"), F.Id("n"), scalars),
        Comma, RowBreak, body,
        End, Grp(F.Id("gathered"))));

    private static Formula PriceWindow() =>
        And(Le(D(2), F.Id("k")),
            And(Lt(RatioNext(), F.Id("p")), Lt(F.Id("p"), RatioPrev())));

    private static Formula RatioNext() =>
        Call("log", new Formula.Fraction(Seq(F.Id("k"), Sp, Plus, Sp, D(1)), F.Id("k")));

    private static Formula RatioPrev() =>
        Call("log", new Formula.Fraction(F.Id("k"), Seq(F.Id("k"), Sp, Minus, Sp, D(1))));

    private static Formula MarginBody() =>
        Call("min",
            Call("min", Sub(RatioPrev(), F.Id("p")), Sub(F.Id("p"), RatioNext())),
            Sub(Call("log", Square()), Call("log", Seq(Square(), Sp, Minus, Sp, D(1)))));

    private static Formula Square() => Seq(F.Id("k"), Caret, D(2));

    private static Formula Margin() =>
        Seq(DeltaLower, Open, F.Id("k"), Comma, Sp, F.Id("p"), Close);

    private static Formula Identity() => Call("I", F.Id("n"));

    private static Formula PosDefReal() => Call("PosDef", F.Id("T"));

    private static Formula PosDefInteger() => Call("PosDef", Call("R", F.Id("T")));

    private static Formula Det() => Call("det", F.Id("T"));

    private static Formula Entry(string row, string column) =>
        Call("T", F.Id(row), F.Id(column));

    private static Formula ComplementProduct() => Seq(Prod, Underscore,
        Grp(F.Id("l"), Sp, InMacro, Sp, F.Id("n"), Sp, Setminus, Sp,
            OpenBrace, F.Id("i"), Comma, F.Id("j"), CloseBrace),
        Sp, Entry("l", "l"));

    private static Formula FullProduct() => Seq(Prod, Underscore,
        Grp(F.Id("l"), Colon, F.Id("n")), Sp, Entry("l", "l"));

    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);

    private static Formula Group(Formula inner) => Seq(Open, inner, Close);

    private static Formula Mul(Formula left, Formula right) =>
        Seq(left, Sp, Cdot, Sp, right);

    private static Formula Sub(Formula left, Formula right) =>
        Seq(left, Sp, Minus, Sp, right);

    private static Formula Le(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);

    private static Formula Lt(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.LessThan, right);

    private static Formula NotEqual(Formula left, Formula right) =>
        new Formula.Relation(left, FormulaRelationOperator.NotEqual, right);

    private static Formula And(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right);

    private static Formula Implies(Formula left, Formula right) =>
        new Formula.Logic(left, FormulaLogicOperator.Implies, right);

    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);

    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));

    private static Formula Reals() => Seq(Mathbb, Grp(F.Id("R")));

    private static Formula Integers() => Seq(Mathbb, Grp(F.Id("Z")));
}
