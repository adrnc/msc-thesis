%%% DIMENSIONS %%%

% Every occurring dimension needs to specify a value relation.
% For simplicity, any dimension occuring in the input is assumed
% to only contain integer values and a natural ordering of these.
% Usually, all non-integer values can be mapped to integers. The
% predicate strengthens(D, S), where D is the dimension and S is
% the side, defines which side is strengthened when the integer
% values become larger.
strengthens(d1, defendant).
strengthens(d2, defendant).
strengthens(d3, defendant).

%%% CASE BASE %%%

case(c1, defendant).
val(c1, d1, 18). mf(c1, d1, 12).

case(c2, defendant).
val(c2, d2, 80). mf(c2, d2, 75).
val(c2, d3, 1).

case(c2', plaintiff).
val(c2', d3, 2).

%%% FOCUS CASE %%%

focus_case(c3).
val(c3, d1, 16).
val(c3, d2, 77).
