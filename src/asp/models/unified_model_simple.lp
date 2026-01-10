%%% SIDES %%%

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% VALUE TRANSLATION %%%

has_mf(C, D) :- mf(C, D, P).

rval(C, D, P) :- mf(C, D, P).
rval(C, D, P) :- val(C, D, P), not has_mf(C, D).

%%% VALUE RELATION %%%

ord(S, D, P, Q) :-
    rval(C, D, P), rval(C', D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% CONSTRAINT RELATION %%%

has_rval(C, D) :- rval(C, D, P).

-dim_domain_is_subset(C, S, F) :-
    case(C, S), focus_case(F),
    has_rval(C, D), not has_rval(F, D).

-all_dims_are_weaker_or_equal(C, S, F) :-
    case(C, S), focus_case(F),
    rval(C, D, P), rval(F, D, Q),
    not ord(S, D, P, Q).

dim_constraint(F, D, S) :-
    case(C, S), focus_case(F), has_rval(C, D),
    not -dim_domain_is_subset(C, S, F),
    not -all_dims_are_weaker_or_equal(C, S, F).

dim_constraint(F, D, S) :-
    focus_case(F), rval(F, D, P),
    max_val(D, S, M), P = M.

permission(F, S) :-
    focus_case(F), opposite(S, S'),
    has_rval(F, D), not dim_constraint(F, S', D).

constraint(F, S')
    focus_case(F), opposite(S, S'),
    not permission(F, S).
