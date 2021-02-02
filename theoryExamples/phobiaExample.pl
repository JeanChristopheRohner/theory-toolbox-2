/* NOTES---------------------------------------------------------------------------------------------------------------------------------------------

Important parts of the DSM5® definition of simple phobia:
"Marked fear or anxiety about a specific object or situation (e.g., flying, heights, animals, receiving an 
  injection, seeing blood)."
"The fear, anxiety, or avoidance causes clinically significant distress or impairment in social, occupational, 
  or other important areas of functioning."
"The phobic object or situation almost always provokes immediate fear or anxiety."
"The phobic object or situation is avoided or endured with intense fear or anxiety."

The last clause is external to the DSM® definition, it means that avoiding an object is negatively related to
encountering the object

This theory is problematic: Because it is supposed to mirror the DSM5® definition as closely as possible, 
it ends up having two clauses with the same consequent (1 and 2); in conjunction with what main clause 4 entails, 
the theory becomes internally incoherent, as shown by query q3.

SOURCES
American Psychiatric Association. (2013). Diagnostic and statistical manual of mental disorders (DSM-5®). 
  American Psychiatric Publishers.

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% source(S) 
% human(H)
% event(H, phobia, O, time, X)

% S = dsm5 ∨ S = plausibleAssumption
% H is a constant
% O = spiders ∨ O = insects ∨ O = dogs ∨ O = heights ∨ O = storms ∨ O = water ∨ O = needles ∨ O = medicalProcedures ∨
% O = airplanes ∨ O = elevators ∨ O = enclosedSpaces
% {X ∈ ℝ | 0 =< X =< 1}


% BACKGROUND CLAUSES

object(spiders).
object(insects).
object(dogs).
object(heights).
object(storms).
object(water).
object(needles).
object(medicalProcedures).
object(airplanes).
object(elevators).
object(enclosedSpaces).


% MAIN CLAUSES

event(H, fear, O, time, X1) ⇐
	source(dsm5)
	∧ human(H)
	∧ object(O)
	∧ event(H, phobia, O, time, X2)
	∧ {X1 = 1.0 * X2}.

event(H, fear, O, time, X1) ⇐
	source(dsm5)
	∧ human(H)
	∧ object(O)
	∧ event(H, phobia, O, time, X2)
	∧ event(H, encounter, O, time, X3)
	∧ {X1 = 1.0 * X2 * X3}.

event(H, avoid, O, time, X1) ⇐
	source(dsm5)
	∧ human(H)
	∧ object(O)
	∧ event(H, phobia, O, time, X2)
	∧ {X1 = 1.0 * X2}.

event(H, encounter, O, time, X1) ⇐
	source(plausibleAssumption)
	∧ human(H)
	∧ object(O)
	∧ event(H, avoid, O, time, X2)
	∧ {X1 = 1.0 - X2}.


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐	GOAL = event(somebody, _, _, time, _)
	∧ INPUT = [
		source(dsm5),
		human(somebody),
		event(somebody, phobia, heights, time, 0.8)
	]
	∧ provable(GOAL, INPUT, RESULT)
	∧ showProvable(RESULT) ∧ fail.

q2 ⇐	GOAL1 = event(S, V, O, T, X1)
	∧ GOAL2 = event(S, V, O, T, X2)
	∧ INPUT = [
		source(dsm5), 
		human(somebody),
		event(somebody, phobia, spiders, time, 1)
	]
	∧ THRESHOLD = 0.1
	∧ incoherence(GOAL1, GOAL2, INPUT, THRESHOLD, X1, X2, RESULT)
	∧ showIncoherence(RESULT, color) ∧ fail.

q3 ⇐	GOAL1 = event(S, V, O, T, X1)
	∧ GOAL2 = event(S, V, O, T, X2)
	∧ INPUT = [
		source(dsm5), 
		source(plausibleAssumption), 
		human(somebody),
		event(somebody, phobia, spiders, time, 1)
	]
	∧ THRESHOLD = 0.1
	∧ incoherence(GOAL1, GOAL2, INPUT, THRESHOLD, X1, X2, RESULT)
	∧ showIncoherence(RESULT, lanes) ∧ fail.