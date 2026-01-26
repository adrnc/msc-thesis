%%% DEFINE SIDES %%%

side(plaintiff).
side(defendant).

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% INFER VALUE RELATION %%%

ord(S, D, P, Q) :-
    val(_, D, P), val(_, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% GENERATE FACTS FROM CASES %%%

fcase(reduct(C)) :- case(C).
val(reduct(C), D, P) :- case(C, _), val(C, D, P), not mf(C, D, _).
val(reduct(C), D, P) :- case(C, _), mf(C, D, P).

fcase(reason(C)) :- case(C, S).
val(reason(C), D, P) :- case(C, _), mf(C, D, P).

facts(val(D, P)) :- pcase(C, _), val(C, D, P).
facts(and(val(D, P), val(D', Q))) :- pcase(C, _), val(C, D, P), val(C, D', Q), D < D'.
facts(and(X, val(D', Q))) :- X = and(U, val(D, P)), facts(X), val(C, D', Q), D < D'.

fval(X, D, P) :- facts(X), X = val(D, P).
fval(X, D, P) :- facts(X), X = and(U, val(D, P)).
fval(X, D, P) :- facts(X), X = and(U, _), fval(U, D, P).

missing_facts_dim(C, U) :-
    pcase(C, _), facts(U),
    val(C, D, P), not fval(U, D, P).

missing_case_dim(C, U) :-
    pcase(C, _), facts(U),
    not val(C, D, P), fval(U, D, P).

pooled(U, S) :-
    pcase(C, S), facts(U),
    not missing_case_dim(C, U),
    not missing_facts_dim(C, U).

%%% DOMAIN COMPARISONS %%%

missing_dim(X, Y) :-
    set(X), set(Y),
    val(Y, D, _), not val(X, D, _).

subseteq(X, Y) :-
    set(X), set(Y),
    not missing_dim(Y, X).

worse_on_dim(S, X, Y) :-
    set(X), set(Y),
    val(X, D, P), val(Y, D, Q),
    ord(S, D, P, Q), P != Q.

leq(S, X, Y) :-
    side(S), set(X), set(Y),
    not worse_on_dim(S, Y, X).

%%% PRUNE POOLS %%%

pruned(Y, S) :-
    pooled(X, S), pooled(Y, S),
    X != Y, not pruned(X, S),
    subseteq(X, Y), subseteq(Y, X), leq(S, X, Y).

%%% GENERATE RESIDUALS %%%

pooled(residual(X, Y), S) :-
    pooled(X, S'), pooled(Y, S), opposite(S, S'),
    not pruned(X, S'), not pruned(Y, S),
    subseteq(X, Y), leq(S, Y, X),
    not val(X, D, _), val(Y, D, _).
