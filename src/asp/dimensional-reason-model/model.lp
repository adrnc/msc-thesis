%%% GENERAL INFO %%%

% First, check the example

%%% SIDE DEFINITIONS %%%

opposite(plaintiff, defendant).
opposite(S2, S1) :- opposite(S1, S2).

%%% DIMENSION HELPERS %%%

dimension_value(D, Min..Max) :- dimension_config(D, S, Min, Max).

dimension_present(C, D) :- dimension(C, D, Q).

dimension_factor(D, S, 1) :- dimension_config(D, S, Min, Max).
dimension_factor(D, S2, -1) :- dimension_config(D, S1, Min, Max), opposite(S1, S2).

%%% CHECK CONSISTENCY OF CASE SPACE %%%

not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), not dimension_present(C1, D).

not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_entails_reason(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), not_case_entails_magnitude(C1, C2, D).

% prevent inconsistency for regular case space
:-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

%%% CHECK INCONSISTENCY OF MODIFIED CASE SPACES %%%

not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), not dimension_present(C1, D).

not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX).

% check inconsistency for modified case space
not_case_space_mod_consistent(CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    not not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX), not not_case_mod_entails_reason(C2, C1, CX, MX, DX, PX).

% require inconsistency for modified case space
:- case_space_mod(CX, MX, DX, PX), not not_case_space_mod_consistent(CX, MX, DX, PX).

%%% GENERATE CASE PROPOSALS %%%

case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).
case(C, S) :- case_proposal(C, S).

{ magnitude_proposal(C, D, P) : dimension(C, D, Q),  dimension_value(D, P), dimension_factor(D, S, F), (P * F) <= (Q * F) } :- case_proposal(C, S).
magnitude(C, D, P) :- magnitude_proposal(C, D, P).

:- case_proposal(C, S), magnitude_proposal(C, D, P1), magnitude_proposal(C, D, P2), P1 != P2.

%%% SELECT CASE SPACE MODIFICATIONS %%%

case_space_mod(C, remove, D, P) :- case_proposal(C, S), magnitude(C, D, P).

case_space_mod(C, weaken, D, V) :-
    case_proposal(C, S), magnitude(C, D, P), dimension_factor(D, S, F),
    dimension_value(D, V), V = P - F.

%%% GENERATE MODIFIED CASE SPACES %%%

case_mod(C, S, CX, MX, DX, PX) :- case(C, S), case_space_mod(CX, MX, DX, PX).

magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), C != CX.
magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), D != DX.

magnitude_mod(CX, DX, PX, CX, weaken, DX, PX) :- magnitude(CX, DX, P), case_space_mod(CX, weaken, DX, PX).

%%% OUTPUT %%%

#show case_proposal/2.
#show magnitude_proposal/3.