% opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% global factors
factor(f1, plaintiff).
factor(f2, plaintiff).
factor(f3, defendant).
factor(f4, defendant).

% case with some fact situation
case(c1, plaintiff).

case_fact(c1, f1).
case_fact(c1, f2).
case_fact(c1, f3).
case_fact(c1, f4).

case_rule_condition(c1, f1).

% new case to be decided
new_case(c2).

case_fact(c2, f1).
case_fact(c2, f2).
case_fact(c2, f3).

% infer new case decision
case_decision(N, S, C) :- new_case(N), case(C, S).

% restrict missing case rule condition in new case
:- case_decision(N, S1, C), case_rule_condition(C, F), not case_fact(N, F).

% restrict weaker fact situations
:- case_decision(N, S1, C),                     factor(F, S1), case_fact(C, F), not case_fact(N, F).
:- case_decision(N, S1, C), opposite(S1, S2),   factor(F, S2), case_fact(N, F), not case_fact(C, F).