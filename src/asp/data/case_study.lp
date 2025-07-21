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

case(1, defendant).
fact(1, screen, 240).
fact(1, protest, cried).
fact(1, activity, 90).
fact(1, coop, verbal).
fact(1, read, 95).
magnitude(1, protest, kicked).
magnitude(1, coop, verbal).

case(2, plaintiff).
fact(2, screen, 30).
fact(2, protest, kicked).
fact(2, activity, 210).
fact(2, coop, physical).
fact(2, read, 30).
magnitude(2, protest, screamed).
magnitude(2, activity, 240).
magnitude(2, coop, ignored).
magnitude(2, read, 30).

case(3, defendant).
fact(3, screen, 120).
fact(3, protest, cried).
fact(3, activity, 75).
fact(3, coop, played).
fact(3, read, 10).
magnitude(3, screen, 210).
magnitude(3, protest, cried).
magnitude(3, coop, ignored).

case(4, defendant).
fact(4, screen, 240).
fact(4, protest, cried).
fact(4, activity, 90).
fact(4, coop, played).
fact(4, read, 85).
magnitude(4, protest, screamed).
magnitude(4, coop, verbal).
magnitude(4, read, 50).

case(5, plaintiff).
fact(5, screen, 105).
fact(5, protest, complained).
fact(5, activity, 105).
fact(5, coop, physical).
fact(5, read, 65).
magnitude(5, activity, 180).
magnitude(5, coop, verbal).

case(6, plaintiff).
fact(6, screen, 285).
fact(6, protest, kicked).
fact(6, activity, 225).
fact(6, coop, physical).
fact(6, read, 70).
magnitude(6, screen, 150).
magnitude(6, coop, physical).

case(7, plaintiff).
fact(7, screen, 240).
fact(7, protest, kicked).
fact(7, activity, 90).
fact(7, coop, played).
fact(7, read, 35).
magnitude(7, screen, 120).
magnitude(7, protest, kicked).
magnitude(7, coop, played).
magnitude(7, read, 40).

case(8, defendant).
fact(8, screen, 210).
fact(8, protest, cried).
fact(8, activity, 150).
fact(8, coop, verbal).
fact(8, read, 0).
magnitude(8, protest, cried).
magnitude(8, coop, verbal).

case(9, defendant).
fact(9, screen, 135).
fact(9, protest, cried).
fact(9, activity, 165).
fact(9, coop, physical).
fact(9, read, 60).
magnitude(9, screen, 150).
magnitude(9, activity, 150).
magnitude(9, read, 40).

case(10, plaintiff).
fact(10, screen, 75).
fact(10, protest, kicked).
fact(10, activity, 270).
fact(10, coop, verbal).
fact(10, read, 40).
magnitude(10, screen, 0).
magnitude(10, protest, screamed).
magnitude(10, coop, ignored).
magnitude(10, read, 40).

case(11, defendant).
fact(11, screen, 120).
fact(11, protest, complained).
fact(11, activity, 105).
fact(11, coop, verbal).
fact(11, read, 30).
magnitude(11, screen, 150).
magnitude(11, protest, cried).
magnitude(11, activity, 90).
magnitude(11, coop, verbal).

case(12, plaintiff).
fact(12, screen, 180).
fact(12, protest, none).
fact(12, activity, 105).
fact(12, coop, played).
fact(12, read, 90).
magnitude(12, screen, 60).
magnitude(12, activity, 150).
magnitude(12, read, 90).

case(13, plaintiff).
fact(13, screen, 15).
fact(13, protest, cried).
fact(13, activity, 90).
fact(13, coop, played).
fact(13, read, 30).
magnitude(13, read, 40).

case(14, plaintiff).
fact(14, screen, 120).
fact(14, protest, kicked).
fact(14, activity, 270).
fact(14, coop, verbal).
fact(14, read, 55).
magnitude(14, screen, 30).
magnitude(14, protest, screamed).
magnitude(14, read, 60).

case(15, defendant).
fact(15, screen, 120).
fact(15, protest, cried).
fact(15, activity, 225).
fact(15, coop, played).
fact(15, read, 0).
magnitude(15, screen, 120).
magnitude(15, activity, 120).

case(16, defendant).
fact(16, screen, 300).
fact(16, protest, none).
fact(16, activity, 270).
fact(16, coop, ignored).
fact(16, read, 45).
magnitude(16, protest, none).
magnitude(16, coop, ignored).

case(17, defendant).
fact(17, screen, 105).
fact(17, protest, none).
fact(17, activity, 0).
fact(17, coop, ignored).
fact(17, read, 15).
magnitude(17, screen, 270).
magnitude(17, protest, cried).

case(18, plaintiff).
fact(18, screen, 45).
fact(18, protest, kicked).
fact(18, activity, 255).
fact(18, coop, ignored).
fact(18, read, 90).
magnitude(18, protest, kicked).

case(19, defendant).
fact(19, screen, 180).
fact(19, protest, none).
fact(19, activity, 90).
fact(19, coop, ignored).
fact(19, read, 55).
magnitude(19, protest, none).
magnitude(19, activity, 30).
magnitude(19, coop, ignored).
magnitude(19, read, 40).

case(20, plaintiff).
fact(20, screen, 15).
fact(20, protest, complained).
fact(20, activity, 195).
fact(20, coop, verbal).
fact(20, read, 0).
magnitude(20, activity, 270).
magnitude(20, coop, verbal).
magnitude(20, read, 50).

