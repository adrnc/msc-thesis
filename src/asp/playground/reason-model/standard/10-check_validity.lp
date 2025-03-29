% PART OF INPUT

% global factors
factor(p1, plaintiff).
factor(p2, plaintiff).
factor(d1, defendant).
factor(d2, defendant).

% case with some reason and some fact situation
case(c1, r1, plaintiff).

fact(c1, p1).
fact(c1, p2).
fact(c1, d1).
fact(c1, d2).

fact(r1, p1).

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
unknown_side_in_case(C, R, S) :- case(C, R, S), not known_side(S).
invalid :- unknown_side_in_factor(F, S).
invalid :- unknown_side_in_case(C, R, S).
#show unknown_side_in_factor/2.
#show unknown_side_in_case/3.

% find factors used that are not known
unknown_factor_used(C, R, S, F) :- case(C, R, S), fact(R, F), not factor(F, S).
invalid :- unknown_factor_used(C, R, S, F).
#show unknown_factor_used/4.

% find inconsistent factors
inconsistent_factor(F, S1, S2) :- factor(F, S1), factor(F, S2), S1 != S2.
invalid :- inconsistent_factor(F, S1, S2).
#show inconsistent_factor/3.

% find duplicates
duplicated_case_different_reason(C, R1, S1, R2, S2) :- case(C, R1, S1), case(C, R2, S2), R1 != R2.
duplicated_case_different_side(C, R1, S1, R2, S2) :- case(C, R1, S1), case(C, R2, S2), S1 != S2.
duplicated_reason_in_cases(R, C1, S1, C2, S2) :- case(C1, R, S1), case(C2, R, S2), C1 != C2.
invalid :- duplicated_case_different_reason(C, R1, S1, R2, S2).
invalid :- duplicated_case_different_side(C, R1, S1, R2, S2).
invalid :- duplicated_reason_in_cases(R, C1, S1, C2, S2).
#show duplicated_case_different_reason/5.
#show duplicated_case_different_side/5.
#show duplicated_reason_in_cases/5.

% check if some reason is empty
nonempty_case(C, R, S) :- case(C, R, S), fact(C, F).
empty_case(C, R, S) :- case(C, R, S), not nonempty_case(C, R, S).
invalid :- empty_case(C, R, S).
#show empty_case/3.

% check if some reason is empty
nonempty_case_reason(C, R, S) :- case(C, R, S), fact(R, F).
empty_case_reason(C, R, S) :- case(C, R, S), not nonempty_case_reason(C, R, S).
invalid :- empty_case_reason(C, R, S).
#show empty_case_reason/3.

% check if the case entails the reason
reason_not_entailed(C, R, S) :- case(C, R, S), fact(R, F), not fact(C, F).
invalid :- reason_not_entailed(C, R, S).
#show reason_not_entailed/3.

% check if some reason supports a fact of opposite side
reason_wrong_factor(R, S1, F, S2) :- case(C, R, S1), opposite(S1, S2), fact(R, F), factor(F, S2).
invalid :- reason_wrong_factor(R, S1, F, S2).
#show reason_wrong_factor/4.

% the program is unsatisfiable if all validity checks are satisfied
:- not invalid.
