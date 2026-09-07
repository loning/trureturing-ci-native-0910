using static StrataLint.Scribe.DefinitionDsl;
using static StrataLint.Scribe.FormulaDsl;
using F = StrataLint.Scribe.FormulaDsl;

namespace StrataLint.Scribe.Blueprint.D5.S1.Ledger;

internal sealed class BoundedTimeSliceDocument : IScribeDocumentDefinition
{
    private const string Prefix = "D5/S1/Ledger/BoundedTimeSlice.";

    public DocumentDefinition Create() => DocumentDefinition.Create(ScribeNode.Create(
        "An actual bounded fixed-sum slice attains the full tail-box size exactly between "
            + "total tail capacity and head capacity. The 5040 slice has unique maximum 12 at time 4.",
        H("Bounded Time Slices"),
        Blocks(
            Paragraph(Text(
                "Throughout the general statements, I is an arbitrary finite type, including "
                    + "the empty type, with decidable equality. Capacities a map I to the "
                    + "natural numbers, and A and t are natural numbers. B(a) is the dependent "
                    + "tail box of coordinates b(i) in Fin(a(i)+1). Write s(b) for the sum "
                    + "of their natural values, R(a) for the sum of a(i), and P(a) for the "
                    + "product of a(i)+1. S(A,a,t) consists of pairs (h,b) with h in Fin(A+1), "
                    + "b in B(a), and val(h)+s(b)=t. Its actual cardinality is r(A,a,t). "
                    + "The map d(A,a,t) deletes the head; head(x) denotes its natural value. "
                    + "Subtraction is natural subtraction. No comparison of A and R(a) is "
                    + "assumed unless displayed. The empty tail type is a formal extension: "
                    + "its box has one element, and saturation reduces to 0<=t<=A. "
                    + "For the specialization c=(2,1,1), I=Fin(3). In the generating-function "
                    + "identity, X is the indeterminate of the polynomial semiring over the "
                    + "natural numbers, and [X^t] denotes coefficient extraction.")),
            Entry("head-recovery", "time_slice_head_eq", "The head is forced by the tails",
                General(ForAll([Bound("x", Slice())],
                    Equal(Call("head", F.Id("x")), Sub(F.Id("t"), Call("s", Deleted(F.Id("x"))))))),
                "The slice equation determines the head by cancellation. Its existence "
                    + "also ensures that the tail sum does not exceed the time."),
            Entry("head-deletion-injective", "forget_head_injective", "Head deletion is injective",
                General(Call("Injective", Deletion())),
                "Two states with the same tails have the same recovered head and therefore "
                    + "are equal as bounded vectors."),
            Entry("head-deletion-surjective", "forget_head_surjective_iff",
                "All tails extend exactly on the plateau",
                General(Equivalent(Call("Surjective", Deletion()), Interval())),
                "Surjectivity applied to the maximal tail forces R(a) at most t; applied "
                    + "to the zero tail it forces t at most A. Conversely s(b) is at most "
                    + "R(a), and the head t-s(b) is proved to lie in Fin(A+1) and to satisfy "
                    + "the fixed-sum equation."),
            Entry("slice-cardinality-bound", "time_slice_count_le", "The tail box bounds every slice",
                General(AtMost(Count(), Product())),
                "The injection into the tail box and the cardinality of a finite dependent "
                    + "product give this bound on the actual slice subtype."),
            Entry("slice-count-generating-function", "time_slice_count_eq_coeff",
                "Polynomial coefficients count bounded slices",
                General(Equal(Count(), CoefficientCount())),
                "The product of finite geometric sums expands over the bounded tail "
                    + "coordinates. Multiplication by a head monomial adds the head to the "
                    + "tail sum, and extraction of coefficient t selects exactly the "
                    + "fixed-sum subtype. The proof composes Mathlib's dependent "
                    + "product-of-sums, polynomial coefficient, and finite cardinality "
                    + "identities. It applies to every natural capacity vector and time."),
            Entry("plateau-saturation-iff", "time_slice_plateau_iff", "Exact saturation criterion",
                General(Equivalent(Equal(Count(), Product()), Interval())),
                "An injection between finite types has equal cardinalities precisely when "
                    + "it is surjective. The criterion holds even when A is smaller than R(a)."),
            Entry("source-domain-plateau-iff", "time_slice_plateau_iff_of_tail_le_head",
                "Saturation under the source capacity condition",
                General(Implies(AtMost(Total(), F.Id("A")),
                    Equivalent(Equal(Count(), Product()), Interval()))),
                "The source introduces its plateau criterion under R(a)<=A. This named "
                    + "specialization retains that applicability condition and follows "
                    + "directly from the general saturation criterion."),
            Entry("strict-bound-outside-plateau", "time_slice_strict_lt_iff",
                "The bound is strict outside the plateau",
                General(Equivalent(Less(Count(), Product()),
                    Or(Less(F.Id("t"), Total()), Less(F.Id("A"), F.Id("t"))))),
                "Outside the interval at least one tail cannot extend. The slice cardinality "
                    + "is consequently strictly below the full tail count."),
            Entry("plateau-trichotomy", "time_slice_plateau_trichotomy", "Three capacity regimes",
                Trichotomy(),
                "If R(a)<A, the distinct times R(a) and A both attain P(a), and the exact "
                    + "criterion identifies all the intervening maximizing times. If A=R(a), "
                    + "the unique maximizing time is R(a). If A<R(a), every slice is strictly "
                    + "smaller than P(a). The first two are global maxima by the universal bound."),
            Entry("source-domain-capacity-regimes", "time_slice_plateau_trichotomy_of_head_maximal",
                "Three regimes with a longest head chain",
                Trichotomy(requireMaximalHead: true),
                "The source names the distinguished head as a longest chain. This "
                    + "specialization retains every tail capacity at most A, including "
                    + "in the regime A<R(a), and follows from the general trichotomy."),
            Entry("zero-after-total-capacity", "time_slice_count_eq_zero_of_total_lt",
                "Slices vanish after total capacity",
                General(Implies(Less(Add(F.Id("A"), Total()), F.Id("t")), Equal(Count(), D(0)))),
                "Every head is at most A and every tail sum is at most R(a), so the subtype "
                    + "is empty when its requested sum exceeds A+R(a)."),
            Entry("capacity-data-for-5040", "time_slice_5040_capacities", "The 5040 capacity data",
                And(Equal(D(5, 0, 4, 0), Seq(D(2), Caret, Grp(D(4)), Sp, Cdot, Sp,
                        D(3), Caret, Grp(D(2)), Sp, Cdot, Sp, D(5), Sp, Cdot, Sp, D(7))),
                    And(Equal(Call("R", F.Id("c")), D(4)), Equal(Call("P", F.Id("c")), D(1, 2)))),
                "The head capacity is 4, for prime 2. The tail capacities are 2, 1, 1, "
                    + "for primes 3, 5, 7. They total 4 and have 12 bounded combinations."),
            Entry("complete-sequence-for-5040", "time_slice_5040_sequence", "All nine slice counts",
                Sequence(),
                "The general coefficient identity rewrites each actual slice count. "
                    + "The proof then expands the independent polynomial "
                    + "(1+X+X^2+X^3+X^4)(1+X+X^2)(1+X)^2 and extracts its nine "
                    + "coefficients. The cardinality definition is unchanged. The universal "
                    + "maximum theorem below is derived from the general plateau criterion."),
            Entry("zero-after-eight-for-5040", "time_slice_5040_zero_after_eight",
                "There are no later nonzero slices",
                ForAll([Bound("t", Naturals())],
                    Implies(Less(D(8), F.Id("t")), Equal(Count5040(F.Id("t")), D(0)))),
                "Total capacity is 8, so the nine displayed counts exhaust every possibly "
                    + "nonzero slice."),
            Entry("unique-maximum-for-5040", "time_slice_5040_unique_maximum",
                "The unique global maximum is 12 at time 4",
                ForAll([Bound("t", Naturals())], And(AtMost(Count5040(F.Id("t")), D(1, 2)),
                    Equivalent(Equal(Count5040(F.Id("t")), D(1, 2)), Equal(F.Id("t"), D(4))))),
                "Head capacity and total tail capacity both equal 4, so the plateau is "
                    + "a singleton. This declaration is intended for the later "
                    + "history_5040_max_schmidt_rank theorem in the coherent-history layer; "
                    + "that later theorem is not established here."),
            Entry("all-tails-extend-for-5040", "time_slice_5040_tail_extension",
                "Each of the twelve tails has one legal head at time four",
                TailExtension(),
                "For every b with b(0)<=2, b(1)<=1 and b(2)<=1, the sum s(b) is at most 4. "
                    + "The unique head is 4-s(b). Thus the distinguished time follows from "
                    + "the capacity equality and simultaneous legal extension of all tails."))));

    private static DocumentBlock.Describe Entry(
        string id, string declaration, string title, Formula formula, string explanation) =>
        Describe.Lean(DescribeId.Create(id), DeclarationHandle.Create(Prefix + declaration),
            H(title), StatementSource.FromAuthor(Disp(formula)), AssessedProvenance.FromRepo(),
            Blocks(Paragraph(Text(explanation))), DescribeRole.Theorem);

    private static Formula Trichotomy(bool requireMaximalHead = false)
    {
        Formula a = F.Id("A");
        Formula t = F.Id("t");
        Formula r = Total();
        Formula p = Product();
        Formula multiple = Implies(Less(r, a), And(Different(r, a),
            And(Equal(Call("r", a, F.Id("a"), r), p), Equal(Call("r", a, F.Id("a"), a), p))));
        Formula unique = Implies(Equal(a, r), ForAll([Bound("t", Naturals())],
            And(AtMost(Count(), p), Equivalent(Equal(Count(), p), Equal(t, r)))));
        Formula absent = Implies(Less(a, r), ForAll([Bound("t", Naturals())], Less(Count(), p)));
        Formula body = And(multiple, And(unique, absent));
        if (requireMaximalHead)
            body = Implies(ForAll([Bound("i", F.Id("I"))],
                AtMost(Call("a", F.Id("i")), a)), body);
        return ForAll([Bound("A", Naturals()), Bound("a", Capacities())],
            body);
    }

    private static Formula Sequence() => Equal(
        Seq(Open, Count5040(D(0)), Comma, Count5040(D(1)), Comma, Count5040(D(2)), Comma,
            Count5040(D(3)), Comma, Count5040(D(4)), Comma, Count5040(D(5)), Comma,
            Count5040(D(6)), Comma, Count5040(D(7)), Comma, Count5040(D(8)), Close),
        Seq(Open, D(1), Comma, D(4), Comma, D(8), Comma, D(1, 1), Comma, D(1, 2), Comma,
            D(1, 1), Comma, D(8), Comma, D(4), Comma, D(1), Close));

    private static Formula CoefficientCount() => Seq(
        OpenBracket, F.Id("X"), Caret, Grp(F.Id("t")), CloseBracket,
        Open, GeometricSum("h", F.Id("A")), Sp, Cdot, Sp,
        Prod, Underscore, Grp(Seq(F.Id("i"), Sp, InMacro, Sp, F.Id("I"))), Sp,
        GeometricSum("k", Call("a", F.Id("i"))), Close);

    private static Formula GeometricSum(string index, Formula capacity) => Seq(
        Open, Sum, Underscore, Grp(Equal(F.Id(index), D(0))), Caret, Grp(capacity), Sp,
        F.Id("X"), Caret, Grp(F.Id(index)), Close);

    private static Formula TailExtension() => ForAll([Bound("b", Call("B", F.Id("c")))],
        Seq(Exists, Bang, Sp, F.Id("h"), Sp, InMacro, Sp, Call("Fin", D(5)), Comma, Sp,
            Open, And(Equal(Add(Call("val", F.Id("h")), Call("s", F.Id("b"))), D(4)),
                Equal(Call("val", F.Id("h")), Sub(D(4), Call("s", F.Id("b"))))), Close));

    private static Formula General(Formula body) => ForAll(
        [Bound("A", Naturals()), Bound("a", Capacities()), Bound("t", Naturals())], body);

    private static Formula Slice() => Call("S", F.Id("A"), F.Id("a"), F.Id("t"));
    private static Formula Count() => Call("r", F.Id("A"), F.Id("a"), F.Id("t"));
    private static Formula Deletion() => Call("d", F.Id("A"), F.Id("a"), F.Id("t"));
    private static Formula Deleted(Formula x) => new Formula.Apply(Deletion(), [x]);
    private static Formula Total() => Call("R", F.Id("a"));
    private static Formula Product() => Call("P", F.Id("a"));
    private static Formula Interval() => And(AtMost(Total(), F.Id("t")), AtMost(F.Id("t"), F.Id("A")));
    private static Formula Count5040(Formula t) => Call("r", D(4), F.Id("c"), t);
    private static Formula Naturals() => Seq(Mathbb, Grp(F.Id("N")));
    private static Formula Capacities() => Seq(Naturals(), Caret, Grp(F.Id("I")));
    private static Formula Add(Formula x, Formula y) => Seq(x, Sp, Plus, Sp, y);
    private static Formula Sub(Formula x, Formula y) => Seq(x, Sp, Minus, Sp, y);
    private static Formula Call(string name, params Formula[] arguments) =>
        new Formula.Apply(F.Id(name), [.. arguments]);
    private static Formula.BoundVariable Bound(string name, Formula domain) =>
        new(FormulaIdentifier.Create(name), domain);
    private static Formula ForAll(Formula.BoundVariable[] variables, Formula body) =>
        new Formula.BindMany(FormulaQuantifier.ForAll, [.. variables], body);
    private static Formula Equal(Formula x, Formula y) =>
        new Formula.Relation(x, FormulaRelationOperator.Equal, y);
    private static Formula Different(Formula x, Formula y) =>
        Seq(x, Sp, Neq, Sp, y);
    private static Formula AtMost(Formula x, Formula y) =>
        new Formula.Relation(x, FormulaRelationOperator.LessThanOrEqual, y);
    private static Formula Less(Formula x, Formula y) =>
        new Formula.Relation(x, FormulaRelationOperator.LessThan, y);
    private static Formula And(Formula x, Formula y) =>
        new Formula.Logic(x, FormulaLogicOperator.And, y);
    private static Formula Or(Formula x, Formula y) =>
        new Formula.Logic(x, FormulaLogicOperator.Or, y);
    private static Formula Equivalent(Formula x, Formula y) =>
        new Formula.Logic(x, FormulaLogicOperator.Iff, y);
    private static Formula Implies(Formula x, Formula y) =>
        new Formula.Logic(x, FormulaLogicOperator.Implies, y);
}
