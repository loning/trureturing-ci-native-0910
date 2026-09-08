using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Entanglement;

internal sealed class SequentialRegisterCircuitDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Actual time-dependent unitaries on retained physical slots have the coefficients of a finite chain on one common complex memory.",
        H("Sequential Register Circuit"),
        Blocks(
            Paragraph(Text(
                "Space(I) is the complex Euclidean Hilbert space on a finite type I; Unitary(I) "
                + "is its linear isometry equivalence group. e(j) is the coordinate basis vector. "
                + "delta(i,j) is 1 if i=j and 0 otherwise. Word(A,n)=Fin(n) to A, and "
                + "Register(A,K,n)=Word(A,n) x K. The same finite complex memory K is used "
                + "at every time. A and K may inhabit independent universes. U(t) is a unitary "
                + "on Space(A x K), and t,n,m are natural numbers. No stationarity is assumed.")),
            T("isometry-extension", "exists_unitary_agree", "Two embedded isometric copies are related by a unitary",
                Alls("E H", Id("Type"), Imp(Call("ComplexInnerProductSpaces", Id("E"), Id("H")),
                    Imp(Call("FiniteDimensional", C, Id("H")),
                        Alls("source target", Call("LinearIsometry", C, Id("E"), Id("H")),
                            Exists("U", Call("LinearIsometryEquiv", C, Id("H"), Id("H")),
                                All("x", Id("E"), Eq(Call("U", Call("source", x)), Call("target", x)))))))),
                "Both spaces are normed additive groups with complex inner products; only H is "
                + "assumed finite dimensional. The pinned LinearIsometry.extend gives agreement "
                + "on the range, and injectivity in finite dimension gives surjectivity."),
            T("coordinate-embedding", "coordinateEmbedding", "Coordinate embeddings are actual linear isometries",
                CoordinateContext(All("x", Space(Id("E")), All("q", Id("F"),
                    Eq(Call("J", Id("e"), x, Id("q")), SumAt("j", Id("E"),
                        Mul(Delta(Call("e", Id("j")), Id("q")), Call("x", Id("j")))))))),
                "E and F are finite with decidable equality, and e:E embeds into F. J(e) is "
                + "the isometry obtained from the matrix delta(e(j),q), whose Gram matrix is "
                + "the identity. It inserts zero in coordinates outside the range.", DescribeRole.Definition),
            T("rectangular-unitary", "rectangular_unitary_coefficients", "Rectangular isometries extend with exact coordinate support",
                RectangularContext(Exists("U", Unit(Prod(A, K)), And(
                    All("x", Space(Id("E")), Eq(Call("U", Call("J", BlankInjection, x)),
                        Call("J", OutputInjection, Call("V", x)))),
                    All("x", Space(Id("E")), All("i", A, All("j", Id("F"),
                        Eq(Call("U", Call("J", BlankInjection, x), Pair(Id("i"), Call("f", Id("j")))),
                            Call("V", x, Pair(Id("i"), Id("j"))))))),
                    All("x", Space(Id("E")), All("i", A, All("k", K,
                        Imp(Call("OutsideRange", Id("k"), Id("f")),
                            Eq(Call("U", Call("J", BlankInjection, x), Pair(Id("i"), Id("k"))), D(0))))))))),
                "All four coordinate types are finite with decidable equality. V maps Space(E) "
                + "isometrically into Space(A x F). blankInjection(j)=(blank,e(j)); "
                + "outputInjection(i,j)=(i,f(j)). The three conjuncts retain vector agreement, "
                + "every coefficient in the output range, and zero outside that range."),
            Paragraph(Text(
                "curry identifies Space(B x C) with the Hilbert direct sum over B of Space(C). "
                + "block(U) applies U separately in every B slice. lift(e,U) conjugates this "
                + "block operator by a coordinate equivalence e:R equiv B x C. headRest separates "
                + "the first physical symbol from (tail word,memory); restHead separates the tail "
                + "word from (first symbol,memory). First(n,U)=lift(restHead(n),U), while "
                + "Tail(n,V)=lift(headRest(n),V). compose(f,g) means apply g, then f.")),
            T("lift-coefficients", "lift_apply", "Lifted operators act in their specified coordinate slice",
                Alls("R B C", Id("Type"), Imp(And(Call("Fintype", Id("R")),
                    Call("Fintype", Id("B")), Call("Fintype", Id("C"))),
                    All("e", Call("Equiv", Id("R"), Prod(Id("B"), Id("C"))),
                        All("U", Unit(Id("C")), All("x", Space(Id("R")), All("r", Id("R"),
                            Eq(Call("lift", Id("e"), U, x, Id("r")),
                                Call("U", Lambda("j", Call("x", Call("inverse", Id("e"),
                                    Pair(Call("fst", Call("e", Id("r"))), Id("j"))))),
                                    Call("snd", Call("e", Id("r"))))))))))),
                "The lambda is included by WithLp.toLp(2). This is an equality for arbitrary "
                + "input vectors and coordinate equivalences, not a premise about a target state."),
            T("actual-circuit", "circuit", "The full circuit is independent unitary operator composition",
                Gates(Alls("n t", N, And(Eq(Circuit(D(0), t), Call("identity", Register(D(0)))),
                    Eq(Circuit(Add(n, D(1)), t), Call("compose",
                        Call("Tail", n, Circuit(n, Add(t, D(1)))), Call("First", n, Call("U", t))))))),
                "Every physical slot remains part of the full Hilbert space. This recursive "
                + "definition uses only actual unitary operators, without a desired coefficient "
                + "formula or a chain contraction in its definition.", DescribeRole.Definition),
            T("partial-circuit", "partialCircuit", "Partial circuits retain the full register",
                Gates(Alls("n m t", N, And(
                    Eq(Partial(D(0), m, t), Call("identity", Register(D(0)))),
                    Eq(Partial(Add(n, D(1)), D(0), t), Call("identity", Register(Add(n, D(1))))),
                    Eq(Partial(Add(n, D(1)), Add(m, D(1)), t), Call("compose",
                        Call("Tail", n, Partial(n, m, Add(t, D(1)))), Call("First", n, Call("U", t))))))),
                "P(U,n,m,t) denotes partialCircuit. It applies the next m gates, stopping if "
                + "no slots remain. It always acts on Space(Register(A,K,n)).", DescribeRole.Definition),
            T("slot-gate", "slotGate", "One gate acts on one slot and the common memory",
                FiniteContext(All("U", Unit(Prod(A, K)), All("n", N, And(
                    Eq(Call("Slot", U, Add(n, D(1)), D(0)), Call("First", n, U)),
                    All("q", Call("Fin", n), Eq(Call("Slot", U, Add(n, D(1)), Call("succ", Id("q"))),
                        Call("Tail", n, Call("Slot", U, n, Id("q"))))))))),
                "At length zero there is no slot index (Fin(0)), so that branch is empty. "
                + "Slot denotes slotGate and is independent of the input or desired output state.", DescribeRole.Definition),
            T("slot-action", "slot_gate_apply", "All other physical coordinates stay fixed",
                FiniteContext(All("U", Unit(Prod(A, K)), All("n", N, All("r", Call("Fin", n),
                    All("x", Space(Register(n)), All("w", Word(n), All("k", K,
                        Eq(Call("Slot", U, n, Id("r"), x, Pair(w, k)),
                            Call("U", Lambda("p", Call("x", Pair(
                                Call("update", w, Id("r"), Call("fst", Id("p"))), Call("snd", Id("p"))))),
                                Pair(Call("w", Id("r")), k)))))))))),
                "The vector lambda p is included with WithLp.toLp(2). Only the selected symbol "
                + "and memory coordinate vary inside the slice supplied to U."),
            T("partial-successor", "partial_circuit_succ_gate", "A successor applies the next gate on the same full space",
                Gates(Alls("n m t", N, Imp(Lt(m, n),
                    Eq(Partial(n, Add(m, D(1)), t), Call("compose",
                        Call("Slot", Call("U", Add(t, m)), n, m), Partial(n, m, t)))))),
                "m<n supplies the Fin(n) slot index. The time of this local gate is t+m."),
            T("all-slots", "partial_circuit_all", "Applying every slot equals the full circuit",
                Gates(Alls("n t", N, Eq(Partial(n, n, t), Circuit(n, t)))),
                "This equality identifies the independently defined recursive full circuit "
                + "with the successive same-register slot applications."),
            Paragraph(Text(
                "blankState(blank,n,j)=e((constant(blank),j)). initialized(blank,n) embeds "
                + "Space(K) at this constant physical word. B(blank,n,j) and I(blank,n,x) denote "
                + "these states. The blank symbol is an explicit parameter in the following "
                + "statements; the occupation companion handles zero slots without asking for one.")),
            T("initialized-state", "initialized", "Initialization embeds any memory vector",
                FiniteContext(All("blank", A, All("n", N, All("x", Space(K), Eq(Init(n, x),
                    Call("J", Call("blankInjection", Call("constant", blank, n), Call("identityEmbedding", K)), x)))))),
                "This is an actual coordinate linear isometry. No normalization of x is needed "
                + "to define it or to establish the coefficient identity.", DescribeRole.Definition),
            T("chain-definition", "unitaryChain", "The chain reads local operator matrix coefficients",
                Blanked(All("k", K, Alls("n t", N, And(
                    Eq(Chain(D(0), t, k), Call("terminal", Lambda("j", Delta(Id("j"), k)))),
                    Eq(Chain(Add(n, D(1)), t, k), Call("step",
                        Lambda("i", Lambda("j", Lambda("l", Call("U", t, Call("e", Pair(blank, Id("j"))),
                            Pair(Id("i"), Id("l")))))), Chain(n, Add(t, D(1)), k))))))),
                "Q(U,blank,k,n,t) is unitaryChain, a FiniteChain(A,K) whose next carrier is "
                + "again K at every step. Its terminal covector selects k. contract takes a "
                + "list of symbols; amp(Q,x,w) sums x(j) times contract(Q,ofFn(w),j).", DescribeRole.Definition),
            T("basis-circuit-coefficients", "circuit_basis_coefficients", "Actual circuit coefficients equal chain contractions",
                Blanked(Alls("n t", N, Alls("j k", K, All("w", Word(n),
                    Eq(Call("C", U, n, t, BlankState(n, Id("j")), Pair(w, k)),
                        Call("contract", Chain(n, t, k), Call("ofFn", w), Id("j"))))))),
                "The live induction on the remaining slots uses first_tail_blank to sum over "
                + "the actual common memory. The zero case is the actual register identity. "
                + "This derived identity connects independent operator and chain definitions."),
            T("arbitrary-initial-coefficients", "circuit_initialized_coefficients", "Every initial pure memory has the derived chain amplitude",
                Blanked(Alls("n t", N, All("x", Space(K), All("w", Word(n), All("k", K,
                    Eq(Call("C", U, n, t, Init(n, x), Pair(w, k)),
                        Call("amp", Chain(n, t, k), x, w))))))),
                "Basis expansion and linearity extend the proved basis coefficients to "
                + "arbitrary x, including non-normalized vectors. The physical necessity "
                + "companion uses this identity for normalized initial and terminal memory."),
            T("unused-slots", "unused_slots_zero", "Unvisited slots still contain the homogeneous blank",
                Blanked(Alls("n m t", N, Alls("j k", K, All("w", Word(n), All("r", Call("Fin", n),
                    Imp(And(Le(m, Call("val", Id("r"))), Call("Ne", Call("w", Id("r")), blank)),
                        Eq(Call("P", U, n, m, t, BlankState(n, Id("j")), Pair(w, k)), D(0)))))))),
                "No m<=n premise is needed: the existence of r with m<=val(r)<n already "
                + "bounds m. The statement is an exact vanishing coefficient."),
            T("normalized-register", "initialized_norm", "Unit normalization survives initialization and the circuit",
                Blanked(Alls("n t", N, All("x", Space(K), Imp(Eq(Norm(x), D(1)), And(
                    Eq(Norm(Init(n, x)), D(1)), Eq(Norm(Call("C", U, n, t, Init(n, x))), D(1))))))),
                "Both conjuncts follow from actual isometry norm preservation. No desired "
                + "output equation, rank bound, or occupation constraint is a premise."))));

    private static DocumentBlock T(string id, string name, string title, Formula formula, string text,
        DescribeRole role = DescribeRole.Theorem) => Describe.Lean(DescribeId.Create(id),
        DeclarationHandle.Create("D5/S3/Quantum/Entanglement/SequentialRegisterCircuit." + name), H(title),
        StatementSource.FromAuthor(Disp(formula)),
        AssessedProvenance.FromLiterature(LibraryNoteRef.Create("D5/L/Quantum/raveh2024dicke")),
        Blocks(Paragraph(Text(text))), role);
    private static Formula Id(string name) => F.Id(name);
    private static Formula A => Id("A");
    private static Formula K => Id("K");
    private static Formula U => Id("U");
    private static Formula n => Id("n");
    private static Formula m => Id("m");
    private static Formula t => Id("t");
    private static Formula w => Id("w");
    private static Formula k => Id("k");
    private static Formula x => Id("x");
    private static Formula blank => Id("blank");
    private static Formula N => Seq(Mathbb, Grp(Id("N")));
    private static Formula C => Seq(Mathbb, Grp(Id("C")));
    private static Formula Prod(Formula a, Formula b) => Call("Prod", a, b);
    private static Formula Pair(Formula a, Formula b) => Call("pair", a, b);
    private static Formula Space(Formula i) => Call("Space", i);
    private static Formula Unit(Formula i) => Call("Unitary", i);
    private static Formula Word(Formula q) => Call("Word", A, q);
    private static Formula Register(Formula q) => Call("Register", A, K, q);
    private static Formula Circuit(Formula q, Formula r) => Call("C", U, q, r);
    private static Formula Partial(Formula q, Formula r, Formula s) => Call("P", U, q, r, s);
    private static Formula Init(Formula q, Formula v) => Call("I", blank, q, v);
    private static Formula BlankState(Formula q, Formula j) => Call("B", blank, q, j);
    private static Formula Chain(Formula q, Formula r, Formula j) => Call("Q", U, blank, j, q, r);
    private static Formula Delta(Formula a, Formula b) => Call("delta", a, b);
    private static Formula Norm(Formula a) => Call("norm", a);
    private static Formula BlankInjection => Call("blankInjection", blank, Id("e"));
    private static Formula OutputInjection => Call("outputInjection", Id("f"));
    private static Formula FiniteContext(Formula body) => Alls("A K", Id("Type"),
        Imp(And(Call("Fintype", A), Call("Fintype", K)), body));
    private static Formula Gates(Formula body) => FiniteContext(All("U", Call("Function", N, Unit(Prod(A, K))), body));
    private static Formula Blanked(Formula body) => Gates(All("blank", A, body));
    private static Formula CoordinateContext(Formula body) => Alls("E F", Id("Type"),
        Imp(And(Call("Fintype", Id("E")), Call("Fintype", Id("F")), Call("DecidableEq", Id("E")),
            Call("DecidableEq", Id("F"))), All("e", Call("Embedding", Id("E"), Id("F")), body)));
    private static Formula RectangularContext(Formula body) => Alls("A E F K", Id("Type"),
        Imp(And(new[] { "A", "E", "F", "K" }.Select(q =>
            And(Call("Fintype", Id(q)), Call("DecidableEq", Id(q)))).ToArray()),
            All("blank", A, All("e", Call("Embedding", Id("E"), K), All("f", Call("Embedding", Id("F"), K),
                All("V", Call("LinearIsometry", C, Space(Id("E")), Space(Prod(A, Id("F")))), body))))));
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Id(name), [.. args]);
    private static Formula All(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name), domain, body);
    private static Formula Alls(string names, Formula domain, Formula body) =>
        names.Split(' ').Reverse().Aggregate(body, (b, name) => All(name, domain, b));
    private static Formula Exists(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.Exists, FormulaIdentifier.Create(name), domain, body);
    private static Formula Lambda(string name, Formula body) => Seq(Id(name), Sp, Mapsto, Sp, body);
    private static Formula SumAt(string name, Formula domain, Formula body) =>
        Seq(new Formula.Subscript(Sum, Seq(Id(name), Colon, domain)), Grp(body));
    private static Formula Eq(Formula a, Formula b) => new Formula.Relation(a, FormulaRelationOperator.Equal, b);
    private static Formula Le(Formula a, Formula b) => new Formula.Relation(a, FormulaRelationOperator.LessThanOrEqual, b);
    private static Formula Lt(Formula a, Formula b) => new Formula.Relation(a, FormulaRelationOperator.LessThan, b);
    private static Formula Imp(Formula a, Formula b) => new Formula.Logic(a, FormulaLogicOperator.Implies, b);
    private static Formula And(params Formula[] xs) => xs.Reverse().Aggregate((b, a) => new Formula.Logic(a, FormulaLogicOperator.And, b));
    private static Formula Add(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Add, b);
    private static Formula Mul(Formula a, Formula b) => new Formula.Binary(a, FormulaBinaryOperator.Multiply, b);
}
