%%% DIMENSIONS STRENGTHENING THE PLAINTIFF %%%

int_dimension_strengthens(screen, plaintiff).

custom_dimension_strengthens(protest, plaintiff).
custom_dimension_ordering(
    protest, none, complained;
    protest, complained, cried;
    protest, cried, screamed;
    protest, screamed, kicked).

%%% DIMENSIONS STRENGTHENING THE DEFENDANT %%%

int_dimension_strengthens(activity, defendant).

custom_dimension_strengthens(coop, defendant).
custom_dimension_ordering(
    coop, physical, verbal;
    coop, verbal, ignored;
    coop, ignored, played).

int_dimension_strengthens(read, defendant).

%%% CASES %%%

case(c1, plaintiff).
fact(c1, screen, 5).
magnitude(c1, screen, 4).

unsolved_case(c_un).
fact(c_un, screen, 2).

#show case_base_consistent/0.
#show not_case_base_consistent/0.
#show case_decision_permissible/2.
#show not_case_decision_permissible/2.
