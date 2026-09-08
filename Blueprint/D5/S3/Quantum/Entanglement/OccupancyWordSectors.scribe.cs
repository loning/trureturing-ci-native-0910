using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S3.Quantum.Entanglement;

internal sealed class OccupancyWordSectorsDocument : IScribeDocumentDefinition
{
    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "Actual occupation words have multinomial cardinalities and orthonormal uniform vectors.",
        H("Occupancy Word Sectors"),
        Blocks(
            Paragraph(Text(
                "A is an arbitrary finite alphabet with decidable equality. Word(A,n) is Fin n to A. "
                + "The occupation of a word is the multiset of its List.ofFn entries, so the count "
                + "of each symbol is its occupation number. Multiset order compares these counts. "
                + "M(n,a) denotes multiplicity, the cardinality of the finite set of words with "
                + "occupation a. V(n,a) denotes sectorVector: its coordinate is the complex inverse "
                + "of sqrt(M(n,a)) on that finite set and zero elsewhere. Real square roots are "
                + "nonnegative and are included canonically in the complex numbers.")),
            Theorem("word-length", "occupation_card", "Occupation has the word length",
                AnyAlphabet(All("n", N, All("w", Word(n), Eq(Card(Call("occupation", w)), n)))),
                "There is one entry for each finite position."),
            Theorem("word-concatenation", "occupation_append", "Concatenation adds occupations",
                AnyAlphabet(All("t", N, All("s", N, All("u", Word(t), All("v", Word(s),
                    Eq(Call("occupation", Call("FinAppend", u, v)),
                        Add(Call("occupation", u), Call("occupation", v)))))))),
                "FinAppend is Fin.append, with prefix length t and suffix length s."),
            Theorem("word-representative", "occupation_representative", "Every prescribed occupation is realized",
                AnyAlphabet(All("a", Multi, All("n", N, All("h", Eq(Card(a), n),
                    Eq(Call("occupation", Call("representative", a, Id("h"))), a))))),
                "The representative lists the multiset entries and indexes that list by Fin n."),
            Theorem("word-multiplicity-positive", "multiplicity_pos", "Realized word fibers are nonempty",
                Alphabet(All("a", Multi, All("n", N,
                    Imp(Eq(Card(a), n), Lt(D(0), M(n, a)))))),
                "The representative belongs to the finite word fiber, so its cardinality is positive."),
            Theorem("word-cardinality-multinomial", "sector_words_card_multinomial", "Actual word cardinality is multinomial",
                Alphabet(All("a", Multi, All("n", N, Imp(Eq(Card(a), n),
                    Eq(Card(Call("sectorWords", n, a)), Call("NatMultinomial", Call("univ", Id("A")),
                        Seq(Id("z"), Sp, Mapsto, Sp, Call("count", a, Id("z"))))))))),
                "NatMultinomial is Mathlib's factorial multinomial. The left side counts actual "
                + "functions Fin n to A whose occupation is a. The head/tail recurrence is adapted "
                + "from the immutable QuAIR source identified in the literature note. All finite "
                + "alphabets, including the empty alphabet, and zero occupation coordinates are allowed."),
            Theorem("word-cardinality-factorial", "multiplicity_eq_factorial", "Factorial formula for actual multiplicity",
                Alphabet(All("a", Multi, All("n", N, Imp(Eq(Card(a), n),
                    Eq(M(n, a), new Formula.Fraction(Call("factorial", n),
                        ProdAt("z", Id("A"), Call("factorial", Call("count", a, Id("z")))))))))),
                "The quotient is natural-number division and is exact. Zero coordinates contribute "
                + "0!=1; n=0 gives the unique empty word. This follows from the actual carrier count "
                + "and the definition of Mathlib's multinomial, without enumeration of words."),
            Theorem("word-erasure-multiplicity", "multiplicity_erase_mul", "One-symbol erasure relates actual multiplicities",
                Alphabet(All("a", Multi, All("n", N, All("i", Id("A"),
                    Imp(And(Eq(Card(a), Add(n, D(1))),
                        new Formula.Relation(Id("i"), FormulaRelationOperator.MemberOf, a)),
                        Eq(Mul(Add(n, D(1)), M(n, Call("erase", a, Id("i")))),
                            Mul(Call("count", a, Id("i")), M(Add(n, D(1)), a)))))))),
                "The equality is in natural numbers. It exposes the already adapted multinomial "
                + "erasure recurrence on actual word counts. The sequential occupation transition "
                + "uses it to telescope conditional amplitudes."),
            Theorem("word-sector-gram", "sector_gram", "Uniform occupation vectors are orthonormal",
                Alphabet(All("n", N, All("a", Multi, All("b", Multi,
                    Imp(Eq(Card(a), n), Eq(SumAt("w", Word(n),
                        Mul(Call("star", V(n, a, w)), V(n, b, w))),
                        Call("ite", Eq(a, b), D(1), D(0)))))))),
                "For b=a this is squared Hilbert norm one. Distinct occupations have disjoint "
                + "word supports. Only a needs a length hypothesis; when b differs, its vector "
                + "has zero inner product regardless of whether b is realized."),
            Theorem("boundary-membership", "boundary_spec", "Feasible boundary occupations",
                DiscreteAlphabet(All("a", Multi, All("t", N, All("b", Boundary,
                    And(Le(Val(b), a), Eq(Card(Val(b)), t)))))),
                "Boundary(a,t) is the subtype of distinct members of a.powersetCard(t). "
                + "Equivalently, its multiset value is at most a and has cardinality t; "
                + "no word-existence premise is included in this definition."),
            Theorem("boundary-complement-length", "complement_card", "Suffix occupation has the remaining length",
                DiscreteAlphabet(All("a", Multi, All("t", N, All("s", N,
                    Imp(Eq(Card(a), Add(t, s)), All("b", Boundary,
                        Eq(Card(Sub(a, Val(b))), s))))))),
                "Subtraction removes the prefix occupation from the total multiset."),
            Theorem("boundary-complement-injective", "complement_injective", "Distinct boundaries have distinct suffixes",
                DiscreteAlphabet(All("a", Multi, All("t", N, All("b", Boundary, All("c", Boundary,
                    Imp(Eq(Sub(a, Val(b)), Sub(a, Val(Id("c")))), Eq(b, Id("c")))))))),
                "Adding back a feasible prefix recovers the total occupation, so equal complements "
                + "force equal boundaries."),
            Paragraph(Text(
                "For the coordinate bridge, I is any finite type with decidable equality, A is a "
                + "natural head capacity, and a maps I to natural tail capacities. K(A,a) denotes "
                + "capacityOccupation on Option(I): none is the head and some(i) is tail i. "
                + "TimeSlice(A,a,t) is the landed subtype of h in Fin(A+1) and coordinates "
                + "x(i) in Fin(a(i)+1) satisfying val(h)+sum(i,val(x(i)))=t. "
                + "E(A,a,t) denotes boundaryTimeSliceEquiv. head and tail below return natural "
                + "coordinate values. No positivity or head-dominance assumption is required.")),
            Theorem("capacity-occupation", "capacityOccupation", "Occupation from head and tail capacities",
                CapacityParameters(Eq(K, SumAt("i", Call("Option", Id("I")),
                    Call("nsmul", Call("OptionElim", Id("i"), Id("A"), a),
                        Call("singleton", Id("i")))))),
                "OptionElim(i,A,a) is A for none and a(j) for some(j). The definition takes "
                + "Mathlib's inverse Sym.equivNatSumOfFintype at total A+sum(i,a(i)); its existing "
                + "inverse-coordinate law identifies the resulting multiset with this finite sum.",
                DescribeRole.Definition),
            Theorem("capacity-occupation-card", "capacity_occupation_card", "Total capacity is the actual occupation length",
                CapacityParameters(Eq(Card(K), Add(Id("A"), SumAt("i", Id("I"), Call("a", Id("i")))))),
                "The cardinality comes from the fixed-cardinality Sym carrier of the inverse equivalence."),
            Theorem("capacity-occupation-count", "capacity_occupation_count", "Every occupation coordinate is its capacity",
                CapacityParameters(All("i", Call("Option", Id("I")),
                    Eq(Call("count", K, Id("i")), Call("OptionElim", Id("i"), Id("A"), a)))),
                "This uses the existing forward coordinate law and inverse cancellation."),
            Theorem("bounded-coordinate-equivalence", "boundaryTimeSliceEquiv", "Actual boundaries are actual bounded coordinates",
                CapacityParameters(All("t", N, Seq(Call("E", Id("A"), a, t), Colon,
                    Call("Equiv", Call("Boundary", K, t), Call("TimeSlice", Id("A"), a, t))))),
                "Multiset.le_iff_count restricts Mathlib's existing equivalence to the coordinate "
                + "bounds; separating none from some coordinates gives the landed TimeSlice. "
                + "The inverse reconstructs the actual multiset, with both inverse laws proved.",
                DescribeRole.Definition),
            Theorem("bounded-coordinate-values", "boundary_time_slice_coordinates", "The equivalence preserves each actual count",
                CapacityParameters(All("t", N, All("b", Call("Boundary", K, t),
                    And(Eq(Call("head", Call("E", Id("A"), a, t, b)), Call("count", Val(b), Id("none"))),
                        All("i", Id("I"), Eq(Call("tail", Call("E", Id("A"), a, t, b), Id("i")),
                            Call("count", Val(b), Call("some", Id("i"))))))))),
                "The head and every tail are the original submultiset counts."),
            Theorem("bounded-coordinate-cardinality", "boundary_count_eq_sliceCount", "The two actual counts agree",
                CapacityParameters(All("t", N,
                    Eq(Card(Call("boundaries", K, t)), Call("sliceCount", Id("A"), a, t)))),
                "Fintype.card_congr applies to the bounded equivalence. This is the generic "
                + "bridge consumed by the concrete history rank; no separate count table is used."))));

    private static DocumentBlock Theorem(string id, string name, string title, Formula formula, string text,
        DescribeRole role = DescribeRole.Theorem) =>
        Describe.Lean(DescribeId.Create(id), DeclarationHandle.Create(
            "D5/S3/Quantum/Entanglement/OccupancyWordSectors." + name), H(title),
            StatementSource.FromAuthor(Disp(formula)),
            AssessedProvenance.FromLiterature(LibraryNoteRef.Create("D5/L/Quantum/raveh2024dicke")),
            Blocks(Paragraph(Text(text))), role);

    private static Formula Id(string name) => F.Id(name);
    private static Formula a => Id("a");
    private static Formula b => Id("b");
    private static Formula n => Id("n");
    private static Formula t => Id("t");
    private static Formula s => Id("s");
    private static Formula u => Id("u");
    private static Formula v => Id("v");
    private static Formula w => Id("w");
    private static Formula N => Seq(Mathbb, Grp(Id("N")));
    private static Formula Multi => Call("Multiset", Id("A"));
    private static Formula Boundary => Call("Boundary", a, t);
    private static Formula K => Call("K", Id("A"), a);
    private static Formula CapacityParameters(Formula body) => All("I", Id("Type"),
        Imp(And(Call("Fintype", Id("I")), Call("DecidableEq", Id("I"))),
            All("A", N, All("a", Call("Function", Id("I"), N), body))));
    private static Formula Word(Formula length) => Call("Word", Id("A"), length);
    private static Formula Card(Formula x) => Call("card", x);
    private static Formula Val(Formula x) => Call("val", x);
    private static Formula M(Formula length, Formula x) => Call("M", length, x);
    private static Formula V(Formula length, Formula x, Formula word) => Call("V", length, x, word);
    private static Formula Call(string name, params Formula[] args) => new Formula.Apply(Id(name), [.. args]);
    private static Formula All(string name, Formula domain, Formula body) =>
        new Formula.Bind(FormulaQuantifier.ForAll, FormulaIdentifier.Create(name), domain, body);
    private static Formula Alphabet(Formula body) => All("A", Id("Type"),
        Imp(And(Call("Fintype", Id("A")), Call("DecidableEq", Id("A"))), body));
    private static Formula AnyAlphabet(Formula body) => All("A", Id("Type"), body);
    private static Formula DiscreteAlphabet(Formula body) => All("A", Id("Type"),
        Imp(Call("DecidableEq", Id("A")), body));
    private static Formula Eq(Formula x, Formula y) => new Formula.Relation(x, FormulaRelationOperator.Equal, y);
    private static Formula Le(Formula x, Formula y) => new Formula.Relation(x, FormulaRelationOperator.LessThanOrEqual, y);
    private static Formula Lt(Formula x, Formula y) => new Formula.Relation(x, FormulaRelationOperator.LessThan, y);
    private static Formula Imp(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.Implies, y);
    private static Formula And(Formula x, Formula y) => new Formula.Logic(x, FormulaLogicOperator.And, y);
    private static Formula Add(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Add, y);
    private static Formula Sub(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Subtract, y);
    private static Formula Mul(Formula x, Formula y) => new Formula.Binary(x, FormulaBinaryOperator.Multiply, y);
    private static Formula SumAt(string name, Formula domain, Formula body) =>
        Seq(new Formula.Subscript(Sum, Seq(Id(name), Colon, domain)), Grp(body));
    private static Formula ProdAt(string name, Formula domain, Formula body) =>
        Seq(new Formula.Subscript(Prod, Seq(Id(name), Colon, domain)), Grp(body));
}
