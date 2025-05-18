%%% SIDES %%%

opposite_side(plaintiff, defendant).
opposite_side(S2, S1) :- opposite_side(S1, S2).

%%% DIMENSION HELPERS %%%

dimension_value(D, P) :- reason_magnitude(C, D, P).
dimension_value(D, P) :- dimensional_fact(C, D, P).

dimension_sign(D, S, 1) :- dimension_strengthens(D, S).
dimension_sign(D, S2, -1) :- dimension_strengthens(D, S1), opposite_side(S1, S2).

%%% DIMENSION VALUE RELATION %%%

value_relation(S, D, P, Q) :-
    dimension_strengthens(D, S),
    dimension_value(D, P), dimension_value(D, Q),
    P <= Q.

value_relation(S2, D, Q, P) :- value_relation(S1, D, P, Q), opposite_side(S1, S2).

strict_value_relation(S, D, P, Q) :- value_relation(S, D, P, Q), P != Q.

distant_value_relation(S, D, P, R) :- strict_value_relation(S, D, P, Q), strict_value_relation(S, D, Q, R).

neighbour_value_relation(S, D, P, Q) :- strict_value_relation(S, D, P, Q), not distant_value_relation(S, D, P, Q).

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

%%% RESOLVE NEW CASE WITH STRONGEST REASON AND CHECK CONSISTENCY %%%

1 { case_proposal(C, S1) : opposite_side(S1, S2) } 1 :- unsolved_case(C), not not_case_base_consistent.

reason_magnitude_strongest_proposal(C, D, P) :- case_proposal(C, S), dimensional_fact(C, D, P).

not_case_strongest_proposal_entails_reason(C1, C2) :-
    case_proposal(C1, S1), case(C2, S2), opposite_side(S1, S2),
    reason_magnitude(C2, D, P), dimensional_fact(C1, D, Q),
    not value_relation(S2, D, P, Q).

not_case_entails_reason_strongest_proposal(C1, C2) :-
    case(C1, S1), case_proposal(C2, S2), opposite_side(S1, S2),
    reason_magnitude_strongest_proposal(C2, D, P), dimensional_fact(C1, D, Q),
    not value_relation(S2, D, P, Q).

:-
    case_proposal(C1, S1), case(C2, S2), opposite_side(S1, S2),
    not not_case_strongest_proposal_entails_reason(C1, C2),
    not not_case_entails_reason_strongest_proposal(C2, C1).

%%% SEARCH FOR SAFE WEAKER REASONS %%%

case_proposal_potential_conflict(C1, C2) :-
    case_proposal(C1, S1), case(C2, S2), opposite_side(S1, S2),
    not not_case_strongest_proposal_entails_reason(C1, C2).

reason_magnitude_safe_proposal(C1, D, P) :-
    case_proposal(C1, S1),
    reason_magnitude_strongest_proposal(C1, D, Q),
    value_relation(S1, D, P, Q),
    dimension_sign(D, S1, F),
    P = #max { F * V2 :
        case_proposal_potential_conflict(C1, C2),
        dimensional_fact(C2, D, V1),
        neighbour_value_relation(S1, D, V1, V2) }.

%%% OUTPUT %%%

#show case_proposal/2.
%#show reason_magnitude_strongest_proposal/3.
#show reason_magnitude_safe_proposal/3.