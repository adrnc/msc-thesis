% PART OF INPUT

% each dimension has to weaken/strengthen one side or the other
dimension_strengthens(d1, defendant).
dimension_strengthens(d2, defendant).

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

% propose a decision for the new case
case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).
case(C, S) :- case_proposal(C, S).

% extend case information
%case_rmod

% check if a case rmod is inconsistent
not_case_rmod_consistent(C, S, removed, D, 0) :-
    % select a case and a case rmod
    case(C1, S1), case_rmod(C2, S2, removed, 0), opposite(S1, S2),
    % check entailment of case reasons
    not not_case_entails_reason(C1, R2), not not_case_rmod_entails_reason(C2, R1).

% constrain weaker justifications than the current one
:- case_proposal(C, S), case_rmod(C, S, M, D, P), not not_case_rmod_consistent(C, S, M, D, P).