% global factors
factor(f1, plaintiff).
factor(f2, plaintiff).
factor(f3, defendant).
factor(f4, defendant).

% case with some fact situation
case(c1, plaintiff).
fact_situation(c1, f1).
fact_situation(c1, f2).
fact_situation(c1, f3).
fact_situation(c1, f4).
rule_condition(c1, f1).

% new case to be decided
new_case(c2).
fact_situation(c2, f1).
