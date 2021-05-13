% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% INFO

% © Jean-Christophe Rohner 2019 - 2021
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
% ALL CLAUSES

allClauses(G, I, R):-
    findall(
        c(G, A),
        (
            clause(G, A),
            provable0(A, I)
        ),
        R
    ).

showAllClauses(R):-    
    formatOutputTerm(R, R1), 
    maplist(clauseToFolSyntax, R1, R2),
    nl, writeln('ALL CLAUSES'), nl,
    maplist(writeln, R2).


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% GENERATE RANDOM OBJECTS

generateRandomObjects(NF, NS, PN, R):- 
    randset(NS, NF, L),
    findall(
        X, 
        (
            member(X1, L), 
            atomic_list_concat([PN, '(', X1, ')'], X)
        ),
        L1
    ),
    maplist(term_string, R, L1).


% -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% SAMPLE CLAUSES

sampleClauses(G, I, N, SP, R):-
    SP = [],
    findall(
        c(G, A),
        (
            clause(G, A),
            provable0(A, I)
        ),
        L
    ),
    length(L, NT),
    randomSampleFromList(N, L, S),
    R = [NT, S].

sampleClauses(G, I, N, SP, R):-
    SP \= [],
    maplist(getGroundings(I), SP, GSP),
    getStrataDefinitions(GSP, SD),
    maplist(makeStratum(G, I), SD, STRA),
    maplist(length, STRA, NSSTRA),
    sum_list(NSSTRA, NCLA),
    maplist(randomSampleFromList(N), STRA, SSTRA),
    flatten(SSTRA, SSTRA2),
    R = [NCLA, SD, SSTRA2].

showSampleClauses(R):-    
    R = [NT, R1],
    maplist(formatOutputTerm, R1, R2),
    maplist(clauseToFolSyntax, R2, R3),
    nl, writeln('SAMPLE CLAUSES'), nl,
    write('The total number of clauses is '), write(NT), nl, nl,
    write('Simple random sample of clauses:'), nl,
    maplist(writeln, R3).

showSampleClauses(R):-
    R = [NCLA, SD, SSTRA],
    nl, writeln('SAMPLE CLAUSES'), nl,
    write('The total number of clauses is '), writeln(NCLA), nl,
    writeln('Strata definitions:'),
    maplist(writeln, SD), nl,
    maplist(formatOutputTerm, SSTRA, SSTRA1),
    maplist(clauseToFolSyntax, SSTRA1, SSTRA2),
    writeln('Stratified random sample of clauses:'),
    maplist(writeln, SSTRA2).

getGroundings(I, G, L):-
    findall(G, provable0(G, I), L).

getStrataDefinitions(GSP, SD):-
    GSP = [L],
    findall([X], member(X, L), SD).
getStrataDefinitions(GSP, SD):-
    GSP = [L1, L2],
    findall([X1, X2], (member(X1, L1), member(X2, L2)), SD).
getStrataDefinitions(GSP, SD):-
    GSP = [L1, L2, L3],
    findall([X1, X2, X3], (member(X1, L1), member(X2, L2), member(X3, L3)), SD).
getStrataDefinitions(GSP, SD):-
    GSP = [L1, L2, L3, L4],
    findall([X1, X2, X3, X4], (member(X1, L1), member(X2, L2), member(X3, L3), member(X4, L4)), SD).

makeStratum(G, I, SD, STRM):-
    SD = [STR],
    findall(c(G, A), (clause(G, A), provable0(A, I), inBody(STR, A)), STRM).
makeStratum(G, I, SD, STRM):-
    SD = [STR1, STR2],
    findall(c(G, A), (clause(G, A), provable0(A, I), inBody(STR1, A), inBody(STR2, A)), STRM).
makeStratum(G, I, SD, STRM):-
    SD = [STR1, STR2, STR3],
    findall(c(G, A), (clause(G, A), provable0(A, I), inBody(STR1, A), inBody(STR2, A), inBody(STR3, A)), STRM).
makeStratum(G, I, SD, STRM):-
    SD = [STR1, STR2, STR3, STR4],
    findall(c(G, A), (clause(G, A), provable0(A, I), inBody(STR1, A), inBody(STR2, A), inBody(STR3, A), inBody(STR4, A)),STRM).



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

inBody(X, B):- B = ','(B1, B2), (inBody(X, B1); inBody(X, B2)).
inBody(X, B):- B = ';'(B1, B2), (inBody(X, B1); inBody(X, B2)).
inBody(X, B):- X = B.
inBody(X, B):- \+(X) = B.

clauseToFolSyntax(I, O):-
    I = c(C, A),
    antecedentToFolSyntax(A, A1),
    O1 = (C ⇐ A1),
    termToString(O1, O2),
    stringReplace('∧', ' ∧ ', O2, O3),
    stringReplace('∨', ' ∨ ', O3, O4),
    stringReplace('⇐', ' ⇐ ', O4, O).

antecedentToFolSyntax(I, O):- I = ','(I1, I2), antecedentToFolSyntax(I1, O1), antecedentToFolSyntax(I2, O2), O = ∧(O1, O2).
antecedentToFolSyntax(I, O):- I = ';'(I1, I2), antecedentToFolSyntax(I1, O1), antecedentToFolSyntax(I2, O2), O = ∨(O1, O2).
antecedentToFolSyntax(I, O):- I = \+(I1), O = ¬(I1).
antecedentToFolSyntax(I, O):- I \= ','(_, _), I \= ';'(_, _), I \= \+(_), O = I.

termToString(I, O):-
    term_string(I, O, [numbervars(true)]).

stringReplace(IS, OS, I, O) :-
    atomic_list_concat(L, IS, I),
    atomic_list_concat(L, OS, O).

randomSampleFromList(N, I, O):-
    length(I, NI),
    randset(N, NI, RS),
    maplist(pickNthFromList(I), RS, O).

pickNthFromList(L, N, O):- nth1(N, L, O).