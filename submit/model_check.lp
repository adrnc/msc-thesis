%%% DEFINE SIDES %%%

side(plaintiff).
side(defendant).

opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

%%% REDUCE CASE BASE %%%

rval(C, D, P) :- val(C, D, P), not mf(C, D, _).
rval(C, D, P) :- mf(C, D, P).

%%% INFER VALUE RELATION %%%

ord(S, D, P, Q) :-
    rval(_, D, P), rval(_, D, Q),
    strengthens(D, S), P <= Q.

% duality
ord(S', D, Q, P) :- ord(S, D, P, Q), opposite(S, S').

%%% COMPARE FACT SITUATIONS %%%

missing_dim(X, Y) :-
    rval(X, _, _), rval(Y, D, _), not rval(X, D, _).

subseteq(X, Y) :-
    rval(X, _, _), rval(Y, _, _),
    not missing_dim(Y, X).

worse_on_dim(S, X, Y) :-
    rval(X, D, P), rval(Y, D, Q),
    ord(S, D, P, Q), P != Q.

leq(S, X, Y) :-
    side(S), rval(X, _, _), rval(Y, _, _),
    not worse_on_dim(S, Y, X).

%%% MODEL CONSTRAINT %%%

% calculate potential precedents
precedent(C, S, F) :-
    case(C, S), focus_case(F),
    subseteq(C, F), leq(S, C, F).

% prune redundant precedents
pruned(C, S, F) :-
    precedent(C, S, F), precedent(C', S, F),
    C < C', subseteq(C, C').

% if no precedent exists, all values of the
% focus case need to be resolved
resolve(D, P, S) :-
    focus_case(F), side(S), rval(F, D, P),
    not precedent(_, S, F).

% if a precedent exists, only resolve values
% that are not covered by all precedents
resolve(D, P, S) :-
    precedent(C, S, F), not pruned(C, S, F),
    rval(F, D, P), not rval(C, D, _).

% this statement is inferred through guess and check,
% it will be true in all answer sets, otherwise it is false
%covered(D, P, S) :- resolve(D, P, S).

constraint(F, S) :-
    focus_case(F), side(S),
    % if covered is true in all answer sets for every dimension,
    % then this statement also holds for all answer sets
    0 == #count { D : rval(F, D, P), resolve(D, P, S), not covered(D, P, S) }.

% used for efficiency
:- constraint(F, S), constraint(F, S'), opposite(S, S').
