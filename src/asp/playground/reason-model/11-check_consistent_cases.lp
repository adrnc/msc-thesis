% PART OF INPUT

% global factors
factor(p1, plaintiff).
factor(p2, plaintiff).
factor(d1, defendant).
factor(d2, defendant).

% case with some reason and some fact situation
case(c1, r1, plaintiff).

fact(c1, p1).
fact(c1, p2).
fact(c1, d1).
fact(c1, d2).

fact(r1, p1).

% some unresolved case
new_case(c2).

fact(c2, p1).
fact(c2, p2).
fact(c2, d1).
fact(c2, d2).

% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% propose a solution to a case
case_proposal(C, S1) :- new_case(C), opposite(S1, S2).

% infer if some fact situation does not entail the other one
not_entails_case_proposal_reason(C1, R2) :-
    % retrieve info about two cases
    case_proposal(C1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check entailment
    fact(R2, F), not fact(C1, F).

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