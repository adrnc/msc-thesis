% PART OF INPUT

allowed_dimension_value(-5..5).

dimension_strengthens(d1, defendant).
dimension_strengthens(d2, defendant).

dimension_min(d1, -5).
dimension_max(d2, 5).

case(c1, defendant).
dimension(c1, d1, 1).
dimension(c1, d2, 1).
magnitude(c1, d1, 1).

unsolved_case(c3).
dimension(c3, d1, 1).
dimension(c3, d2, 1).

% PART OF PROGRAM

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% regular case space

not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), dimension(C1, D, Q),
    dimension_strengthens(D, S1), P < Q.

not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), dimension(C1, D, Q),
    dimension_strengthens(D, S2), P > Q.

not_case_entails_reason(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), not_case_entails_magnitude(C1, C2, D).

% prevent inconsistency for regular case space
:-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

% modified case spaces

not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), dimension(C1, D, Q),
    dimension_strengthens(D, S1), P < Q.

not_case_mod_entails_magnitude(C1, C2, D) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), dimension(C1, D, Q),
    dimension_strengthens(D, S2), P > Q.

not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX) :-
    case(C1, S1, CX, MX, DX, PX), case(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX).

% check inconsisency for modified case space
not_case_space_mod_consistent(CX, MX, DX, PX) :-
    case(C1, S1, CX, MX, DX, PX), case(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    not not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX), not not_case_mod_entails_reason(C2, C1, CX, MX, DX, PX).

% require inconsistency for modified case space
:- case_space_mod(CX, MX, DX, PX), not not_case_space_mod_consistent(CX, MX, DX, PX).

#show case_proposal/2.
#show magnitude_proposal/3.