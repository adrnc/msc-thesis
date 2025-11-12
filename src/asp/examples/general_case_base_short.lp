strengthens(d1, plaintiff).
strengthens(d2, plaintiff).
strengthens(d3, plaintiff).

case(c1, plaintiff).
va(c1, d1, 20). mg(c1, d1, 15).

case(c2, plaintiff).
va(c2, d2, 100). mg(c2, d2, 90).
va(c2, d3, 10).

unsolved_case(c3).
va(c3, d1, 17).
va(c3, d2, 95).

unsolved_case(c4).
va(c4, d1, 17).
va(c4, d2, 95).
va(c4, d3, 100).
