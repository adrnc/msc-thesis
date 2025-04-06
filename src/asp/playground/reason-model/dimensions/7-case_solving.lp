% PART OF INPUT

% define global dimension limit
allowed_dimension_value(-5..5).

% each dimension has to weaken/strengthen one side or the other
dimension_strengthens(d1, defendant).
dimension_strengthens(d2, plaintiff).

% optionally, set minimums and maximums for dimensions
dimension_min(d1, -5).
dimension_max(d2, 5).

% case c1 decided for the defendant
case(c1, defendant).

% facts holding in case c1
dimension(c1, d1, 1).
dimension(c1, d2, 1).

% reason justifying the result of c1
magnitude(c1, d1, 0).

% case c2
unsolved_case(c2).

% facts holding in case c2
dimension(c2, d1, 1).
dimension(c2, d2, 1).

% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% check if a case entails some magnitude from a case of opposite side
case_entails_magnitude(C1, C2, D) :-
    % select two cases of opposite side
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case
    magnitude(C2, D, P), dimension(C1, D, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(D, S1), P >= Q.

% check if a case entails some magnitude from a case of opposite side
case_entails_magnitude(C1, C2, D) :-
    % select two cases of opposite side
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case
    magnitude(C2, D, P), dimension(C1, D, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(D, S2), P <= Q.

% define when some reason of a case from opposite side is not entailed
not_case_entails_reason(C1, C2) :-
    % select two cases of opposite side
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    % select a magnitude from the second case and check if it is not entailed
    magnitude(C2, D, P), not case_entails_magnitude(C1, C2, D).

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

% propose a non-empty reason
1 { magnitude_proposal(C, D, P) : dimension(C, D, Q), allowed_dimension_value(P) } :- case_proposal(C, S).
magnitude(C, D, P) :- magnitude_proposal(C, D, P).

% prevent magnitude proposals with two different values for the same dimension
:- case_proposal(C, S), magnitude_proposal(C, D, P1), magnitude_proposal(C, D, P2), P1 != P2.

% select removed magnitudes for case proposals containing at least two magnitudes
case_proposal_reason_mod(C, S, removed, D1, P1) :- case_proposal(C, S), magnitude(C, D1, P1), magnitude(C, D2, P2), D1 != D2.

% select weakened strengthening magnitudes case proposals
case_proposal_reason_mod(C, S, weaker, D, P - 1) :- case_proposal(C, S), magnitude(C, D, P), dimension_strengthens(D, S), not has_dimension_min(D).
case_proposal_reason_mod(C, S, weaker, D, P - 1) :- case_proposal(C, S), magnitude(C, D, P), dimension_strengthens(D, S), dimension_min(D, M), P >= M.

% select weakened weakening magnitudes for case proposals
case_proposal_reason_mod(C, S, weaker, D, P + 1) :- case_proposal(C, S), magnitude(C, D, P), not dimension_strengthens(D, S), not has_dimension_max(D).
case_proposal_reason_mod(C, S, weaker, D, P + 1) :- case_proposal(C, S), magnitude(C, D, P), not dimension_strengthens(D, S), dimension_max(D, M), P <= M.

% check if a case entails some magnitude from a case proposal of opposite side
case_entails_proposal_reason_mod_magnitude(C1, C2, S2, M, DX, PX, D) :-
    % select a regular case and a case proposal with removed reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, DX, PX), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case that is not the modified magnitude
    magnitude(C2, D, P), dimension(C1, D, Q), D != DX,
    % check if that magnitude is not entailed
    dimension_strengthens(D, S1), P >= Q.

% check if a case entails some magnitude from a case proposal of opposite side
case_entails_proposal_reason_mod_magnitude(C1, C2, S2, M, DX, PX, D) :-
    % select a regular case and a case proposal with removed reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, DX, PX), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case that is not the modified magnitude
    magnitude(C2, D, P), dimension(C1, D, Q), D != DX,
    % check if that magnitude is not entailed
    dimension_strengthens(D, S2), P <= Q.

% check if a case entails some magnitude from a case proposal of opposite side
case_entails_proposal_reason_mod_magnitude(C1, C2, S2, weaker, D, P, D) :-
    % select a regular case and a case proposal with removed reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, D, P), opposite(S1, S2).

% check if a case entails some magnitude from a case proposal of opposite side
case_entails_proposal_reason_mod_magnitude(C1, C2, S2, weaker, D, P, D) :-
    % select a regular case and a case proposal with weakened reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, weaker, D, P), opposite(S1, S2),
    % select the weakened dimension from the first case that is the modified magnitude
    dimension(C1, D, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(D, S1), P >= Q.

% check if a case entails some magnitude from a case proposal of opposite side
case_entails_proposal_reason_mod_magnitude(C1, C2, S2, weaker, D, P, D) :-
    % select a regular case and a case proposal with weakened reason magnitude of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, weaker, D, P), opposite(S1, S2),
    % select the weakened dimension from the first case that is the modified magnitude
    dimension(C1, D, Q),
    % check if that magnitude is not entailed
    dimension_strengthens(D, S2), P <= Q.

% check if a case entails some magnitude from a case proposal of opposite side
not_case_entails_proposal_reason_mod(C1, C2, S2, M, DX, PX) :-
    % select a regular case and a case proposal with modified reason of opposite side
    case(C1, S1), case_proposal_reason_mod(C2, S2, M, DX, PX), opposite(S1, S2),
    % select a magnitude from the second case and check if it is not entailed
    magnitude(C2, D, P), not case_entails_proposal_reason_mod_magnitude(C1, C2, S2, M, DX, PX, D).

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

#show case_proposal/2.
#show magnitude_proposal/3.
#show case_entails_proposal_reason_mod_magnitude/7.