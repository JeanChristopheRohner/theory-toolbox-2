/* NOTES----------------------------------------------------------------------------------------------------------------------------------------------

A recursive theory about the transitivity of distance relations. For related research, 
see for example Brainerd et al (1984). People can deduce a distance relation A beyond C, if they represent that A is 
beyond C, or if they represent that A is beyond B and can deduce that B is beyond C.

SOURCES
Brainerd, C. J., & Kingma, J. (1984). Do children have to remember to reason? A fuzzy-trace theory of transitivity 
  development. Developmental Review, 4(4), 311-377.

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% source(S)
% human(H)
% event(H, represent, relation(A, beyond, B), time, X)

% H, A and B are constants
% S = recursive ∨ S = nonrecursive
% {X ∈ ℝ | 0 =< X =< 1}


% MAIN CLAUSES

event(H, deduce, relation(A, beyond, B), time, X1) ⇐
	human(H)
	∧ event(H, represent, relation(A, beyond, B), time, X2)
	∧ {X1 = 1.0 * X2}.

event(H, deduce, relation(A, beyond, C), time, X1) ⇐
	source(recursive)
	∧ human(H)
	∧ event(H, represent, relation(A, beyond, B), time, X2)
	∧ event(H, deduce, relation(B, beyond, C), time, X3)
	∧ {X1 = 0.8 * X2 * X3}.

event(H, deduce, relation(A, beyond, C), time, X1) ⇐
	source(nonrecursive)
	∧ human(H)
	∧ event(H, represent, relation(A, beyond, B), time, X2)
	∧ event(H, represent, relation(B, beyond, C), time, X3)
	∧ {X1 = 0.8 * X2 * X3}.


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐	GOAL = event(somebody, deduce, relation(_, beyond, _), time, _)
	∧ INPUT = [
		source(recursive),
		human(somebody),
		event(somebody, represent, relation(earth, beyond, venus), time, 1),
		event(somebody, represent, relation(mars, beyond, earth), time, 1),
		event(somebody, represent, relation(jupiter, beyond, mars), time, 1),
		event(somebody, represent, relation(saturn, beyond, jupiter), time, 1),
		event(somebody, represent, relation(uranus, beyond, saturn), time, 1),
		event(somebody, represent, relation(neptune, beyond, uranus), time, 1),
		event(somebody, represent, relation(pluto, beyond, neptune), time, 1)
	]
	∧ falsifiability(GOAL, INPUT, RESULT)
	∧ showFalsifiability(RESULT).

q2 ⇐	GOAL = event(somebody, deduce, relation(_, beyond, _), time, _)
	∧ INPUT = [
		source(nonrecursive),
		human(somebody),
		event(somebody, represent, relation(earth, beyond, venus), time, 1),
		event(somebody, represent, relation(mars, beyond, earth), time, 1),
		event(somebody, represent, relation(jupiter, beyond, mars), time, 1),
		event(somebody, represent, relation(saturn, beyond, jupiter), time, 1),
		event(somebody, represent, relation(uranus, beyond, saturn), time, 1),
		event(somebody, represent, relation(neptune, beyond, uranus), time, 1),
		event(somebody, represent, relation(pluto, beyond, neptune), time, 1)
	]
	∧ falsifiability(GOAL, INPUT, RESULT)
	∧ showFalsifiability(RESULT).

q3 ⇐ 	GOAL = event(somebody, deduce, relation(_, beyond, _), time, _)
	∧ INPUT = [
		human(somebody),
		event(somebody, represent, relation(earth, beyond, venus), time, 1),
		event(somebody, represent, relation(mars, beyond, earth), time, 1),
		event(somebody, represent, relation(jupiter, beyond, mars), time, 1),
		event(somebody, represent, relation(saturn, beyond, jupiter), time, 1),
		event(somebody, represent, relation(uranus, beyond, saturn), time, 1),
		event(somebody, represent, relation(neptune, beyond, uranus), time, 1),
		event(somebody, represent, relation(pluto, beyond, neptune), time, 1)
	]
	∧ SUPERTHEORY = source(recursive)
	∧ SUBTHEORY = source(nonrecursive)
	∧ subsumes(SUPERTHEORY, SUBTHEORY, GOAL, INPUT, RESULT)
	∧ showSubsumes(RESULT).