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

% ad 3.)

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

%%% GENERATE CASE PROPOSALS %%%

% In this section we generate new case proposals for unsolved cases. Each proposal
% consists of a proposed side, and a reason, i.e.,
% a selection of magnitudes.

% Here we define a case proposal for either side. This presents a choice to the model of
% which side to rule in favour for.
case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).

% Along with the proposal of a winning side S comes a proposal of magnitudes for the reason.
% To prevent illegal magnitudes, we restrict that they entail the case facts through the
% factor restriction (P * F) <= (Q * F), where P is the magnitude value, Q the dimensional fact
% value and F the factor for D and side S, as described earlier.
{ magnitude_proposal(C, D, P) : dimension(C, D, Q),  dimension_value(D, P), dimension_factor(D, S, F), (P * F) <= (Q * F) } :- case_proposal(C, S).

% Here we simply prevent that a case contains to magnitudes for the same dimension D that
% have different values. That is, every magnitude can only occur at most once.
:- case_proposal(C, S), magnitude_proposal(C, D, P1), magnitude_proposal(C, D, P2), P1 != P2.

% We consider a case proposal no different from a regular case.
case(C, S) :- case_proposal(C, S).
magnitude(C, D, P) :- magnitude_proposal(C, D, P).

%%% CHECK CONSISTENCY OF CASE SPACE %%%

% In the following section we will enforce the consistency of the case space.
% In particular, we will check if we can find two cases of opposite side where
% each case's fact situation entails the other case's reason, as already described at the top.
% If two such cases can be found, the model is unsatisfiable.
%
% Do note that it is much easier to check whether a reason is NOT entailed
% compared to whether a reason is entailed, since checking the former merely requires
% us to find one magnitude that is not satisfied by a dimensional fact.
% For magnitudes not entailed there are to cases:
% 1. The needed dimension for entailment is not present.
% 2. The needed dimension for entailment is too weak.

% This is the first NOT-entailment check, where we select two cases C1 and C2 and test if
% the magnitude on dimension D for case C2 is not satisfied by case C1, because dimensional
% fact D is missing in C1.
not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), not dimension_present(C1, D).

% This is the second NOT-entailment check where we again select two cases C1 and C2 and test if
% the magnitude M on dimension D for case C2 is not satisfied by case C1. This time, because
% dimensional fact of D is present in C1, but too weak. Here we make use of the factor defined
% earlier. Consider checking entailment first. Given values P for the magnitude and Q for the dimensional fact, we require (P * F) <= (Q * F),
% where factor F is taken for side S2 strengthening C2, as this is the side we want
% to argue for. Thus, we receive F through dimension_factor(D, S2, F). Since we want to
% NOT-entailment, we test for the opposite, namely (P * F) > (Q * F).
not_case_entails_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), dimension(C1, D, Q),
    dimension_factor(D, S2, F), (P * F) > (Q * F).

% Now we check if case C1 does not eintail the reason for case C2. This happens when we can
% magnitude that is not entailed.
not_case_entails_reason(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    magnitude(C2, D, P), not_case_entails_magnitude(C1, C2, D).

% Lastly, we check for consistency by requiring that no two cases of opposite side can
% entail each other's reasons, as described in the top section.
:-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

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

%%% OUTPUT %%%

#show case_proposal/2.
#show magnitude_proposal/3.