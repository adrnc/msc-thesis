consistent_case(Case, Side) :-
    case(Case, Side),
    not -consistent_case(Case, Side).

cases_consistent_count(N) :- N = #count { Case, Side : consistent_case(Case, Side) }.
cases_not_consistent_count(N) :- N = #count { Case, Side : -consistent_case(Case, Side) }.

decision_constraint_count(N) :- N = #count { Decision, Side : constraint(Decision, Side) }.

#show cases_consistent_count/1.
#show cases_not_consistent_count/1.
#show decision_constraint_count/1.

#show constraint/2.
