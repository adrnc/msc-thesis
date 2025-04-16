%%% DIMENSION CONFIGURATION %%%

dimension_config(d1, defendant, -5, 5).
dimension_config(d2, defendant, -5, 5).

%%% SOLVED CASES %%%

case(c1, defendant).
dimension(c1, d1, 1).
dimension(c1, d2, 1).
magnitude(c1, d1, 1).
magnitude(c1, d2, 1).

case(c2, plaintiff).
dimension(c2, d1, 1).
dimension(c2, d2, 0).
magnitude(c1, d1, 1).

%%% SOLVED %%%

unsolved_case(c3).
dimension(c3, d1, 1).
dimension(c3, d2, 2). %dimension(c3, d2, 0).
