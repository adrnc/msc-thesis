dimension_strengthens(d1, defendant).
dimension_strengthens(d2, defendant).

case(c1, defendant).
dimensional_fact(c1, d1, 1).
dimensional_fact(c1, d2, 1).
reason_magnitude(c1, d1, 1).
reason_magnitude(c1, d2, 1).

case(c2, plaintiff).
dimensional_fact(c2, d1, 1).
dimensional_fact(c2, d2, 0).
reason_magnitude(c1, d1, 1).

unsolved_case(c3).
dimensional_fact(c3, d1, 1).
dimensional_fact(c3, d2, 2). %dimensional_fact(c3, d2, 0).
