case_consistent_with_case_base(Case, Side) :-
    case(Case, Side),
    not not_case_consistent_with_case_base(Case, Side).

cases_consistent_count(N) :- N = #count { Case, Side : case_consistent_with_case_base(Case, Side) }.
cases_not_consistent_count(N) :- N = #count { Case, Side : not_case_consistent_with_case_base(Case, Side) }.

decision_constraint_count(N) :- N = #count { Decision, Side : decision_constrained(Decision, Side) }.

#show cases_consistent_count/1.
#show cases_not_consistent_count/1.
#show decision_constraint_count/1.

%#show decision_constrained/2.
