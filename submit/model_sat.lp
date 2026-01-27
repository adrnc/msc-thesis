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

1 { supports(S, D, P) : rval(C, D, P) } 1 :- case(C, S).

%1 { supports(S, D, P) : side(S) } 1 :- case(C, _), rval(C, D, P).

supports(S, D, Q) :- supports(S, D, P), ord(S, D, P, Q).

:- supports(S, D, P), supports(S', D, P), opposite(S, S').

%%% MODEL CONSTRAINT %%%

precedent(F, C, S) :-
    focus_case(F), case(C, S),
    #count {
        D : rval(C, D, _), not rval(F, D, _);
        D : rval(C, D, P), rval(F, D, Q), ord(S, D, Q, P), P != Q
    } == 0.

% empty precedent
precedent(F, empty, S) :- focus_case(F), side(S).

covered(F, C, S, D) :- precedent(F, C, S), rval(C, D, _).

covered(F, C, S, D) :-
    precedent(F, C, S), rval(F, D, P), supports(S, D, P).

constraint(F, S) :-
    precedent(F, C, S),
    #count { D : rval(F, D, _), not covered(F, C, S, D) } == 0.
