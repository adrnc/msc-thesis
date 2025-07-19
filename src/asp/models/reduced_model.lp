%%% SIDES %%%

side(plaintiff).
side(defendant).

opposite_side(plaintiff, defendant).
opposite_side(defendant, plaintiff).

%%% VALUE RELATION %%%

dimension_value(Dimension, Value) :- fact(Case, Dimension, Value).
dimension_value(Dimension, Value) :- magnitude(Case, Dimension, Value).

value_relation(Side, Dimension, Value1, Value2) :-
    int_dimension_strengthens(Dimension, Side),
    dimension_value(Dimension, Value1),
    dimension_value(Dimension, Value2),
    Value1 <= Value2.

custom_dimension_ordering(Dimension, Value1, Value3) :-
    custom_dimension_ordering(Dimension, Value1, Value2),
    custom_dimension_ordering(Dimension, Value2, Value3).

value_relation(Side, Dimension, Value1, Value2) :-
    custom_dimension_strengthens(Dimension, Side),
    dimension_value(Dimension, Value1),
    dimension_value(Dimension, Value2),
    custom_dimension_ordering(Dimension, Value1, Value2).

% reflexivity
value_relation(Side, Dimension, Value, Value) :-
    side(Side),
    dimension_value(Dimension, Value).

% transitivity
value_relation(Side, Dimension, Value1, Value3) :-
    value_relation(Side, Dimension, Value1, Value2),
    value_relation(Side, Dimension, Value2, Value3).

% duality
value_relation(OppositeSide, Dimension, Value2, Value1) :-
    value_relation(Side, Dimension, Value1, Value2),
    opposite_side(Side, OppositeSide).

strict_value_relation(Side, Dimension, Value1, Value2) :-
    value_relation(Side, Dimension, Value1, Value2),
    Value1 != Value2.

%%% TRANSLATION %%%

has_magnitude(Case, Dimension) :-
    magnitude(Case, Dimension, ThresholdValue).

% use magnitudes if present
reduced_fact(Case, Dimension, Value) :-
    magnitude(Case, Dimension, Value).

% use facts otherwise
reduced_fact(Case, Dimension, Value) :-
    case(Case, Side),
    fact(Case, Dimension, Value),
    not has_magnitude(Case, Dimension).

%%% CONSISTENCY %%%

case_like(Case, Side) :- case(Case, Side).
reduced_fact_like(Case, Dimension, Value) :- reduced_fact(Case, Dimension, Value).

opposing_case_likes(Case, Side, OppCase, OppSide) :-
    case_like(Case, Side), case_like(OppCase, OppSide),
    opposite_side(Side, OppSide),
    Case != OppCase.

not_fact_leq_opposing_fact(Case, Side, OppCase, OppSide, Dimension) :-
    % pick two opposing cases
    opposing_case_likes(Case, Side, OppCase, OppSide),
    % pick the reduced fact from the first case
    reduced_fact_like(Case, Dimension, Value1),
    % pick the matching reduced fact from the second case
    reduced_fact_like(OppCase, Dimension, Value2),
    % check if the reduced fact from the first case is stronger
    strict_value_relation(Side, Dimension, Value2, Value1).

not_facts_leq_opposing_facts(Case, Side, OppCase, OppSide) :-
    not_fact_leq_opposing_fact(Case, Side, OppCase, OppSide, Dimension).

not_consistent(Case, Side, OppCase, OppSide) :-
    opposing_case_likes(Case, Side, OppCase, OppSide),
    not not_facts_leq_opposing_facts(Case, Side, OppCase, OppSide).

not_cases_consistent(Case, Side, OppCase, OppSide) :-
    case(Case, Side), case(OppCase, OppSide),
    not_consistent(Case, Side, OppCase, OppSide).

not_case_base_consistent :- not_cases_consistent(Case, Side, OppCase, OppSide).

%%% DECISION %%%

decision(Case, Side) :-
    unsolved_case(Case),
    side(Side),
    not not_case_base_consistent.

case_like(Case, Side) :- decision(Case, Side).

reduced_fact_like(Case, Dimension, Value) :-
    decision(Case, Side),
    fact(Case, Dimension, Value).

not_decision_consistent_with_case(Case, Side, OppCase, OppSide) :-
    decision(Case, Side),
    case(OppCase, OppSide),
    not_consistent(Case, Side, OppCase, OppSide).

not_decision_permissible(Case, Side) :-
    not_decision_consistent_with_case(Case, Side, OppCase, OppSide).
