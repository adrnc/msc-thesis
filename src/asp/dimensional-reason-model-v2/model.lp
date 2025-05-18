%%% SIDES %%%

opposite_side(plaintiff, defendant).
opposite_side(S2, S1) :- opposite_side(S1, S2).

%%% DIMENSION VALUE RELATION %%%

% defines all values that are present for a dimension
dimension_value(D, P) :- reason_magnitude(C, D, P).
dimension_value(D, P) :- dimensional_fact(C, D, P).

% defines the value relation for all present dimensions
value_relation(S, D, P, Q) :-
    dimension_strengthens(D, S), dimension_value(D, P), dimension_value(D, Q),
    P <= Q.

% defines the value relation for elements that are at max 1 apart
adjacent_value_relation(S, D, P, P) :- dimension_value(D, P).
adjacent_value_relation(S, D, P, Q) :-
    dimension_strengthens(D, S), dimension_value(D, P),
    P < Q, Q = #min { V : dimension_value(D, V) }.

% defines the dual of the value relation for the opposite side
value_relation(S2, D, Q, P) :- value_relation(S1, D, P, Q), opposite_side(S1, S2).
adjacent_value_relation(S2, D, Q, P) :- adjacent_value_relation(S1, D, P, Q), opposite_side(S1, S2).

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

% make a decision for a side
1 { case_proposal(C, S1) : opposite_side(S1, S2) } 1 :- unsolved_case(C), not not_case_base_consistent.

% generate the strongest reason
reason_magnitude_strongest_proposal(C, D, P) :- case_proposal(C, S), dimensional_fact(C, D, P).

% check which reasons the case proposal entails
not_case_proposal_entails_reason(C1, C2) :-
    case_proposal(C1, S1), case(C2, S2), opposite_side(S1, S2),
    reason_magnitude(C2, D, P), dimensional_fact(C1, D, Q),
    strict_value_relation(S2, D, Q, P).

% check which cases entail the case proposal reason
not_case_entails_reason_strongest_proposal(C1, C2) :-
    case(C1, S1), case_proposal(C2, S2), opposite_side(S1, S2),
    reason_magnitude_strongest_proposal(C2, D, P), dimensional_fact(C1, D, Q),
    strict_value_relation(S2, D, Q, P).

% since we know that a side can only be chosen, if the strongest
% reason is consistent, we constrain decisions for a side through the strongest reason
:-
    case_proposal(C1, S1), case(C2, S2), opposite_side(S1, S2),
    not not_case_proposal_entails_reason(C1, C2),
    not not_case_entails_reason_strongest_proposal(C2, C1).

%%% SEARCH FOR SAFE WEAKER REASONS %%%

% every case where the reason is entailed by the case proposal is a potential conflict,
% because consistency now requires that the other case does not entail the case proposal reason
case_proposal_potential_conflict(C1, C2) :-
    case_proposal(C1, S1), case(C2, S2), opposite_side(S1, S2),
    not not_case_proposal_entails_reason(C1, C2).

% we weaken the reason magnitudes such that consistency is preserved
reason_magnitude_proposal(C1, D, P) :-
    case_proposal(C1, S1), reason_magnitude_strongest_proposal(C1, D, Q), value_relation(S1, D, P, Q),
    dimension_strengthens(D, S1),
    P = #max { QX :
        case_proposal_potential_conflict(C1, C2),
        dimensional_fact(C2, D, PX),
        adjacent_value_relation(S1, D, PX, QX) }.

% the same but this time the dimension strengthens the opposite side
reason_magnitude_proposal(C1, D, P) :-
    case_proposal(C1, S1), reason_magnitude_strongest_proposal(C1, D, Q), value_relation(S1, D, P, Q),
    dimension_strengthens(D, S2), opposite_side(S1, S2),
    P = #min { QX :
        case_proposal_potential_conflict(C1, C2),
        dimensional_fact(C2, D, PX),
        adjacent_value_relation(S1, D, PX, QX) }.

%%% OUTPUT %%%

#show not_case_base_consistent/0.
#show not_cases_consistent/2.

#show case_proposal/2.
#show reason_magnitude_proposal/3.