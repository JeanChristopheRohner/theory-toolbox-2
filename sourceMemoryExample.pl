/* NOTES---------------------------------------------------------------------------------------------------------------------------------------------

This theory represents the source monitoring framework (SMF, Johnson et al., 1993). According to the
SMF people rely on perceptual, contextual and cognitive detail in a memory exprience (E) when making judgements 
about where the memory comes from (source, S). External sources (e.g. actually seeing something) have more perceptual and 
contextual detail, and less cognitive detail, represented by the feature vector (1, 1, -1). Internal sources 
(e.g. imagining something) have less perceptual and contextual detail, but more cognitive detail, 
represented by the feature vector (-1, -1, 1). The probability that somebody thinks that an experience
came from a certain source, depends on how similar the experience is to the source in terms of the feature
vectors for the experience and the source.

A correct source attribution, i.e. remembering the source, occurs when a source generated an experience
and when somebody believes that the same source generated the experience. An incorrect source attribution, 
i.e. being wrong about the source, occurs when a source generated an experience and when somebody believes  
that another source generated the experience. Examples of source misattributions are thinking that person A said 
something when person B in fact did, confusing actually locking the door with imagining locking the door,
confusing seeing a person at a crime scene with seeing them on TV, involuntary plagiarism, etc.

REFERENCES
Johnson, M. K., Hashtroudi, S., & Lindsay, D. S. (1993). Source monitoring. Psychological bulletin, 114(1), 3.
Mitchell, K. J., & Johnson, M. K. (2000). Source monitoring: Attributing mental experiences. 
  The Oxford handbook of memory, 179-195.

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% human(H)
% source(S)
% internal(S) ∨ external(S)
% experience(E)
% event(H, attend, E, past, X)
% event(S, generate, E, past, 1)

% H, S and E are constants
% {X ∈ ℝ | 0 =< X =< 1}


% BACKGROUND CLAUSES

time(past).
time(present).
precedes(past, present).


% MAIN CLAUSES

event(H, remember, event(S, generate, E, T1, 1), T2, X1) ⇐
	human(H)
	∧ source(S)
	∧ experience(E)
	∧ precedes(T1, T2)
	∧ event(S, generate, E, T1, 1)
	∧ event(H, represent, event(S, generate, E, T1, 1), T2, X2)
	∧ {X1 = X2}.

event(H, misremember, event(S1, generate, E, T1, 1), T2, X1) ⇐ 
	human(H)
	∧ source(S1)
	∧ source(S2)
	∧ ¬(S1 = S2)
	∧ experience(E)
	∧ precedes(T1, T2)
	∧ event(S2, generate, E, T1, 1)
	∧ event(H, represent, event(S1, generate, E, T1, 1), T2, X2)
	∧ {X1 = X2}.

event(H, represent, event(S, generate, E, T1, 1), T2, X1) ⇐
	human(H)
	∧ source(S)
	∧ experience(E)
	∧ time(T1) 
	∧ time(T2)
	∧ event(H, represent, event(E, hasFeatures, F1, T1, 1), T2, X2)
	∧ event(H, represent, event(S, hasFeatures, F2, T1, 1), T2, X3)
	∧ event(H, represent, event(F1, similar, F2, T1, 1), T2, X4)
	∧ {X1 = X2 * X3 * X4}.

event(H, represent, event(E, hasFeatures, F, T1, X2), T2, X1) ⇐
	human(H)
	∧ experience(E)
	∧ precedes(T1, T2)
	∧ event(E, hasFeatures, F, T1, X2)
	∧ event(H, attend, E, T1, X3)     
	∧ {X1 = X2 * X3}.

event(E, hasFeatures, features(F1, F2, F3), T, 1) ⇐
	experience(E)
	∧ (F1 = -0.9 ∨ F1 = 0.9) ∧ (F2 = -0.9 ∨ F2 = 0.9) ∧ (F3 = -0.9 ∨ F3 = 0.9)
	∧ time(T). 

event(H, represent, event(S, hasFeatures, features(1, 1, -1), T1, 1), T2, 1) ⇐ 
	human(H) 
	∧ source(S)
	∧ external(S)
	∧ time(T1)
	∧ time(T2).

event(H, represent, event(S, hasFeatures, features(-1, -1, 1), T1, 1), T2, 1) ⇐ 
	human(H)
	∧ source(S) 
	∧ internal(S) 
	∧ time(T1) 
	∧ time(T2).

event(H, represent, event(F1, similar, F2, T1, 1), T2, X) ⇐
	human(H)
	∧ time(T1)
	∧ time(T2)
	∧ F1 = features(F11, F12, F13)
	∧ F2 = features(F21, F22, F23)
	∧ {X = (F11 * F21 + F12 * F22 + F13 * F23) / 6 + 0.5}.


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐	GOAL = event(h1, remember, _, _, X)
	∧ INPUT = [
		human(h1),
		source(newsPaper), 
		source(crimeScene),
		external(newsPaper), 
		external(crimeScene),
		experience(imageOfJohnDoe),
		event(h1, attend, imageOfJohnDoe, past, 1),
		event(newsPaper, generate, imageOfJohnDoe, past, 1)
	]
	∧ maxValue(X, GOAL, INPUT, RESULT)
	∧ showMaxValue(RESULT, lanes).

q2 ⇐	GOAL = event(h1, misremember, _, _, X)
	∧ INPUT = [
		human(h1),
		source(newsPaper), 
		source(crimeScene),
		source(dream),
		external(newsPaper), 
		external(crimeScene),
		internal(dream),
		experience(imageOfJohnDoe),
		event(h1, attend, imageOfJohnDoe, past, 1),
		event(newsPaper, generate, imageOfJohnDoe, past, 1)
	]
	∧ maxValue(X, GOAL, INPUT, RESULT)
	∧ showMaxValue(RESULT, color).

q3 ⇐ 	GOAL = event(h1, misremember, _, _, X)
	∧ INPUT = [
		human(h1),
		source(newsPaper), 
		source(crimeScene),
		external(newsPaper), 
		external(crimeScene),
		internal(dream),
		experience(imageOfJohnDoe),
		event(h1, attend, imageOfJohnDoe, past, 1),
		event(newsPaper, generate, imageOfJohnDoe, past, 1)
	]
	∧ minValue(X, GOAL, INPUT, RESULT)
	∧ showMinValue(RESULT, lanes).

q4 ⇐	GOAL = event(h1, misremember, _, _, X)
	∧ INPUT = [
		human(h1),
		source(actualSpeech), source(imaginedSpeech),
		internal(actualSpeech), internal(imaginedSpeech),
		experience(speakingToJohn),
		event(h1, attend, speakingToJohn, past, 1),
		event(imaginedSpeech, generate, speakingToJohn, past, 1)
	]
	∧ maxValue(X, GOAL, INPUT, RESULT)
	∧ showMaxValue(RESULT, color) ∧ fail.