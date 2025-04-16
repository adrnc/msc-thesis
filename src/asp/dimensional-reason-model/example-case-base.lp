%%% DIMENSION CONFIGURATION %%%

% In this part we define types of dimensions like so:
% dimension_config(DIMENSION_ID, STRENGTHENS_SIDE, MIN_VALUE, MAX_VALUE)
%
% The DIMENSION_ID uniquely identifies a dimension across cases.
% MIN_VALUE and MAX_VALUE limit the range a dimension can have.
% The model assumes MIN_VALUE <= MAX_VALUE.
%
% Lastly, we have the parameter STRENGTHENS_SIDE, which denotes how a
% parameter strengthens a side. The two sides are "defendant" and "plaintiff".
% When dimension strengthens side S, this means that the MAX_VALUE
% favours side S the most and MIN_VALUE favours the side opposite of S
% the most. Likewise, when a dimension strengthens the side opposite of S,
% this means that MIN_VALUE favours S the most and MAX_VALUE favours
% the side opposite of S the most.

dimension_config(d1, defendant, -5, 5).
dimension_config(d2, defendant, -5, 5).

%%% SOLVED CASES %%%

% This section contains cases that were already solved.
% Each case is made up of the following:
% 1. Exactly one: case(CASE_ID, WINNING_SIDE)
% 2. Several: dimension(CASE_ID, DIMENSION_ID, DIMENSION_VALUE)
% 3. Several: magnitude(CASE_ID, DIMENSION_ID, DIMENSION_VALUE)
%
% This is the implemented equivalent of Horty's case triple <X, r, s>
% where X are the dimensions present as facts, r is the rule and s is
% the winning side.
%
% In our implementation, we define an already decided case
% with case(CASE_ID, WINNING_SIDE), where CASE_ID uniquely
% identifies a case and WINNING_SIDE denotes the side that
% was ruled for in favour.
%
% Each fact present in the case is defined with
% dimension(CASE_ID, DIMENSION_ID, DIMENSION_VALUE)
% where DIMENSION_VALUE is within the the range of
% the dimension configured with DIMENSION_ID.
%
% The reason that is used to rule for the winning side is defined
% with magnitude(CASE_ID, DIMENSION_ID, THRESHOLD_VALUE).
% The THRESHOLD_VALUE has to be either above or below the value
% of the matching dimension, which has to be present. This depends
% on which side the dimension strengthens. If the dimension strengthens
% the winning side, the threshold value has to be smaller or equal to
% the dimension value. If the dimension strengthens the side opposite
% of the winning side, the threshold value has to be larger or equal
% to the dimension value.

case(c1, defendant).
dimension(c1, d1, 1).
dimension(c1, d2, 1).
magnitude(c1, d1, 1).
magnitude(c1, d2, 1).

case(c2, plaintiff).
dimension(c2, d1, 1).
dimension(c2, d2, 0).
magnitude(c1, d1, 1).

%%% SOLVED %%%

% In this section we define unsolved cases.
% Each unsolved case is made up of the following:
% 1. Exactly one: unsolved_case(CASE_ID)
% 2. Several: dimension(CASE_ID, DIMENSION_ID, DIMENSION_VALUE)
%
% Again, the CASE_ID has to be unique. In contrast to a solved case,
% no winning side is yet given and neither is a reason. Both of these
% will be decided upon by the model.

unsolved_case(c3).
dimension(c3, d1, 1).
dimension(c3, d2, 2). %dimension(c3, d2, 0).
