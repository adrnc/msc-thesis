case_base_consistent :-
    not not_case_base_consistent.

decision_permissible(Case, Side) :-
    decision(Case, Side),
    not decision_permissible(Case, Side).

#show case_base_consistent/0.
#show not_case_base_consistent/0.

#show decision_permissible/2.
#show not_decision_permissible/2.
