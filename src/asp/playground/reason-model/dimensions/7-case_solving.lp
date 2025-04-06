% PART OF INPUT

% each dimension has to weaken/strengthen one side or the other
dimension_strengthens(d1, defendant).
dimension_strengthens(d2, defendant).

% optionally, set minimums and maximums for dimensions
dimension_min(d1, 0).

% case c4 decided for the defendant
case(c4, defendant).

% facts holding in case c4
dimension(c4, d1, 30).
dimension(c4, d2, 60).

% reason justifying the result of c4
magnitude(c4, d1, 12).

% case c8
unsolved_case(c8).

% facts holding in case c8
dimension(c8, d1, 36).
dimension(c8, d2, 10).

% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% check if a case entails some magnitude from a case of opposite side
not_case_entails_magnitude(C1, C2, D) :-
    % select two cases of opposite side
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case
    magnitude(C2, D, P), dimension(C1, D, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(D, S1), P < Q.

% check if a case entails some magnitude from a case of opposite side
not_case_entails_magnitude(C1, C2, D) :-
    % select two cases of opposite side
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case
    magnitude(C2, D, P), dimension(C1, D, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(D, S2), P > Q.

% define when some reason of a case from opposite side is not entailed
not_case_entails_reason(C1, C2) :-
    % select two cases of opposite side
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    % select a magnitude from the second case and check if it is not entailed
    magnitude(C2, D, P), not_case_entails_magnitude(C1, C2, D).

% constrain inconsistency
:-
    % select two cases of opposite side
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    % check entailment of case reasons
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

% check if dimension min and max are present
has_dimension_min(D) :- dimension_min(D, M).
has_dimension_max(D) :- dimension_max(D, M).

% propose a decision for the new case
case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).
case(C, S) :- case_proposal(C, S).



% select removed magnitudes for case proposals
case_proposal_reason_mod(C, S, removed, D, 0) :- case_proposal(C, S), magnitude(C, D, P).

% select weakened strengthening magnitudes case proposals
case_proposal_reason_mod(C, S, weaker, D, P - 1) :- case_proposal(C, S), magnitude(C, D, P), dimension_strengthens(D, S), not has_dimension_min(D).
case_proposal_reason_mod(C, S, weaker, D, P - 1) :- case_proposal(C, S), magnitude(C, D, P), dimension_strengthens(D, S), dimension_min(D, M), M < P.

% select weakened weakening magnitudes for case proposals
case_proposal_reason_mod(C, S, weaker, D, P + 1) :- case_proposal(C, S), magnitude(C, D, P), not dimension_strengthens(D, S), not has_dimension_min(D).
case_proposal_reason_mod(C, S, weaker, D, P + 1) :- case_proposal(C, S), magnitude(C, D, P), not dimension_strengthens(D, S), dimension_max(D, M), M > P.

% check if a case entails some magnitude from a case proposal of opposite side
not_case_entails_proposal_reason_mod_magnitude(C1, C2, S2, M, DX, PX, D) :-
    % select a regular case and a case proposal with removed reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, DX, PX), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case that is not the modified magnitude
    magnitude(C2, D, P), dimension(C1, D, Q), D != DX,
    % check if that magnitude is not entailed
    dimension_strengthens(D, S1), P < Q.

% check if a case entails some magnitude from a case proposal of opposite side
not_case_entails_proposal_reason_mod_magnitude(C1, C2, S2, M, DX, PX, D) :-
    % select a regular case and a case proposal with removed reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, DX, PX), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case that is not the modified magnitude
    magnitude(C2, D, P), dimension(C1, D, Q), D != DX,
    % check if that magnitude is not entailed
    dimension_strengthens(D, S2), P > Q.

% check if a case entails some magnitude from a case proposal of opposite side
not_case_entails_proposal_reason_mod_magnitude(C1, C2, S2, weaker, DX, PX, DX) :-
    % select a regular case and a case proposal with removed reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, weaker, DX, PX), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case that is the modified magnitude
    magnitude(C2, DX, P), dimension(C1, DX, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(DX, S1), PX < Q.

% check if a case entails some magnitude from a case proposal of opposite side
not_case_entails_proposal_reason_mod_magnitude(C1, C2, S2, weaker, DX, PX, DX) :-
    % select a regular case and a case proposal with removed reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, weaker, DX, PX), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case that is the modified magnitude
    magnitude(C2, DX, P), dimension(C1, DX, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(DX, S2), PX > Q.

% check if a case entails some magnitude from a case proposal of opposite side
not_case_entails_proposal_reason_mod(C1, C2) :-
    % select a regular case and a case proposal with modified reason of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, DX, PX), opposite(S1, S2),
    % select a magnitude from the second case and check if it is not entailed
    magnitude(C2, D, P), not_case_entails_proposal_reason_mod_magnitude(C1, C2, S2, M, DX, PX, D).

% check if a case reason mod is inconsistent
not_case_proposal_reason_mod_consistent(C2, S2, M, D, P) :-
    % select a regular case and a case proposal with modified reason of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, D, P), opposite(S1, S2),
    % check entailment of modified case proposal reason
    not not_case_entails_proposal_reason_mod(C1, C2, S2, M, D, P),
    % check entailment of regular case reason
    not not_case_entails_reason(C2, C1).

% constrain to only output the weakest justifications
:- case_proposal_reason_mod(C, S, M, D, P), not not_case_proposal_reason_mod_consistent(C, S, M, D, P).

%#show case_proposal/2.