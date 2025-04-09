% PART OF INPUT

dimension_range(d1, -5, 5).
dimension_range(d2, -5, 5).

dimension_strengthens(d1, defendant).
dimension_strengthens(d2, defendant).

case(c1, defendant).
dimension(c1, d1, 1).
dimension(c1, d2, 1).
magnitude(c1, d1, 1).
magnitude(c1, d2, 1).

case(c2, plaintiff).
dimension(c2, d1, 1).
dimension(c2, d2, 0).
magnitude(c1, d1, 1).

unsolved_case(c3).
dimension(c3, d1, 1).
dimension(c3, d2, 2).

% PART OF PROGRAM

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% DIMENSION HELPERS %%%

dimension_value(D, Min) :- dimension_range(D, Min, Max).
dimension_value(D, V + 1) :- dimension_value(D, V), dimension_range(D, Min, Max), V < Max.

dimension_factor(D, S, 1) :- dimension_strengthens(D, S).
dimension_factor(D, S2, -1) :- dimension_strengthens(D, S1), opposite(S1, S2).

dimension_min(D, S, Min) :- dimension_strengthens(D, S), dimension_range(D, Min, Max).
dimension_min(D, S2, Max) :- dimension_strengthens(D, S1), opposite(S1, S2), dimension_range(D, Min, Max).

dimension_max(D, S, Max) :- dimension_strengthens(D, S), dimension_range(D, Min, Max).
dimension_max(D, S2, Min) :- dimension_strengthens(D, S1), opposite(S1, S2), dimension_range(D, Min, Max).

%%% CHECK CONSISTENCY OF CASE SPACE TYPE %%%

not_case_type_entails_magnitude(C1, C2, D, TX) :-
    case_type(C1, S1, TX), case_type(C2, S2, TX), opposite(S1, S2),
    magnitude_type(C2, D, P, TX), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_type_entails_reason(C1, C2, TX) :-
    case_type(C1, S1, TX), case_type(C2, S2, TX), opposite(S1, S2),
    magnitude_type(C2, D, P, TX), not_case_type_entails_magnitude(C1, C2, D, TX).

% prevent inconsistency for case space types
:-
    case_type(C1, S1, TX), case_type(C2, S2, TX), opposite(S1, S2),
    not not_case_type_entails_reason(C1, C2, TX), not not_case_type_entails_reason(C2, C1, TX).

%%% CHECK INCONSISTENCY OF MODIFIED CASE SPACES %%%

not_case_mod_entails_magnitude(C1, C2, D, TX, CX, MX, DX, PX) :-
    case_mod(C1, S1, TX, CX, MX, DX, PX), case_mod(C2, S2, TX, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, TX, CX, MX, DX, PX), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_mod_entails_reason(C1, C2, TX, CX, MX, DX, PX) :-
    case_mod(C1, S1, TX, CX, MX, DX, PX), case_mod(C2, S2, TX, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, TX, CX, MX, DX, PX), not_case_mod_entails_magnitude(C1, C2, D, TX, CX, MX, DX, PX).

% check inconsistency for modified case space
not_case_space_mod_consistent(TX, CX, MX, DX, PX) :-
    case_mod(C1, S1, TX, CX, MX, DX, PX), case_mod(C2, S2, TX, CX, MX, DX, PX), opposite(S1, S2),
    not not_case_mod_entails_reason(C1, C2, TX, CX, MX, DX, PX), not not_case_mod_entails_reason(C2, C1, TX, CX, MX, DX, PX).

% require inconsistency for modified case space
:- case_space_mod(TX, CX, MX, DX, PX), not not_case_space_mod_consistent(TX, CX, MX, DX, PX).

%%% GENERATE CASE SPACE TYPES %%%

case_space_type(weak).
case_space_type(strong).

case_type(C, S, TX) :- case(C, S), case_space_type(TX).
magnitude_type(C, D, P, TX) :- magnitude(C, D, P), case_space_type(TX).

%%% GENERATE CASE SPACE MODIFICATIONS %%%

case_mod(C, S, TX, CX, MX, DX, PX) :- case_type(C, S, TX), case_space_mod(TX, CX, MX, DX, PX).

magnitude_mod(C, D, P, TX, CX, MX, DX, PX) :- magnitude_type(C, D, P, TX), case_space_mod(TX, CX, MX, DX, PX), C != CX.
magnitude_mod(C, D, P, TX, CX, MX, DX, PX) :- magnitude_type(C, D, P, TX), case_space_mod(TX, CX, MX, DX, PX), D != DX.

magnitude_mod(CX, DX, PX, TX, CX, weaken, DX, PX) :- magnitude_type(TX, CX, DX, P), case_space_mod(TX, CX, weaken, DX, PX).
magnitude_mod(CX, DX, PX, TX, CX, strengthen, DX, PX) :- magnitude_type(TX, CX, DX, P), case_space_mod(TX, CX, strengthen, DX, PX).

magnitude_mod(CX, DX, PX, TX, CX, add, DX, PX) :- case_space_mod(TX, CX, add, DX, PX).


%%% GENERATE CASE PROPOSALS %%%

case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).
case_type_proposal(C, S, TX) :- case_proposal(C, S), case_space_type(TX).
case_type(C, S, TX) :- case_type_proposal(C, S, TX).

{ magnitude_type_proposal(C, D, P, TX) : dimension(C, D, Q),  dimension_value(D, P), dimension_factor(D, S, F), (P * F) <= (Q * F) } :- case_type_proposal(C, S, TX).
magnitude_type(C, D, P, TX) :- magnitude_type_proposal(C, D, P, TX).

:- case_type_proposal(C, S, TX), magnitude_type_proposal(C, D, P1, TX), magnitude_type_proposal(C, D, P2, TX), P1 != P2.

%%% SELECT CASE SPACE MODIFICATIONS FOR PROPOSALS %%%

case_space_mod(weak, CX, remove, DX, PX) :- case_type_proposal(weak, CX, S), magnitude_type(weak, CX, DX, PX).

case_space_mod(weak, C, weaken, D, V) :-
    case_type_proposal(weak, C, S), magnitude_type(weak, C, D, P), dimension_factor(D, S, F),
    dimension_value(D, V), V = P - F.

%%% OUTPUT %%%

#show case_type_proposal/3.
#show magnitude_type_proposal/4.