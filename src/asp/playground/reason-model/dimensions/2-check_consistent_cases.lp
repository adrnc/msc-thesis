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

% check entailment of cases with missing dimension
case_reason_dimension_missing(C1, R2, D) :-
    % select two cases, for efficiency they have to be of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % select a magnitude from the second reason
    magnitude(R2, D, P),
    % check if a matching dimension from is present in the first case
    not dimension_present(C1, D).

% check entailment of cases with present dimension
case_reason_dimension_too_weak(C1, R2, D) :-
    % select two cases, for efficiency they have to be of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % select a magnitude from the second reason and a dimension from the first case
    magnitude(R2, D, P), dimension(C1, D, Q),
    % check if the second case does not entail the first reason
    not ord(S2, P, Q).

% define when some reason is not entailed
case_reason_not_entailed(C1, R2) :- case_reason_dimension_missing(C1, R2, D).
case_reason_not_entailed(C1, R2) :- case_reason_dimension_too_weak(C1, R2, D).

% generate priority ordering
priority_ordering(C1, R2, R1):-
    % select two cases of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment of case reasons
    not case_reason_not_entailed(C1, R2).

% constrain inconsistency
:- priority_ordering(C, R1, R2), priority_ordering(C, R2, R1).
