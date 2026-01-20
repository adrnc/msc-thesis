%%% SIDES %%%

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% VALUE TRANSLATION %%%

has_mf(R, D) :- mf(R, D, P).

ival(reduct(C), D, P) :- case(C, S), mf(C, D, P).
ival(reduct(C), D, P) :- case(C, S), val(C, D, P), not has_mf(C, D).

ival(reason(C), D, P) :- case(C, S), mf(C, D, P).

ival(F, D, P) :- focus_case(F), val(F, D, P).

%%% VALUE RELATION %%%

ord(S, D, P, Q) :-
    ival(C, D, P), ival(C', D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% HELPERS %%%

item(C) :- ival(C, D, P).
has_ival(C, D) :- ival(C, D, P).

-domain_subseteq(C, C') :-
    has_ival(C, D), item(C'), not has_ival(C', D).

-domain_disjoint(C, C') :-
    has_ival(C, D), has_ival(C', D).

-dims_leq(S, C, C') :-
    ival(C, D, P), ival(C', D, Q),
    ord(S, D, Q, P), P != Q.

%%% POOL %%%

pooled(reduct(C), S) :- case(C, S).
pooled(reason(C), S) :- case(C, S).

%%% PRUNE %%%

pruned(C', S) :-
    pooled(C, S), pooled(C', S), C < C',
    not -domain_subseteq(C, C'),
    not -domain_subseteq(C', C),
    not -dims_leq(S, C, C').

%%% RESIDUALS %%%

pooled(residual(C', C), S) :-
    pooled(C', S'), pooled(C, S), opposite(S, S'),
    not pruned(C', S'), not pruned(C, S),
    not -domain_subseteq(C', C), not -dims_leq(S, C, C'),
    not has_ival(C', D), has_ival(C, D).

ival(residual(C', C), D, P) :-
    pooled(residual(C', C), S),
    not has_ival(C', D), ival(C, D, P).

%%% GENERATE UNION CASES %%%

fixpoint(C, S) :- pooled(C, S), not pruned(C, S).

ground_partial_precedent(C, S, F) :-
    fixpoint(C, S), focus_case(F),
    not -domain_subseteq(C, F),
    not -dims_leq(S, C, F).

partial_precedent(union(C, C'), S, F) :-
    ground_partial_precedent(C, S, F),
    ground_partial_precedent(C', S, F),
    C < C', not -domain_disjoint(C, C').

partial_precedent(union(union(C1, C2), C3), S, F) :-
    partial_precedent(union(C1, C2), S, F),
    ground_partial_precedent(C3, S, F),
    C2 < C3, not -domain_disjoint(union(C1, C2), C3).

ival(union(C, C'), D, P) :- partial_precedent(union(C, C'), S, F), ival(C, D, P).
ival(union(C, C'), D, P) :- partial_precedent(union(C, C'), S, F), ival(C', D, P).

-precedent(C, S, F) :-
    partial_precedent(C, S, F),
    has_ival(F, D), not has_ival(C, D).

constraint(F, S) :-
    partial_precedent(C, S, F),
    not -precedent(C, S, F).

%%% EXAMPLE %%%

strengthens(d1, defendant).
strengthens(d2, defendant).

case(c1, defendant).
val(c1, d1, 20). mf(c1, d1, 10).

case(c2, defendant).
val(c2, d2, 20). mf(c2, d2, 10).

focus_case(c3).
val(c3, d1, 15). val(c3, d2, 15).
