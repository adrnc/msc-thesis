covered(F, S, D) :-
    focus_case(F), rval(F, D, P),
    supports(S, D, Q).

worse_on_dim(S, F, C) :-
    focus_case(F), case(C, S),
    rval(F, D, P), rval(C, D, Q),
    ord(S, D, P, Q), P != Q.

precedent(F, C, S) :-
    focus_case(F), case(C, S), opposite(S, S'),
    not worse_on_dim(S, F, C),
    #count { D : rval(F, D, _), not rval(C, D, _), not covered(F, S, D) } = 0,
    #count { D : not rval(F, D, _), rval(C, D, P), not supports(S', D, P) } = 0.

constraint(F, S) :- precedent(F, C, S).

supports(defendant,d1,15).
