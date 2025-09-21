%%% DIMENSIONS %%%

int_dimension_strengthens(screen, plaintiff).

custom_dimension_strengthens(protest, plaintiff).
custom_dimension_ordering(protest, none, complained).
custom_dimension_ordering(protest, complained, cried).
custom_dimension_ordering(protest, cried, screamed).
custom_dimension_ordering(protest, screamed, kicked).

int_dimension_strengthens(activity, defendant).

custom_dimension_strengthens(coop, defendant).
custom_dimension_ordering(coop, physical, verbal).
custom_dimension_ordering(coop, verbal, ignored).
custom_dimension_ordering(coop, ignored, played).

int_dimension_strengthens(read, defendant).

%%% CASES %%%

case(1, plaintiff).
factor(1, protest, screamed).
factor(1, screen, 105).
factor(1, activity, 285).
factor(1, coop, physical).
factor(1, read, 30).
magnitude(1, protest, cried).
magnitude(1, coop, physical).
magnitude(1, read, 30).

case(3, plaintiff).
factor(3, protest, kicked).
factor(3, screen, 135).
factor(3, activity, 255).
factor(3, coop, played).
factor(3, read, 20).
magnitude(3, protest, kicked).
magnitude(3, coop, played).
magnitude(3, read, 80).

case(5, plaintiff).
factor(5, protest, cried).
factor(5, screen, 75).
factor(5, activity, 285).
factor(5, coop, physical).
factor(5, read, 45).
magnitude(5, coop, verbal).
magnitude(5, read, 50).

case(10, plaintiff).
factor(10, protest, kicked).
factor(10, screen, 15).
factor(10, activity, 150).
factor(10, coop, physical).
factor(10, read, 95).
magnitude(10, protest, screamed).
magnitude(10, activity, 240).
magnitude(10, coop, physical).

case(13, defendant).
factor(13, screen, 210).
factor(13, protest, screamed).
factor(13, activity, 150).
factor(13, coop, verbal).
factor(13, read, 85).
magnitude(13, read, 60).

case(14, defendant).
factor(14, protest, none).
factor(14, screen, 255).
factor(14, activity, 75).
factor(14, coop, played).
factor(14, read, 5).
magnitude(14, protest, none).
magnitude(14, coop, played).

case(18, defendant).
factor(18, protest, none).
factor(18, screen, 165).
factor(18, activity, 285).
factor(18, coop, verbal).
factor(18, read, 100).
magnitude(18, protest, none).
magnitude(18, screen, 180).
magnitude(18, activity, 90).
magnitude(18, read, 90).

case(20, defendant).
factor(20, protest, screamed).
factor(20, screen, 240).
factor(20, activity, 15).
factor(20, coop, ignored).
factor(20, read, 100).
magnitude(20, read, 10).

%%% UNSOLVED CASES %%%

unsolved_case(2).
factor(2, protest, screamed).
factor(2, screen, 90).
factor(2, activity, 75).
factor(2, coop, ignored).
factor(2, read, 10).

unsolved_case(4).
factor(4, protest, cried).
factor(4, screen, 165).
factor(4, activity, 285).
factor(4, coop, played).
factor(4, read, 25).

unsolved_case(6).
factor(6, protest, complained).
factor(6, screen, 120).
factor(6, activity, 30).
factor(6, coop, verbal).
factor(6, read, 60).

unsolved_case(7).
factor(7, protest, kicked).
factor(7, screen, 45).
factor(7, activity, 90).
factor(7, coop, played).
factor(7, read, 15).

unsolved_case(8).
factor(8, protest, complained).
factor(8, screen, 255).
factor(8, activity, 105).
factor(8, coop, played).
factor(8, read, 55).

unsolved_case(9).
factor(9, protest, cried).
factor(9, screen, 210).
factor(9, activity, 15).
factor(9, coop, played).
factor(9, read, 100).

unsolved_case(11).
factor(11, protest, screamed).
factor(11, screen, 210).
factor(11, activity, 90).
factor(11, coop, ignored).
factor(11, read, 95).

unsolved_case(12).
factor(12, protest, kicked).
factor(12, screen, 150).
factor(12, activity, 60).
factor(12, coop, verbal).
factor(12, read, 35).

unsolved_case(15).
factor(15, protest, complained).
factor(15, screen, 60).
factor(15, activity, 150).
factor(15, coop, played).
factor(15, read, 25).

unsolved_case(16).
factor(16, protest, kicked).
factor(16, screen, 180).
factor(16, activity, 30).
factor(16, coop, physical).
factor(16, read, 85).

unsolved_case(17).
factor(17, protest, none).
factor(17, screen, 195).
factor(17, activity, 75).
factor(17, coop, verbal).
factor(17, read, 0).

unsolved_case(19).
factor(19, protest, kicked).
factor(19, screen, 180).
factor(19, activity, 60).
factor(19, coop, verbal).
factor(19, read, 50).
