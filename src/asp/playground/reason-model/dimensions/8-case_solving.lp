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

%%% CHECK CONSISTENCY OF CASE SPACE %%%

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

%%% CHECK INCONSISTENCY OF MODIFIED CASE SPACES %%%

not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), dimension(C1, D, Q),
    dimension_strengthens(D, S1), P < Q.

not_case_mod_entails_magnitude(C1, C2, D) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), dimension(C1, D, Q),
    dimension_strengthens(D, S2), P > Q.

not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX).

% check inconsisency for modified case space
not_case_space_mod_consistent(CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    not not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX), not not_case_mod_entails_reason(C2, C1, CX, MX, DX, PX).

% require inconsistency for modified case space
:- case_space_mod(CX, MX, DX, PX), not not_case_space_mod_consistent(CX, MX, DX, PX).

%%% GENERATE CASE PROPOSALS %%%

case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).
case(C, S) :- case_proposal(C, S).

% TODO: make more efficient
1 { magnitude_proposal(C, D, P) : dimension(C, D, Q), allowed_dimension_value(P) } :- case_proposal(C, S).
magnitude(C, D, P) :- magnitude_proposal(C, D, P).

:- case_proposal(C, S), magnitude_proposal(C, D, P1), magnitude_proposal(C, D, P2), P1 != P2.

%%% SELECT CASE SPACE MODIFICATIONS %%%

has_dimension_min(D) :- dimension_min(D, M).
has_dimension_max(D) :- dimension_max(D, M).

case_space_mod(C, removed, D1, P1) :- case_proposal(C, S), magnitude(C, D1, P1), magnitude(C, D2, P2), D1 != D2.

case_space_mod(C, weaker, D, P - 1) :- case_proposal(C, S), magnitude(C, D, P), dimension_strengthens(D, S), not has_dimension_min(D).
case_space_mod(C, weaker, D, P - 1) :- case_proposal(C, S), magnitude(C, D, P), dimension_strengthens(D, S), dimension_min(D, M), P >= M.

case_space_mod(C, weaker, D, P + 1) :- case_proposal(C, S1), magnitude(C, D, P), opposite(S1, S2), dimension_strengthens(D, S2), not has_dimension_max(D).
case_space_mod(C, weaker, D, P + 1) :- case_proposal(C, S1), magnitude(C, D, P), opposite(S1, S2), dimension_strengthens(D, S2), dimension_max(D, M), P <= M.

%%% GENERATE MODIFIED CASE SPACES %%%

case_mod(C, S, CX, MX, DX, PX) :- case(C, S), case_space_mod(CX, MX, DX, PX).

magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), C != CX.
magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), D != DX.

magnitude_mod(CX, DX, PX, CX, weaker, DX, PX) :- magnitude(CX, DX, P), case_space_mod(CX, weaker, DX, PX).

#show case_proposal/2.
#show magnitude_proposal/3.
