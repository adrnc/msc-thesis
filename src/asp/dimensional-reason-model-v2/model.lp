%%% SIDES %%%

opposite_side(plaintiff, defendant).
opposite_side(S2, S1) :- opposite_side(S1, S2).

%%% DIMENSION VALUE RELATION %%%

% defines all values that are present for a dimension
dimension_value(D, P) :- reason_magnitude(C, D, P).
dimension_value(D, P) :- dimensional_fact(C, D, P).

% defines the value relation for all present dimensions
value_relation(S, D, P, Q) :-
    dimension_strengthens(D, S),
    dimension_value(D, P), dimension_value(D, Q),
    P <= Q.

% defines the value relation for elements that have no element between them, i.e., they are neighbours
neighbour_value_relation(S, D, P, Q) :-
    dimension_strengthens(D, S),
    dimension_value(D, P), dimension_value(D, Q),
    P < Q, Q = #min { V : dimension_value(D, V) }.

% defines the dual of the value relation for the opposite side
value_relation(S2, D, Q, P) :- value_relation(S1, D, P, Q), opposite_side(S1, S2).
neighbour_value_relation(S2, D, Q, P) :- neighbour_value_relation(S1, D, P, Q), opposite_side(S1, S2).

% defines the value relation for elements that are different from each other (ie., not reflexive)
strict_value_relation(S, D, P, Q) :- value_relation(S, D, P, Q), P != Q.

%%% CHECK CONSISTENCY OF CASE SPACE %%%

% check if case C1 entails the reason of case C2,
% if case C1 were decided for side S2
not_case_entails_reason(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite_side(S1, S2),
    reason_magnitude(C2, D, P), dimensional_fact(C1, D, Q),
    strict_value_relation(S2, D, Q, P).

% check which cases are inconsistent
not_cases_consistent(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite_side(S1, S2),
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

% mark the whole case base as inconsistent, if some inconsistent cases are found
not_case_base_consistent :- not_cases_consistent(C1, C2).

%%% RESOLVE NEW CASE WITH STRONGEST REASON AND CHECK CONSISTENCY %%%

1 { case_proposal(C, S1) : opposite_side(S1, S2) } 1 :- unsolved_case(C), not not_case_base_consistent.

reason_magnitude_strongest_proposal(C, D, P) :- case_proposal(C, S), dimensional_fact(C, D, P).

not_case_strongest_proposal_entails_reason(C1, C2) :-
    case_proposal(C1, S1), case(C2, S2), opposite_side(S1, S2),
    reason_magnitude(C2, D, P), dimensional_fact(C1, D, Q),
    strict_value_relation(S2, D, Q, P).

not_case_entails_reason_strongest_proposal(C1, C2) :-
    case(C1, S1), case_proposal(C2, S2), opposite_side(S1, S2),
    reason_magnitude_strongest_proposal(C2, D, P), dimensional_fact(C1, D, Q),
    strict_value_relation(S2, D, Q, P).

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
    dimension_strengthens(D, S1),
    P = #max { V2 :
        case_proposal_potential_conflict(C1, C2),
        dimensional_fact(C2, D, V1),
        neighbour_value_relation(S1, D, V1, V2) }.

reason_magnitude_safe_proposal(C1, D, P) :-
    case_proposal(C1, S1), opposite_side(S1, S2),
    reason_magnitude_strongest_proposal(C1, D, Q),
    value_relation(S1, D, P, Q),
    dimension_strengthens(D, S2),
    P = #min { V2 :
        case_proposal_potential_conflict(C1, C2),
        dimensional_fact(C2, D, V1),
        neighbour_value_relation(S1, D, V1, V2) }.

%%% OUTPUT %%%

#show not_case_base_consistent/0.
#show not_cases_consistent/2.

#show case_proposal/2.
%#show reason_magnitude_strongest_proposal/3.
#show reason_magnitude_safe_proposal/3.