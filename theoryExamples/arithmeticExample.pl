/* NOTES----------------------------------------------------------------------------------------------------------------------------------------------

A hypothetical theory about the relation between basic arithmetic ability, language ability and spatial ability.
It illustrates how a (preliminary) theory can be used as a guide for conducting empirical studies that are representative with respect to a theory. No 
constraints are imposed yet on the quantities X1, X2 and X3 because their functional relation should be estimated inductively
from an empirical study (in which X1, X2 and X3 are measured). I.e. after data is available for X1, X2 and X3, an algorithm such as logistic regression
could be used to find an equation that replaces f(X1, X2, X3).

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2021


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT

% range(L, H)
% human(P)
% event(P, has, languageAbility, time, _)
% event(P, has, spatialAbility, time, _)

% P is a constant
% {L ∈ ℤ, H ∈ ℤ, L < H}


% BACKGROUND CLAUSES

problemType(multiplication).
problemType(addition).
problemType(subtraction).
problemType(division).

num(N) ⇐ range(L, H) ∧ between(L, H, N).

f(_, _, _).


% MAIN CLAUSES

event(H, represent, relation(N1 * N2, equals, R), time, X1) ⇐
    human(H)
    ∧ num(N1)
    ∧ num(N2)
    ∧ R is N1 * N2
    ∧ problemType(multiplication)
    ∧ event(H, has, languageAbility, time, X2)
    ∧ event(H, has, spatialAbility, time, X3)
    ∧ f(X1, X2, X3).

event(H, represent, relation(N1 / N2, equals, R), time, X1) ⇐
    human(H)
    ∧ num(N1)
    ∧ num(N2)
    ∧ R is round(N1 / N2)
    ∧ problemType(division)
    ∧ event(H, has, languageAbility, time, X2)
    ∧ event(H, has, spatialAbility, time, X3)
    ∧ f(X1, X2, X3).

event(H, represent, relation(N1 + N2, equals, R), time, X1) ⇐
    human(H)
    ∧ num(N1)
    ∧ num(N2)
    ∧ R is N1 + N2
    ∧ problemType(addition)
    ∧ event(H, has, languageAbility, time, X2)
    ∧ event(H, has, spatialAbility, time, X3)
    ∧ f(X1, X2, X3).

event(H, represent, relation(N1 - N2, equals, R), time, X1) ⇐
    human(H)
    ∧ num(N1)
    ∧ num(N2)
    ∧ R is N1 - N2
    ∧ problemType(subtraction)
    ∧ event(H, has, languageAbility, time, X2)
    ∧ event(H, has, spatialAbility, time, X3)
    ∧ f(X1, X2, X3).


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐    GOAL = event(_, represent, _, time, _)
    ∧ generateRandomObjects(1000000, 16, human, HUMANS)
    ∧ INPUT1 = [
       range(1, 10),
       event(_, has, languageAbility, time, _),
       event(_, has, spatialAbility, time, _)
    ]
    ∧ append(HUMANS, INPUT1, INPUT2)
    ∧ N = 6
    ∧ STRATIFY = [human(_), problemType(_)]
    ∧ sampleClauses(GOAL, INPUT2, N, STRATIFY, RESULT)
    ∧ showSampleClauses(RESULT).