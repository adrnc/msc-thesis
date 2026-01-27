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

%%% SAT SOLVING %%%

1 { supports(S, D, P) : rval(C, D, P) } :- case(C, S).

1 { supports(S, D, P) : side(S) } 1 :- case(C, _), rval(C, D, P).

supports(S, D, Q) :- supports(S, D, P), ord(S, D, P, Q).

:-
    supports(S, D, P), supports(S', D, Q),
    opposite(S, S'), ord(S, D, P, Q).

%%% MODEL CONSTRAINT %%%

constraint(F, S) :-
    focus_case(F), side(S),
    0 == #count { D : rval(F, D, P), not supports(S, D, P) }.
