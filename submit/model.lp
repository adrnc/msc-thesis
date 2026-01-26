%%% DEFINE SIDES %%%

side(plaintiff).
side(defendant).

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% RESTRICT GROUNDING OF SETS %%%

usize(1..N) :- dim_count(N).

uset(reduct(C), S, N) :- case(C, S), usize(N), N = #count { D : val(C, D, _) }.
uset(reason(C), S, N) :- case(C, S), usize(N), N = #count { D : mf(C, D, _) }.

uset(residual(X, Y), S, K) :-
    uset(X, S', M), uset(Y, S, N), opposite(S, S'),
    M < N, K = N - 1, usize(K).

set(F) :- focus_case(F).
set(X) :- uset(X, _, _).

%%% INFER VALUE RELATION %%%

ord(S, D, P, Q) :-
    val(_, D, P), val(_, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% ADD DOMAIN COMPARISONS %%%

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

%%% INITIALISE POOLS %%%

pooled(reduct(C), S) :- case(C, S).
val(reduct(C), D, P) :- case(C, S), mf(C, D, P).
val(reduct(C), D, P) :- case(C, S), val(C, D, P), not mf(C, D, _).

pooled(reason(C), S) :- case(C, S).
val(reason(C), D, P) :- case(C, S), mf(C, D, P).

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

val(residual(X, Y), D, P) :-
    pooled(residual(X, Y), S),
    not val(X, D, _), val(Y, D, P).

%%% CHECK CONSTRAINT %%%

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
