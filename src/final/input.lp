strengthens(d1, defendant).
strengthens(d2, defendant).
strengthens(d3, defendant).

case(c1, plaintiff).
val(c1, d1, 12).
val(c1, d2, 60).

case(c2, defendant).
val(c2, d1, 10).
val(c2, d2, 60).
val(c2, d3, 8).

case(c4, defendant).
val(c4, d1, 15).

focus_case(f).
val(f, d1, 15).
val(f, d3, 10).
