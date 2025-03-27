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

% conflicting new case
case(c2, r2, defendant).

fact(c2, f1).
fact(c2, f3).

fact(r2, f3).

% mark all relevant fact situations
fact_situation(C) :- case(C, R, S).
fact_situation(R) :- case(C, R, S).

% infer if some fact situation does not entail the other one
not_entails(X, Y) :-
    fact_situation(X), fact_situation(Y), fact(Y, F), not fact(X, F).

% constrain inconsistency efficiently
:-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2),
    % check if the entailment holds for the first and for the second case
    not not_entails(C1, R2), not not_entails(C2, R1).
