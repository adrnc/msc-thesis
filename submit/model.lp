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

% This predicate defines the potential sizes a domain can have,
% by counting how many dimensions are defined. The statement
% usize(1..N) is a shorthand expression for generating
% usize(1)., usize(2)., ... usize(N).
usize(1..N) :- N = #count { D : strengthens(D, _) }.

% We now initialise pool cases that contain an upper bound on
% the number of dimensions that are contained within them.
% For reduct and reason cases, these are exact by counting
% the value assignments and magnitude factors.
ucase(reduct(C), S) :- case(C, S).
ucase(reason(C), S) :- case(C, S).

val(reduct(C), D, P) :- case(C, S), mf(C, D, P).
val(reduct(C), D, P) :- case(C, S), val(C, D, P), not mf(C, D, _).
val(reason(C), D, P) :- case(C, S), mf(C, D, P).

% This is the crucial step where we limit the grounding.
% When generating residuals, we make the observation that
% residual(X, Y) contains strictly one fewer dimension than
% Y. Therefore, we know that the upper bound of residual(X, Y)
% is at most the upper bound of Y minus one.
ucase(residual(X, Y), S) :-
    % Since residuals are generated for opposing cases,
    % we pick two opposing cases together with their
    % upper bounds.
    ucase(X, S'), ucase(Y, S), opposite(S, S'),
    % Since the domain of X has to be a real subset of the
    % domain of Y, otherwise residual(X, Y) could be empty,
    % we know that the upper
    usize(XYD), XYD = #count { D : val(X, D, _), not val(Y, D, _) },
    usize(YXD), YXD = #count { D : val(Y, D, _), not val(X, D, _) },
    XYD = 0, YXD >= 1.

val(residual(X, Y), D, P) :-
    pooled(residual(X, Y), S),
    not val(X, D, _), val(Y, D, P).

% We can now infer set(...) predicates by adding the focus
% case, as well as any fact situation that was added to ucase(...).
set(F) :- focus_case(F).
set(X) :- ucase(X, _).

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

%1 { constraint(F, S) : focus_case(F), side(S) } 1.

candidate(X, S, F) :-
    pooled(X, S), not pruned(X, S), constraint(F, S),
    subseteq(X, F), leq(S, X, F).

%1 { precedent(X, S, F) : candidate(X, S, F) }.

%:-
%    precedent(X, S, F), precedent(Y, S, F),
%    X != Y, val(X, D, _), val(Y, D, _).

dim_covered(F, S, D) :-
    precedent(X, S, F), val(X, D, _).

%:-
%    constraint(F, S), val(F, D, _),
%    not dim_covered(F, S, D).
