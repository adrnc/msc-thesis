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
