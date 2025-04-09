% PART OF INPUT

dimension_strengthens(d1, defendant).
dimension_strengthens(d2, defendant).

dimension_minmax(d1, -5, 5).
dimension_minmax(d2, -5, 5).

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

dimension_value(D, Min) :- dimension_minmax(D, Min, Max).
dimension_value(D, V + 1) :- dimension_value(D, V), dimension_minmax(D, Min, Max), V < Max.

dimension_factor(D, S, 1) :- dimension_strengthens(D, S).
dimension_factor(D, S2, -1) :- dimension_strengthens(D, S1), opposite(S1, S2).

%%% CHECK CONSISTENCY OF CASE SPACE %%%

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

case_space_mod(C, removed, D, P) :- case_proposal(C, S), magnitude(C, D, P).

case_space_mod(C, weaker, D, V) :-
    case_proposal(C, S), magnitude(C, D, P), dimension_factor(D, S, F),
    dimension_value(D, V), V = P - F.

%%% GENERATE MODIFIED CASE SPACES %%%

case_mod(C, S, CX, MX, DX, PX) :- case(C, S), case_space_mod(CX, MX, DX, PX).

magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), C != CX.
magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), D != DX.

magnitude_mod(CX, DX, PX, CX, weaker, DX, PX) :- magnitude(CX, DX, P), case_space_mod(CX, weaker, DX, PX).

#show case_proposal/2.
#show magnitude_proposal/3.