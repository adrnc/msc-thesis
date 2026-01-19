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

%%% GENERATE INITIAL POOL OF CASES %%%

has_rval(C, D) :- rval(C, D, P).

-outcome_flip_pair(C, S, C', S') :-
    rcase(C, S), rcase(C', S'), opposite(S, S'),
    has_rval(C, D), not has_rval(C', D).

-outcome_flip_pair(C, S, C', S') :-
    rcase(C, S), rcase(C', S'), opposite(S, S'),
    rval(C, D, P), rval(C', D, Q),
    not ord(S', D, Q, P).

residual_pair(C, C', S') :-
    rcase(C, S), rcase(C', S'), opposite(S, S'),
    not has_rval(C, D), has_rval(C', D),
    not -outcome_flip_pair(C, S, C', S').

pool_rcase(residual(C, C'), S') :-
    residual_pair(C, C', S').

pool_rval(residual(C, C'), D, P) :-
    residual_pair(C, C', S'),
    not has_rval(C, D), rval(C', D, P).

pool_rcase(C, S) :- rcase(C, S).
pool_rval(C, D, P) :- rval(C, D, P).

%%% ADD POOL CASES %%%



%%% PRUNE POOL CASES %%%

has_pool_rval(C, D) :- pool_rval(C, D, P).

-are_domains_identical(C, C', S) :-
    pool_rcase(C, S), pool_rcase(C', S), C != C',
    has_pool_rval(C, D), not has_pool_rval(C', D).

-are_domains_identical(C, C', S) :-
    pool_rcase(C, S), pool_rcase(C', S), C != C',
    not has_pool_rval(C, D), has_pool_rval(C', D).

-are_all_dims_stronger(C, C', S) :-
    pool_rcase(C, S), pool_rcase(C', S), C != C',
    pool_rval(C, D, P), pool_rval(C', D, Q),
    not ord(S, D, P, Q).

pruned_rcase(C, S) :-
    pool_rcase(C, S), pool_rcase(C', S), C != C',
    not -are_domains_identical(C, C', S),
    not -are_all_dims_stronger(C, C', S).

precedent_rcase(C, S) :-
    pool_rcase(C, S), not pruned_rcase(C, S).
