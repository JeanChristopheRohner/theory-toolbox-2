/* NOTES---------------------------------------------------------------------------------------------------------------------------------------------

An appraisal theory of emotion loosely based on Lazarus (1991), Smith and Ellsworth (1985), and 
Smith and Lazarus (1993). Happiness occurs when people experience an event that is congruent with a 
valued goal. A negative emotions occurs when people experience an event that is incongruent with
a valued goal. In anger, blame is directed to somebody else; in sadness blame is directed towards
the situation; in shame blame is directed towards oneself.

SOURCES
Lazarus, Richard S. (1991). Progress on a cognitive-motivational-relational theory of Emotion. 
  American Psychologist, 46(8), 819-834.
Smith, C. & Ellsworth, P. (1985). Patterns of Cognitive Appraisal in Emotion. Journal of personality 
  and social psychology. 48. 813-38.
Smith, C. A., & Lazarus, R. S. (1993). Appraisal components, core relational themes, and the emotions. 
  Cognition & Emotion, 7(3-4), 233-269.

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% human(H1)
% human(H2)

% H1 and H2 are constants


% BACKGROUND CLAUSES

time(past).
time(present).
time(future).

precedes(past, present).
precedes(present, future).

goal(selfPreservation).
goal(affiliation).
goal(achievement).

event(love).
event(professionalSuccess).
event(physicalSafety).
event(socialAcceptance).
event(physicalHarm).
event(socialRejection).
event(personalLoss).
event(professionalFailure).

event(H, appraise, event(H, value, selfPreservation, T1, 1), T2, 0.9) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(H, value, affiliation, T1, 1), T2, 0.9) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(H, value, achievement, T1, 1), T2, 0.9) ⇐ human(H) ∧ time(T1) ∧ time(T2).

event(H, appraise, event(H, experience, E, T1, 1), T2, X) ⇐ human(H) ∧ event(E) ∧ time(T1) ∧ time(T2) ∧ (X = 0.1 ∨ X = 0.9).

event(H, appraise, event(love, congruent, affiliation, T1, 1), T2, 0.9) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(professionalSuccess, congruent, achievement, T1, 1), T2, 0.9) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(physicalSafety, congruent, selfPreservation, T1, 1), T2, 0.9) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(socialAcceptance, congruent, affiliation, T1, 1), T2, 0.9) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(physicalHarm, congruent, selfPreservation, T1, 1), T2, 0.1) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(socialRejection, congruent, affiliation, T1, 1), T2, 0.1) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(personalLoss, congruent, affiliation, T1, 1), T2, 0.1) ⇐ human(H) ∧ time(T1) ∧ time(T2).
event(H, appraise, event(professionalFailure, congruent, achievement, T1, 1), T2, 0.1) ⇐ human(H) ∧ time(T1) ∧ time(T2).

event(H, appraise, event(H, cause, E, T1, 1), T2, X) ⇐ human(H) ∧ event(E) ∧ time(T1) ∧ time(T2) ∧ (X = 0.1 ∨ X = 0.9).
event(H1, appraise, event(H2, cause, E, T1, 1), T2, X) ⇐ human(H1) ∧ human(H2) ∧ ¬(H1 = H2) ∧ event(E) ∧ time(T1) ∧ time(T2) ∧ (X = 0.1 ∨ X = 0.9).
event(H, appraise, event(situation, cause, E, T1, 1), T2, X) ⇐ human(H) ∧ event(E) ∧ time(T1) ∧ time(T2) ∧ (X = 0.1 ∨ X = 0.9).


% MAIN CLAUSES

event(H1, experience, anger, T1, X1) ⇐
	human(H1)
	∧ human(H2)
	∧ ¬(H1 = H2)
	∧ event(E)
	∧ goal(G)
	∧ precedes(T2, T1)
	∧ event(H1, appraise, event(H1, value, G, T1, 1), T1, X2)
	∧ event(H1, appraise, event(H1, experience, E, T2, 1), T1, X3)
	∧ event(H1, appraise, event(E, congruent, G, T1, 1), T1, X4)
	∧ event(H1, appraise, event(H1, cause, E, T2, 1), T1, X5)
	∧ event(H1, appraise, event(H2, cause, E, T2, 1), T1, X6)
	∧ event(H1, appraise, event(situation, cause, E, T2, 1), T1, X7)
	∧ {X1 = X2 * X3 * (1 - X4) * (1 - X5) * X6 * (1 - X7)}.

event(H1, experience, shame, T1, X1) ⇐
	human(H1)
	∧ human(H2)
	∧ ¬(H1 = H2)
	∧ event(E)
	∧ goal(G)
	∧ precedes(T2, T1)
	∧ event(H1, appraise, event(H1, value, G, T1, 1), T1, X2)
	∧ event(H1, appraise, event(H1, experience, E, T2, 1), T1, X3)
	∧ event(H1, appraise, event(E, congruent, G, T1, 1), T1, X4)
	∧ event(H1, appraise, event(H1, cause, E, T2, 1), T1, X5)
	∧ event(H1, appraise, event(H2, cause, E, T2, 1), T1, X6)
	∧ event(H1, appraise, event(situation, cause, E, T2, 1), T1, X7)
	∧ {X1 = X2 * X3 * (1 - X4) * X5 * (1 - X6) * (1 - X7)}.

event(H, experience, fear, T1, X1) ⇐
	human(H)
	∧ event(E)
	∧ goal(G)
	∧ precedes(T1, T2)
	∧ event(H, appraise, event(H, value, G, T1, 1), T1, X2)
	∧ event(H, appraise, event(H, experience, E, T2, 1), T1, X3)
	∧ event(H, appraise, event(E, congruent, G, T1, 1), T1, X4)
	∧ {X1 = X2 * X3 * (1 - X4)}.

event(H1, experience, sadness, T1, X1) ⇐
	human(H1)
	∧ human(H2)
	∧ ¬(H1 = H2)
	∧ event(E)
	∧ goal(G)
	∧ precedes(T2, T1)
	∧ event(H1, appraise, event(H1, value, G, T1, 1), T1, X2)
	∧ event(H1, appraise, event(H1, experience, E, T2, 1), T1, X3)
	∧ event(H1, appraise, event(E, congruent, G, T1, 1), T1, X4)
	∧ event(H1, appraise, event(H1, cause, E, T2, 1), T1, X5)
	∧ event(H1, appraise, event(H2, cause, E, T2, 1), T1, X6)
	∧ event(H1, appraise, event(situation, cause, E, T2, 1), T1, X7)
	∧ {X1 = X2 * X3 * (1 - X4) * (1 - X5) * (1 - X6) * X7}.

event(H, experience, happiness, T1, X1) ⇐
	human(H)
	∧ event(E)
	∧ goal(G)
	∧ precedes(T2, T1)
	∧ event(H, appraise, event(H, value, G, T1, 1), T1, X2)
	∧ event(H, appraise, event(H, experience, E, T2, 1), T1, X3)
	∧ event(H, appraise, event(E, congruent, G, T1, 1), T1, X4)
	∧ {X1 = X2 * X3 * X4}.


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐	GOAL = event(somebody, experience, shame, present, X)
	∧ INPUT = [
		human(somebody),
		human(somebodyElse)
	]
	∧ {X > 0.5}
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).

q2 ⇐	(EMO = anger ∨ EMO = shame ∨ EMO = fear ∨ EMO = sadness ∨ EMO = happiness)
	∧ GOAL = event(somebody, experience, EMO, present, X)
	∧ INPUT = [
		human(somebody),
		human(somebodyElse)
	]
	∧ maxValue(X, GOAL, INPUT, RESULT)
	∧ showMaxValue(RESULT, color) ∧ fail.