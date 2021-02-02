/* NOTES----------------------------------------------------------------------------------------------------------------------------------------------

A general theory about natural selection. An individual exists if they have a parent that reproduces. A parent 
passes on a trait to their offspring if they reproduce and have a trait that is heritable. The probability of reproducing depends 
on having a trait that is adaptive in a habitat. 

SOURCES
Bell, G. (2008). Selection: the mechanism of evolution. Oxford University Press on Demand.
Neuberg, S. L., Kenrick, D. T., & Schaller, M. (2010). Evolutionary social psychology.
Schaffner, S. & Sabeti, P. (2008) Evolutionary adaptation in the human lineage. Nature Education 1(1):14

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:- include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% generations(G)
% event(_, inhabits, H, _, X).
% event(T, adaptiveIn, H, _, X).
% event(T, hasProperty, heritable, _, X).
% event(1, hasTrait, T, time, X).

% H and T are constants
% {G ∈ ℤ | 1 =< G =< 10}
% {X ∈ ℝ | 0 =< X =< 1}


% BACKGROUND CLAUSES

parent(PARENT, OFFSPRING) ⇐ 
	generations(G) 
	∧ between(2, G, OFFSPRING) 
	∧ PARENT is OFFSPRING - 1.


% MAIN CLAUSES

event(OFFSPRING, does, exist, time, X) ⇐
	parent(PARENT, OFFSPRING)
	∧ event(PARENT, does, reproduce, time, X).

event(OFFSPRING, hasTrait, TRAIT, time, X1) ⇐
	parent(PARENT, OFFSPRING)
	∧ event(PARENT, does, reproduce, time, X2)
	∧ event(PARENT, hasTrait, TRAIT, time, X3)
	∧ event(TRAIT, hasProperty, heritable, time, X4)
	∧ X1 is X2 * X3 * X4.

event(INDIVIDUAL, does, reproduce, time, X1) ⇐
	event(INDIVIDUAL, inhabits, HABITAT, time, X2)
	∧ event(INDIVIDUAL, hasTrait, TRAIT, time, X3)
	∧ event(TRAIT, adaptiveIn, HABITAT, time, X4)
	∧ X1 is X2 * X3 * X4.


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐	GOAL = event(4, hasTrait, _, time, _)
	∧ INPUT = [
		generations(4),
		event(1, hasTrait, cooperation, time, 1),
		event(cooperation, hasProperty, heritable, _, 1),
		event(_, inhabits, humanEcology, _, 1),
		event(cooperation, adaptiveIn, humanEcology, _, 0.99)
	]
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).

q2 ⇐	GOAL = event(4, hasTrait, _, time, _)
	∧ INPUT = [
		generations(4),
		event(1, hasTrait, hostility, time, 1),
		event(hostility, hasProperty, heritable, _, 1),
		event(_, inhabits, humanEcology, _, 1),
		event(hostility, adaptiveIn, humanEcology, _, 0.5)
	]
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).

q3 ⇐	GOAL = event(4, does, exist, time, _)
	∧ INPUT = [
		generations(4),
		event(1, hasTrait, cooperation, time, 1),
		event(cooperation, hasProperty, heritable, _, 1),
		event(_, inhabits, humanEcology, _, 1),
		event(cooperation, adaptiveIn, humanEcology, _, 0.99)
	]
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).

q4 ⇐	GOAL = event(3, hasTrait, _, _, _)
	∧ INPUT = [
		generations(3),
		event(_, inhabits, agrarianNiche, _, 1),
		event(1, hasTrait, lactoseTolerance, time, 1),
		event(lactoseTolerance, hasProperty, heritable, _, 1),
		event(lactoseTolerance, adaptiveIn, agrarianNiche, _, 1),
		event(1, hasTrait, palmarGraspReflex, time, 1),
		event(palmarGraspReflex, hasProperty, heritable, _, 1),
		event(palmarGraspReflex, adaptiveIn, agrarianNiche, _, 0.1)
	]
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).