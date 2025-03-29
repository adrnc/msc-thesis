% opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% global factors
factor(p1, plaintiff).
factor(p2, plaintiff).
factor(d1, defendant).
factor(d2, defendant).

% case with some reason and some fact situation
case(1, r1, plaintiff).

fact(1, p1).
fact(1, p2).
fact(1, d1).
fact(1, d2).

fact(r1, p1).

% case to be decided
case(2, r2, defendant).

fact(2, p1).
fact(2, p2).
fact(2, d1).
fact(2, d2).

% infer if some fact situation does not entail the other one
not_entails_case_reason(C1, R2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2), C1 < C2,
    % check entailment
    fact(R2, F), not fact(C1, F).

% check conflicting cases
case_conflict(C1, S1, C2, S2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2), C1 < C2,
    % check if the entailment holds for the first and for the second case
    not not_entails_case_reason(C1, R2), not not_entails_case_reason(C2, R1).

% mark consistent case bases as unsatisfiable
inconsistent :- case_conflict(C1, S1, C2, S2).
:- not inconsistent.

% show case conflicts
#show case_conflict/4.
