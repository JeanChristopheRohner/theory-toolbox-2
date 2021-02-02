:-include('theoryToolbox2.pl').


% ---------------------------------------------------------------------------------------------------------------------
% TUTORIAL EXAMPLES

% This file contains basic examples that show what each predicate in Theory Toolbox does.

% NOTE: These are hypothetical examples and not empirically validated theories.

% © Jean-Christophe Rohner 2020


% ---------------------------------------------------------------------------------------------------------------------
% PROVABLE

% Example 1

aunt(A, C) ⇐ sister(M, A) ∧ parent(M, C).

q1 ⇐    GOAL = aunt(_, _)    
    ∧ INPUT = [
        sister(marge, patty),
        sister(marge, selma),
        parent(marge, bart),
        parent(marge, lisa)
    ]
    ∧ provable(GOAL, INPUT, RESULT)
    ∧ showProvable(RESULT).


% Example 2

p(animal(A), X1) ⇐ p(breathes(A), X2) ∧ {X1 = 0.99 * X2}.

q2 ⇐    GOAL = p(animal(_), _)
    ∧ INPUT = [
        p(breathes(monkey), 0.99),
        p(breathes(rock), 0.01)
    ]
    ∧ provable(GOAL, INPUT, RESULT)
    ∧ showProvable(RESULT).


% ---------------------------------------------------------------------------------------------------------------------
% PROVE

% Example 3

man(X) ⇐ male(X) ∧ adult(X).
bachelor(X) ⇐ man(X) ∧ unmarried(X).

q3 ⇐    GOAL = bachelor(_)
    ∧ INPUT = [
        male(kirk),
        adult(kirk),
        unmarried(kirk),
        male(bart),
        unmarried(bart)
    ]
    ∧ prove(GOAL, INPUT, RESULT)
    ∧ showProof(RESULT, color).


% ---------------------------------------------------------------------------------------------------------------------
% MAX AND MIN VALUE

% Example 4

income(C, X) ⇐ company(C) ∧ (X = 0 ∨ X = 5 ∨ X = 10).
salaries(C, X) ⇐ company(C) ∧ (X = 0 ∨ X = 5 ∨ X = 10).
rawMaterials(C, X) ⇐ company(C) ∧ (X = 0 ∨ X = 5 ∨ X = 10).

profit(C, X1) ⇐ company(C) ∧ income(C, X2) ∧ expenses(C, X3) ∧ {X1 = X2 - X3}.
expenses(C, X1) ⇐ company(C) ∧ salaries(C, X2) ∧ rawMaterials(C, X3) ∧ {X1 = X2 + X3}.

q41 ⇐    GOAL = profit(_, X)
    ∧ INPUT = [
        company(acmeINC)
    ]
    ∧ maxValue(X, GOAL, INPUT, RESULT)
    ∧ showMaxValue(RESULT, lanes).

q42 ⇐    GOAL = profit(_, X)
    ∧ INPUT = [
        company(acmeINC)
    ]
    ∧ minValue(X, GOAL, INPUT, RESULT)
    ∧ showMinValue(RESULT, monochrome).


% ---------------------------------------------------------------------------------------------------------------------
% INCOHERENCE

% Example 5

likes(P1, P2, X1) ⇐ friends(P1, P2, X2) ∧ meet(P1, P2, X3) ∧ {X1 = X2 * X3}.
likes(P1, P2, X1) ⇐ friends(P1, P2, X2) ∧ {X1 = X2}.

q5 ⇐    GOAL1 = likes(A, B, X1)
    ∧ GOAL2 = likes(A, B, X2)
    ∧ INPUT = [
        friends(john, mark, 0.8),
        meet(john, mark, 0.8),
        friends(john, mary, 0.8)
    ]
    ∧ THRESHOLD = 0.1
    ∧ incoherence(GOAL1, GOAL2, INPUT, THRESHOLD, X1, X2, RESULT)
    ∧ showIncoherence(RESULT, color).


% ---------------------------------------------------------------------------------------------------------------------
% FALSIFIABILITY

% Example 6

parent(P, C) ⇐ source(subTheoryA) ∧ mother(P, C).
parent(P, C) ⇐ source(subTheoryB) ∧ (mother(P, C) ∨ father(P, C)).

q61 ⇐    GOAL = parent(_, _)
    ∧ INPUT = [
        source(subTheoryA),
        mother(marge, lisa),
        mother(marge, maggie),
        father(homer, lisa),
        father(homer, maggie)
    ]
    ∧ falsifiability(GOAL, INPUT, RESULT)
    ∧ showFalsifiability(RESULT).

q62 ⇐    GOAL = parent(_, _)
    ∧ INPUT = [
        source(subTheoryB),
        mother(marge, lisa),
        mother(marge, maggie),
        father(homer, lisa),
        father(homer, maggie)
    ]
    ∧ falsifiability(GOAL, INPUT, RESULT)
    ∧ showFalsifiability(RESULT).


% ---------------------------------------------------------------------------------------------------------------------
% SUBSUMES

% Example 7

anchestor(A, C) ⇐ source(theoryA) ∧ parent(A, C).
anchestor(A, C) ⇐ source(theoryB) ∧ parent(A, C).
anchestor(A, C) ⇐ source(theoryB) ∧ parent(A, P) ∧ parent(P, C).

q7 ⇐    GOAL = anchestor(_, _)
    ∧ INPUT = [
        parent(orville, abe),
        parent(abe, homer),
        parent(homer, bart)
    ]
    ∧ SUPERTHEORY = source(theoryB)
    ∧ SUBTHEORY = source(theoryA)
    ∧ subsumes(SUPERTHEORY, SUBTHEORY, GOAL, INPUT, RESULT)
    ∧ showSubsumes(RESULT).