% opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% global factors
factor(f1, plaintiff).
factor(f2, plaintiff).
factor(f3, defendant).
factor(f4, defendant).

% case with some reason and some fact situation
case(c1, r1).
factor(c1, f1).
factor(c1, f2).
factor(c1, f3).
factor(c1, f4).

reason(r1, plaintiff).
factor(r1, f1).

% conflicting new case
case(c2, r2).
factor(c2, f1).
factor(c2, f3).

reason(r2, defendant).
factor(r2, f3).

% infer all fact situations
fact_situation(C) :- case(C, R).
fact_situation(R) :- case(C, R).

% infer if some fact situation does not entail the other one
not_entails(X, Y) :-
    fact_situation(X), fact_situation(Y), factor(Y, F), not factor(X, F).

% infer priority ordering
priority_ordering(W, Z) :-
    % retrieve info about case
    case(C, R), reason(R, S1), opposite(S1, S2),
    % retrieve matching reasons
    reason(W, S2), reason(Z, S1),
    % check if the entailment holds
    not not_entails(C, W), not not_entails(Z, R).

% prevent inconsistent case bases
:- priority_ordering(R1, R2), priority_ordering(R2, R1).