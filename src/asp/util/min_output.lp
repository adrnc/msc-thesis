case_base_consistent :-
    not not_case_base_consistent.

decision_permissible(Case, Side) :-
    decision(Case, Side),
    not decision_permissible(Case, Side).

cases_consistent(Case, Side, OppCase, OppSide) :-
    case(Case, Side),
    case(OppCase, OppSide),
    opposing_case_likes(Case, Side, OppCase, OppSide),
    not not_cases_consistent(Case, Side, OppCase, OppSide).

cases_consistent_count(N) :- N = #count { Case, Side, OppCase, OppSide : cases_consistent(Case, Side, OppCase, OppSide), Case < OppCase }.
not_cases_consistent_count(N) :- N = #count { Case, Side, OppCase, OppSide : not_cases_consistent(Case, Side, OppCase, OppSide), Case < OppCase }.

#show case_base_consistent/0.
#show not_case_base_consistent/0.

#show decision_permissible/2.
#show not_decision_permissible/2.

#show cases_consistent_count/1.
#show not_cases_consistent_count/1.
