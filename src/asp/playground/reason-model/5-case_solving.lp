% opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% global factors
factor(f1, plaintiff).
factor(f2, plaintiff).
factor(f3, defendant).
factor(f4, defendant).

% case with some reason and some fact situation
case(c1, r1, plaintiff).

fact(c1, f1).
fact(c1, f2).
fact(c1, f3).
fact(c1, f4).

fact(r1, f1).

% case to be decided
unresolved_case(c2, r2).

fact(c2, f1).
fact(c2, f3).

% two reason choices opposing each other
reason_choice(w, plaintiff).
reason_choice(z, defendant).

% select decision for new case
new_case(C, R, S1) :- unresolved_case(C, R), opposite(S1, S2), not case(C, R, S2).
case(C, R, S) :- new_case(C, R, S).

% select reason for new case decision
{ new_fact(R, F) : new_case(C, R, S), fact(C, F), factor(F, S) }.
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
