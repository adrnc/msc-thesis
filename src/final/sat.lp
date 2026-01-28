1 { supports(S, D, P) : rval(C, D, P) } :- case(C, S).

1 { supports(S, D, P) : side(S) } 1 :- case(C, _), rval(C, D, P).

#show supports/3.
