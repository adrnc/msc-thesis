%%% GENERAL INFO %%%

% We will first give a rough outline of how the reason model works.
% It involves three parts:
% 1. For every unsolved case, we choose some winning side and reason.
% 2. We check the consistency of the case base including the newly decided cases.
% 3. We check whether we can find a weaker reason that allows us to rule
%    for the same side. If so, we do not consider that reason.
%
% Let us give a bit more details on these:
%
% ad 1.) Choosing a winning side and some reason is easy.
% We simply select either the "defendant" or the "plaintiff" as the
% winning side and then afterwards select the magnitudes for the reason
% in such a way that they respect the requirements of Horty's reason model.

% ad 2.) The consistency check is based on Horty's following observation:
% A case base is inconsistent if and only if there are two cases C1 and C2
% of opposite sides S1 and S2 such that the reason of C2 satisfies the facts
% in C1 and the reason of C1 satisfies the facts in C2. By "satisfies" we mean
% that the dimensional facts present in C2 have to be strong enough such
% that the reason of C1 can be used to decide C2 in favour of S1. Likewise,
% the reason of C2 can be used to decide C1 in favour of S2. If we find two
% such cases, we consider the case base inconsistent.

%%% SIDE DEFINITIONS %%%

% Here, we define the opposite sides,
% namely, "plaintiff" and "defendant".

opposite(plaintiff, defendant).
opposite(S2, S1) :- opposite(S1, S2).

%%% DIMENSION HELPERS %%%

% This section contains some helpers that simplify
% the reasoning with dimensional facts.

% Here we define every potential value a dimension D can take.
dimension_value(D, Min..Max) :- dimension_config(D, S, Min, Max).

% This gives us info, if a dimension D is present in a case C,
% regardless of its specific value. We will use this to check the
% entailment of reasons.
dimension_present(C, D) :- dimension(C, D, Q).

% This one is the most difficult helper to grasp for now,
% but it merely simplifies checking entailment of reasons.
% Consider a dimension D with value Q and a magnitude M with
% value P. If the dimension strengthens side S, we the require
% P <= Q to be satisfied. Likewise, if the dimension strengthens
% the side opposite of S, we require P >= Q. By introducing a factor F
% that is 1 iff D strengthens S and -1 iff D strengthens the side
% opposite of S. Thus, we can write (P * F) <= (Q * F) to capture
% both conditions with one statement.
dimension_factor(D, S, 1) :- dimension_config(D, S, Min, Max).
dimension_factor(D, S2, -1) :- dimension_config(D, S1, Min, Max), opposite(S1, S2).

%%% CHECK CONSISTENCY OF CASE SPACE %%%

not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), not dimension_present(C1, D).

not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_entails_reason(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), not_case_entails_magnitude(C1, C2, D).

% prevent inconsistency for regular case space
:-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

%%% CHECK INCONSISTENCY OF MODIFIED CASE SPACES %%%

not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), not dimension_present(C1, D).

not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), dimension(C1, D, Q),
    dimension_factor(D, S1, F), (P * F) < (Q * F).

not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    magnitude_mod(C2, D, P, CX, MX, DX, PX), not_case_mod_entails_magnitude(C1, C2, D, CX, MX, DX, PX).

% check inconsistency for modified case space
not_case_space_mod_consistent(CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    not not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX), not not_case_mod_entails_reason(C2, C1, CX, MX, DX, PX).

% require inconsistency for modified case space
:- case_space_mod(CX, MX, DX, PX), not not_case_space_mod_consistent(CX, MX, DX, PX).

%%% GENERATE CASE PROPOSALS %%%

case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).
case(C, S) :- case_proposal(C, S).

{ magnitude_proposal(C, D, P) : dimension(C, D, Q),  dimension_value(D, P), dimension_factor(D, S, F), (P * F) <= (Q * F) } :- case_proposal(C, S).
magnitude(C, D, P) :- magnitude_proposal(C, D, P).

:- case_proposal(C, S), magnitude_proposal(C, D, P1), magnitude_proposal(C, D, P2), P1 != P2.

%%% SELECT CASE SPACE MODIFICATIONS %%%

case_space_mod(C, remove, D, P) :- case_proposal(C, S), magnitude(C, D, P).

case_space_mod(C, weaken, D, V) :-
    case_proposal(C, S), magnitude(C, D, P), dimension_factor(D, S, F),
    dimension_value(D, V), V = P - F.

%%% GENERATE MODIFIED CASE SPACES %%%

case_mod(C, S, CX, MX, DX, PX) :- case(C, S), case_space_mod(CX, MX, DX, PX).

magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), C != CX.
magnitude_mod(C, D, P, CX, MX, DX, PX) :- magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), D != DX.

magnitude_mod(CX, DX, PX, CX, weaken, DX, PX) :- magnitude(CX, DX, P), case_space_mod(CX, weaken, DX, PX).

%%% OUTPUT %%%

#show case_proposal/2.
#show magnitude_proposal/3.