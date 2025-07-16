%%% DIMENSIONS STRENGTHENING THE PLAINTIFF %%%

int_dimension_strengthens(screen, plaintiff).

custom_dimension_strengthens(protest, plaintiff).
custom_dimension_ordering(none, complained; complained, cried; cried, screamed; screamed, kicked).

%%% DIMENSIONS STRENGTHENING THE DEFENDANT %%%

int_dimension_strengthens(activity, defendant).

custom_dimension_strengthens(coop, defendant).
custom_dimension_ordering(physical, verbal; verbal, ignored; ignored, played).

int_dimension_strengthens(read, defendant).
