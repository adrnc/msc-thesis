%%% SIDES %%%

side(plaintiff).
side(defendant).

opposite_side(plaintiff, defendant).
opposite_side(defendant, plaintiff).

%%% VALUE RELATION %%%

dimension_value(Dimension, Value) :- value_assignment(Case, Dimension, Value).
dimension_value(Dimension, Value) :- magnitude_factor(Case, Dimension, Value).

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

% antisymmetry
:-
    value_relation(Side, Dimension, Value1, Value2),
    value_relation(Side, Dimension, Value2, Value1),
    Value1 != Value2.

% duality
value_relation(OppositeSide, Dimension, Value2, Value1) :-
    value_relation(Side, Dimension, Value1, Value2),
    opposite_side(Side, OppositeSide).

strict_value_relation(Side, Dimension, Value1, Value2) :-
    value_relation(Side, Dimension, Value1, Value2),
    Value1 != Value2.

%%% TRANSLATION %%%

has_magnitude_factor(Case, Dimension) :-
    magnitude_factor(Case, Dimension, ThresholdValue).

% use magnitude factors if present
reduced_value_assignment(Case, Dimension, Value) :-
    magnitude_factor(Case, Dimension, Value).

% use value assignments otherwise
reduced_value_assignment(Case, Dimension, Value) :-
    case(Case, Side),
    value_assignment(Case, Dimension, Value),
    not has_magnitude_factor(Case, Dimension).

%%% CONSISTENCY %%%

case_like(Case, Side) :- case(Case, Side).
reduced_value_assignment_like(Case, Dimension, Value) :-
    reduced_value_assignment(Case, Dimension, Value).

opposing_case_likes(Case, Side, OppCase, OppSide) :-
    case_like(Case, Side),
    case_like(OppCase, OppSide),
    opposite_side(Side, OppSide),
    Case != OppCase.

not_value_assignment_leq_opposing_value_assignment(Case, Side, OppCase, OppSide, Dimension) :-
    % pick two opposing cases
    opposing_case_likes(Case, Side, OppCase, OppSide),
    % pick the reduced value assignment from the first case
    reduced_value_assignment_like(Case, Dimension, Value1),
    % pick the matching reduced value assignment from the second case
    reduced_value_assignment_like(OppCase, Dimension, Value2),
    % check if the reduced value assignment from the first case is stronger
    strict_value_relation(Side, Dimension, Value2, Value1).

not_fact_situation_leq_opposing_fact_situation(Case, Side, OppCase, OppSide) :-
    not_value_assignment_leq_opposing_value_assignment(Case, Side, OppCase, OppSide, Dimension).

not_consistent(Case, Side, OppCase, OppSide) :-
    opposing_case_likes(Case, Side, OppCase, OppSide),
    not not_fact_situation_leq_opposing_fact_situation(Case, Side, OppCase, OppSide).

not_cases_consistent(Case, Side, OppCase, OppSide) :-
    case(Case, Side),
    case(OppCase, OppSide),
    not_consistent(Case, Side, OppCase, OppSide).

not_case_base_consistent :-
    not_cases_consistent(Case, Side, OppCase, OppSide).

%%% DECISION %%%

decision(Case, Side) :-
    unsolved_case(Case),
    side(Side),
    not not_case_base_consistent.

case_like(Case, Side) :-
    decision(Case, Side).

reduced_value_assignment_like(Case, Dimension, Value) :-
    decision(Case, Side),
    value_assignment(Case, Dimension, Value).

not_decision_consistent_with_case(Case, Side, OppCase, OppSide) :-
    decision(Case, Side),
    case(OppCase, OppSide),
    not_consistent(Case, Side, OppCase, OppSide).

not_decision_permissible(Case, Side) :-
    not_decision_consistent_with_case(Case, Side, OppCase, OppSide).
