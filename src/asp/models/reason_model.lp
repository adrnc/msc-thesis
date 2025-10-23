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

%%% CONSISTENCY %%%

case_like(Case, Side) :-
    case(Case, Side).

magnitude_factor_like(Case, Dimension, ThresholdValue) :-
    magnitude_factor(Case, Dimension, ThresholdValue).

has_magnitude_factor_like(Case, Dimension) :-
    magnitude_factor_like(Case, Dimension, ThresholdValue).

opposing_case_likes(Case, Side, OppCase, OppSide) :-
    case_like(Case, Side),
    case_like(OppCase, OppSide),
    opposite_side(Side, OppSide),
    Case != OppCase.

not_value_assignment_satisfies_opposing_magnitude_factor(Case, Side, OppCase, OppSide, Dimension) :-
    % pick two opposing cases
    opposing_case_likes(Case, Side, OppCase, OppSide),
    % pick a value assignment from the fact situation of the first case
    value_assignment(Case, Dimension, Value),
    % pick the matching magnitude factor from the reason of the second case
    magnitude_factor_like(OppCase, Dimension, ThresholdValue),
    % assert that the value assignment does not satisfy the magnitude factor
    strict_value_relation(OppSide, Dimension, Value, ThresholdValue).

not_fact_situation_satisfies_opposing_reason(Case, Side, OppCase, OppSide) :-
    not_value_assignment_satisfies_opposing_magnitude_factor(Case, Side, OppCase, OppSide, Dimension).

not_negated_magnitude_factor_present_for_opposing_magnitude_factor(Case, Side, OppCase, OppSide, Dimension) :-
    % pick two opposing cases
    opposing_case_likes(Case, Side, OppCase, OppSide),
    % ensure that the magnitude factor from the second case is present
    has_magnitude_factor_like(OppCase, Dimension),
    % ensure that the magnitude factor from the first case is not present
    not has_magnitude_factor_like(Case, Dimension).

not_negated_magnitude_factor_satisfies_opposing_magnitude_factor(Case, Side, OppCase, OppSide, Dimension) :-
    % pick two opposing cases
    opposing_case_likes(Case, Side, OppCase, OppSide),
    % pick a magnitude factor from the reason of the first case
    magnitude_factor_like(Case, Dimension, ThresholdValue1),
    % pick the matching magnitude factor from the reason of the second case
    magnitude_factor_like(OppCase, Dimension, ThresholdValue2),
    % check that the magnitude in the first case is weaker
    % than the magnitude in the second case
    strict_value_relation(OppSide, Dimension, ThresholdValue1, ThresholdValue2).

not_negated_reason_satisfies_opposing_reason(Case, Side, OppCase, OppSide) :-
    not_negated_magnitude_factor_present_for_opposing_magnitude_factor(Case, Side, OppCase, OppSide, Dimension).

not_negated_reason_satisfies_opposing_reason(Case, Side, OppCase, OppSide) :-
    not_negated_magnitude_factor_satisfies_opposing_magnitude_factor(Case, Side, OppCase, OppSide, Dimension).

not_consistent_cross_condition(Case, Side, OppCase, OppSide) :-
    opposing_case_likes(Case, Side, OppCase, OppSide),
    not not_fact_situation_satisfies_opposing_reason(Case, Side, OppCase, OppSide).

not_consistent_cross_condition(Case, Side, OppCase, OppSide) :-
    opposing_case_likes(Case, Side, OppCase, OppSide),
    not not_negated_reason_satisfies_opposing_reason(Case, Side, OppCase, OppSide).

not_consistent(Case, Side, OppCase, OppSide) :-
    not_consistent_cross_condition(Case, Side, OppCase, OppSide),
    not_consistent_cross_condition(OppCase, OppSide, Case, Side).

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

magnitude_factor_like(Case, Dimension, Value) :-
    decision(Case, Side),
    value_assignment(Case, Dimension, Value).

not_decision_consistent_with_case(Case, Side, OppCase, OppSide) :-
    decision(Case, Side),
    case(OppCase, OppSide),
    not_consistent(Case, Side, OppCase, OppSide).

not_decision_permissible(Case, Side) :-
    not_decision_consistent_with_case(Case, Side, OppCase, OppSide).
