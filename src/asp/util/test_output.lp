c(19).

not_dec_con_with(C,S,OC,OS) :- c(C), not_decision_consistent_with_case(C,S,OC,OS).
dec_perm(C,S) :- c(C), decision(C,S), not not_decision_permissible(C,S).
dec_con(C, S) :- dec_perm(C,S), opposite_side(S,OS), not dec_perm(C,OS).
dec_notcon(C) :- dec_perm(C,S), dec_perm(C,OS), opposite_side(S,OS).

#show dec_con/2.
%#show dec_con_by/3.
#show dec_notcon/1.
%#show dec_perm/2.
#show not_dec_con_with/4.
%#show not_cases_consistent/4.
