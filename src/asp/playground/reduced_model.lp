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

opposing_cases(Case, Side, OppCase, OppSide) :-
    case(Case, Side),
    case(OppCase, OppSide),
    opposite_side(Side, OppSide).

not_case_fact_leq_opposing_case_fact(Case, Side, OppCase, Dimension) :-
    % pick two opposing cases
    opposing_cases(Case, Side, OppCase, OppSide),
    % pick the reduced fact from the first case
    reduced_fact(Case, Dimension, Value1),
    % pick the reduced fact from the second case
    reduced_fact(OppCase, Dimension, Value2),
    % check if the reduced fact from the first case is stronger
    strict_value_relation(Side, Dimension, Value2, Value1).

not_case_facts_leq_opposing_case_facts(Case, Side, OppCase) :-
    not_case_fact_leq_opposing_case_fact(Case, Side, OppCase, Dimension).

not_cases_consistent(Case, OppCase) :-
    opposing_cases(Case, Side, OppCase, OppSide),
    not not_case_facts_leq_opposing_case_facts(Case, Side, OppCase),
    not not_case_facts_leq_opposing_case_facts(OppCase, OppSide, Case).

not_case_base_consistent :- not_cases_consistent(Case, OppCase).

case_base_consistent :- not not_case_base_consistent.

%%% DECISION %%%

pending_case(Case) :-
    unsolved_case(Case),
    case_base_consistent.

not_pending_case_fact_geq_other_case_fact(Case, SomeCase, SomeSide, Dimension) :-
    % pick the pending case
    pending_case(Case),
    % pick some other solved case
    case(SomeCase, SomeSide),
    % pick the fact from the case decision
    fact(Case, Dimension, Value1),
    % pick the reduced fact from the opposing case
    reduced_fact(SomeCase, Dimension, Value2),
    % check if the reduced fact from the first case is weaker
    strict_value_relation(SomeSide, Dimension, Value1, Value2).

not_pending_case_facts_geq_other_case_facts(Case, SomeCase, SomeSide) :-
    not_pending_case_fact_geq_other_case_fact(Case, SomeCase, SomeSide, Dimension).

case_decision_constrainedby_other_case(Case, SomeCase, SomeSide) :-
    pending_case(Case),
    case(SomeCase, SomeSide),
    not not_pending_case_facts_geq_other_case_facts(Case, SomeCase, SomeSide).

case_decision_constraint(Case, Side) :-
    case_decision_constrainedby_other_case(Case, SomeCase, Side).

not_case_decision_permissible(Case, Side) :-
    pending_case(Case),
    opposite_side(Side, OppSide),
    case_decision_constraint(Case, OppSide).

case_decision_permissible(Case, Side) :-
    pending_case(Case),
    side(Side),
    not not_case_decision_permissible(Case, Side).
