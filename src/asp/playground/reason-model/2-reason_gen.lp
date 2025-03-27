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
fact(c1, f1).
fact(c1, f2).
fact(c1, f3).
fact(c1, f4).

reason(r1, plaintiff).
fact(r1, f1).

% conflicting new case
case(c2, r2).
fact(c2, f1).
fact(c2, f3).

reason(r2, defendant).
fact(r2, f3).

% two reason choices opposing each other
reason_choice(w, plaintiff).
reason_choice(z, defendant).

% select reasons to test
{ fact(w, F) : factor(F, plaintiff) }.
{ fact(z, F) : factor(F, defendant) }.

% mark all relevant fact situations
fact_situation(C) :- case(C, R).
fact_situation(R) :- case(C, R).
fact_situation(R) :- reason_choice(R, S).

% infer if some fact situation does not entail the other one
not_entails(X, Y) :-
    fact_situation(X), fact_situation(Y), fact(Y, F), not fact(X, F).

% infer priority ordering
priority_ordering(W, Z) :-
    % retrieve info about case
    case(C, R), reason(R, S1), opposite(S1, S2),
    % retrieve matching reasons for opposite sides
    reason_choice(W, S2), reason_choice(Z, S1),
    % check if the entailment holds
    not not_entails(C, W), not not_entails(Z, R).

inconsistent(base) :- priority_ordering(R1, R2), priority_ordering(R2, R1).

% unsat if consistent case base
:- not inconsistent(base).
