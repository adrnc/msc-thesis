%%% DIMENSION DEFINITIONS %%%

% Dimension "fact0_plaintiff": Screen time minutes before scheduled bedtime
dimension_definition(fact0_plaintiff, plaintiff, 0, 180).

% Dimension "fact1_plaintiff": Sugar intake grams after dinner
dimension_definition(fact1_plaintiff, plaintiff, 0, 100).

% Dimension "fact2_plaintiff": Count of bedtime protests by children
dimension_definition(fact2_plaintiff, plaintiff, 0, 10).

% Dimension "fact3_plaintiff": Ambient noise level in bedroom (dB)
dimension_definition(fact3_plaintiff, plaintiff, 20, 80).

% Dimension "fact4_defendant": Reading/story time minutes before bedtime
dimension_definition(fact4_defendant, defendant, 0, 60).

% Dimension "fact5_defendant": Parental routine consistency rating
dimension_definition(fact5_defendant, defendant, 0, 10).

% Dimension "fact6_defendant": Physical activity minutes during day
dimension_definition(fact6_defendant, defendant, 0, 180).

% Dimension "fact7_defendant": Homework completion percentage
dimension_definition(fact7_defendant, defendant, 0, 100).

% Dimension "fact8_defendant": Sibling cooperation incidents count
dimension_definition(fact8_defendant, defendant, 0, 10).

% Dimension "fact9_defendant": Parental engagement minutes before bedtime
dimension_definition(fact9_defendant, defendant, 0, 120).


%%% CASE BASE %%%

% CASE "case10_plaintiff": A case where the plaintiff wins.
case(case10_plaintiff, plaintiff).
dimensional_fact(case10_plaintiff, fact0_plaintiff, 17).
dimensional_fact(case10_plaintiff, fact1_plaintiff, 42).
dimensional_fact(case10_plaintiff, fact2_plaintiff, 3).
dimensional_fact(case10_plaintiff, fact3_plaintiff, 51).
dimensional_fact(case10_plaintiff, fact4_defendant, 8).
dimensional_fact(case10_plaintiff, fact5_defendant, 9).
dimensional_fact(case10_plaintiff, fact6_defendant, 62).
dimensional_fact(case10_plaintiff, fact7_defendant, 52).
dimensional_fact(case10_plaintiff, fact8_defendant, 1).
dimensional_fact(case10_plaintiff, fact9_defendant, 45).
reason_magnitude(case10_plaintiff, fact1_plaintiff, 42).
reason_magnitude(case10_plaintiff, fact2_plaintiff, 3).
reason_magnitude(case10_plaintiff, fact3_plaintiff, 51).
reason_magnitude(case10_plaintiff, fact7_defendant, 53).

% CASE "case11_defendant": A case where the defendant wins.
case(case11_defendant, defendant).
dimensional_fact(case11_defendant, fact0_plaintiff, 119).
dimensional_fact(case11_defendant, fact1_plaintiff, 6).
dimensional_fact(case11_defendant, fact2_plaintiff, 10).
dimensional_fact(case11_defendant, fact3_plaintiff, 45).
dimensional_fact(case11_defendant, fact4_defendant, 51).
dimensional_fact(case11_defendant, fact5_defendant, 3).
dimensional_fact(case11_defendant, fact6_defendant, 137).
dimensional_fact(case11_defendant, fact7_defendant, 54).
dimensional_fact(case11_defendant, fact8_defendant, 7).
dimensional_fact(case11_defendant, fact9_defendant, 118).
reason_magnitude(case11_defendant, fact2_plaintiff, 11).
reason_magnitude(case11_defendant, fact5_defendant, 3).
reason_magnitude(case11_defendant, fact7_defendant, 54).
reason_magnitude(case11_defendant, fact8_defendant, 7).
reason_magnitude(case11_defendant, fact9_defendant, 118).

% CASE "case12_plaintiff": A case where the plaintiff wins.
case(case12_plaintiff, plaintiff).
dimensional_fact(case12_plaintiff, fact0_plaintiff, 140).
dimensional_fact(case12_plaintiff, fact1_plaintiff, 83).
dimensional_fact(case12_plaintiff, fact2_plaintiff, 0).
dimensional_fact(case12_plaintiff, fact3_plaintiff, 79).
dimensional_fact(case12_plaintiff, fact4_defendant, 15).
dimensional_fact(case12_plaintiff, fact5_defendant, 7).
dimensional_fact(case12_plaintiff, fact6_defendant, 102).
dimensional_fact(case12_plaintiff, fact7_defendant, 21).
dimensional_fact(case12_plaintiff, fact8_defendant, 6).
dimensional_fact(case12_plaintiff, fact9_defendant, 100).
reason_magnitude(case12_plaintiff, fact0_plaintiff, 140).
reason_magnitude(case12_plaintiff, fact4_defendant, 16).
reason_magnitude(case12_plaintiff, fact8_defendant, 7).

% CASE "case13_defendant": A case where the defendant wins.
case(case13_defendant, defendant).
dimensional_fact(case13_defendant, fact0_plaintiff, 73).
dimensional_fact(case13_defendant, fact1_plaintiff, 93).
dimensional_fact(case13_defendant, fact2_plaintiff, 8).
dimensional_fact(case13_defendant, fact3_plaintiff, 51).
dimensional_fact(case13_defendant, fact4_defendant, 18).
dimensional_fact(case13_defendant, fact5_defendant, 0).
dimensional_fact(case13_defendant, fact6_defendant, 138).
dimensional_fact(case13_defendant, fact7_defendant, 40).
dimensional_fact(case13_defendant, fact8_defendant, 9).
dimensional_fact(case13_defendant, fact9_defendant, 117).
reason_magnitude(case13_defendant, fact3_plaintiff, 52).
reason_magnitude(case13_defendant, fact4_defendant, 18).
reason_magnitude(case13_defendant, fact6_defendant, 138).
reason_magnitude(case13_defendant, fact7_defendant, 40).

% CASE "case14_plaintiff": A case where the plaintiff wins.
case(case14_plaintiff, plaintiff).
dimensional_fact(case14_plaintiff, fact0_plaintiff, 40).
dimensional_fact(case14_plaintiff, fact1_plaintiff, 65).
dimensional_fact(case14_plaintiff, fact2_plaintiff, 2).
dimensional_fact(case14_plaintiff, fact3_plaintiff, 24).
dimensional_fact(case14_plaintiff, fact4_defendant, 15).
dimensional_fact(case14_plaintiff, fact5_defendant, 9).
dimensional_fact(case14_plaintiff, fact6_defendant, 152).
dimensional_fact(case14_plaintiff, fact7_defendant, 10).
dimensional_fact(case14_plaintiff, fact8_defendant, 9).
dimensional_fact(case14_plaintiff, fact9_defendant, 40).
reason_magnitude(case14_plaintiff, fact0_plaintiff, 40).
reason_magnitude(case14_plaintiff, fact1_plaintiff, 65).
reason_magnitude(case14_plaintiff, fact2_plaintiff, 2).
reason_magnitude(case14_plaintiff, fact5_defendant, 10).
reason_magnitude(case14_plaintiff, fact6_defendant, 153).

% CASE "case15_defendant": A case where the defendant wins.
case(case15_defendant, defendant).
dimensional_fact(case15_defendant, fact0_plaintiff, 52).
dimensional_fact(case15_defendant, fact1_plaintiff, 40).
dimensional_fact(case15_defendant, fact2_plaintiff, 6).
dimensional_fact(case15_defendant, fact3_plaintiff, 61).
dimensional_fact(case15_defendant, fact4_defendant, 20).
dimensional_fact(case15_defendant, fact5_defendant, 1).
dimensional_fact(case15_defendant, fact6_defendant, 159).
dimensional_fact(case15_defendant, fact7_defendant, 12).
dimensional_fact(case15_defendant, fact8_defendant, 3).
dimensional_fact(case15_defendant, fact9_defendant, 16).
reason_magnitude(case15_defendant, fact1_plaintiff, 41).
reason_magnitude(case15_defendant, fact2_plaintiff, 7).
reason_magnitude(case15_defendant, fact3_plaintiff, 62).
reason_magnitude(case15_defendant, fact5_defendant, 1).
reason_magnitude(case15_defendant, fact7_defendant, 12).

% CASE "case16_plaintiff": A case where the plaintiff wins.
case(case16_plaintiff, plaintiff).
dimensional_fact(case16_plaintiff, fact0_plaintiff, 17).
dimensional_fact(case16_plaintiff, fact1_plaintiff, 47).
dimensional_fact(case16_plaintiff, fact2_plaintiff, 7).
dimensional_fact(case16_plaintiff, fact3_plaintiff, 65).
dimensional_fact(case16_plaintiff, fact4_defendant, 51).
dimensional_fact(case16_plaintiff, fact5_defendant, 0).
dimensional_fact(case16_plaintiff, fact6_defendant, 141).
dimensional_fact(case16_plaintiff, fact7_defendant, 84).
dimensional_fact(case16_plaintiff, fact8_defendant, 2).
dimensional_fact(case16_plaintiff, fact9_defendant, 113).
reason_magnitude(case16_plaintiff, fact1_plaintiff, 47).
reason_magnitude(case16_plaintiff, fact6_defendant, 142).
reason_magnitude(case16_plaintiff, fact7_defendant, 85).
reason_magnitude(case16_plaintiff, fact8_defendant, 3).
reason_magnitude(case16_plaintiff, fact9_defendant, 114).

% CASE "case17_defendant": A case where the defendant wins.
case(case17_defendant, defendant).
dimensional_fact(case17_defendant, fact0_plaintiff, 141).
dimensional_fact(case17_defendant, fact1_plaintiff, 36).
dimensional_fact(case17_defendant, fact2_plaintiff, 5).
dimensional_fact(case17_defendant, fact3_plaintiff, 60).
dimensional_fact(case17_defendant, fact4_defendant, 32).
dimensional_fact(case17_defendant, fact5_defendant, 0).
dimensional_fact(case17_defendant, fact6_defendant, 108).
dimensional_fact(case17_defendant, fact7_defendant, 5).
dimensional_fact(case17_defendant, fact8_defendant, 2).
dimensional_fact(case17_defendant, fact9_defendant, 33).
reason_magnitude(case17_defendant, fact0_plaintiff, 142).
reason_magnitude(case17_defendant, fact2_plaintiff, 6).
reason_magnitude(case17_defendant, fact5_defendant, 0).
reason_magnitude(case17_defendant, fact7_defendant, 5).
reason_magnitude(case17_defendant, fact9_defendant, 33).

% CASE "case18_plaintiff": A case where the plaintiff wins.
case(case18_plaintiff, plaintiff).
dimensional_fact(case18_plaintiff, fact0_plaintiff, 113).
dimensional_fact(case18_plaintiff, fact1_plaintiff, 54).
dimensional_fact(case18_plaintiff, fact2_plaintiff, 1).
dimensional_fact(case18_plaintiff, fact3_plaintiff, 76).
dimensional_fact(case18_plaintiff, fact4_defendant, 9).
dimensional_fact(case18_plaintiff, fact5_defendant, 5).
dimensional_fact(case18_plaintiff, fact6_defendant, 37).
dimensional_fact(case18_plaintiff, fact7_defendant, 5).
dimensional_fact(case18_plaintiff, fact8_defendant, 0).
dimensional_fact(case18_plaintiff, fact9_defendant, 26).
reason_magnitude(case18_plaintiff, fact2_plaintiff, 1).

% CASE "case19_defendant": A case where the defendant wins.
case(case19_defendant, defendant).
dimensional_fact(case19_defendant, fact0_plaintiff, 170).
dimensional_fact(case19_defendant, fact1_plaintiff, 99).
dimensional_fact(case19_defendant, fact2_plaintiff, 6).
dimensional_fact(case19_defendant, fact3_plaintiff, 67).
dimensional_fact(case19_defendant, fact4_defendant, 59).
dimensional_fact(case19_defendant, fact5_defendant, 2).
dimensional_fact(case19_defendant, fact6_defendant, 45).
dimensional_fact(case19_defendant, fact7_defendant, 3).
dimensional_fact(case19_defendant, fact8_defendant, 5).
dimensional_fact(case19_defendant, fact9_defendant, 52).
reason_magnitude(case19_defendant, fact0_plaintiff, 171).
reason_magnitude(case19_defendant, fact3_plaintiff, 68).
reason_magnitude(case19_defendant, fact4_defendant, 59).
reason_magnitude(case19_defendant, fact7_defendant, 3).

