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
fact(c2, d1).

% select decision for new case
new_case(C, R, S1) :- unresolved_case(C, R), opposite(S1, S2), not case(C, R, S2).
case(C, R, S) :- new_case(C, R, S).

% select reason for new case decision
1 { new_fact(R, F) : fact(C, F), factor(F, S) } :- new_case(C, R, S).
fact(R, F) :- new_fact(R, F).

% infer if some fact situation does not entail the other one
not_entails_case_reason(C1, R2) :-
    case(C1, R1, S1), case(C2, R2, S2), fact(R2, F), not fact(C1, F).

% constrain inconsistency
:-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check if the entailment holds for the first and for the second case
    not not_entails_case_reason(C1, R2), not not_entails_case_reason(C2, R1).

#show new_case/3.
#show new_fact/2.