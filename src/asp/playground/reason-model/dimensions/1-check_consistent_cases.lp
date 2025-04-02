% PART OF INPUT

% case with some reason and some fact situation
case(c4, r4, defendant).

dimension(c1, d1, 30).
dimension(c1, d2, 60).
%dimension(c1, d2, 15).

magnitude(r4, d1, 12).

% some unresolved case
case(c6, r6, plaintiff).

dimension(c6, d1, 36).
dimension(c6, d2, 10).

magnitude(r6, d2, 25).

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
ord(S, P, Q) :- case(C, R, S), magnitude(R, D, P), dimension(C, D, Q).

% check entailment of cases
not_entails_case_reason(C1, R2) :-
    % select two cases, for efficiency they have to be of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % select a magnitude from the first reason and a dimension from the second case
    magnitude(R1, D, P), dimension(C2, D, Q),
    % check if the second case does not entail the first reason
    not ord(S1, P, Q).

% constrain inconsistency
:-
    % select two cases of opposite side
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment of case reasons
    not not_entails_case_reason(C1, R2), not not_entails_case_reason(C2, R1).
