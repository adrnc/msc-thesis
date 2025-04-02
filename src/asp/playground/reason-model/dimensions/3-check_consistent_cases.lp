% PART OF INPUT

% case with some reason and some fact situation
case(c4, r4, defendant).

dimension(c4, d1, 30).
dimension(c4, d2, 60).
%dimension(c1, d2, 15).

magnitude(r4, d1, 12).

% some inconsistent case
case(c8, r8, plaintiff).

dimension(c8, d1, 36).
dimension(c8, d2, 10).

magnitude(r8, d2, 75).

% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% define partial order conditions
ord(S, P, P) :- ord(S, P, Q).
ord(S, Q, Q) :- ord(S, P, Q).
ord(S, P, R) :- ord(S, P, Q), ord(S, Q, R).
:- ord(S, P, Q), ord(S, Q, P), P != Q.
ord(S2, Q, P) :- ord(S1, P, Q), opposite(S1, S2).

% generate partial order from cases
ord(S, P, P) :- case(C, R, S), magnitude(R, D, P).
ord(S, Q, Q) :- case(C, R, S), dimension(C, D, Q).
ord(S, P, Q) :- case(C, R, S), magnitude(R, D, P), dimension(C, D, Q).

% allow checking if some dimension is present
dimension_present(C, D) :- dimension(C, D, Q).

% check if a case entails some magnitude from a case of opposite side
case_entails_magnitude(C1, R2, D) :-
    % select two cases of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case
    magnitude(R2, D, P), dimension(C1, D, Q),
    % check if that magnitude is entailed
    ord(S2, P, Q).

% define when some reason of a case from opposite side is not entailed
case_reason_not_entailed(C1, R2) :-
    % select two cases of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case
    magnitude(R2, D, P), dimension(C1, D, Q),
    % check if that magnitude is not entailed
    not case_entails_magnitude(C1, R2, D).
% constrain inconsistency

priority_ordering(C1, R2, R1):-
    % select two cases of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment of case reasons
    not case_reason_not_entailed(C1, R2), not case_reason_not_entailed(C2, R1).

