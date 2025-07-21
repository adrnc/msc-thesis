cases_consistent(Case, Side, OppCase, OppSide) :-
    case(Case, Side),
    case(OppCase, OppSide),
    opposing_case_likes(Case, Side, OppCase, OppSide),
    not not_cases_consistent(Case, Side, OppCase, OppSide).

#show cases_consistent/4.
