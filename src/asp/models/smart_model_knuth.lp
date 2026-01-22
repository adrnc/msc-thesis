%%% SIDES %%%

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% VALUE TRANSLATION %%%

ival(reduct(C), D, P) :- case(C, S), mf(C, D, P).
ival(reduct(C), D, P) :- case(C, S), val(C, D, P), not mf(C, D, _).

ival(reason(C), D, P) :- case(C, S), mf(C, D, P).

ival(F, D, P) :- focus_case(F), val(F, D, P).

%%% VALUE RELATION %%%

ord(S, D, P, Q) :-
    ival(_, D, P), ival(_, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% POOL %%%

pooled(reduct(C), S) :- case(C, S).
pooled(reason(C), S) :- case(C, S).

%%% DOMAIN COMPARISONS %%%

missing_dim(X, Y) :-
    ival(X, _, _), ival(Y, D, _), not ival(X, D, _).

subseteq(X, Y) :-
    ival(X, _, _), ival(Y, _, _),
    not missing_dim(Y, X).

worse_on_dim(S, X, Y) :-
    ival(X, D, P), ival(Y, D, Q),
    ord(S, D, P, Q), P != Q.

leq(S, X, Y) :-
    ival(X, _, _), ival(Y, _, _), opposite(S, _),
    not worse_on_dim(S, Y, X).

%%% PRUNE POOLS %%%

pruned(Y, S) :-
    pooled(X, S), pooled(Y, S), not pruned(X, S),
    subseteq(X, Y), subseteq(Y, X), leq(S, X, Y).

%%% RESIDUALS %%%

pooled(residual(X, Y), S) :-
    pooled(X, S'), pooled(Y, S), opposite(S, S'),
    not pruned(X, S'), not pruned(Y, S),
    subseteq(X, Y), leq(S, Y, X),
    not ival(X, D, _), ival(Y, D, _).

ival(residual(X, Y), D, P) :-
    pooled(residual(X, Y), S),
    not ival(X, D, _), ival(Y, D, P).

%%% CONSTRAINT %%%

1 { constraint(F, S) : focus_case(F), opposite(S, _) } 1.

candidate(X, S, F) :-
    pooled(X, S), not pruned(X, S), constraint(F, S),
    subseteq(X, F), leq(S, X, F).

1 { precedent(X, S, F) : candidate(X, S, F) }.

:-
    precedent(X, S, F), precedent(Y, S, F),
    X != Y, ival(X, D, _), ival(Y, D, _).

dim_covered(F, S, D) :-
    precedent(X, S, F), ival(X, D, _).

:-
    constraint(F, S), ival(F, D, _),
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
