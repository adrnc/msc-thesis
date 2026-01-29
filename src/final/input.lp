strengthens(d1, defendant).
strengthens(d2, defendant).
strengthens(d3, defendant).

case(c1, defendant).
val(c1, d1, 18). mf(c1, d1, 12).

case(c2, defendant).
val(c2, d2, 85). mf(c2, d2, 75).

case(c3, plaintiff).
val(c3, d2, 40).

case(c4, defendant).
val(c4, d2, 30).
val(c4, d3, 7).

focus_case(cf).
val(cf, d1, 16).
val(cf, d3, 8).
