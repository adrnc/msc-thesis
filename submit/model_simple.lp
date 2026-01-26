%%% DEFINE SIDES %%%

side(plaintiff).
side(defendant).

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% REDUCE CASE BASE %%%

rval(C, D, P) :- val(C, D, P), not mf(C, D, _).
rval(C, D, P) :- mf(C, D, P).

%%% INFER VALUE RELATION %%%

ord(S, D, P, Q) :-
    rval(_, D, P), rval(_, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% COMPARE FACT SITUATIONS %%%

missing_dim(X, Y) :-
    rval(X, _, _), rval(Y, D, _), not rval(X, D, _).

subseteq(X, Y) :-
    rval(X, _, _), rval(Y, _, _),
    not missing_dim(Y, X).

worse_on_dim(S, X, Y) :-
    rval(X, D, P), rval(Y, D, Q),
    ord(S, D, P, Q), P != Q.

leq(S, X, Y) :-
    side(S), rval(X, _, _), rval(Y, _, _),
    not worse_on_dim(S, Y, X).

%%% MODEL CONSTRAINT %%%

1 { constraint(F, S) : focus_case(F), side(S) } 1.

candidate(C, S, F) :-
    constraint(F, S), case(C, S),
    subseteq(C, F), leq(S, C, F).

pruned(C, S, F) :-
    candidate(C, S, F), candidate(C', S, F),
    C != C', subseteq(C, C').

1 { precedent(C, S, F) : candidate(C, S, F), not pruned(C, S, F) } 1
    :- constraint(F, S), candidate(_, S, F).

covered(F, S, D) :-
    precedent(C, S, F), rval(C, D, _).

resolved(F, S, D) :-
    % TODO: check with SAT solving
    constraint(C, S), rval(F, D, _),
    not covered(F, S, D).

:-
    constraint(F, S), rval(F, D, _),
    not covered(F, S, D), not resolved(F, S, D).
