%%% SIDES %%%

side(plaintiff). side(defendant).
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% VALUE RELATION %%%

dim_range(D, P) :- val(C, D, P).
dim_range(D, P) :- mf(C, D, P).

ord(S, D, P, Q) :-
    dim_range(D, P), dim_range(D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% VALUE TRANSLATION %%%

has_mf(C, D) :- mf(C, D, P).

rval(C, D, P) :- mf(C, D, P).
rval(C, D, P) :- val(C, D, P), not has_mf(C, D).

%%% CONSTRAINT RELATION %%%

test_pair(T, C, S) :- test_case(T), case(C, S), T != C.

has_dim(C, D) :- rval(C, D, P).

-domain_superset_or_equal(T, C, S) :-
    test_pair(T, C, S), has_dim(C, D), not has_dim(T, D).

-dims_stronger_or_equal(T, C, S) :-
    test_pair(T, C, S), rval(C, D, P), rval(T, D, Q),
    not ord(S, D, P, Q).

dim_constraint(T, S, D) :-
    test_pair(T, C, S), has_dim(C, D),
    not -domain_superset_or_equal(T, C, S),
    not -dims_stronger_equal(T, C, S).

-constraint(T, S) :-
    test_case(T), side(S),
    has_dim(T, D), not dim_constraint(T, S, D).

permission(T, S) :-
    test_case(T), opposite(S, S'),
    -constraint(T, S').

%%% CONSISTENCY %%%

test_case(C) :- case(C, S).

case_consistent(C, S) :- case(C, S), permission(C, S).

-case_base_consistent :-
    case(C, S), not case_consistent(C, S).

%%% DECISION CONSTRAINTS %%%

test_case(C) :- focus_case(C).

decision_permission(C, S) :-
    focus_case(C), permission(C, S),
    not -case_base_consistent.
