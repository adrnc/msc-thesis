%%% SIDES %%%

side(plaintiff). side(defendant).
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
    ival(X, D, P), ival(Y, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% POOL %%%

pooled(reduct(C), S) :- case(C, S).
pooled(reason(C), S) :- case(C, S).

%%% DOMAIN COMPARISONS %%%

iset(X) :- ival(X, D, P).

has_ival(X, D) :- ival(X, D, P).

-domain_subseteq(X, Y) :-
    has_ival(X, D), iset(Y), not has_ival(Y, D).

-domain_disjoint(X, Y) :-
    has_ival(X, D), has_ival(Y, D).

-dims_leq(S, X, Y) :-
    ival(X, D, P), ival(Y, D, Q),
    ord(S, D, Q, P), P != Q.

%%% PRUNE POOLS %%%

pruned(Y, S) :-
    pooled(X, S), pooled(Y, S), X < Y,
    not -domain_subseteq(X, Y),
    not -domain_subseteq(Y, X),
    not -dims_leq(S, X, Y).

%%% RESIDUALS %%%

pooled(residual(X, Y), S) :-
    pooled(X, S'), pooled(Y, S), opposite(S, S'),
    not pruned(X, S'), not pruned(Y, S),
    not -domain_subseteq(X, Y), not -dims_leq(S, Y, X),
    not has_ival(X, D), has_ival(Y, D).

ival(residual(X, Y), D, P) :-
    pooled(residual(X, Y), S),
    not has_ival(X, D), ival(Y, D, P).

fixpoint(X, S) :- pooled(X, S), not pruned(X, S).

%%% CONSTRAINT %%%

1 { constraint(F, S) : focus_case(F), side(S) } 1.

potential_precedent(X, S, F) :-
    fixpoint(X, S), constraint(F, S),
    not -domain_subseteq(X, F),
    not -dims_leq(S, X, F).

1 { precedent(X, S, F) : potential_precedent(X, S, F) }.

:-
    precedent(X, S, F), precedent(Y, S, F),
    X != Y, -domain_disjoint(X, Y).

ival_covered(F, D, S) :-
    precedent(X, S, F), has_ival(X, D).

:-
    constraint(F, S), has_ival(F, D),
    not ival_covered(F, D, S).

%%% EXAMPLE %%%

strengthens(d1, defendant).
strengthens(d2, defendant).

case(c1, defendant).
val(c1, d1, 20). mf(c1, d1, 10).

case(c2, defendant).
val(c2, d2, 20). mf(c2, d2, 10).

focus_case(c3).
val(c3, d1, 15). val(c3, d2, 15).

#show constraint/2.
