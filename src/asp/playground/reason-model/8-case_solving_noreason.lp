% opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

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

% case to be decided
unresolved_case(c2, r2).

fact(c2, p1).
fact(c2, p2).
fact(c2, d1).
fact(c2, d2).

% select case decision proposal for unresolved case,
% reason is not given, assumed to be empty
case_proposal(C, S1) :- unresolved_case(C, R), opposite(S1, S2).
case(C, R, S) :- unresolved_case(C, R), case_proposal(C, S).

% infer if some fact situation does not entail the other one
not_entails_case_reason(C1, R2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2), C1 != C2,
    % check entailment
    fact(R2, F), not fact(C1, F).

% check conflicting cases
case_conflict(C1, S1, C2, S2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2), C1 != C2,
    % check if the entailment holds for the first and for the second case
    not not_entails_case_reason(C1, R2), not not_entails_case_reason(C2, R1).

% constrain inconsistent model on already decided cases
:-
    % retrieve two conflicting cases
    case_conflict(C1, S1, C2, S2),
    % check that none of them is a proposal
    not case_proposal(C1, S1), not case_proposal(C2, S2).

% find inconsistent cases
case_inconsistent(C1, S1) :- case_conflict(C1, S1, C2, S2).

% check valid case decisions
case_decision(C, S) :- case_proposal(C, S), not case_inconsistent(C, S).

% mark case bases as inconsistent where no decision can be reached
:-
    % retrieve unresolve case and both opposite sides
    unresolved_case(C, R), opposite(S1, S2),
    % check if both sides are inconsistent
    case_inconsistent(C, S1), case_inconsistent(C, S2).

% show case decisions
#show case_decision/2.
#show case_conflict/4.
