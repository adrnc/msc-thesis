% PART OF INPUT

% case with some reason and some fact situation
case(c4, r4, defendant).

dimension(c1, d1, 30).
dimension(c1, d2, 60).
%dimension(c1, d2, 15).

magnitude(r4, d1, 12).

% some unresolved case
case(c6, r6, plaintiff).

dimension(c6, d1, 36).
dimension(c6, d2, 10).

magnitude(r6, d2, 25).

% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).
