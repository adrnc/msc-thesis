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
fact(1, screen, 195).
fact(1, protest, kicked).
fact(1, activity, 120).
fact(1, coop, ignored).
fact(1, read, 70).
magnitude(1, coop, ignored).
magnitude(1, read, 10).

case(2, plaintiff).
fact(2, screen, 75).
fact(2, protest, cried).
fact(2, activity, 240).
fact(2, coop, played).
fact(2, read, 65).
magnitude(2, screen, 60).

case(3, defendant).
fact(3, screen, 45).
fact(3, protest, kicked).
fact(3, activity, 15).
fact(3, coop, verbal).
fact(3, read, 0).
magnitude(3, screen, 60).

case(4, plaintiff).
fact(4, screen, 225).
fact(4, protest, cried).
fact(4, activity, 165).
fact(4, coop, played).
fact(4, read, 85).
magnitude(4, screen, 90).

case(5, defendant).
fact(5, screen, 30).
fact(5, protest, screamed).
fact(5, activity, 90).
fact(5, coop, played).
fact(5, read, 50).
magnitude(5, screen, 270).
magnitude(5, protest, screamed).
magnitude(5, read, 20).

case(6, defendant).
fact(6, screen, 45).
fact(6, protest, complained).
fact(6, activity, 90).
fact(6, coop, played).
fact(6, read, 70).
magnitude(6, screen, 240).
magnitude(6, protest, kicked).
magnitude(6, activity, 0).

case(7, defendant).
fact(7, screen, 135).
fact(7, protest, none).
fact(7, activity, 150).
fact(7, coop, physical).
fact(7, read, 70).
magnitude(7, screen, 180).
magnitude(7, protest, kicked).
magnitude(7, read, 40).

case(8, plaintiff).
fact(8, screen, 255).
fact(8, protest, none).
fact(8, activity, 105).
fact(8, coop, physical).
fact(8, read, 70).
magnitude(8, screen, 210).
magnitude(8, activity, 270).
magnitude(8, coop, ignored).

case(9, plaintiff).
fact(9, screen, 15).
fact(9, protest, screamed).
fact(9, activity, 210).
fact(9, coop, ignored).
fact(9, read, 20).
magnitude(9, protest, complained).
magnitude(9, activity, 300).
magnitude(9, coop, ignored).
magnitude(9, read, 20).

case(10, plaintiff).
fact(10, screen, 30).
fact(10, protest, cried).
fact(10, activity, 300).
fact(10, coop, ignored).
fact(10, read, 90).
magnitude(10, protest, complained).

case(11, defendant).
fact(11, screen, 255).
fact(11, protest, kicked).
fact(11, activity, 225).
fact(11, coop, verbal).
fact(11, read, 85).
magnitude(11, activity, 210).
magnitude(11, read, 40).

case(12, defendant).
fact(12, screen, 30).
fact(12, protest, cried).
fact(12, activity, 255).
fact(12, coop, ignored).
fact(12, read, 85).
magnitude(12, screen, 30).
magnitude(12, protest, cried).
magnitude(12, activity, 180).
magnitude(12, coop, ignored).
magnitude(12, read, 30).

case(13, plaintiff).
fact(13, screen, 90).
fact(13, protest, cried).
fact(13, activity, 0).
fact(13, coop, verbal).
fact(13, read, 40).
magnitude(13, activity, 60).
magnitude(13, coop, ignored).

case(14, defendant).
fact(14, screen, 45).
fact(14, protest, screamed).
fact(14, activity, 150).
fact(14, coop, ignored).
fact(14, read, 20).
magnitude(14, screen, 120).
magnitude(14, protest, kicked).
magnitude(14, coop, ignored).
magnitude(14, read, 20).

case(15, plaintiff).
fact(15, screen, 270).
fact(15, protest, kicked).
fact(15, activity, 150).
fact(15, coop, verbal).
fact(15, read, 15).
magnitude(15, screen, 150).
magnitude(15, activity, 180).
magnitude(15, coop, ignored).
magnitude(15, read, 80).

case(16, defendant).
fact(16, screen, 90).
fact(16, protest, none).
fact(16, activity, 240).
fact(16, coop, ignored).
fact(16, read, 90).
magnitude(16, protest, none).
magnitude(16, activity, 30).
magnitude(16, read, 20).

case(17, defendant).
fact(17, screen, 255).
fact(17, protest, kicked).
fact(17, activity, 30).
fact(17, coop, verbal).
fact(17, read, 15).
magnitude(17, coop, physical).
magnitude(17, read, 10).

case(18, defendant).
fact(18, screen, 45).
fact(18, protest, cried).
fact(18, activity, 105).
fact(18, coop, ignored).
fact(18, read, 0).
magnitude(18, screen, 270).
magnitude(18, protest, cried).

case(19, plaintiff).
fact(19, screen, 255).
fact(19, protest, complained).
fact(19, activity, 150).
fact(19, coop, verbal).
fact(19, read, 100).
magnitude(19, activity, 180).

case(20, plaintiff).
fact(20, screen, 75).
fact(20, protest, cried).
fact(20, activity, 195).
fact(20, coop, verbal).
fact(20, read, 10).
magnitude(20, coop, verbal).
magnitude(20, read, 30).

