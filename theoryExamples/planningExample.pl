/* NOTES---------------------------------------------------------------------------------------------------------------------------------------------

A recursive theory about how people make plans by connecting actions between sequences of state transitions to find a goal. 
Query q1 and q2 use a single-argument state representation; query q3 uses a multi-argument state representation. See the "Monkey and Banana" 
example in Bratko (2001) for a related example.

SOURCES
Bratko, I. (2001). Prolog programming for artificial intelligence. Pearson education.

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% human(H)
% event(H, represent, transition(START, ACTION, GOAL), time, X)

% H and ACTION are constants
% START and GOAL are constants or functions
% {X ∈ ℝ | 0 =< X =< 1}


% MAIN CLAUSES

event(H, deduce, plan(START, ACTIONS, GOAL), time, X1) ⇐
	human(H)
	∧ event(H, represent, transition(START, ACTION, GOAL), time, X2)
	∧ ACTIONS = ACTION
	∧ {X1 = 1.00 * X2}.

event(H, deduce, plan(START, ACTIONS, GOAL), time, X1) ⇐
	human(H)
	∧ event(H, represent, transition(START, ACTION, INTERIMGOAL), time, X2)
	∧ event(H, deduce, plan(INTERIMGOAL, DEDUCEDACTIONS, GOAL), time, X3)
	∧ ACTIONS = (ACTION, DEDUCEDACTIONS)
	∧ {X1 = 0.80 * X2 * X3}. 


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐	GOAL = event(somebody, deduce, plan(start, _, satisfied), time, _)
	∧ INPUT = [
		human(somebody),
		event(somebody, represent, transition(start, openFridge, fridgeOpen), time, 1),
		event(somebody, represent, transition(start, openWaterFaucet, haveBeverage), time, 1),
		event(somebody, represent, transition(fridgeOpen, getMilk, haveBeverage), time, 1),
		event(somebody, represent, transition(fridgeOpen, getJuice, haveBeverage), time, 1),
		event(somebody, represent, transition(haveBeverage, getGlass, haveGlass), time, 1),
		event(somebody, represent, transition(haveBeverage, drinkBeverage, satisfied), time, 1),
		event(somebody, represent, transition(haveGlass, pourBeverageInGlass, beverageInGlass), time, 1),
		event(somebody, represent, transition(beverageInGlass, drinkBeverage, satisfied), time, 1)
	]
	∧ provable(GOAL, INPUT, RESULT)
	∧ showProvable(RESULT) ∧ fail.

q2 ⇐	GOAL = event(somebody, deduce, plan(inCopenhagen, _, inApartment), time, _)
	∧ INPUT = [
		human(somebody),
		event(somebody, represent, transition(inCopenhagen, takeTrainToMalmo, inMalmo), time, 1),
		event(somebody, represent, transition(inMalmo, takeBussToLund, inLund), time, 1),
		event(somebody, represent, transition(inMalmo, takeTrainToLund, inLund), time, 1),
		event(somebody, represent, transition(inLund, walkToApartment, outsideApartment), time, 1),
		event(somebody, represent, transition(inLund, callTaxi, haveTaxi), time, 1),
		event(somebody, represent, transition(outsideApartment, lookForKeys, keysThere), time, 1),
		event(somebody, represent, transition(outsideApartment, lookForKeys, keysMissing), time, 1),
		event(somebody, represent, transition(keysThere, unlockDoor, doorOpen), time, 1),
		event(somebody, represent, transition(keysMissing, getLadder, haveLadder), time, 1),
		event(somebody, represent, transition(keysMissing, callLocksmith, haveLocksmit), time, 1),
		event(somebody, represent, transition(haveTaxi, rideTaxiToApartment, outsideApartment), time, 1),
		event(somebody, represent, transition(haveLadder, moveLadderToWindow, ladderBelowWindow), time, 1),
		event(somebody, represent, transition(ladderBelowWindow, getRock, haveRock), time, 1),
		event(somebody, represent, transition(haveRock, climbLadder, atWindow), time, 1),
		event(somebody, represent, transition(atWindow, breakWindow, windowBroken), time, 1),
		event(somebody, represent, transition(windowBroken, enterApartment, inApartment), time, 1),
		event(somebody, represent, transition(haveLocksmit, payLocksmith, doorOpen), time, 1),
		event(somebody, represent, transition(doorOpen, enterApartment, inApartment), time, 1)
	]
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).

q3 ⇐	GOAL = event(h, deduce, plan(s(home, noPassport, noClothes), _, s(vacation, passport, clothes)), time, _)
	∧ INPUT = [
		human(h),
		event(h, represent, transition(	s(home, noPassport, CLOTHES1), 		getPassport, 		s(home, passport, CLOTHES1)), 			time, 1),
		event(h, represent, transition(	s(home, PASSPORT1, noClothes), 		getClothes, 		s(home, PASSPORT1, clothes)), 			time, 1),
		event(h, represent, transition(	s(home, PASSPORT2, clothes), 		walkToBus,		s(busStop, PASSPORT2, clothes)), 		time, 1),
		event(h, represent, transition(	s(home, PASSPORT3, clothes), 		takeBikeToBeach, 	s(beach, PASSPORT3, clothes)), 			time, 1),
		event(h, represent, transition(	s(busStop, PASSPORT4, clothes), 	takeBusToAirport, 	s(airport, PASSPORT4, clothes)), 		time, 1),
		event(h, represent, transition(	s(home, PASSPORT5, clothes), 		takeCabToAirport, 	s(airport, PASSPORT5, clothes)),		time, 1),
		event(h, represent, transition(	s(airport, passport, clothes), 		takePlaneToHawaii, 	s(hawaii, passport, clothes)), 			time, 1),
		event(h, represent, transition(	s(airport, passport, clothes), 		takePlaneToMadrid, 	s(madrid, passport, clothes)), 			time, 1),
		event(h, represent, transition(	s(madrid, passport, clothes), 		takePlaneToRome, 	s(rome, passport, clothes)), 			time, 1),
		event(h, represent, transition(	s(rome, PASSPORT6, clothes), 		takeTrainToAnzio, 	s(beach, PASSPORT6, clothes)), 			time, 1),
		event(h, represent, transition(	s(hawaii, PASSPORT7, CLOTHES2), 	getToHotel, 		s(vacation, PASSPORT7, CLOTHES2)), 		time, 1),
		event(h, represent, transition(	s(beach, PASSPORT8, CLOTHES3), 		relax, 			s(vacation, PASSPORT8, CLOTHES3)), 		time, 1)
	]
	∧ prove(GOAL, INPUT, RESULT)
	∧ showProof(RESULT, color).