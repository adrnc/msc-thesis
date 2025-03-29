% PART OF INPUT

% define global factors
factor(p1, plaintiff).
factor(p1, plaintiff).
factor(d1, defendant).
factor(d2, defendant).



% PART OF PROGRAM

% define opposite sides
opposite(plaintiff, defendant).
opposite(defendant, plaintiff).

% infer if some fact situation does not entail the other one
not_entails_case_reason(C1, R2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2), C1 < C2,
    % check entailment
    fact(R2, F), not fact(C1, F).

% check conflicting cases
case_conflict(C1, C2) :-
    % retrieve info about two cases
    case(C1, R1, S1), case(C2, R2, S2), opposite(S1, S2), C1 < C2,
    % check if the entailment holds for the first and for the second case
    not not_entails_case_reason(C1, R2), not not_entails_case_reason(C2, R1).
invalid :- case_conflict(C1, C2).
#show case_conflict/2.

% find unknown sides
known_side(S1) :- opposite(S1, S2).
unknown_side_in_factor(F, S) :- factor(F, S), not known_side(S).
unknown_side_in_case(C, S) :- case(C, R, S), not known_side(S).
invalid :- unknown_side_in_factor(F, S).
invalid :- unknown_side_in_case(C, S).
#show unknown_side_in_factor/2.
#show unknown_side_in_case/2.

% find factors used that are not known
unknown_factor_used(F) :- case(C, F, S), fact(R, F), not factor(F, S).
invalid :- unknown_factor_used(F).
#show unknown_factor_used/1.

% find inconsistent factors
inconsistent_factor(F) :- factor(F, S1), factor(F, S2), S1 != S2.
invalid :- inconsistent_factor(F).
#show inconsistent_factor/1.

% find duplicates
duplicated_case(C) :- case(C, R1, S1), case(C, R2, S2), R1 != R2.
duplicated_case(C) :- case(C, R1, S1), case(C, R2, S2), S1 != S2.
duplicated_reason(R) :- case(C1, R, S1), case(C2, R, S2), C1 != C2.
invalid :- duplicate_case(C).
invalid :- duplicated_reason(R).
#show duplicated_case/1.
#show duplicated_reason/1.

% check if some reason is empty
nonempty_case(C) :- case(C, R, S), fact(C, F).
empty_case(C) :- case(C, R, S), not nonempty_case(C).
invalid :- empty_case(C).
#show empty_case/1.

% check if some reason is empty
nonempty_reason(R) :- case(C, R, S), fact(R, F).
empty_reason(R) :- case(C, R, S), not nonempty_reason(R).
invalid :- empty_reason(R).
#show empty_reason/1.

% check if the case entails the reason
reason_not_entailed(C, R) :- case(C, R, S), fact(R, F), not fact(C, F).
invalid :- reason_not_entailed(C, R).
#show reason_not_entailed/2.

% check if some reason supports a fact of opposite side
reason_wrong_factor(R, F) :- case(C, R, S1), opposite(S1, S2), fact(R, F), factor(F, S2).
invalid :- reason_wrong_factor(R, F).
#show reason_wrong_factor/2.

% the program is unsatisfiable if all validity checks are satisfied
:- not invalid.
