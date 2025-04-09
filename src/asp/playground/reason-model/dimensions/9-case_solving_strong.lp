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

%%% DIMENSION/MAGNITUDE HELPERS %%%

dimension_value(D, Min) :- dimension_range(D, Min, Max).
dimension_value(D, V + 1) :- dimension_value(D, V), dimension_range(D, Min, Max), V < Max.

dimension_factor(D, S, 1) :- dimension_strengthens(D, S).
dimension_factor(D, S2, -1) :- dimension_strengthens(D, S1), opposite(S1, S2).

dimension_min(D, S, Min) :- dimension_strengthens(D, S), dimension_range(D, Min, Max).
dimension_min(D, S2, Max) :- dimension_strengthens(D, S1), opposite(S1, S2), dimension_range(D, Min, Max).

dimension_max(D, S, Max) :- dimension_strengthens(D, S), dimension_range(D, Min, Max).
dimension_max(D, S2, Min) :- dimension_strengthens(D, S1), opposite(S1, S2), dimension_range(D, Min, Max).

%%% CHECK CONSISTENCY OF CASE SPACE TYPE %%%

not_case_type_entails_magnitude(TX, C1, C2, D) :-
    case_type(TX, C1, S1), case_type(TX, C2, S2), opposite(S1, S2),
    magnitude_type(TX, C2, D, P), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_type_entails_reason(TX, C1, C2) :-
    case_type(TX, C1, S1), case_type(TX, C2, S2), opposite(S1, S2),
    magnitude_type(TX, C2, D, P), not_case_type_entails_magnitude(TX, C1, C2, D).

% prevent inconsistency for case space types
:-
    case_type(TX, C1, S1), case_type(TX, C2, S2), opposite(S1, S2),
    not not_case_type_entails_reason(TX, C1, C2), not not_case_type_entails_reason(TX, C2, C1).

%%% CHECK INCONSISTENCY OF MODIFIED CASE SPACES %%%

not_case_mod_entails_magnitude(TX, CX, MX, DX, PX, C1, C2, D) :-
    case_mod(TX, CX, MX, DX, PX, C1, S1), case_mod(TX, CX, MX, DX, PX, C2, S2), opposite(S1, S2),
    magnitude_mod(TX, CX, MX, DX, PX, C2, D, P), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_mod_entails_reason(TX, CX, MX, DX, PX, C1, C2) :-
    case_mod(TX, CX, MX, DX, PX, C1, S1), case_mod(TX, CX, MX, DX, PX, C2, S2), opposite(S1, S2),
    magnitude_mod(TX, CX, MX, DX, PX, C2, D, P), not_case_mod_entails_magnitude(TX, CX, MX, DX, PX, C1, C2, D).

% check inconsistency for modified case space
not_case_space_mod_consistent(TX, CX, MX, DX, PX) :-
    case_mod(TX, CX, MX, DX, PX, C1, S1), case_mod(TX, CX, MX, DX, PX, C2, S2), opposite(S1, S2),
    not not_case_mod_entails_reason(TX, CX, MX, DX, PX, C1, C2), not not_case_mod_entails_reason(TX, CX, MX, DX, PX, C2, C1).

% require inconsistency for modified case space
%:- case_space_mod(TX, CX, MX, DX, PX), not not_case_space_mod_consistent(TX, CX, MX, DX, PX).

%%% GENERATE CASE SPACE TYPES %%%

case_space_type(weak).
case_space_type(strong).

case_type(TX, C, S) :- case(C, S), case_space_type(TX).
magnitude_type(TX, C, D, P) :- magnitude(C, D, P), case_space_type(TX).

%%% GENERATE CASE SPACE MODIFICATIONS %%%

case_mod(TX, CX, MX, DX, PX, C, S) :- case_type(TX, C, S), case_space_mod(TX, CX, MX, DX, PX).

magnitude_mod(TX, CX, MX, DX, PX, C, D, P) :- magnitude_type(TX, C, D, P), case_space_mod(TX, CX, MX, DX, PX), C != CX.
magnitude_mod(TX, CX, MX, DX, PX, C, D, P) :- magnitude_type(TX, C, D, P), case_space_mod(TX, CX, MX, DX, PX), D != DX.

magnitude_mod(TX, CX, weaken, DX, PX, CX, DX, PX) :- magnitude_type(TX, CX, DX, P), case_space_mod(TX, CX, weaken, DX, PX).
magnitude_mod(TX, CX, strengthen, DX, PX, CX, DX, PX) :- magnitude_type(TX, CX, DX, P), case_space_mod(TX, CX, strengthen, DX, PX).

magnitude_mod(TX, CX, add, DX, PX, CX, DX, PX) :- case_space_mod(TX, CX, add, DX, PX).

%%% GENERATE CASE PROPOSALS %%%

case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).
case_type_proposal(TX, C, S) :- case_proposal(C, S), case_space_type(TX).
case_type(TX, C, S) :- case_type_proposal(TX, C, S).

{ magnitude_type_proposal(TX, C, D, P) : dimension(C, D, Q),  dimension_value(D, P), dimension_factor(D, S, F), (P * F) <= (Q * F) } :- case_type_proposal(TX, C, S).
magnitude_type(TX, C, D, P) :- magnitude_type_proposal(TX, C, D, P).

:- case_type_proposal(TX, C, S), magnitude_type_proposal(TX, C, D, P1), magnitude_type_proposal(TX, C, D, P2), P1 != P2.

%%% SELECT CASE SPACE MODIFICATIONS FOR PROPOSALS %%%

case_space_mod(weak, CX, remove, DX, PX) :- case_type_proposal(weak, CX, S), magnitude_type(weak, CX, DX, PX).

case_space_mod(weak, CX, weaken, DX, PX) :-
    case_type_proposal(weak, CX, S), magnitude_type(weak, CX, DX, P), dimension_factor(DX, S, F),
    dimension_value(DX, PX), PX = P - F.

case_space_mod(strong, CX, add, DX, PX) :-
    case_type_proposal(strong, CX, S), dimension(CX, DX, Q),
    dimension_value(DX, P), not magnitude_type(strong, CX, DX, P),
    % TODO: improve efficiency
    dimension_value(DX, PX), dimension_factor(D, S, F), (PX * F) <= (Q * F).

case_space_mod(strong, CX, strengthen, DX, PX) :-
    case_type_proposal(strong, CX, S), magnitude_type(strong, CX, DX, P), dimension_factor(DX, S, F),
    dimension_value(DX, PX), PX = P + F.

%%% OUTPUT %%%

#show case_proposal/2.
#show magnitude_type_proposal/4.
#show case_space_mod/5.