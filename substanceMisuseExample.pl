/* NOTES---------------------------------------------------------------------------------------------------------------------------------------------

The theory below is loosely based on the work of Ajzen (1991), Bandura(2004), Nutt et al (2007), Skinner (1953), 
and Walters and Rotgers (2011). The likelihood of misuse behavior is determined by cognitive beliefs towards the 
behavior, as well as positive reinforcement and observational learning. The likelihood of physical harm
depends on the probability of using a substance and the harmfulness of the substance.

Pleasure values and harm values for different substances were obtained by dividing 
the expert ratings in  Nutt et al (2007, Table 3) by 3 to standardize values to the 0-1 range. Note that only 
relative comparisons between probabilities are meaningful, since the works on which the theory is based are not that 
detailed about various background assumptions that impact different parameter values (e.g. how long does one have 
to use heroin to get a harm value of 3, etc). But relative comparisons between probabilities should be meaningful.
Physical harm does not appear as an outcome in the operant learning clause because physical harm does not produce 
immediate displeasure (i.e. not a reinforcer). For the sake of clarity the theory also uses a simple 
representation of the relation between substance misuse and physical harm: It does not increment harm as a function 
of the number of misuse episodes. Harm values should insted be interpreted as the harm that results from one misuse 
episode. The file substanceAbuseExampleState.pl contains a more advanced state representation of harm.

SOURCES
Ajzen, I. (1991). The theory of planned behavior. Organizational behavior and human decision 
  processes, 50(2), 179-211. 
Nutt, D., King, L., Saulsbury, W., & Blakemore, C. (2007). Development of a rational scale to assess the harm of 
  drugs of potential misuse. Lancet, 369, 1047-1053.
Skinner, B. F. (1953). Science and human behavior: Simon and Schuster.
Bandura, A. (2004). Observational Learning. In J. H. Byrne (Ed.), Learning and Memory (2nd ed. ed., pp. 482-484). 
  Macmillan Reference USA.
Walters, S. T., & Rotgers, F. (Eds.). (2011). Treating substance abuse: Theory and technique. Guilford Press.

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% source(S)	
% human(H)
% referent(R, H)
% exogenousEvent(_, _, _, _, X)

% S = theoryOfPlannedBehavior ∨ S = operantLearning ∨ S = vicariousLearning ∨ S = harmBehavior
% H and R are constants
% {X ∈ ℝ | 0 =< X =< 1}


% BACKGROUND CLAUSES

misuse(useHeroin).
misuse(useCocaine).
misuse(useAlchohol).
misuse(useBenzodiazepines).
misuse(useAmphetamine).
misuse(useTobacco).
misuse(useCannabis).
misuse(useLSD).
misuse(useEcstasy).
misuse(useStreetMethadone).

outcome(pleasure).
outcome(physicalHarm).
positive(pleasure).
negative(physicalHarm).
reinforcer(pleasure).

time(1).
time(2).
time(3).
time(4).
time(5).
time(6).

precedes(X, Y) ⇐ time(X) ∧ time(Y) ∧ {Y = X + 1}.

event(useHeroin, cause, physicalHarm, T, 0.93) ⇐ time(T).
event(useCocaine, cause, physicalHarm, T, 0.78) ⇐ time(T).
event(useAlchohol, cause, physicalHarm, T, 0.47) ⇐ time(T).
event(useBenzodiazepines, cause, physicalHarm, T, 0.54) ⇐ time(T).
event(useAmphetamine, cause, physicalHarm, T, 0.60) ⇐ time(T).
event(useTobacco, cause, physicalHarm, T, 0.41) ⇐ time(T).
event(useCannabis, cause, physicalHarm, T, 0.33) ⇐ time(T).
event(useLSD, cause, physicalHarm, T, 0.38) ⇐ time(T).
event(useEcstasy, cause, physicalHarm, T, 0.35) ⇐ time(T).
event(useStreetMethadone, cause, physicalHarm, T, 0.62) ⇐ time(T).

event(useHeroin, cause, pleasure, T, 1.00) ⇐ time(T).
event(useCocaine, cause, pleasure, T, 1.00) ⇐ time(T).
event(useAlchohol, cause, pleasure, T, 0.77) ⇐ time(T).
event(useBenzodiazepines, cause, pleasure, T, 0.57) ⇐ time(T).
event(useAmphetamine, cause, pleasure, T, 0.67) ⇐ time(T).
event(useTobacco, cause, pleasure, T, 0.77) ⇐ time(T).
event(useCannabis, cause, pleasure, T, 0.63) ⇐ time(T).
event(useLSD, cause, pleasure, T, 0.73) ⇐ time(T).
event(useEcstasy, cause, pleasure, T, 0.50) ⇐ time(T).
event(useStreetMethadone, cause, pleasure, T, 0.60) ⇐ time(T).


% MAIN CLAUSES

event(H, represent, event(H, like, M, T1, 1), T1, X1) ⇐
	source(theoryOfPlannedBehavior)
	∧ human(H)
	∧ misuse(M)
	∧ outcome(PO) ∧ outcome(NO)
	∧ positive(PO) ∧ negative(NO)
	∧ precedes(T2, T1)
	∧ exogenousEvent(H, represent, event(M, cause, PO, T2, 1), T2, X2)
	∧ exogenousEvent(H, represent, event(M, cause, NO, T2, 1), T2, X3)
	∧ {X1 = X2 * (1 - X3)}.

event(H, represent, event(H, control, M, T1, 1), T1, X1) ⇐
	source(theoryOfPlannedBehavior)
	∧ human(H)
	∧ misuse(M)
	∧ precedes(T2, T1)
	∧ exogenousEvent(H, represent, event(environment, afford, M, T2, 1), T2, X2)
	∧ exogenousEvent(H, represent, event(H, affect, environment, T2, 1), T2, X3)
	∧ {X1 = X2 * X3}.

event(H, represent, event(H, should, M, T1, 1), T1, X1) ⇐
	source(theoryOfPlannedBehavior)
	∧ human(H)
	∧ referent(R, H)
	∧ misuse(M)
	∧ precedes(T2, T1)
	∧ exogenousEvent(R, represent, event(H, ought, M, T2, 1), T2, X2)
	∧ exogenousEvent(H, represent, event(H, comply, R, T2, 1), T2, X3)
	∧ {X1 = X2 * X3}.

event(H, represent, event(H, intend, M, T1, 1), T1, X1) ⇐
	source(theoryOfPlannedBehavior)
	∧ human(H)
	∧ misuse(M)
	∧ precedes(T2, T1)
	∧ event(H, represent, event(H, like, M, T2, 1), T2, X2)
	∧ event(H, represent, event(H, control, M, T2, 1), T2, X3)
	∧ event(H, represent, event(H, should, M, T2, 1), T2, X4)
	∧ {X1 = X2 * X3 * X4}.

event(H, perform, M, T1, X1) ⇐
	source(theoryOfPlannedBehavior)
	∧ human(H)
	∧ misuse(M)
	∧ precedes(T2, T1)
	∧ event(H, represent, event(H, intend, M, T2, 1), T2, X2)
	∧ {X1 = X2}.

event(H, perform, M, T1, X1) ⇐
	source(operantLearning)
	∧ human(H)
	∧ misuse(M)
	∧ outcome(O)
	∧ positive(O)
	∧ reinforcer(O)
	∧ precedes(T2, T1)
	∧ event(M, cause, O, T2, X2)
	∧ event(H, perform, M, T2, X3)
	∧ {X1 = X2 * X3}.

event(H, perform, M, T1, X1) ⇐
	source(vicariousLearning)
	∧ human(H)
	∧ misuse(M)
	∧ referent(R, H)
	∧ outcome(O)
	∧ positive(O)
	∧ reinforcer(O)
	∧ precedes(T2, T1)
	∧ event(M, cause, O, T2, X2)
	∧ event(R, perform, M, T2, X3)
	∧ exogenousEvent(H, attend, R, T2, X4)
	∧ exogenousEvent(H, capable, M, T2, X5)
	∧ {X1 = X2 * X3 * X4 * X5}.

event(H, experience, physicalHarm, T1, X1) ⇐
	source(harmBehavior)
	∧ human(H)
	∧ misuse(M)
	∧ precedes(T2, T1)
	∧ event(H, perform, M, T2, X2)
	∧ event(M, cause, physicalHarm, T2, X3)
	∧ {X1 = X2 * X3}.


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

% PROVABLE

q1 ⇐	GOAL = event(_, _, _, _, _)
	∧ INPUT = [
		exogenousEvent(_, _, _, _, _),
		source(_),
		human(somebody),
		referent(friend, somebody)
	]
	∧ provable(GOAL, INPUT, RESULT)
	∧ showProvable(RESULT) ∧ fail.

q2 ⇐ 	GOAL = event(somebody, experience, physicalHarm, 6, _)
	∧ misuse(MISUSE)
	∧ INPUT = [
		source(operantLearning),
		source(harmBehavior), 
		human(somebody), 
		referent(friend, somebody), 
		event(somebody, perform, MISUSE, 1, 1)
	]
	∧ provable(GOAL, INPUT, RESULT)
	∧ write(MISUSE) ∧ write(': ') ∧ showProvable(RESULT) ∧ fail.


% PROVE

q3 ⇐  	GOAL = event(somebody, perform, useTobacco, 6, _)
	∧ INPUT = [
		source(_),
		exogenousEvent(_, _, _, _, _),
		human(somebody), human(friend),
		referent(friend, somebody), referent(somebody, friend)
	]
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).


% MAXVALUE

q4 ⇐ 	GOAL = event(somebody, experience, physicalHarm, _, X)
	∧ INPUT = [
		source(_),
		exogenousEvent(_, _, _, _, 0.1),
		exogenousEvent(_, _, _, _, 0.9),
		human(somebody),
		referent(friend, somebody)
	]
	∧ maxValue(X, GOAL, INPUT, RESULT)
	∧ showMaxValue(RESULT, lanes).

q5 ⇐ 	GOAL = event(somebody, perform, eatUnhealthy, 6, X)
	∧ INPUT = [
		source(_),
		exogenousEvent(_, _, _, _, 0.1),
		exogenousEvent(_, _, _, _, 0.9),
		misuse(eatUnhealthy),
		human(somebody), human(friend),
		referent(friend, somebody), referent(somebody, friend)
	]
	∧ maxValue(X, GOAL, INPUT, RESULT)
	∧ showMaxValue(RESULT, color).


% MINVALUE

q6 ⇐ 	GOAL = event(somebody, perform, eatUnhealthy, 6, X)
	∧ INPUT = [
		source(_),
		exogenousEvent(_, _, _, _, 0.1),
		exogenousEvent(_, _, _, _, 0.9),
		misuse(eatUnhealthy),
		human(somebody), human(friend),
		referent(friend, somebody)
	]
	∧ minValue(X, GOAL, INPUT, RESULT)
	∧ showMinValue(RESULT, lanes).