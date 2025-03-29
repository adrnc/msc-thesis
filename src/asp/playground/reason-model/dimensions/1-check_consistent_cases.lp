% PART OF INPUT

% case with some reason and some fact situation
case(c4, r4, defendant).

dimension(c1, d1, 30).
dimension(c1, d2, 60).
%dimension(c1, d2, 15).

magnitude(r4, d1, 12).

% some unresolved case
case(c6, r6, plaintiff).

dimension(c1, d1, 36).
dimension(c1, d2, 10).

magnitude(r4, d2, 25).

% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% find dimension presence
dimension_present(c1, d1) :- dimension(R, D, V).

% infer if some fact situation does not entail the other one
% by checking if some dimension is missing
not_entails_case_reason(C1, R2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment
    magnitude(R2, D, V), not dimension_present(C1, D).

% infer if some fact situation does not entail the other one
% by checking if some dimension is weaker
not_entails_case_reason(C1, R2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment
    % TODO: fix
    magnitude(R2, D, V2), dimension(C1, D, V1), V2 > V1.

% constrain inconsistency
:-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check if the entailment holds
    not not_entails_case_reason(C1, R2), not not_entails_case_reason(C2, R1).
