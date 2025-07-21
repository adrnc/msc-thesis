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
fact(1, screen, 105).
fact(1, protest, screamed).
fact(1, activity, 285).
fact(1, coop, physical).
fact(1, read, 30).
magnitude(1, protest, cried).
magnitude(1, coop, physical).
magnitude(1, read, 30).

case(2, plaintiff).
fact(2, screen, 90).
fact(2, protest, screamed).
fact(2, activity, 75).
fact(2, coop, ignored).
fact(2, read, 10).
magnitude(2, screen, 90).
magnitude(2, protest, screamed).
magnitude(2, activity, 90).
magnitude(2, coop, played).
magnitude(2, read, 20).

case(3, defendant).
fact(3, screen, 210).
fact(3, protest, screamed).
fact(3, activity, 90).
fact(3, coop, ignored).
fact(3, read, 95).
magnitude(3, activity, 60).
magnitude(3, read, 20).

case(4, defendant).
fact(4, screen, 150).
fact(4, protest, kicked).
fact(4, activity, 60).
fact(4, coop, verbal).
fact(4, read, 35).
magnitude(4, screen, 270).
magnitude(4, read, 10).

case(5, defendant).
fact(5, screen, 210).
fact(5, protest, screamed).
fact(5, activity, 150).
fact(5, coop, verbal).
fact(5, read, 85).
magnitude(5, read, 60).

case(6, defendant).
fact(6, screen, 255).
fact(6, protest, none).
fact(6, activity, 75).
fact(6, coop, played).
fact(6, read, 5).
magnitude(6, protest, none).
magnitude(6, coop, played).

case(7, plaintiff).
fact(7, screen, 135).
fact(7, protest, kicked).
fact(7, activity, 255).
fact(7, coop, played).
fact(7, read, 20).
magnitude(7, protest, kicked).
magnitude(7, coop, played).
magnitude(7, read, 80).

case(8, plaintiff).
fact(8, screen, 165).
fact(8, protest, cried).
fact(8, activity, 285).
fact(8, coop, played).
fact(8, read, 25).
magnitude(8, screen, 150).
magnitude(8, read, 80).

case(9, plaintiff).
fact(9, screen, 75).
fact(9, protest, cried).
fact(9, activity, 285).
fact(9, coop, physical).
fact(9, read, 45).
magnitude(9, coop, verbal).
magnitude(9, read, 50).

case(10, defendant).
fact(10, screen, 60).
fact(10, protest, complained).
fact(10, activity, 150).
fact(10, coop, played).
fact(10, read, 25).
magnitude(10, screen, 60).
magnitude(10, protest, cried).
magnitude(10, coop, ignored).

case(11, plaintiff).
fact(11, screen, 120).
fact(11, protest, complained).
fact(11, activity, 30).
fact(11, coop, verbal).
fact(11, read, 60).
magnitude(11, screen, 90).
magnitude(11, activity, 60).
magnitude(11, coop, ignored).

case(12, plaintiff).
fact(12, screen, 15).
fact(12, protest, kicked).
fact(12, activity, 150).
fact(12, coop, physical).
fact(12, read, 95).
magnitude(12, protest, screamed).
magnitude(12, activity, 240).
magnitude(12, coop, physical).

case(13, defendant).
fact(13, screen, 180).
fact(13, protest, kicked).
fact(13, activity, 30).
fact(13, coop, physical).
fact(13, read, 85).
magnitude(13, read, 70).

case(14, plaintiff).
fact(14, screen, 45).
fact(14, protest, kicked).
fact(14, activity, 90).
fact(14, coop, played).
fact(14, read, 15).
magnitude(14, protest, screamed).
magnitude(14, activity, 120).
magnitude(14, read, 90).

case(15, plaintiff).
fact(15, screen, 255).
fact(15, protest, complained).
fact(15, activity, 105).
fact(15, coop, played).
fact(15, read, 55).
magnitude(15, screen, 150).
magnitude(15, activity, 180).
magnitude(15, read, 90).

case(16, plaintiff).
fact(16, screen, 210).
fact(16, protest, cried).
fact(16, activity, 15).
fact(16, coop, played).
fact(16, read, 100).
magnitude(16, screen, 150).
magnitude(16, activity, 30).

case(17, defendant).
fact(17, screen, 195).
fact(17, protest, none).
fact(17, activity, 75).
fact(17, coop, verbal).
fact(17, read, 0).
magnitude(17, protest, cried).

case(18, defendant).
fact(18, screen, 165).
fact(18, protest, none).
fact(18, activity, 285).
fact(18, coop, verbal).
fact(18, read, 100).
magnitude(18, screen, 180).
magnitude(18, protest, none).
magnitude(18, activity, 90).
magnitude(18, read, 90).

case(19, defendant).
fact(19, screen, 180).
fact(19, protest, kicked).
fact(19, activity, 60).
fact(19, coop, verbal).
fact(19, read, 50).
magnitude(19, screen, 240).
magnitude(19, read, 30).

case(20, defendant).
fact(20, screen, 240).
fact(20, protest, screamed).
fact(20, activity, 15).
fact(20, coop, ignored).
fact(20, read, 100).
magnitude(20, read, 10).

