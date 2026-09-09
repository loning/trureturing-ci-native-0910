using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Entanglement;

internal sealed class StationaryOccupationResidualCircuitDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Last-tail residual vectors determine every coefficient of a stationary occupation circuit.",
        H("Stationary Occupation Residual Circuits"),
        Blocks(
            Paragraph(Text(
                "A and K are finite types with decidable equality. Space(K) is the complex "
                + "Euclidean space, and Unitary(A x K) is its physical register unitary group. "
                + "Word(A,n) consists of functions Fin(n) to A. The multiset occ(w) records "
                + "the occupation of w. C(U,n,t,z,w,k) denotes the coefficient (w,k) of the "
                + "actual circuit with the constant schedule U, n slots and starting time t. "
                + "J(blank,n,x) initializes all slots with blank and the memory with x. "
                + "B(blank,x) inserts the memory into one fresh blank slot.")),
            Describe.Lean(DescribeId.Create("last-tail-mass"),
                DeclarationHandle.Create(Prefix + "lastTailMass"), H("Last-tail multiplicity"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "For a chosen head letter q, R(q,b) is the sum of the counts of all "
                    + "letters other than q. The last-tail mass is R(q,b) M(card(b),b)/card(b), "
                    + "where M counts actual occupation words. Division is real division. "
                    + "The head slice S(q,b,h) replaces the head count by h and preserves "
                    + "every tail count."))), DescribeRole.Definition),
            T("head-amplitude", "head_slice_head_amplitude", "Removing one head letter",
                All("A", Id("Type"), Imp(Alphabet, All("q", A, All("b", Multi,
                    All("h", N, Imp(And(Lt(D(0), h), Lt(D(0), Call("R", q, b))),
                        Eq(Mul(Call("sqrtC", Call("headProbability", h, Call("R", q, b))),
                            Call("sqrtC", Mass(h))), Call("sqrtC", Mass(Sub(h, D(1))))))))))),
                "sqrtC is the nonnegative real square root included in the complex numbers. "
                + "The multiplicity erase identity proves this equality, including the "
                + "case R(q,b)=1. Subtraction in the head index is natural subtraction."),
            Describe.Lean(DescribeId.Create("padding-residual"),
                DeclarationHandle.Create(Prefix + "paddingResidual"), H("Residual memory vectors"),
                StatementSource.WithoutFormula(), AssessedProvenance.FromRepo(),
                Blocks(Paragraph(Text(
                    "If b is a submultiset of a and R(q,b)>0, paddingResidual(q,a,b) sums "
                    + "sqrtC(lastTailMass(q,S(q,b,h))) times the basis vector indexed by "
                    + "the tail occupation of b and h, for 0<=h<=count(b,q). When the tail "
                    + "is empty it is the sink basis vector. It is zero when b is not a "
                    + "submultiset of a. physicalResidual transports this vector through "
                    + "the exact finite memory equivalence."))), DescribeRole.Definition),
            Paragraph(Text(
                "Step(a,blank,U,r) means that for every nonzero b<=a and every i:A and k:K, "
                + "the (i,k) coefficient of U(B(blank,r(b))) equals r(erase(b,i))(k) if "
                + "i belongs to b, and equals zero otherwise. Here r maps multisets to "
                + "Space(K). IndicatorEq(c,b,v) means v if c=b and zero otherwise.")),
            T("all-circuit-coefficients", "circuit_output_of_residuals", "Local residual equations determine the output",
                General(All("blank", A, All("U", Unit, All("a", Multi,
                    All("r", Call("Function", Multi, Space), All("f", Space,
                        Imp(And(Eq(Call("r", D(0)), f), Step),
                            All("n", N, All("t", N, All("b", Multi,
                                Imp(And(Eq(Call("card", b), n), Le(b, a)),
                                    All("w", Word(n), All("k", K,
                                        Eq(Out(n, t, Call("r", b)),
                                            Call("IndicatorEq", Call("occ", w), b, Call("f", k)))))))))))))))),
                "Induction on the number of slots uses the actual circuit recursion. "
                + "A legal first letter erases one occurrence from the remaining multiset; "
                + "an absent first letter makes the coefficient zero. The empty word "
                + "uses r(0)=f. This includes all legal and illegal words."),
            T("normalized-coefficients", "normalized_output_of_residuals", "Normalized equal-phase occupation output",
                General(All("blank", A, All("U", Unit, All("a", Multi,
                    All("r", Call("Function", Multi, Space), All("f", Space,
                        Imp(And(Eq(Call("r", D(0)), f), Step), All("w", Word(CardA),
                            All("k", K, Eq(Out(CardA, D(0), Call("scale", InvRoot, Call("r", a))),
                                Mul(Call("sector", CardA, a, w), Call("f", k)))))))))))),
                "InvRoot(a) is the complex inverse of the square root of M(card(a),a). "
                + "The sector coefficient is this same positive real amplitude on words "
                + "of occupation a and zero on every other word. Linearity transfers "
                + "the unnormalized coefficient identity to the scaled input."),
            T("initial-normalization", "initial_norm_of_sector_output", "The exact output fixes the initial norm",
                General(All("a", Multi, All("blank", A, All("U", Unit,
                    All("x", Space, All("sink", K,
                        Imp(All("w", Word(CardA), All("k", K,
                            Eq(Out(CardA, D(0), x),
                                Mul(Call("sector", CardA, a, w), Call("basis", Id("sink"), k))))),
                            Eq(Call("norm", x), D(1))))))))),
                "The occupation sector has norm one. Embedding it into the sink memory "
                + "preserves that norm, while the actual unitary circuit and initialization "
                + "preserve the norm of x. No initial normalization hypothesis is used."),
            T("concrete-residual-reduction", "target_of_residual_step", "Concrete transitions suffice for attainment",
                All("A", Id("Type"), Imp(And(Alphabet, Call("Nonempty", A)),
                    All("a", Multi, Imp(Call("ResidualStep", a), Call("Target", a))))),
                "ResidualStep is Step for the maximal-capacity head as blank, the fixed "
                + "padding unitary, and physicalResidual(a,-). Target(a) asserts existence "
                + "of one blank, one unitary on A x Fin(d), and unit initial and final memories, "
                + "with every coefficient equal to sector(card(a),a,w) times the final memory; "
                + "d is product(count(a,i)+1) minus the maximum count. The initial memory "
                + "is InvRoot(a) times physicalResidual(a,a), and the terminal memory is "
                + "the sink. The argument also includes the zero multiset."))));

    private const string Prefix = "D5/S3/Quantum/Entanglement/StationaryOccupationResidualCircuit.";
    private static DocumentBlock T(string id, string name, string title, Formula formula, string text) =>
        Describe.Lean(DescribeId.Create(id), DeclarationHandle.Create(Prefix + name), H(title),
            StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(text))), DescribeRole.Theorem);
    private static Formula Id(string name) => F.Id(name);
    private static Formula A => Id("A");
    private static Formula K => Id("K");
    private static Formula a => Id("a");
    private static Formula b => Id("b");
    private static Formula q => Id("q");
    private static Formula h => Id("h");
    private static Formula n => Id("n");
    private static Formula t => Id("t");
    private static Formula w => Id("w");
    private static Formula k => Id("k");
    private static Formula x => Id("x");
    private static Formula f => Id("f");
    private static Formula N => Seq(Mathbb, Grp(Id("N")));
    private static Formula Multi => Call("Multiset", A);
    private static Formula Space => Call("Space", K);
    private static Formula Unit => Call("Unitary", Call("Prod", A, K));
    private static Formula CardA => Call("card", a);
    private static Formula InvRoot => Call("InvRoot", a);
    private static Formula Alphabet => And(Call("Fintype", A), Call("DecidableEq", A));
    private static Formula Step => Call("Step", a, Id("blank"), Id("U"), Id("r"));
    private static Formula Mass(Formula j) => Call("lastTailMass", q, Call("S", q, b, j));
    private static Formula Word(Formula j) => Call("Word", A, j);
    private static Formula Out(Formula slots, Formula time, Formula memory) =>
        Call("C", Id("U"), slots, time, Call("J", Id("blank"), slots, memory), w, k);
    private static Formula General(Formula body) => All("A", Id("Type"), All("K", Id("Type"),
        Imp(And(Alphabet, Call("Fintype", K), Call("DecidableEq", K)), body)));
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Id(name), [.. args]);
    private static Formula All(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name), domain, body);
    private static Formula Eq(Formula left, Formula right) => new Formula.Relation(left, FormulaRelationOperator.Equal, right);
    private static Formula Le(Formula left, Formula right) => new Formula.Relation(left, FormulaRelationOperator.LessThanOrEqual, right);
    private static Formula Lt(Formula left, Formula right) => new Formula.Relation(left, FormulaRelationOperator.LessThan, right);
    private static Formula Imp(Formula left, Formula right) => new Formula.Logic(left, FormulaLogicOperator.Implies, right);
    private static Formula And(params Formula[] terms) => terms.Reverse().Aggregate((right, left) =>
        new Formula.Logic(left, FormulaLogicOperator.And, right));
    private static Formula Mul(Formula left, Formula right) => new Formula.Binary(left, FormulaBinaryOperator.Multiply, right);
    private static Formula Sub(Formula left, Formula right) => new Formula.Binary(left, FormulaBinaryOperator.Subtract, right);
}
