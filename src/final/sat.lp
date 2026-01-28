1 { supports(S, D, P) : rval(C, D, P) } :- case(C, S).

1 { supports(S, D, P) : side(S) } 1 :- case(C, _), rval(C, D, P).

supports(S, D, Q) :- supports(S, D, P), ord(S, D, P, Q).

#show supports/3.
