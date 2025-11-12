%%% SIDES %%%

side(plaintiff). side(defendant).

opp(plaintiff, defendant).
opp(defendant, plaintiff).

%%% CONSTRUCT VALUE RELATION %%%

dval(Dim, Val) :- va(Case, Dim, Val).
dval(Dim, Val) :- mg(Case, Dim, Val).

rel(Side, Dim, Val1, Val2) :-
    strengthens(Dimension, Side),
    dval(Dim, Val1), dval(Dim, Val2),
    Val1 <= Val2.

rel(OppSide, Dim, Val2, Val1) :-
    rel(Side, Dim, Val1, Val2),
    opp(Side, OppSide).

%%% TRANSLATE CASE BASE %%%

has_mg(Case, Dim) :- mg(Case, Dim, Val).

va'(Case, Dim, Val) :- mg(Case, Dim, Val).

va'(Case, Dim, Val) :-
    va(Case, Dim, Val),
    not has_mg(Case, Dim).

%%% COMPARE STRENGTH OF FACT SITUATIONS %%%

case_and_declike(Case, Side, Dec) :-
    case(Case, Side), declike(Dec),
    Case != Dec.

has_va'(Case, Dim) :- va'(Case, Dim, Val).

-case_forces_declike'(Case, Side, Dec) :-
    case_and_declike(Case, Side, Dec),
    va'(Case, Dim, Val), not has_va'(Dec, Dim).

-case_forces_declike'(Case, Side, Dec) :-
    case_and_declike(Case, Side, Dec),
    va'(Case, Dim, Val1), va'(Dec, Dim, Val2),
    not rel(Side, Dim, Val1, Val2).

forced_declike'(Dec, Side) :-
    case_and_declike(Case, Side, Dec),
    not -case_forces_declike'(Case, Side, Dec).

declike_dim_covered(Dec, Side, Dim) :-
    case_and_declike(Case, Side, Dec),
    va'(Case, Dim, Val),
    not -case_forces_declike'(Case, Side, Dec).

-forced_declike(Dec, Side) :-
    declike(Dec), side(Side),
    not forced_declike'(Dec, Side).

-forced_declike(Dec, Side) :-
    declike(Dec), side(Side),
    va'(Dec, Dim, Val),
    not declike_dim_covered(Dec, Side, Dim).

%%% CHECK CONSISTENCY %%%

declike(Case) :- case(Case, Side).

-consistent_case(Case, Side) :-
    case(Case, Side), opp(Side, OppSide),
    not -forced_declike(Case, OppSide).

-consistent_base :- -consistent_case(Case, Side).

%%% CHECK DECISION CONSTRAINTS %%%

declike(Dec) :-
    unsolved_case(Dec),
    not -consistent_base.

constraint(Dec, Side) :-
    unsolved_case(Dec), side(Side),
    not -forced_declike(Dec, Side).
