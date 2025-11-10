int_dimension_strengthens(d1, plaintiff).
int_dimension_strengthens(d2, plaintiff).
int_dimension_strengthens(d3, plaintiff).

case(c1, plaintiff).
value_assignment(c1, d1, 20).
magnitude_factor(c1, d1, 15).

case(c2, plaintiff).
value_assignment(c2, d2, 100).
value_assignment(c2, d3, 10).
magnitude_factor(c2, d2, 90).

unsolved_case(c3).
value_assignment(c3, d1, 17).
value_assignment(c3, d2, 95).
