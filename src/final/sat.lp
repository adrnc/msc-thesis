1 { supports(S, D, P) : side(S) } 1 :- case(C, _), rval(C, D, P).

supports(S, D, Q) :- supports(S, D, P), ord(S, D, P, Q).

1 { supports(S, D, P) : rval(C, D, P) } :- case(C, S).

distinguishable(C, C') :-
    case(C, S), case(C', S'), opposite(S, S'),
    rval(C, D, P), rval(C', D, Q),
    not ord(S, D, P, Q).

1 { supports(S, D, P) : rval(C, D, P), not rval(C', D, _);
    supports(S', D, Q) : rval(C', D, Q), not rval(C, D, _) } :-
    case(C, S), case(C', S'), opposite(S, S'),
    not distinguishable(C, C').

#show supports/3.
