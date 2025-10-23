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
value_assignment(1, protest, screamed).
value_assignment(1, screen, 105).
value_assignment(1, activity, 285).
value_assignment(1, coop, physical).
value_assignment(1, read, 30).
magnitude_factor(1, protest, cried).
magnitude_factor(1, coop, physical).
magnitude_factor(1, read, 30).

case(2, plaintiff).
value_assignment(2, protest, screamed).
value_assignment(2, screen, 90).
value_assignment(2, activity, 75).
value_assignment(2, coop, ignored).
value_assignment(2, read, 10).
magnitude_factor(2, protest, screamed).
magnitude_factor(2, screen, 90).
magnitude_factor(2, activity, 90).
magnitude_factor(2, coop, played).
magnitude_factor(2, read, 20).

case(3, plaintiff).
value_assignment(3, protest, kicked).
value_assignment(3, screen, 135).
value_assignment(3, activity, 255).
value_assignment(3, coop, played).
value_assignment(3, read, 20).
magnitude_factor(3, protest, kicked).
magnitude_factor(3, coop, played).
magnitude_factor(3, read, 80).

case(4, plaintiff).
value_assignment(4, protest, cried).
value_assignment(4, screen, 165).
value_assignment(4, activity, 285).
value_assignment(4, coop, played).
value_assignment(4, read, 25).
magnitude_factor(4, screen, 150).
magnitude_factor(4, read, 80).

case(5, plaintiff).
value_assignment(5, protest, cried).
value_assignment(5, screen, 75).
value_assignment(5, activity, 285).
value_assignment(5, coop, physical).
value_assignment(5, read, 45).
magnitude_factor(5, coop, verbal).
magnitude_factor(5, read, 50).

case(6, plaintiff).
value_assignment(6, protest, complained).
value_assignment(6, screen, 120).
value_assignment(6, activity, 30).
value_assignment(6, coop, verbal).
value_assignment(6, read, 60).
magnitude_factor(6, screen, 90).
magnitude_factor(6, activity, 60).
magnitude_factor(6, coop, ignored).

case(7, plaintiff).
value_assignment(7, protest, kicked).
value_assignment(7, screen, 45).
value_assignment(7, activity, 90).
value_assignment(7, coop, played).
value_assignment(7, read, 15).
magnitude_factor(7, protest, screamed).
magnitude_factor(7, activity, 120).
magnitude_factor(7, read, 90).

case(8, plaintiff).
value_assignment(8, protest, complained).
value_assignment(8, screen, 255).
value_assignment(8, activity, 105).
value_assignment(8, coop, played).
value_assignment(8, read, 55).
magnitude_factor(8, screen, 150).
magnitude_factor(8, activity, 180).
magnitude_factor(8, read, 90).

case(9, plaintiff).
value_assignment(9, protest, cried).
value_assignment(9, screen, 210).
value_assignment(9, activity, 15).
value_assignment(9, coop, played).
value_assignment(9, read, 100).
magnitude_factor(9, screen, 150).
magnitude_factor(9, activity, 30).

case(10, plaintiff).
value_assignment(10, protest, kicked).
value_assignment(10, screen, 15).
value_assignment(10, activity, 150).
value_assignment(10, coop, physical).
value_assignment(10, read, 95).
magnitude_factor(10, protest, screamed).
magnitude_factor(10, activity, 240).
magnitude_factor(10, coop, physical).

case(11, defendant).
value_assignment(11, protest, screamed).
value_assignment(11, screen, 210).
value_assignment(11, activity, 90).
value_assignment(11, coop, ignored).
value_assignment(11, read, 95).
magnitude_factor(11, activity, 60).
magnitude_factor(11, read, 20).

case(12, defendant).
value_assignment(12, protest, kicked).
value_assignment(12, screen, 150).
value_assignment(12, activity, 60).
value_assignment(12, coop, verbal).
value_assignment(12, read, 35).
magnitude_factor(12, screen, 270).
magnitude_factor(12, read, 10).

case(13, defendant).
value_assignment(13, protest, screamed).
value_assignment(13, screen, 210).
value_assignment(13, activity, 150).
value_assignment(13, coop, verbal).
value_assignment(13, read, 85).
magnitude_factor(13, read, 60).

case(14, defendant).
value_assignment(14, protest, none).
value_assignment(14, screen, 255).
value_assignment(14, activity, 75).
value_assignment(14, coop, played).
value_assignment(14, read, 5).
magnitude_factor(14, protest, none).
magnitude_factor(14, coop, played).

case(15, defendant).
value_assignment(15, protest, complained).
value_assignment(15, screen, 60).
value_assignment(15, activity, 150).
value_assignment(15, coop, played).
value_assignment(15, read, 25).
magnitude_factor(15, protest, cried).
magnitude_factor(15, screen, 60).
magnitude_factor(15, coop, ignored).

case(16, defendant).
value_assignment(16, protest, kicked).
value_assignment(16, screen, 180).
value_assignment(16, activity, 30).
value_assignment(16, coop, physical).
value_assignment(16, read, 85).
magnitude_factor(16, read, 70).

case(17, defendant).
value_assignment(17, protest, none).
value_assignment(17, screen, 195).
value_assignment(17, activity, 75).
value_assignment(17, coop, verbal).
value_assignment(17, read, 0).
magnitude_factor(17, protest, cried).

case(18, defendant).
value_assignment(18, protest, none).
value_assignment(18, screen, 165).
value_assignment(18, activity, 285).
value_assignment(18, coop, verbal).
value_assignment(18, read, 100).
magnitude_factor(18, protest, none).
magnitude_factor(18, screen, 180).
magnitude_factor(18, activity, 90).
magnitude_factor(18, read, 90).

case(19, defendant).
value_assignment(19, protest, kicked).
value_assignment(19, screen, 180).
value_assignment(19, activity, 60).
value_assignment(19, coop, verbal).
value_assignment(19, read, 50).
magnitude_factor(19, screen, 240).
magnitude_factor(19, read, 30).

case(20, defendant).
value_assignment(20, protest, screamed).
value_assignment(20, screen, 240).
value_assignment(20, activity, 15).
value_assignment(20, coop, ignored).
value_assignment(20, read, 100).
magnitude_factor(20, read, 10).

