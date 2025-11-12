%%% SIDES %%%

side(plaintiff).
side(defendant).

opposite_side(plaintiff, defendant).
opposite_side(defendant, plaintiff).

%%% CONSTRUCT VALUE RELATION %%%

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

%%% TRANSLATE CASE BASE %%%

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

%%% COMPARE STRENGTH OF FACT SITUATIONS %%%

case_and_decision_like(Case, Side, Decision) :-
    % pick a case
    case(Case, Side),
    % pick a decision-like
    decision_like(Decision),
    % require that the decision-like is not the case itself
    Case != Decision.

has_reduced_value_assignment_like(Case, Dimension) :-
    reduced_value_assignment_like(Case, Dimension, Value).

% check if a case does not partially constrain a decision-like,
% because some dimension in the decision is missing
not_case_partially_constrains_decision_like(Case, Side, Decision) :-
    % pick a case and a decision-like
    case_and_decision_like(Case, Side, Decision),
    % check if a value assignment is present in the case
    reduced_value_assignment(Case, Dimension, Value),
    % but not in the decision,
    % if so, the decision cannot be constrained
    not has_reduced_value_assignment_like(Decision, Dimension).

% check if a case does not partially constrain a decision-like,
% because some dimension in the decision is weaker
not_case_partially_constrains_decision_like(Case, Side, Decision) :-
    % pick a case and a decision-like
    case_and_decision_like(Case, Side, Decision),
    % pick the value assignments of the shared dimension
    reduced_value_assignment(Case, Dimension, Value1),
    reduced_value_assignment_like(Decision, Dimension, Value2),
    % check if the value of the decision is weaker than the value of the case,
    % if so, the decision cannot be constrained
    strict_value_relation(Side, Dimension, Value2, Value1).

% check if a decision-like is partially constrained at all
decision_like_partially_constrained(Decision, Side) :-
    % pick a case and a decision-like
    case_and_decision_like(Case, Side, Decision),
    % check if the decision is partially constrained
    not not_case_partially_constrains_decision_like(Case, Side, Decision).

% check which dimensions are covered by precedents
decision_like_has_dimension_covered(Decision, Side, Dimension) :-
    % pick a case and a decision-like
    case_and_decision_like(Case, Side, Decision),
    % check if the case partially constrains the decision-like
    not not_case_partially_constrains_decision_like(Case, Side, Decision),
    % if it does, all dimensions in the case cover the dimensions in the decision-like
    reduced_value_assignment(Case, Dimension, Value).

% check if the decision-like is not constrained,
% because there is no case that constrains it
not_decision_like_constrained(Decision, Side) :-
    % pick a decision-like and a side
    decision_like(Decision), side(Side),
    % check if there is no partial constraint
    not decision_like_partially_constrained(Decision, Side).

% check if the decision-like is not constrained,
% because there is some dimension that is not covered partially
not_decision_like_constrained(Decision, Side) :-
    % pick a decision-like and a side
    decision_like(Decision), side(Side),
    % pick a dimension in the decision
    reduced_value_assignment_like(Decision, Dimension, Value),
    % check if the dimension is not covered
    not decision_like_has_dimension_covered(Decision, Side, Dimension).

%%% CHECK CONSISTENCY %%%

decision_like(Case) :- case(Case, Side).

reduced_value_assignment_like(Case, Dimension, Value) :-
    case(Case, Side),
    reduced_value_assignment(Case, Dimension, Value).

not_case_consistent_with_case_base(Case, Side) :-
    % pick a case and its opposite side
    case(Case, Side), opposite_side(Side, OppSide),
    % check if the case is constrained to the opposite side
    not not_decision_like_constrained(Case, OppSide).

not_case_base_consistent :- not_case_consistent_with_case_base(Case, Side).

%%% CHECK DECISION CONSTRAINTS %%%

decision_like(Decision) :-
    unsolved_case(Decision),
    not not_case_base_consistent.

reduced_value_assignment_like(Case, Dimension, Value) :-
    unsolved_case(Case),
    value_assignment(Case, Dimension, Value),
    not not_case_base_consistent.

decision_constrained(Decision, Side) :-
    % pick an unsolved case and a side
    unsolved_case(Decision), side(Side),
    % check if the decision is constrained
    not not_decision_like_constrained(Decision, Side).
