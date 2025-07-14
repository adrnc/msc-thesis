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

value_relation(Side, Dimension, Value1, Value2) :-
    custom_dimension_strengthens(Dimension, Side),
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

%%% CONSISTENCY %%%

opposing_cases(Case, Side, OppCase, OppSide) :-
    case(Case, Side),
    case(OppCase, OppSide),
    opposite_side(Side, OppSide).

not_case_fact_satisfies_opposing_case_magnitude(Case, OppCase, Dimension) :-
    % pick two opposing cases
    opposing_cases(Case, Side, OppCase, OppSide),
    % pick a fact from the fact situation of the first case
    fact(Case, Dimension, Value),
    % pick a magnitude from the reason of the second case
    magnitude(OppCase, Dimension, ThresholdValue),
    % check that the fact does not satisfy the magnitude
    strict_value_relation(OppSide, Dimension, Value, ThresholdValue).

not_case_facts_satisfy_opposing_case_reason(Case, OppCase) :-
    not_case_fact_satisfies_opposing_case_magnitude(Case, OppCase, Dimension).

not_case_negated_magnitude_satisfies_opposing_case_magnitude(Case, OppCase, Dimension) :-
    % pick two opposing cases
    opposing_cases(Case, Side, OppCase, OppSide),
    % pick a magnitude from the reason of the first case
    magnitude(Case, Dimension, ThresholdValue1),
    % pick a magnitude from the reason of the second case
    magnitude(OppCase, Dimension, ThresholdValue2),
    % check that the magnitude in the first case is weaker
    % than the magnitude in the second case
    strict_value_relation(OppSide, Dimension, ThresholdValue1, ThresholdValue2).

not_case_negated_reason_satisfies_opposing_case_reason(Case, OppCase) :-
    not_case_negated_magnitude_satisfies_opposing_case_magnitude(Case, OppCase, Dimension).

not_cases_consistent(Case, OppCase) :-
  opposing_cases(Case, Side, OppCase, OppSide),
  not not_case_facts_satisfy_opposing_case_reason(Case, OppCase),
  not not_case_facts_satisfy_opposing_case_reason(OppCase, Case).

not_cases_consistent(Case, OppCase) :-
  opposing_cases(Case, Side, OppCase, OppSide),
  not not_case_facts_satisfy_opposing_case_reason(Case, OppCase),
  not not_case_negated_reason_satisfies_opposing_case_reason(OppCase, Case).

not_cases_consistent(Case, OppCase) :-
  opposing_cases(Case, Side, OppCase, OppSide),
  not not_case_negated_reason_satisfies_opposing_case_reason(Case, OppCase),
  not not_case_facts_satisfy_opposing_case_reason(OppCase, Case).

not_cases_consistent(Case, OppCase) :-
  opposing_cases(Case, Side, OppCase, OppSide),
  not not_case_negated_reason_satisfies_opposing_case_reason(Case, OppCase),
  not not_case_negated_reason_satisfies_opposing_case_reason(OppCase, Case).

not_case_base_consistent :- not_cases_consistent(Case, OppCase).

%%% DECISION %%%

case_decision(Case, Side) :-
    unsolved_case(Case),
    side(Side),
    not not_case_base_consistent.

opposing_case_decision(Case, Side, OppCase, OppSide) :-
    case_decision(Case, Side),
    case(OppCase, OppSide),
    opposite_side(Side, OppSide).

not_case_decision_fact_satisfies_opposing_case_magnitude(Case, Side, OppCase, Dimension) :-
    % pick the case decision with an opposing case
    opposing_case_decision(Case, Side, OppCase, OppSide),
    % pick a fact from the fact situation of the case decision
    fact(Case, Dimension, Value),
    % pick a magnitude from the reason of the opposing case
    magnitude(OppCase, Dimension, ThresholdValue),
    % check that the fact does not satisfy the magnitude
    strict_value_relation(OppSide, Dimension, Value, ThresholdValue).

not_case_decision_facts_satisfy_opposing_case_reason(Case, Side, OppCase) :-
    not_case_decision_fact_satisfies_opposing_case_magnitude(Case, Side, OppCase, Dimension).

not_case_decision_fact_leq_opposing_case_fact(Case, Side, OppCase, Dimension) :-
    % pick the case decision with an opposing case
    opposing_case_decision(Case, Side, OppCase, OppSide),
    % pick a fact from the fact situation of the case decision
    fact(Case, Dimension, Value1),
    % pick a fact from the fact situation of the opposing case
    fact(OppCase, Dimension, Value2),
    % check that the fact in the case decision is stronger
    % than the fact in the opposing case
    strict_value_relation(Side, Dimension, Value2, Value1).

not_case_decision_facts_leq_opposing_case_facts(Case, Side, OppCase) :-
    not_case_decision_fact_leq_opposing_case_fact(Case, Side, OppCase, Dimension).

not_case_decision_maxmagnitude_entailedby_opposing_case_negated_magnitude(Case, Side, OppCase, Dimension) :-
    % pick the case decision with an opposing case
    opposing_case_decision(Case, Side, OppCase, OppSide),
    % pick a fact from the fact situation of the case decision
    fact(Case, Dimension, Value),
    % pick a magnitude from the reason of the opposing case
    magnitude(OppCase, Dimension, ThresholdValue),
    % check that the fact is stronger than the magnitude
    strict_value_relation(Side, Dimension, ThresholdValue, Value).

not_case_decision_maxreason_entailedby_opposing_case_negated_reason(Case, Side, OppCase) :-
    not_case_decision_maxmagnitude_entailedby_opposing_case_negated_magnitude(Case, Side, OppCase, Dimension).

not_case_decision_consistent_with_opposing_case(Case, Side, OppCase) :-
    opposing_case_decision(Case, Side, OppCase, OppSide),
    not not_case_decision_facts_satisfy_opposing_case_reason(Case, Side, OppCase),
    not not_case_decision_facts_leq_opposing_case_facts(Case, Side, OppCase).

not_case_decision_consistent_with_opposing_case(Case, Side, OppCase) :-
    opposing_case_decision(Case, Side, OppCase, OppSide),
    not not_case_decision_facts_satisfy_opposing_case_reason(Case, Side, OppCase),
    not not_case_decision_maxreason_entailedby_opposing_case_negated_reason(Case, Side, OppCase).

not_case_decision_permissible(Case, Side) :-
    not_case_decision_consistent_with_opposing_case(Case, Side, OppCase).

case_decision_permissible(Case, Side) :-
    case_decision(Case, Side),
    not not_case_decision_permissible(Case, Side).
