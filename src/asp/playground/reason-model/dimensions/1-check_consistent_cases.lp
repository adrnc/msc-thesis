% PART OF INPUT

% case with some reason and some fact situation
case(c1, r1, plaintiff).

dimension(c1, d1, 1).
dimension(c1, d2, 2).
dimension(c1, d3, 3).
dimension(c1, d4, 4).

dimension(r1, d2, 1).

% some unresolved case
new_case(c2).

dimension(c1, d1, 1).
dimension(c1, d2, 2).
dimension(c1, d3, 3).
dimension(c1, d4, 4).

% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% find dimension presence
dimension_present(c1, d1) :- dimension(R, D, V).

% propose a solution to a case
case_proposal(C, S1) :- new_case(C), opposite(S1, S2).

% infer if some fact situation does not entail the other one
% by checking if some dimension is missing
not_entails_case_proposal_reason(C1, R2) :-
    % retrieve info about two cases
    case_proposal(C1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment
    dimension_present(R2, D), not dimension_present(C1, D).

% infer if some fact situation does not entail the other one
% by checking if some dimension is weaker
not_entails_case_proposal_reason(C1, R2) :-
    % retrieve info about two cases
    case_proposal(C1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment
    dimension(R2, D, V1), dimension(C1, D, V2), V2 < V1.

% check conflict regarding proposal
case_proposal_conflict(C1, S1, C2, S2) :-
    % retrieve info about two cases
    case_proposal(C1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check if the entailment for the reason of the decided case holds for the case proposal
    not not_entails_case_proposal_reason(C1, R2).

% filter inconsistent case proposals
case_proposal_inconsistent(C1, S1) :- case_proposal_conflict(C1, S1, C2, S2).

% find valid case decisions
case_decision(C, S) :- case_proposal(C, S), not case_proposal_inconsistent(C, S).

new_case_inconsistent(C) :-
    % retrieve a case proposal and the opposite side
    case_proposal(C, S1), opposite(S1, S2),
    % test that no decision can be made for either side
    not case_decision(C, S1), not case_decision(C, S2).

#show case_decision/2.
#show case_proposal_conflict/4.
#show new_case_inconsistent/1.