%%% SIDES %%%

opposite_side(plaintiff, defendant).
opposite_side(S2, S1) :- opposite_side(S1, S2).

%%% DIMENSION VALUE RELATION %%%

dimension_value(D, P) :- reason_magnitude(C, D, P).
dimension_value(D, P) :- dimensional_fact(C, D, P).

value_relation(S, D, P, Q) :-
    dimension_strengthens(D, S),
    dimension_value(D, P), dimension_value(D, Q),
    P <= Q.

value_relation(S2, D, Q, P) :- value_relation(S1, D, P, Q), opposite(S1, S2).

%%% CHECK CONSISTENCY OF CASE SPACE %%%

not_case_entails_reason_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite_side(S1, S2),
    reason_magnitude(C2, D, P), dimensional_fact(C1, D, Q),
    not value_relation(S2, D, P, Q).

not_case_entails_reason(C1, C2) :- not_case_entails_reason_magnitude(C1, C2, D).

not_cases_consistent(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite_side(S1, S2),
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

not_case_base_consistent :- not_cases_consistent(C1, C2).

%%% RESOLVE NEW CASE %%%

1 { case_proposal(C, S1) : opposite_side(S1, S2) } 1 :- unsolved_case(C), not not_case_base_consistent.

reason_magnitude_iteration(0, C, D, Q) :- case_proposal(C, S), dimensional_fact(C, D, Q).

%%% OUTPUT %%%