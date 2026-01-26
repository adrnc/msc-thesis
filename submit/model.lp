%%% DEFINE SIDES %%%

side(plaintiff).
side(defendant).

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% INFER VALUE RELATION %%%

ord(S, D, P, Q) :-
    val(_, D, P), val(_, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% RESTRICT GROUNDING OF SETS %%%

% We instantiate residuals using the function residual(X, Y).
% However, there is a problem of infinite recursion that comes
% with this definition. Since X can also be a residual, the
% statement could expand to residual(residual(XX, XY), Y).
% This can continue to infinity.

% Such infinite recursion can prevent successful grounding.
% Grounding is the mechanism that transforms all rules in ASP
% into variable-free forms before solving the program. Since
% residual(...) may expand infinitely, grounding cannot succeed.

% To prevent this, we will limit how residual(...) can be
% expanded on a syntactical level. We want to construct set(X),
% where X refers to a valid expansion. We then limit the
% grounding of subsequent rules containing fact situations,
% by requiring that there are matching set(...) statements.

% We now initialise cases that contain the number of dimensions
% in the domain.
ncase(reduct(C), S, N) :- case(C, S), N = #count { D : val(C, D, _) }.
ncase(reason(C), S, N) :- case(C, S), N = #count { D : mf(C, D, _) }.

% We also initialise the value assignments for reduct and reason
% cases
val(reduct(C), D, P) :- case(C, S), mf(C, D, P).
val(reduct(C), D, P) :- case(C, S), val(C, D, P), not mf(C, D, _).
val(reason(C), D, P) :- case(C, S), mf(C, D, P).

% This is the crucial step where we limit the grounding.
% When generating residuals, we make the observation that
% residual(X, Y) contains at least one fewer dimension than
% Y, and at least one fewer dimension than X.
ncase(residual(X, Y), S, K) :-
    % Since residuals are generated for opposing cases,
    % we pick two opposing cases together with their
    % domain sizes.
    ncase(X, S', M), ncase(Y, S, N), opposite(S, S'),
    % The size of the residual has to be N - M, since
    % it is the set difference Y \ X, and X is a subset
    % of Y.
    K = N - M, M < N,
    % The grounding is limited by requiring that at least
    % some element remains in the residual.
    1 <= K.

% Is residual(residual(X, Y), X) possible? No, since X is a subset of Y
% Is residual(Y, residual(X, Y)) possible?
% Is residual(residual(residual(X, Y), Z), Y) possible?

% We also infer the value assignments for the residual.
val(residual(X, Y), D, P) :-
    ncase(residual(X, Y), _, _),
    not val(X, D, _), val(Y, D, P).

% We can now infer set(...) predicates by adding the focus
% case, as well as any fact situation that was added to ucase(...).
set(F) :- focus_case(F).
set(X) :- ncase(X, _, _).

%%% PERFORM DOMAIN COMPARISONS %%%

missing_dim(X, Y) :-
    set(X), set(Y),
    val(Y, D, _), not val(X, D, _).

subseteq(X, Y) :-
    set(X), set(Y),
    not missing_dim(Y, X).

worse_on_dim(S, X, Y) :-
    set(X), set(Y),
    val(X, D, P), val(Y, D, Q),
    ord(S, D, P, Q), P != Q.

leq(S, X, Y) :-
    side(S), set(X), set(Y),
    not worse_on_dim(S, Y, X).

%%% INITIALISE POOLS %%%

pooled(reduct(C), S) :- case(C, S).
pooled(reason(C), S) :- case(C, S).

%%% PRUNE POOLS %%%

pruned(Y, S) :-
    pooled(X, S), pooled(Y, S),
    X != Y, not pruned(X, S),
    subseteq(X, Y), subseteq(Y, X), leq(S, X, Y).

%%% GENERATE RESIDUALS %%%

pooled(residual(X, Y), S) :-
    pooled(X, S'), pooled(Y, S), opposite(S, S'),
    not pruned(X, S'), not pruned(Y, S),
    subseteq(X, Y), leq(S, Y, X),
    not val(X, D, _), val(Y, D, _).

%%% CHECK CONSTRAINT %%%

1 { constraint(F, S) : focus_case(F), side(S) } 1.

candidate(X, S, F) :-
    pooled(X, S), not pruned(X, S), constraint(F, S),
    subseteq(X, F), leq(S, X, F).

1 { precedent(X, S, F) : candidate(X, S, F) }.

:-
    precedent(X, S, F), precedent(Y, S, F),
    X != Y, val(X, D, _), val(Y, D, _).

dim_covered(F, S, D) :-
    precedent(X, S, F), val(X, D, _).

:-
    constraint(F, S), val(F, D, _),
    not dim_covered(F, S, D).
