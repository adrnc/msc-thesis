% some dimension is worse on F than on C
failure(F, C, S) :-
    focus_case(F), case(C, S),
    rval(F, D, P), rval(C, D, Q),
    ord(S, D, P, Q), P != Q.

% some dimension that is in F but
% not in C does not support side S
failure(F, C, S) :-
    focus_case(F), case(C, S),
    rval(F, D, P), not rval(C, D, _),
    not supports(S, D, P).

% some dimension that is in C but
% not in F does not support the
% opposing side S'
failure(F, C, S) :-
    focus_case(F), case(C, S),
    not rval(F, D, _), rval(C, D, P),
    opposite(S, S'), not supports(S', D, P).

precedent(F, C, S) :-
    focus_case(F), case(C, S),
    not failure(F, C, S).

constraint(F, S) :- precedent(F, C, S).

supports(defendant,d1,15).
