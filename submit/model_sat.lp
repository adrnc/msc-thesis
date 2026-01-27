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

%%% SAT SOLVING %%%

1 { supports(S, D, P) : rval(C, D, P) } :- case(C, S).

1 { supports(S, D, P) : side(S) } 1 :- case(C, _), rval(C, D, P).

supports(S, D, Q) :- supports(D, P, S), ord(S, D, P, Q).

:-
    supports(S, D, P), supports(S', D, Q),
    opposite(S, S'), ord(S, D, P, Q).

%%% MODEL CONSTRAINT %%%

% empty precedent
precedent(empty, S, F) :- side(S), focus_case(F).

precedent(C, S, F) :-
    case(C, S), focus_case(F),
    subseteq(C, F), leq(S, C, F).

covered(C, S, F, D) :-
    precedent(C, S, F), rval(C, D, _).

covered(C, S, F, D) :-
    precedent(C, S, F), rval(F, D, P), supports(S, D, P).

constraint(F, S) :-
    precedent(C, S, F),
    0 == #count { D : rval(F, D, _), not covered(C, S, F, D) }.
