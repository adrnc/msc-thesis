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
