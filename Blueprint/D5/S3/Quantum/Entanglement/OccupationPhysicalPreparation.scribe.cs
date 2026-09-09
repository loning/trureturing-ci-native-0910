using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Entanglement;

internal sealed class OccupationPhysicalPreparationDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Occupation histories admit actual sequential pure-state circuits on one common memory, and their maximum cut rank is the attained least memory dimension.",
        H("Occupation Physical Preparation"),
        Blocks(
            Paragraph(Text(
                "A is a finite alphabet with decidable equality unless a weaker context is "
                + "explicitly displayed. a is a multiset, L=card(a), and Word(A,n)=Fin(n) to A. "
                + "B(a,t)=Boundary(a,t) consists of multisets val(b)<=a with card(val(b))=t. "
                + "R(a)=boundaryMaximum(a) is the maximum of card(B(a,t)) over 0<=t<=L. "
                + "M(n,r)=multiplicity(n,r) counts actual length-n words of occupation r. "
                + "V(n,r,w)=sectorVector(n,r,w) is the complex inverse square root of M(n,r) "
                + "on those words, and zero otherwise. All square roots below are nonnegative "
                + "real roots included in the complex numbers where multiplied by V.")),
            Paragraph(Text(
                "Space(I), Unitary(I), e(j)=basis(j), C(U,n,t), P(U,n,m,t), Bstate(blank,n,j), and "
                + "delta are the actual Hilbert spaces, unitaries, basis vectors, full and "
                + "partial circuits, blank basis state, and coordinate delta of "
                + "SequentialRegisterCircuit. They act on all n physical slots and one common "
                + "memory. J(slots,x)=slotInitialized(slots,x) inserts x at the physical word "
                + "slots, including the empty word. It is a coordinate linear isometry.")),
            T("boundary-embedding", "boundaryEmbedding", "Every cut carrier embeds into the same maximum memory",
                Discrete(All("a", Multi, All("t", N, Imp(Le(t, L),
                    Member(E(t), Call("Embedding", B(t), Fin(R))))))),
                "E(a,t)=boundaryEmbedding(a,t,ht) is chosen from the actual cardinality bound, "
                + "where ht:t<=card(a). R(a)>0, since the time-zero boundary is a singleton. "
                + "Neither a blank symbol nor finiteness of A is needed for this embedding.", DescribeRole.Definition),
            T("boundary-size", "boundary_card_le_maximum", "Every feasible cut size is bounded by the maximum",
                Discrete(All("a", Multi, All("t", N, Imp(Le(t, L), Le(Card(B(t)), R))))),
                "The proof instantiates the finite supremum bound; this companion is used "
                + "both for the embeddings and the physical cut bound."),
            Paragraph(Text(
                "S(a,t)=nextStep(a,t) has rows (i,c) in A x B(a,t+1) and columns b in B(a,t). "
                + "Its coefficient is sqrt(count(a-val(b),i)/(L-t)) if val(c)=val(b)+{i}, "
                + "and zero otherwise. The denominator L-t is natural subtraction before real "
                + "division. The existing next_step_gram proves S dagger S=1 when t<L. "
                + "Jcoord(e) is the coordinate isometry; Binj(blank,e)(b)=(blank,e(b)), and "
                + "Oinj(f)(i,c)=(i,f(c)).")),
            T("physical-step-extension", "fixed_register_next_step_coefficients", "The actual Gram isometry extends to the common register",
                Context(All("K", Id("Type"), Imp(And(Call("Fintype", K), Call("DecidableEq", K)),
                    All("blank", A, All("t", N, Imp(Lt(t, L),
                        All("e", Call("Embedding", B(t), K), All("f", Call("Embedding", B(Add(t, D(1))), K),
                            Exists("U", Unit(Prod(A, K)), StepAgreement))))))))),
                "The first conjunct is agreement for every input vector, the second gives "
                + "each matrix entry, and the third proves zero outside the next boundary "
                + "image. The current S.next_step_gram is consumed by this unitary extension."),
            Paragraph(Text(
                "occupationUnitary(blank,a,t) chooses the preceding unitary using E(a,t) "
                + "and E(a,t+1) for each t:Fin(L). G(blank,a,t)=occupationGates is this unitary "
                + "at t<L and the identity at later times. terminalBoundary(a) is the total "
                + "occupation a; terminalMemory(a)=E(a,L)(terminalBoundary(a)). Denote it by "
                + "kend(a). The initial boundary bzero(a) is the empty occupation. "
                + "F(a,n,t,w,b)=contraction from the current SequentialOccupationHistory: "
                + "F(a,0,t,w,b)=delta(val(b),a), and its successor sums "
                + "S(a,t)((w(0),c),b) F(a,n,t+1,tail(w),c) over c:B(a,t+1).")),
            T("occupation-gates", "occupationGates", "Time-dependent occupation gates use one fixed Hilbert space",
                Context(All("blank", A, All("t", N, And(
                    Imp(Lt(t, L), Eq(G, Call("occupationUnitary", blank, a, t))),
                    Imp(Le(L, t), Eq(G, Call("identity", Space(Prod(A, Fin(R)))))))))),
                "The active branch carries the proof t<L needed for its Fin(L) index. "
                + "This definition specifies unitaries independently of the full output amplitudes.", DescribeRole.Definition),
            T("occupation-circuit-induction", "occupation_circuit_coefficients", "The actual occupation circuit has a decoupled terminal memory",
                Context(All("blank", A, Alls("n t", N, Imp(Eq(L, Add(t, n)),
                    All("b", B(t), All("w", Word(n), All("k", Fin(R), Eq(
                        Call("C", Gates, n, t, Call("Bstate", blank, n, Call("E", a, t, b)), Pair(w, k)),
                        Mul(Call("F", a, n, t, w, b), Delta(k, End)))))))))),
                "Induction on remaining slots uses occupation_gate_sum to restrict the real "
                + "memory sum to the next embedded boundary. The zero case uses uniqueness "
                + "of the terminal boundary. This is the live operator proof of attainment."),
            T("occupation-reachable-memory", "occupation_reachable_memory", "Partial circuits remain in the reached boundary image",
                Context(All("blank", A, Alls("n m t", N, Imp(And(Le(m, n), Le(Add(t, m), L)),
                    All("b", B(t), All("w", Word(n), All("k", Fin(R),
                        Imp(Call("OutsideRange", k, E(Add(t, m))),
                            Eq(Call("P", Gates, n, m, t, Call("Bstate", blank, n, Call("E", a, t, b)),
                                Pair(w, k)), D(0)))))))))),
                "This is an exact zero coefficient outside the actual reached subspace. "
                + "Unvisited physical slots remain blank by the general circuit theorem."),
            T("fixed-register-sufficiency", "fixed_register_sufficiency", "A homogeneous blank prepares the normalized whole history",
                Context(All("blank", A, And(Eq(Norm(Initial), D(1)), Eq(Norm(Output), D(1)),
                    All("w", Word(L), All("k", Fin(R),
                        Eq(Call("eval", Output, Pair(w, k)), Mul(V(L, a, w), Delta(k, End)))))))),
                "Initial=Bstate(blank,L,E(a,0)(bzero(a))) and Output=C(G(blank,a),L,0)(Initial). "
                + "All slots are retained and the terminal memory is a fixed pure basis state."),
            T("all-alphabets-sufficiency", "fixed_register_sufficiency_all", "The actual circuit exists also for an empty alphabet",
                Context(Exists("slots", Word(L), Exists("kzero", Fin(R), Exists("kend", Fin(R),
                    Exists("U", Call("Function", N, Unit(Prod(A, Fin(R)))), And(
                        Homogeneous(L), Eq(Norm(Call("e", Pair(slots, Id("kzero")))), D(1)),
                        Eq(Norm(Call("C", U, L, D(0), Call("e", Pair(slots, Id("kzero"))))), D(1)),
                        All("w", Word(L), All("k", Fin(R), Eq(
                            Call("C", U, L, D(0), Call("e", Pair(slots, Id("kzero"))), Pair(w, k)),
                            Mul(V(L, a, w), Delta(k, Id("kend")))))))))))),
                "When a=0 the physical word is Fin.elim0 and all gates are identity. "
                + "This branch requests no element of A. Otherwise a symbol in a supplies "
                + "the homogeneous blank and the proved occupation circuit supplies output."),
            T("eight-slot-sufficiency", "fixed_register_5040_sufficiency", "Eight physical slots suffice with twelve memory states",
                Exists("kzero", Fin(D(1, 2)), Exists("kend", Fin(D(1, 2)),
                    Exists("U", Call("Function", N, Unit(Prod(ConcreteA, Fin(D(1, 2))))), And(
                        Eq(Norm(ConcreteInitial), D(1)), Eq(Norm(Call("C", U, D(8), D(0), ConcreteInitial)), D(1)),
                        All("w", Call("Word", ConcreteA, D(8)), All("k", Fin(D(1, 2)), Eq(
                            Call("C", U, D(8), D(0), ConcreteInitial, Pair(w, k)),
                            Mul(V(D(8), Ast, w), Delta(k, Id("kend")))))))))),
                "ast is the existing occupation5040 on Option(Fin(3)), with counts (4;2,1,1). "
                + "ConcreteInitial=Bstate(none,8,kzero). Values 8 and 12 are transported from "
                + "occupation_5040_card and occupation_5040_boundary_maximum."),
            T("physical-preparation-definition", "Preparation", "Preparation means actual normalized separated output",
                MemoryContext(All("slots", Word(L), Alls("x y", Space(K),
                    All("U", Call("Function", N, Unit(Prod(A, K))), Iff(
                        Member(Call("tuple", slots, x, y, U), Call("PreparationData", a, K)),
                        And(Homogeneous(L), Eq(Norm(x), D(1)), Eq(Norm(y), D(1)),
                            All("w", Word(L), All("k", K, Eq(Out(L), Mul(V(L, a, w), Call("y", k))))))))))),
                "Preparation(a,K) is the Lean structure carrying exactly this data and its "
                + "four proof fields. PreparationData forgets the proof fields. The initial "
                + "and terminal memory vectors are arbitrary unit vectors. No rank inequality, "
                + "factorization or claimed minimum is included in membership.", DescribeRole.Definition),
            T("physical-to-chain", "circuit_to_chain", "Separated physical output yields an actual constant-memory chain",
                FiniteMemoryContext(All("n", N, All("slots", Word(n),
                    All("U", Call("Function", N, Unit(Prod(A, K))), Alls("x y", Space(K),
                        All("psi", Call("Function", Word(n), C), Imp(And(Homogeneous(n), Eq(Norm(y), D(1)),
                            All("w", Word(n), All("k", K, Eq(Out(n), Mul(Call("psi", w), Call("y", k)))))),
                            Exists("c", Call("FiniteChain", A, K), Exists("initial", Call("Function", K, C),
                                ChainFacts(n, Id("psi"))))))))))),
                "Only y is normalized in this bridge; x may be arbitrary. A nonzero coordinate "
                + "y(k) supplies the algebraic terminal cap and initial(j)=x(j)/y(k). For n>0 "
                + "the proven circuit_initialized_coefficients derives the chain amplitude. "
                + "For n=0 a terminal chain works without selecting a blank symbol."),
            T("preparation-chain", "preparation_to_chain", "Every preparation yields the chain needed for necessity",
                MemoryContext(All("p", Call("Preparation", a, K), Exists("c", Call("FiniteChain", A, K),
                    Exists("initial", Call("Function", K, C), ChainFacts(L, Lambda("w", V(L, a, w))))))),
                "The output equality of p supplies the target amplitude. Every actual cut "
                + "carrier has card(K), including both endpoints, and so does its maximum."),
            T("physical-necessity", "physical_memory_necessity", "Every exact sequential pure preparation needs the maximum cut rank",
                MemoryContext(All("p", Call("Preparation", a, K), Le(R, Card(K)))),
                "The derived physical-to-chain bridge supplies the hypotheses of the existing "
                + "maximum_bond_necessity theorem. Necessity is derived from actual output."),
            T("physical-cut-necessity", "physical_cut_necessity", "Every cut retains its actual coefficient rank and memory bound",
                MemoryContext(All("p", Call("Preparation", a, K), All("t", N, Imp(Le(t, L), And(
                    Eq(Rank(a, t, Sub(L, t)), Card(B(t))), Le(Card(B(t)), Card(K))))))),
                "The coefficient matrix is the actual complex word coefficient matrix. "
                + "Natural subtraction L-t is used only under t<=L."),
            T("physical-memory-set", "achievablePhysicalMemories", "Achievable dimensions quantify actual preparations",
                Context(All("d", N, Iff(Member(Id("d"), Ach),
                    Exists("p", Call("Preparation", a, Fin(Id("d"))), Call("True"))))),
                "This is exactly {d : Nat | Nonempty(Preparation(a,Fin(d)))}. It includes "
                + "normalized initial and terminal memory, homogeneous slots, actual unitaries "
                + "and separated exact output through the preceding structure definition.", DescribeRole.Definition),
            T("physical-attainment", "physical_attainment", "The maximum dimension is physically attained",
                Context(Member(R, Ach)),
                "The all-alphabets circuit supplies basis initial and terminal memory. "
                + "preparation_of_basis packages those actual unit vectors and its output proof."),
            T("physical-least", "physical_memory_minimum", "Necessity and attainment give the least physical memory",
                Context(Least(Ach, R)),
                "This is IsLeast(achievablePhysicalMemories(a),R(a)), with both membership "
                + "and a lower bound for every member. It asserts neither attainability of "
                + "every larger dimension nor computable numerical matrices for the gates."),
            T("physical-5040-least", "physical_5040_memory_minimum", "The least physical memory for 5040 is twelve",
                Least(Call("achievablePhysicalMemories", Ast), D(1, 2)),
                "Membership consumes physical_5040_attainment from the actual eight-slot "
                + "circuit. The lower bound transports the general physical minimum."),
            Paragraph(Text(
                "For L=t+s, p(a,t,s,b) is the real product over z:A of binomial(count(a,z), "
                + "count(val(b),z)), divided by binomial(t+s,t). In the following display, "
                + "factorial divisions for M are natural divisions, while the ratio of three "
                + "multiplicities and p are real divisions. coefficient(a,t,s) has entry "
                + "V(t+s,a,append(u,v)); rank is its actual complex linear algebra rank. "
                + "sigma(a,t,s,b) denotes the existing schmidtCoefficient. Its square is the "
                + "multiplicity ratio, and sigma=sqrt(p). star denotes complex conjugation. "
                + "FinsetSup(range(L+1),f) includes all cuts 0 through L.")),
            T("coherent-history-clauses", "coherent_history_clause_assembly", "All general coherent-history clauses occur in one terminal consumer",
                Context(Alls("t s", N, Imp(Eq(L, Add(t, s)), GeneralAssembly))),
                "The thirteen conjuncts are equation (7); total factorial count; whole-state "
                + "normalization; past and future factorial counts; equation (8); positive "
                + "Schmidt coefficients and positive weights; both Gram equations; actual "
                + "coefficient rank; its maximum; and both the algebraic and physical attained "
                + "minima. The existing C/S and word-sector results supply the earlier clauses."),
            T("coherent-history-5040-clauses", "coherent_history_5040_clause_assembly", "The concrete ranks and both attained minima are transported together",
                And(Eq(Call("ListMap", Lambda("t", Rank(Ast, t, Sub(D(8), t))), Call("range", D(9))),
                        Call("list", D(1), D(4), D(8), D(1, 1), D(1, 2), D(1, 1), D(8), D(4), D(1))),
                    Eq(SupAt(D(9), Rank(Ast, t, Sub(D(8), t))), D(1, 2)),
                    Eq(Rank(Ast, D(4), D(4)), D(1, 2)),
                    Least(Call("achievableMaximumBonds", Ast), D(1, 2)),
                    Least(Call("achievablePhysicalMemories", Ast), D(1, 2))),
                "These five conjuncts use the existing rank sequence, maximum and middle "
                + "rank, the existing algebraic minimum, and the physical minimum proved here. "
                + "There is no new enumeration or certified numerical instance."),
            Paragraph(Text(
                "The physical model uses time-dependent gates, one common complex memory, "
                + "and actual retained homogeneous physical slots. It is distinct from a "
                + "stationary realization and from the prediction problem with dimension 16. "
                + "These are known occupation/Dicke-state constructions, without a novelty "
                + "claim. This terminal companion supplies formal clauses; it does not itself "
                + "record independent review, canonical atom coverage or completion of the "
                + "broader research objective.")))));

    private static Formula StepAgreement => And(
        All("x", Space(B(t)), Eq(Call("U", Call("Jcoord", Call("Binj", blank, Id("e")), x)),
            Call("Jcoord", Call("Oinj", Id("f")), Call("toEuclideanLin", S, x)))),
        All("b", B(t), All("i", A, All("c", B(Add(t, D(1))), Eq(
            Call("U", Call("basis", Pair(blank, Call("e", b))), Pair(Id("i"), Call("f", Id("c")))),
            Call("entry", S, Pair(Id("i"), Id("c")), b))))),
        All("b", B(t), All("i", A, All("k", K, Imp(Call("OutsideRange", k, Id("f")), Eq(
            Call("U", Call("basis", Pair(blank, Call("e", b))), Pair(Id("i"), k)), D(0)))))));
    private static Formula ChainFacts(Formula length, Formula psi) => And(
        Eq(Call("length", Id("c")), length),
        All("r", N, Imp(Le(Id("r"), length), Eq(Card(Call("cutBond", Id("c"), Id("r"))), Card(K)))),
        All("w", Word(length), Eq(Call("amp", Id("c"), Id("initial"), w), Call("apply", psi, w))),
        Eq(Call("maximumBond", Id("c")), Card(K)));
    private static Formula GeneralAssembly => And(
        All("u", Word(t), All("v", Word(s), Eq(V(Add(t, s), a, Call("append", Id("u"), Id("v"))),
            SumAt("b", B(t), Mul(Mul(Seq(Sqrt, Grp(Weight)), V(t, Val(b), Id("u"))), V(s, Sub(a, Val(b)), Id("v"))))))),
        Eq(M(Add(t, s), a), Counts(Add(t, s), a)),
        Eq(SumAt("w", Word(Add(t, s)), Mul(Call("star", V(Add(t, s), a, w)), V(Add(t, s), a, w))), D(1)),
        All("b", B(t), Eq(M(t, Val(b)), Counts(t, Val(b)))),
        All("b", B(t), Eq(M(s, Sub(a, Val(b))), Counts(s, Sub(a, Val(b))))),
        All("b", B(t), Eq(Div(Mul(M(t, Val(b)), M(s, Sub(a, Val(b)))), M(Add(t, s), a)), Weight)),
        All("b", B(t), Lt(D(0), Call("sigma", a, t, s, b))),
        All("b", B(t), Lt(D(0), Weight)),
        Alls("b c", B(t), And(
            Eq(SumAt("u", Word(t), Mul(Call("star", V(t, Val(b), Id("u"))), V(t, Val(Id("c")), Id("u")))), Delta(b, Id("c"))),
            Eq(SumAt("v", Word(s), Mul(Call("star", V(s, Sub(a, Val(b)), Id("v"))),
                V(s, Sub(a, Val(Id("c"))), Id("v")))), Delta(b, Id("c"))))),
        Eq(Rank(a, t, s), Card(B(t))),
        Eq(SupAt(Add(L, D(1)), Rank(a, t, Sub(L, t))), R),
        Least(Call("achievableMaximumBonds", a), R), Least(Ach, R));
    private static DocumentBlock T(string id, string name, string title, Formula formula, string text,
        DescribeRole role = DescribeRole.Theorem) => Describe.Lean(DescribeId.Create(id),
        DeclarationHandle.Create("D5/S3/Quantum/Entanglement/OccupationPhysicalPreparation." + name), H(title),
        StatementSource.FromAuthor(Disp(formula)),
        AssessedProvenance.FromLiterature(LibraryNoteRef.Create("D5/L/Quantum/raveh2024dicke")),
        Blocks(Paragraph(Text(text))), role);
    private static Formula Id(string name) => F.Id(name);
    private static Formula A => Id("A");
    private static Formula K => Id("K");
    private static Formula U => Id("U");
    private static Formula a => Id("a");
    private static Formula b => Id("b");
    private static Formula n => Id("n");
    private static Formula m => Id("m");
    private static Formula t => Id("t");
    private static Formula s => Id("s");
    private static Formula w => Id("w");
    private static Formula k => Id("k");
    private static Formula x => Id("x");
    private static Formula y => Id("y");
    private static Formula slots => Id("slots");
    private static Formula blank => Id("blank");
    private static Formula N => Seq(Mathbb, Grp(Id("N")));
    private static Formula C => Seq(Mathbb, Grp(Id("C")));
    private static Formula Multi => Call("Multiset", A);
    private static Formula L => Card(a);
    private static Formula R => Call("R", a);
    private static Formula S => Call("S", a, t);
    private static Formula G => Call("G", blank, a, t);
    private static Formula Gates => Call("G", blank, a);
    private static Formula End => Call("kend", a);
    private static Formula Ach => Call("achievablePhysicalMemories", a);
    private static Formula Ast => Id("ast");
    private static Formula ConcreteA => Call("Option", Fin(D(3)));
    private static Formula ConcreteInitial => Call("Bstate", Id("none"), D(8), Id("kzero"));
    private static Formula Initial => Call("Bstate", blank, L, Call("E", a, D(0), Call("bzero", a)));
    private static Formula Output => Call("C", Gates, L, D(0), Initial);
    private static Formula Weight => Div(ProductAt("z", A, Call("binomial", Call("count", a, Id("z")),
        Call("count", Val(b), Id("z")))), Call("binomial", Add(t, s), t));
    private static Formula Counts(Formula q, Formula r) => Div(Call("factorial", q),
        ProductAt("z", A, Call("factorial", Call("count", r, Id("z")))));
    private static Formula B(Formula q) => Call("B", a, q);
    private static Formula E(Formula q) => Call("E", a, q);
    private static Formula M(Formula q, Formula r) => Call("M", q, r);
    private static Formula V(Formula q, Formula r, Formula v) => Call("V", q, r, v);
    private static Formula Rank(Formula r, Formula q, Formula v) => Call("rank", Call("coefficient", r, q, v));
    private static Formula Out(Formula q) => Call("C", U, q, D(0), Call("J", slots, x), Pair(w, k));
    private static Formula Homogeneous(Formula q) => Alls("i j", Fin(q), Eq(Call("slots", Id("i")), Call("slots", Id("j"))));
    private static Formula Least(Formula set, Formula value) => And(Member(value, set),
        All("d", N, Imp(Member(Id("d"), set), Le(value, Id("d")))));
    private static Formula SupAt(Formula limit, Formula body) => Call("FinsetSup", Call("range", limit), Lambda("t", body));
    private static Formula Fin(Formula q) => Call("Fin", q);
    private static Formula Prod(Formula q, Formula r) => Call("Prod", q, r);
    private static Formula Pair(Formula q, Formula r) => Call("pair", q, r);
    private static Formula Space(Formula q) => Call("Space", q);
    private static Formula Unit(Formula q) => Call("Unitary", q);
    private static Formula Word(Formula q) => Call("Word", A, q);
    private static Formula Card(Formula q) => Call("card", q);
    private static Formula Val(Formula q) => Call("val", q);
    private static Formula Norm(Formula q) => Call("norm", q);
    private static Formula Delta(Formula q, Formula r) => Call("delta", q, r);
    private static Formula Discrete(Formula body) => All("A", Id("Type"), Imp(Call("DecidableEq", A), body));
    private static Formula Context(Formula body) => Discrete(Imp(Call("Fintype", A), All("a", Multi, body)));
    private static Formula MemoryContext(Formula body) => Context(All("K", Id("Type"), Imp(Call("Fintype", K), body)));
    private static Formula FiniteMemoryContext(Formula body) => Alls("A K", Id("Type"),
        Imp(And(Call("Fintype", A), Call("Fintype", K)), body));
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Id(name), [.. args]);
    private static Formula All(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name), domain, body);
    private static Formula Alls(string names, Formula domain, Formula body) =>
        names.Split(' ').Reverse().Aggregate(body, (body, name) => All(name, domain, body));
    private static Formula Exists(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.Exists, FormulaIdentifier.Create(name), domain, body);
    private static Formula Lambda(string name, Formula body) => Seq(Id(name), Sp, Mapsto, Sp, body);
    private static Formula SumAt(string name, Formula domain, Formula body) =>
        Seq(new Formula.Subscript(Sum, Seq(Id(name), Colon, domain)), Grp(body));
    private static Formula ProductAt(string name, Formula domain, Formula body) =>
        Seq(new Formula.Subscript(F.Prod, Seq(Id(name), Colon, domain)), Grp(body));
    private static Formula Eq(Formula a, Formula b) => new Formula.Relation(a, FormulaRelationOperator.Equal, b);
    private static Formula Le(Formula a, Formula b) => new Formula.Relation(a, FormulaRelationOperator.LessThanOrEqual, b);
    private static Formula Lt(Formula a, Formula b) => new Formula.Relation(a, FormulaRelationOperator.LessThan, b);
    private static Formula Member(Formula a, Formula b) => new Formula.Relation(a, FormulaRelationOperator.MemberOf, b);
    private static Formula Imp(Formula a, Formula b) => new Formula.Logic(a, FormulaLogicOperator.Implies, b);
    private static Formula Iff(Formula a, Formula b) => new Formula.Logic(a, FormulaLogicOperator.Iff, b);
    private static Formula And(params Formula[] xs) => xs.Reverse().Aggregate((b, a) => new Formula.Logic(a, FormulaLogicOperator.And, b));
    private static Formula Add(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Add, b);
    private static Formula Sub(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Subtract, b);
    private static Formula Mul(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Multiply, b);
    private static Formula Div(Formula a, Formula b) => Seq(Frac, Grp(a), Grp(b));
}
