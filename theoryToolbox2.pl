% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% INFO

% © Jean-Christophe Rohner 2019, 2020
% This is experimental software. Use at your own risk.
% See the LICENSE file for more information.


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% SETUP

:- use_module(library(clpr)).
:- op(1200, xfx, ⇐).
:- op(1000, xfy, ∧).
:- op(1100, xfy, ∨).
:- op(900, fy, ¬).
term_expansion(A ⇐ B, A:- B).
goal_expansion(A ∧ B, (A, B)).
goal_expansion(A ∨ B, (A; B)).
goal_expansion(¬A, \+A).


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% PROVABLE

% provable(GOAL, INPUT, RESULT). 
% Query if GOAL is provable given INPUT and unify the result with RESULT.
% GOAL should be an atomic formula with constants, variables or functions as arguments.
% INPUT should be a list of zero or more atomic formulas.

% showProvable(RESULT). 
% Prints the RESULT obtained from provable(GOAL, INPUT, RESULT) to the console.

% Usage examples:
% tutorialExamples.pl
% collinsQuillianExample.pl
% phobiaExample.pl
% planningExample.pl
% substanceMisuseExample.pl
% substanceMisuseExampleState.pl


provable(G, I, G):- provable0(G, I).

provable0(true, _):- !.
provable0((G1, G2), I):- !, provable0(G1, I), provable0(G2, I).
provable0((G1; G2), I):- !, (provable0(G1, I); provable0(G2, I)).
provable0(G, I):- G = \+(G0), !, \+provable0(G0, I).
provable0(G, _):- predicate_property(G, imported_from(_)), !, call(G).
provable0(G, I):- copy_term(I, I1), member(G, I1).
provable0(H, I):- clause(H, Body), provable0(Body, I).

showProvable(G):- formatOutputTerm(G, G1), writeln(G1).


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% PROVE

% prove(GOAL, INPUT, RESULT). 
% Find a proof for GOAL given INPUT and unify the result with RESULT.
% GOAL should be an atomic formula with constants, variables or functions as arguments.
% INPUT should be a list of zero or more atomic formulas.

% showProof(RESULT, OPTION). 
% Prints the proof obtained from prove(GOAL, INPUT, RESULT) to the console.
% OPTION should be one of the following: monochrome, color, lanes

% Usage examples:
% tutorialExamples.pl
% collinsQuillianExample.pl
% naturalSelectionExample.pl
% planningExample.pl
% substanceMisuseExample.pl
% substanceMisuseExampleState.pl



prove(true, _, true):- !.
prove((G1, G2), I, (P1, P2)):- !, prove(G1, I, P1), prove(G2, I, P2).
prove((G1; G2), I, (P1; P2)):- !, (prove(G1, I, P1); prove(G2, I, P2)).
prove(G, I, P):- G = \+(G0), !, \+prove(G0, I, _), P = subproof(¬G0, true).
prove(G, _, P):- predicate_property(G, imported_from(_)), !, call(G), P = subproof(G, true).
prove(G, I, P):- copy_term(I, I1), member(G, I1), P = subproof(G, true).
prove(H, I, subproof(H, Subproof)):- clause(H, Body), prove(Body, I, Subproof).

showProof0(X, SUB, monochrome):- X = subproof(G, P), P \= true, writeNTabs(SUB), format('~w~w~n', [G, ' ⇐']), SUB1 is SUB + 1, showProof0(P, SUB1, monochrome).
showProof0(X, SUB, color):- X = subproof(G, P), P \= true, writeNTabs(SUB), color(SUB, C), ansi_format([C], '~w~w~n', [G, ' ⇐']), SUB1 is SUB + 1, showProof0(P, SUB1, color).
showProof0(X, SUB, lanes):- X = subproof(G, P), P \= true, writeNTabs(SUB, lanes), format('~w~w~n', [G, ' ⇐']), SUB1 is SUB + 1, showProof0(P, SUB1, lanes).
showProof0(X, SUB, O):- X = ','(A, B), A \= true, B \= true, showProof0(A, SUB, O), showProof0(B, SUB, O).
showProof0(X, SUB, O):- X = ';'(A, _), A \= true, showProof0(A, SUB, O).
showProof0(X, SUB, O):- X = ';'(_, B), B \= true, showProof0(B, SUB, O).
showProof0(X, SUB, monochrome):- X = subproof(G, true), writeNTabs(SUB), format('~w~w~n', [G, ' ⇐ true']).
showProof0(X, SUB, color):- X = subproof(G, true), writeNTabs(SUB), color(SUB, C), ansi_format([C], '~w~w~n', [G, ' ⇐ true']).
showProof0(X, SUB, lanes):- X = subproof(G, true), writeNTabs(SUB, lanes), format('~w~w~n', [G, ' ⇐ true']).

showProof(P, O):- formatOutputTerm(P, P1), nl, writeln('PROOF'), nl, showProof0(P1, 0, O).

color(0, fg(255, 196, 126)).
color(1, fg(255, 250, 127)).
color(2, fg(164, 255, 157)).
color(3, fg(152, 245, 255)).
color(4, fg(213, 172, 255)).
color(5, fg(255, 156, 153)).

color(6, fg(255, 196, 126)).
color(7, fg(255, 250, 127)).
color(8, fg(164, 255, 157)).
color(9, fg(152, 245, 255)).
color(10, fg(213, 172, 255)).
color(11, fg(255, 156, 153)).

color(12, fg(255, 196, 126)).
color(13, fg(255, 250, 127)).
color(14, fg(164, 255, 157)).
color(15, fg(152, 245, 255)).
color(16, fg(213, 172, 255)).
color(17, fg(255, 156, 153)).

color(X, fg(255, 196, 126)):- X > 17.


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% MAXVALUE

% maxValue(X, GOAL, INPUT, RESULT). 
% Find a proof for GOAL given INPUT such that the value X in GOAL is as high as possible and unify the result with RESULT.
% GOAL should be an atomic formula with constants, variables or functions as arguments,  where the argument X is a numerical variable.
% INPUT should be a list of zero or more atomic formulas.
% Note: A set of numerical constants should be defined for any variables that are exogenous in the theory or in INPUT.

% showMaxValue(RESULT, OPTION). 
% Prints the results obtained from maxValue(X, GOAL, INPUT, RESULT) to the console.
% OPTION should be one of the following: monochrome, color, lanes

% Usage examples:
% tutorialExamples.pl
% emotionExample.pl
% psychopharmacologyExample.pl
% sourceMemoryExample.pl
% substanceMisuseExample.pl


maxValue(Y, G, I, R):-
	findall(
    	Y,
      	provable0(G, I),
      	L
   ),
   max_list(L, MAXY),
   Y = MAXY,
   prove(G, I, P),
   R = [P].

showMaxValue(R, O):-
   [P] = R,
   formatOutputTerm(P, P1),
   nl, 
   writeln('MAX VALUE (PROOF)'), nl,
   showProof0(P1, 0, O), nl.


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% MINVALUE

% minValue(X, GOAL, INPUT, RESULT). 
% Find a proof for GOAL given INPUT such that the value X in GOAL is as low as possible and unify the result with RESULT.
% GOAL should be an atomic formula with constants, variables or functions as arguments, where the argument X is a numerical variable.
% INPUT should be a list of zero or more atomic formulas.
% Note: A set of numerical constants should be defined for any variables that are exogenous in the theory or in INPUT.

% showMinValue(RESULT, OPTION). Prints the results obtained from minValue(X, GOAL, INPUT, RESULT) to the console.
% OPTION should be one of the following: monochrome, color, lanes

% Usage examples:
% tutorialExamples.pl
% emotionExample.pl
% sourceMemoryExample.pl
% substanceMisuseExample.pl
% psychopharmacologyExample.pl


minValue(Y, G, I, R):-
	findall(
    	Y,
      	provable0(G, I),
      	L
   ),
   min_list(L, MINY),
   Y = MINY,
   prove(G, I, P),
   R = [P].

showMinValue(R, O):-
   [P] = R,
   formatOutputTerm(P, P1),
   nl, 
   writeln('MIN VALUE (PROOF)'), nl,
   showProof0(P1, 0, O), nl.


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% INCOHERENCE

% incoherence(GOAL1, GOAL2, INPUT, THRESHOLD, X1, X2, RESULT). 
% Check if GOAL1 and GOAL2 differ with respect to their numerical values X1 and X2, more than THRESHOLD given INPUT.  Unify the result with RESULT.
% GOAL1 and GOAL2 should be atomic formulas that each contain a numerical variable; for example X1 and X2, respectively.
% INPUT should be a list of zero or more atomic formulas.
% THRESHOLD should be a number (integer or real).
% X1 and X2 are the numerical variables in GOAL1 and GOAL2.

% showIncoherence(RESULT, OPTION). 
% Print the results obtained from incoherence(INPUT, GOAL1, GOAL2, THRESHOLD, X1, X2, RESULT) to the console.
% OPTION should be one of the following: monochrome, color, lanes

% Usage examples:
% tutorialExamples.pl
% phobiaExample.pl


incoherence(G1, G2, I, T, X1, X2, R):-
	provable0(G1, I),
	provable0(G2, I),
	{abs(X1 - X2) > T}, 
	R = [I, G1, G2, T],
	!.

showIncoherence(R, O):-
	[I, G1, G2, T] = R,
	nl,
	writeln('INCOHERENCE'), nl,
    formatOutputTerm(I, I1),
	writeln('Given inputs:'), maplist(writeln, I1), nl,
	write('These goals are incoherent at the threshold '), write(T), writeln('.'), nl,
	writeln('PROOFS'), nl,
	prove(G1, I, P1), 
	prove(G2, I, P2),
    formatOutputTerm(P1, P12),
    formatOutputTerm(P2, P22),
	showProof0(P12, 0, O),
	nl,
	showProof0(P22, 0, O),
	nl.


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% FALSIFIABILITY

% falsifiability(GOAL, INPUT, RESULT). 
% Count the number of unique predictions with respect to GOAL given INPUT and unify the result with RESULT.
% GOAL should be an atomic formula with constants, variables or functions as arguments.
% INPUT should be a list of zero or more atomic formulas.

% showFalsifiability(RESULT). Prints the results of falsifiability(GOAL, INPUT, RESULT) to the console.

% Usage examples:
% tutorialExamples.pl
% distanceExample.pl


falsifiability(G, I, R):-
	findall(G, provable0(G, I), L),
	sort(L, L0),
	length(L0, N),
	R = [G, I, N].
   
showFalsifiability(R):-
	[G, I, N] = R,
	nl,
	formatOutputTerm(G, G1),
	formatOutputTerm(I, I1),
	findall(G, provable0(G, I), L),
	formatOutputTerm(L, L1),
	writeln('FALSIFIABILITY'), nl,
	writeln('Given inputs:'), maplist(writeln, I1), nl,
	write('There are '), write(N), write(' predictions for the goal '), write(G1), write('.'), nl, nl,
	writeln('These are: '), maplist(writeln, L1), nl.


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% SUBSUMES

% subsumes(SUPERTHEORY, SUBTHEORY, GOAL, INPUT, RESULT). 
% Check if SUPERTHEORY subsumes SUBTHEORY with respect to GOAL given INPUT and unify the result with RESULT.
% GOAL should be an atomic formula with constants, variables or functions as arguments.
% SUPERTHEORY and SUBTHEORY should be atomic formulas
% INPUT should be a list of zero or more atomic formulas.
% Note: Clauses that belong to SUPERTHEORY should have SUPERTHEORY in their antecedent; clauses that belong to 
%  SUBTHEORY should have SUBTHEORY in their antecedent. INPUT should not contain SUPERTHEORY and SUBTHEORY.

% showSubsumes(RESULT). Prints the results from subsumes(SUPERTHEORY, SUBTHEORY, GOAL, INPUT, RESULT) to the console.

% Usage examples:
% tutorialExamples.pl
% distanceExample.pl


subsumes(SUPER, SUB, G, I, R):-
	append(I, [SUPER], ISUPER),
	append(I, [SUB], ISUB),
	findall(G, provable0(G, ISUPER), LSUPER),
	findall(G, provable0(G, ISUB), LSUB),
	sort(LSUPER, LSUPER1),
	sort(LSUB, LSUB1),
	subset(LSUB1, LSUPER1),
	subtract(LSUPER1, LSUB1, EXTRA),
	R = [SUPER, SUB, G, EXTRA].

showSubsumes(R):-
	[SUPER, SUB, G, EXTRA] = R,
	formatOutputTerm(G, G1),
	formatOutputTerm(EXTRA, EXTRA1),
	nl,
	writeln('SUBSUMES'), nl,
	write('Given the goal '), write(G1), write(', '), write(SUPER), write(' subsumes '), write(SUB), nl, nl,
	write('There are '), length(EXTRA1, N), write(N), write(' predictions in '), write(SUPER), write(' that are not in '), write(SUB), write(', namely:'), nl,
	maplist(writeln, EXTRA1), nl.


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% UTILITY PREDICATES

writeNTabs(N):- findall('     ', between(1, N, _), L), maplist(write, L).
writeNTabs(N, lanes):- findall('    |', between(1, N, _), L), maplist(writeLane, L).

writeLane(X):- ansi_format(fg(100, 100, 100), '~w', [X]).

formatOutputTerm(I, O):- I =.. L, maplist(parse_arg, L, L1), I2 =.. L1, copy_term_nat(I2, O), numbervars(O, 0, _).

parse_arg(I, O):- float(I), format(atom(O), '~3f', [I]).
parse_arg(I, O):- integer(I), O = I.
parse_arg(I, O):- \+number(I), \+compound(I), O = I.
parse_arg(I, O):- compound(I), I =.. L, maplist(parse_arg, L, L1), O =.. L1.