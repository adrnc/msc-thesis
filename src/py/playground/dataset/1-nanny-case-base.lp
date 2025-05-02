%%% DIMENSION DEFINITIONS %%%

dimension_definition(d0, plaintiff, 0, 180).
dimension_definition(d1, plaintiff, 0, 100).
dimension_definition(d2, plaintiff, 0, 10).
dimension_definition(d3, plaintiff, 20, 80).
dimension_definition(d4, defendant, 0, 60).
dimension_definition(d5, defendant, 0, 10).
dimension_definition(d6, defendant, 0, 180).
dimension_definition(d7, defendant, 0, 100).
dimension_definition(d8, defendant, 0, 10).
dimension_definition(d9, defendant, 0, 120).

%%% CASE BASE %%%

% CASE c0: Very high screen time and protests with weak routine—kids misbehaved, so parents enforce bedtime.
case(c0, defendant).
dimensional_fact(c0, d0, 160).
dimensional_fact(c0, d1, 70).
dimensional_fact(c0, d2, 8).
dimensional_fact(c0, d3, 65).
dimensional_fact(c0, d4, 15).
dimensional_fact(c0, d5, 3).
dimensional_fact(c0, d6, 20).
dimensional_fact(c0, d7, 40).
dimensional_fact(c0, d8, 2).
dimensional_fact(c0, d9, 10).
reason_magnitude(c0, d0, 150).
reason_magnitude(c0, d2, 8).

% CASE c1: Excellent reading, routine, activity and homework—kids earn to stay up a bit later.
case(c1, plaintiff).
dimensional_fact(c1, d0, 40).
dimensional_fact(c1, d1, 20).
dimensional_fact(c1, d2, 1).
dimensional_fact(c1, d3, 30).
dimensional_fact(c1, d4, 50).
dimensional_fact(c1, d5, 9).
dimensional_fact(c1, d6, 100).
dimensional_fact(c1, d7, 90).
dimensional_fact(c1, d8, 7).
dimensional_fact(c1, d9, 60).
reason_magnitude(c1, d4, 45).
reason_magnitude(c1, d5, 8).
reason_magnitude(c1, d7, 95).

% CASE c2: Moderate routine but very high sugar and noise—misbehavior predominates, bedtime enforced.
case(c2, defendant).
dimensional_fact(c2, d0, 100).
dimensional_fact(c2, d1, 85).
dimensional_fact(c2, d2, 6).
dimensional_fact(c2, d3, 70).
dimensional_fact(c2, d4, 20).
dimensional_fact(c2, d5, 5).
dimensional_fact(c2, d6, 50).
dimensional_fact(c2, d7, 60).
dimensional_fact(c2, d8, 3).
dimensional_fact(c2, d9, 25).
reason_magnitude(c2, d1, 80).
reason_magnitude(c2, d3, 65).

% CASE c3: Strong homework, activity and engagement—kids behaved well, so they may stay up.
case(c3, plaintiff).
dimensional_fact(c3, d0, 50).
dimensional_fact(c3, d1, 30).
dimensional_fact(c3, d2, 2).
dimensional_fact(c3, d3, 25).
dimensional_fact(c3, d4, 40).
dimensional_fact(c3, d5, 8).
dimensional_fact(c3, d6, 120).
dimensional_fact(c3, d7, 85).
dimensional_fact(c3, d8, 6).
dimensional_fact(c3, d9, 50).
reason_magnitude(c3, d6, 110).
reason_magnitude(c3, d7, 80).

% CASE c4: High protests and screen time with poor routine—misbehavior, bedtime enforced.
case(c4, defendant).
dimensional_fact(c4, d0, 130).
dimensional_fact(c4, d1, 60).
dimensional_fact(c4, d2, 9).
dimensional_fact(c4, d3, 55).
dimensional_fact(c4, d4, 10).
dimensional_fact(c4, d5, 4).
dimensional_fact(c4, d6, 30).
dimensional_fact(c4, d7, 35).
dimensional_fact(c4, d8, 1).
dimensional_fact(c4, d9, 15).
reason_magnitude(c4, d2, 9).
reason_magnitude(c4, d0, 120).

% CASE c5: Balanced screen and reading with solid routine—good behavior, kids stay up.
case(c5, plaintiff).
dimensional_fact(c5, d0, 70).
dimensional_fact(c5, d1, 30).
dimensional_fact(c5, d2, 3).
dimensional_fact(c5, d3, 35).
dimensional_fact(c5, d4, 45).
dimensional_fact(c5, d5, 7).
dimensional_fact(c5, d6, 80).
dimensional_fact(c5, d7, 75).
dimensional_fact(c5, d8, 5).
dimensional_fact(c5, d9, 40).
reason_magnitude(c5, d4, 40).
reason_magnitude(c5, d5, 7).

% CASE c6: Low activity but extreme noise and sugar—misbehavior, bedtime enforced.
case(c6, defendant).
dimensional_fact(c6, d0, 110).
dimensional_fact(c6, d1, 90).
dimensional_fact(c6, d2, 7).
dimensional_fact(c6, d3, 75).
dimensional_fact(c6, d4, 10).
dimensional_fact(c6, d5, 2).
dimensional_fact(c6, d6, 15).
dimensional_fact(c6, d7, 50).
dimensional_fact(c6, d8, 2).
dimensional_fact(c6, d9, 20).
reason_magnitude(c6, d3, 70).
reason_magnitude(c6, d1, 85).

% CASE c7: Perfect sibling cooperation and engagement—good behavior, kids stay up.
case(c7, plaintiff).
dimensional_fact(c7, d0, 20).
dimensional_fact(c7, d1, 10).
dimensional_fact(c7, d2, 0).
dimensional_fact(c7, d3, 20).
dimensional_fact(c7, d4, 50).
dimensional_fact(c7, d5, 10).
dimensional_fact(c7, d6, 100).
dimensional_fact(c7, d7, 95).
dimensional_fact(c7, d8, 10).
dimensional_fact(c7, d9, 90).
reason_magnitude(c7, d8, 10).
reason_magnitude(c7, d9, 85).

% CASE c8: Moderate protests and screen with solid activity—misbehavior still moderate, bedtime enforced.
case(c8, defendant).
dimensional_fact(c8, d0, 90).
dimensional_fact(c8, d1, 40).
dimensional_fact(c8, d2, 5).
dimensional_fact(c8, d3, 50).
dimensional_fact(c8, d4, 25).
dimensional_fact(c8, d5, 5).
dimensional_fact(c8, d6, 70).
dimensional_fact(c8, d7, 65).
dimensional_fact(c8, d8, 4).
dimensional_fact(c8, d9, 30).
reason_magnitude(c8, d0, 85).
reason_magnitude(c8, d2, 5).

% CASE c9: High reading, routine and homework—excellent behavior, kids earn to stay up.
case(c9, plaintiff).
dimensional_fact(c9, d0, 50).
dimensional_fact(c9, d1, 30).
dimensional_fact(c9, d2, 2).
dimensional_fact(c9, d3, 35).
dimensional_fact(c9, d4, 55).
dimensional_fact(c9, d5, 8).
dimensional_fact(c9, d6, 90).
dimensional_fact(c9, d7, 80).
dimensional_fact(c9, d8, 6).
dimensional_fact(c9, d9, 45).
reason_magnitude(c9, d4, 50).
reason_magnitude(c9, d6, 85).

