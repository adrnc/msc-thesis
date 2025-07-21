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

case(case_1, plaintiff).
fact(case_1, screen, 225).
fact(case_1, protest, complained).
fact(case_1, activity, 120).
fact(case_1, coop, ignored).
fact(case_1, read, 90).
magnitude(case_1, protest, complained).
magnitude(case_1, read, 90).

case(case_2, defendant).
fact(case_2, screen, 285).
fact(case_2, protest, none).
fact(case_2, activity, 45).
fact(case_2, coop, ignored).
fact(case_2, read, 25).
magnitude(case_2, protest, cried).
magnitude(case_2, activity, 0).
magnitude(case_2, coop, ignored).
magnitude(case_2, read, 20).

case(case_3, plaintiff).
fact(case_3, screen, 150).
fact(case_3, protest, complained).
fact(case_3, activity, 240).
fact(case_3, coop, played).
fact(case_3, read, 0).
magnitude(case_3, screen, 150).
magnitude(case_3, protest, complained).

case(case_4, plaintiff).
fact(case_4, screen, 210).
fact(case_4, protest, cried).
fact(case_4, activity, 180).
fact(case_4, coop, physical).
fact(case_4, read, 40).
magnitude(case_4, screen, 60).
magnitude(case_4, activity, 210).
magnitude(case_4, coop, played).
magnitude(case_4, read, 50).

case(case_5, plaintiff).
fact(case_5, screen, 30).
fact(case_5, protest, cried).
fact(case_5, activity, 75).
fact(case_5, coop, played).
fact(case_5, read, 25).
magnitude(case_5, protest, complained).
magnitude(case_5, coop, played).

case(case_6, plaintiff).
fact(case_6, screen, 30).
fact(case_6, protest, complained).
fact(case_6, activity, 15).
fact(case_6, coop, ignored).
fact(case_6, read, 10).
magnitude(case_6, activity, 120).

case(case_7, defendant).
fact(case_7, screen, 150).
fact(case_7, protest, screamed).
fact(case_7, activity, 120).
fact(case_7, coop, played).
fact(case_7, read, 55).
magnitude(case_7, screen, 150).

case(case_8, defendant).
fact(case_8, screen, 195).
fact(case_8, protest, none).
fact(case_8, activity, 60).
fact(case_8, coop, physical).
fact(case_8, read, 35).
magnitude(case_8, screen, 300).
magnitude(case_8, activity, 60).
magnitude(case_8, read, 20).

case(case_9, plaintiff).
fact(case_9, screen, 195).
fact(case_9, protest, screamed).
fact(case_9, activity, 120).
fact(case_9, coop, ignored).
fact(case_9, read, 70).
magnitude(case_9, protest, screamed).
magnitude(case_9, activity, 180).
magnitude(case_9, coop, ignored).
magnitude(case_9, read, 90).

case(case_10, defendant).
fact(case_10, screen, 120).
fact(case_10, protest, screamed).
fact(case_10, activity, 150).
fact(case_10, coop, ignored).
fact(case_10, read, 95).
magnitude(case_10, coop, verbal).
magnitude(case_10, read, 90).

case(case_11, plaintiff).
fact(case_11, screen, 225).
fact(case_11, protest, cried).
fact(case_11, activity, 270).
fact(case_11, coop, verbal).
fact(case_11, read, 70).
magnitude(case_11, protest, complained).
magnitude(case_11, coop, ignored).
magnitude(case_11, read, 70).

case(case_12, defendant).
fact(case_12, screen, 270).
fact(case_12, protest, kicked).
fact(case_12, activity, 105).
fact(case_12, coop, physical).
fact(case_12, read, 30).
magnitude(case_12, protest, kicked).
magnitude(case_12, coop, physical).

case(case_13, defendant).
fact(case_13, screen, 210).
fact(case_13, protest, none).
fact(case_13, activity, 45).
fact(case_13, coop, played).
fact(case_13, read, 70).
magnitude(case_13, screen, 300).
magnitude(case_13, protest, complained).
magnitude(case_13, activity, 0).
magnitude(case_13, coop, ignored).

case(case_14, defendant).
fact(case_14, screen, 285).
fact(case_14, protest, kicked).
fact(case_14, activity, 15).
fact(case_14, coop, played).
fact(case_14, read, 70).
magnitude(case_14, activity, 0).
magnitude(case_14, coop, ignored).

case(case_15, defendant).
fact(case_15, screen, 195).
fact(case_15, protest, complained).
fact(case_15, activity, 285).
fact(case_15, coop, ignored).
fact(case_15, read, 65).
magnitude(case_15, protest, screamed).
magnitude(case_15, activity, 150).

case(case_16, plaintiff).
fact(case_16, screen, 180).
fact(case_16, protest, complained).
fact(case_16, activity, 180).
fact(case_16, coop, physical).
fact(case_16, read, 60).
magnitude(case_16, screen, 180).
magnitude(case_16, protest, none).
magnitude(case_16, coop, played).
magnitude(case_16, read, 60).

case(case_17, defendant).
fact(case_17, screen, 60).
fact(case_17, protest, none).
fact(case_17, activity, 240).
fact(case_17, coop, verbal).
fact(case_17, read, 10).
magnitude(case_17, screen, 60).
magnitude(case_17, protest, complained).
magnitude(case_17, activity, 180).
magnitude(case_17, coop, verbal).
magnitude(case_17, read, 0).

case(case_18, defendant).
fact(case_18, screen, 195).
fact(case_18, protest, cried).
fact(case_18, activity, 120).
fact(case_18, coop, physical).
fact(case_18, read, 20).
magnitude(case_18, screen, 210).
magnitude(case_18, protest, cried).
magnitude(case_18, coop, physical).

case(case_19, defendant).
fact(case_19, screen, 210).
fact(case_19, protest, screamed).
fact(case_19, activity, 165).
fact(case_19, coop, verbal).
fact(case_19, read, 10).
magnitude(case_19, protest, screamed).
magnitude(case_19, activity, 150).
magnitude(case_19, coop, verbal).
magnitude(case_19, read, 10).

case(case_20, plaintiff).
fact(case_20, screen, 180).
fact(case_20, protest, kicked).
fact(case_20, activity, 240).
fact(case_20, coop, played).
fact(case_20, read, 45).
magnitude(case_20, screen, 90).
magnitude(case_20, protest, kicked).
magnitude(case_20, activity, 240).
magnitude(case_20, read, 60).
