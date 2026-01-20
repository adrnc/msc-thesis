%%% SIDES %%%

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% VALUE TRANSLATION %%%

has_mf(R, D) :- mf(R, D, P).

rcase(case(C), S) :- case(C, S).
rval(case(C), D, P) :- mf(R, D, P).
rval(case(C), D, P) :- val(C, D, P), not has_mf(R, D).

rcase(reason(C), S) :- case(C, S).
rval(reason(C), D, P) :- mf(C, D, P).

%%% VALUE RELATION %%%

ord(S, D, P, Q) :-
    rval(C, D, P), rval(C', D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% HELPERS %%%

has_rval(C, D) :- rval(C, D, P).

-domain_subseteq(C, C') :-
    has_rval(C, D), not has_rval(C', D).

-dims_leq(S, C, C') :-
    rval(C, D, P), rval(C', D, Q),
    opposite(S, S'), not ord(S, D, P, Q).

%%% PRUNE CASES %%%

pruned_rcase(C', S) :-
    rcase(C, S), rcase(C', S), C != C',
    not -domain_subseteq(C, C'),
    not -domain_subseteq(C', C),
    not -dims_leq(S, C, C').

%%% GENERATE RESIDUALS %%%

rcase(residual(C', C), S) :-
    rcase(C', S'), rcase(C, S), opposite(S, S'),
    not pruned_rcase(C', S'), not pruned_rcase(C, S),
    not -domain_subseteq(C', C), not -dims_leq(S, C, C'),
    not has_rval(C', D), has_rval(C, D).

rval(residual(C', C), D, P) :-
    rcase(residual(C', C), S),
    not has_rval(C', D), rval(C, D, P).

%%% FILTER PRECEDENT CASES %%%

fixed_rcase(C, S) :-
    rcase(C, S), not pruned_rcase(C, S).
