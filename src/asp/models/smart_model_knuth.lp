%%% SIDES %%%

side(plaintiff). side(defendant).
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% INITIALISE POOLS %%%

pooled(reduct(C), S) :- case(C, S).
val(reduct(C), D, P) :- case(C, S), mf(C, D, P).
val(reduct(C), D, P) :- case(C, S), val(C, D, P), not mf(C, D, _).

pooled(reason(C), S) :- case(C, S).
val(reason(C), D, P) :- case(C, S), mf(C, D, P).

%%% VALUE RELATION %%%

ord(S, D, P, Q) :-
    val(_, D, P), val(_, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% DOMAIN COMPARISONS %%%

missing_dim(X, Y) :-
    val(X, _, _), val(Y, D, _), not val(X, D, _).

subseteq(X, Y) :-
    val(X, _, _), val(Y, _, _),
    not missing_dim(Y, X).

worse_on_dim(S, X, Y) :-
    val(X, D, P), val(Y, D, Q),
    ord(S, D, P, Q), P != Q.

leq(S, X, Y) :-
    val(X, _, _), val(Y, _, _), opposite(S, _),
    not worse_on_dim(S, Y, X).

%%% PRUNE POOLS %%%

pruned(Y, S) :-
    pooled(X, S), pooled(Y, S), not pruned(X, S), X != Y,
    subseteq(X, Y), subseteq(Y, X), leq(S, X, Y).

%%% RESIDUALS %%%

pooled(residual(X, Y), S) :-
    pooled(X, S'), pooled(Y, S), opposite(S, S'),
    not pruned(X, S'), not pruned(Y, S),
    subseteq(X, Y), leq(S, Y, X),
    not val(X, D, _), val(Y, D, _).

val(residual(X, Y), D, P) :-
    pooled(residual(X, Y), S),
    not val(X, D, _), val(Y, D, P).

%%% CONSTRAINT %%%

1 { constraint(F, S) : focus_case(F), side(S) } 1.

candidate(X, S, F) :-
    pooled(X, S), not pruned(X, S), constraint(F, S),
    subseteq(X, F), leq(S, X, F).

1 { precedent(X, S, F) : candidate(X, S, F) }.

:-
    precedent(X, S, F), precedent(Y, S, F),
    X != Y, val(X, D, _), val(Y, D, _).

dim_covered(F, S, D) :-
    precedent(X, S, F), val(X, D, _).

:-
    constraint(F, S), val(F, D, _),
    not dim_covered(F, S, D).

%%% EXAMPLE %%%

strengthens(d1, defendant).
strengthens(d2, defendant).

case(c1, defendant).
val(c1, d1, 20). mf(c1, d1, 10).

case(c2, defendant).
val(c2, d1, 20). mf(c2, d1, 10).
val(c2, d2, 20). mf(c2, d2, 10).

focus_case(c3).
val(c3, d1, 15). val(c3, d2, 15).

#show constraint/2.
