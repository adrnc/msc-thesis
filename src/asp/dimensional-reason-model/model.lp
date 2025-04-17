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
%
% ad 2.) The consistency check is based on Horty's following observation:
% A case base is inconsistent if and only if there are two cases C1 and C2
% of opposite sides S1 and S2 such that the reason of C2 satisfies the facts
% in C1 and the reason of C1 satisfies the facts in C2. By "satisfies" we mean
% that the dimensional facts present in C2 have to be strong enough such
% that the reason of C1 can be used to decide C2 in favour of S1. Likewise,
% the reason of C2 can be used to decide C1 in favour of S2. If we find two
% such cases, we consider the case base inconsistent.
%
% ad 3.) Lastly, we further restrict how unsolved cases can decide on reasons.
% We do this because selecting reasons may yield exponentially many models. To prevent this,
% we only allow the weakest possible reasons for a case to be considered for models. That is,
% if we can weaken the selected reason and this modified case base stays consistent, the selected
% reason will not be considered. Why is it sufficient to consider weakest possible reasons?
% We reconsider the inconsistency condition from earlier, where a case is inconsistent if
% and only if there are two cases C1 and C2 of opposite sides S1 and S2, where the reason of C2
% can be taken to rule for S2 in case C1 and the reason of C1 can be taken to rule for S1 in
% case C2. Thus, a case base is consistent if and only if for all cases C1 and C2 of opposite side
% at least one reason is not satisfied by the opposite case. Either the reason of C2 cannot be
% taken to rule for S2 in case C1 or the reason of C1 cannot be taken to rule for S1 in case S1.
% Let us now consider that we chose some reason for an unsolved case such that the case base is
% consistent. Then making the reason stronger cannot cause the case base to become inconsistent,
% since for all reasons of C1 and C2, one will  stay unsatisfied by the respective other case.
% Thus, it is sufficient for us to output the weakest possible reasons, as all reasons stronger
% than the weakest reason will also yield a consistent case base.

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
dimensional_fact_present(C, D) :- dimensional_fact(C, D, Q).

% This one is the most difficult helper to grasp for now,
% but it merely simplifies checking entailment of reasons.
% Consider a dimension D with value Q and a magnitude M with
% value P. If the dimension strengthens side S, we the require
% P <= Q to be satisfied. Likewise, if the dimension strengthens
% the side opposite of S, we require P >= Q. By introducing a sign F
% that is 1 iff D strengthens S and -1 iff D strengthens the side
% opposite of S. Thus, we can write (P * F) <= (Q * F) to capture
% both conditions with one statement.
dimension_sign(D, S, 1) :- dimension_config(D, S, Min, Max).
dimension_sign(D, S2, -1) :- dimension_config(D, S1, Min, Max), opposite(S1, S2).

%%% GENERATE CASE PROPOSALS %%%

% In this section we generate new case proposals for unsolved cases. Each proposal
% consists of a proposed side, and a reason, i.e.,
% a selection of magnitudes.

% Here we define a case proposal for either side. This presents a choice to the model of
% which side to rule in favour for.
case_proposal(C, S1) :- unsolved_case(C), opposite(S1, S2), not case_proposal(C, S2).

% Along with the proposal of a winning side S comes a proposal of magnitudes for the reason.
% To prevent illegal magnitudes, we restrict that they entail the case facts through the
% sign restriction (P * F) <= (Q * F), where P is the magnitude value, Q the dimensional fact
% value and F the sign for D and side S, as described earlier.
{ magnitude_proposal(C, D, P) : dimensional_fact(C, D, Q),  dimension_value(D, P), dimension_sign(D, S, F), (P * F) <= (Q * F) } :- case_proposal(C, S).

% Here we simply prevent that a case contains to magnitudes for the same dimension D that
% have different values. That is, every magnitude can only occur at most once.
:- case_proposal(C, S), magnitude_proposal(C, D, P1), magnitude_proposal(C, D, P2), P1 != P2.

% We consider a case proposal no different from a regular case.
case(C, S) :- case_proposal(C, S).
reason_magnitude(C, D, P) :- magnitude_proposal(C, D, P).

%%% CHECK CONSISTENCY OF CASE SPACE %%%

% In the following section we will enforce the consistency of the case space.
% In particular, we will check if we can find two cases of opposite side where
% each case's fact situation entails the other case's reason,
% as already described at the top. If two such cases can be found,
% the model is unsatisfiable.
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
not_case_entails_reason_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    reason_magnitude(C2, D, P), not dimensional_fact_present(C1, D).

% This is the second NOT-entailment check where we again select two cases C1 and C2 and test if
% the magnitude M on dimension D for case C2 is not satisfied by case C1. This time, because
% dimensional fact of D is present in C1, but too weak. Here we make use of the sign defined
% earlier. Consider checking entailment first. Given values P for the magnitude and Q for
% the dimensional fact, we require (P * F) <= (Q * F), where sign F is taken for side S2
% strengthening C2, as this is the side we want to argue for. Thus, we receive F through
% dimension_sign(D, S2, F). Since we want to NOT-entailment, we test for the opposite,
% namely (P * F) > (Q * F).
not_case_entails_reason_magnitude(C1, C2, D) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    reason_magnitude(C2, D, P), dimensional_fact(C1, D, Q),
    dimension_sign(D, S2, F), (P * F) > (Q * F).

% Now we check if case C1 does not eintail the reason for case C2. This happens when we can
% magnitude that is not entailed.
not_case_entails_reason(C1, C2) :-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    reason_magnitude(C2, D, P), not_case_entails_reason_magnitude(C1, C2, D).

% Lastly, we check for consistency by requiring that no two cases of opposite side can
% entail each other's reasons, as described in the top section.
:-
    case(C1, S1), case(C2, S2), opposite(S1, S2),
    not not_case_entails_reason(C1, C2), not not_case_entails_reason(C2, C1).

%%% SELECT CASE SPACE MODIFICATIONS %%%

% As described earlier, we want to check if we have found the weakest possible reason for a side.
% To do so in practice, we distinguish between the regular case space and several modified case spaces.
% The regular case space was already defined in previous steps. Now we will generate several
% modified case spaces. A modified case space is a case space, where exactly one magnitude
% in exactly one case is changed, whereas everything else stays the same. Since we are
% interested in finding the weakest possible reason, for the modified case spaces we only
% select unsolved cases for modification and we only either remove or weaken a magnitude.
% We define these modified case spaces with case_space_mod(C, Mod, D, P). C is the case,
% Mod is the selected modification, and the modified magnitude refers to the dimension D
% and gets assigned the new threshold value P. Of course, in case of deletion, this threshold value
% is irrelevant.

% Here we define all case spaces that have exactly one magnitude removed, but everything else
% stays the same.
case_space_mod(C, remove, D, P) :- case_proposal(C, S), reason_magnitude(C, D, P).

% Likewise, here we define all case spaces that have exactly one magnitude weakened, but everthing
% else stays the same. Why do we set the new threshold value V = P - F where F is the dimension sign for the given side? That's because if
% a dimension strengthens a side, F = 1 and V = P - 1 will weaken the reason. In contrast, if
% a dimension strengthens the opposite side F = -1 and V = P + 1 will weaken the reason.
% Therefore, we can simply set V = P - F.
case_space_mod(C, weaken, D, V) :-
    case_proposal(C, S), reason_magnitude(C, D, P), dimension_sign(D, S, F),
    dimension_value(D, V), V = P - F.

%%% GENERATE MODIFIED CASE SPACES %%%

% Having defined what modified case spaces we want to generate, we apply the modifications
% in the following section.

% For every case we create an equivalent case in every modified case space.
case_mod(C, S, CX, MX, DX, PX) :- case(C, S), case_space_mod(CX, MX, DX, PX).

% Here we copy every magnitude as is, that is not affected by the case space modification,
% to the new case space.
reason_magnitude_mod(C, D, P, CX, MX, DX, PX) :- reason_magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), C != CX.
reason_magnitude_mod(C, D, P, CX, MX, DX, PX) :- reason_magnitude(C, D, P), case_space_mod(CX, MX, DX, PX), D != DX.

% Most importantly, we replace the modified magnitudes. Here, we assign the modified
% magnitude its weakened value.
reason_magnitude_mod(CX, DX, PX, CX, weaken, DX, PX) :- reason_magnitude(CX, DX, P), case_space_mod(CX, weaken, DX, PX).

% Since we do not copy the removed magnitudes, they will not be present in the modified case spaces.

%%% CHECK INCONSISTENCY OF MODIFIED CASE SPACES %%%

% Similar to the consistency check, we check for inconsistency of the modified case spaces.
% If at least one of the modified case spaces is consistent, we have found a weaker reason that
% can be used to consistently rule for the same side. If not, this means all weaker reasons are
% inconsistent, thus we have found the weakest reason in our model. Like before, we check for
% NOT-entailment of magnitudes and reasons.

% As seen in the consistency check, we again check if a magnitude is present, but the necessary
% dimension is missing.
not_case_mod_entails_reason_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    reason_magnitude_mod(C2, D, P, CX, MX, DX, PX), not dimensional_fact_present(C1, D).

% Also, as seen in the consistency check, we again check if a magnitude is required to be stronger
% than given in the present dimension.
not_case_mod_entails_reason_magnitude(C1, C2, D, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    reason_magnitude_mod(C2, D, P, CX, MX, DX, PX), dimensional_fact(C1, D, Q),
    dimension_sign(D, S2, F), (P * F) > (Q * F).

% Again, we check which reasons are not entailed.
not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    reason_magnitude_mod(C2, D, P, CX, MX, DX, PX), not_case_mod_entails_reason_magnitude(C1, C2, D, CX, MX, DX, PX).

% At this point, our check differs from the consistency check. Here we simply find all case
% modified spaces that are inconsistent.
not_case_space_mod_consistent(CX, MX, DX, PX) :-
    case_mod(C1, S1, CX, MX, DX, PX), case_mod(C2, S2, CX, MX, DX, PX), opposite(S1, S2),
    not not_case_mod_entails_reason(C1, C2, CX, MX, DX, PX), not not_case_mod_entails_reason(C2, C1, CX, MX, DX, PX).

% And most importantly, we require all modified case spaces to be inconsistent. This we way ensure
% that we have found the weakest possible reason.
:- case_space_mod(CX, MX, DX, PX), not not_case_space_mod_consistent(CX, MX, DX, PX).

%%% OUTPUT %%%

#show case_proposal/2.
#show magnitude_proposal/3.