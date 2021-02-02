/* NOTES---------------------------------------------------------------------------------------------------------------------------------------------

A theory about the neuropharmacology of psychosis closely modeled after Stahl (2018). The effects of different drugs
can be explored by having model(drugModel) in INPUT. Stahl (2018) integrates three theories of psychosis: The dopamine
theory, the serotonin theory and the glutamate theory; these are integrated in the example below. Agonism is represented 
as positive relation between probabilities; antagonism is represented as a negative relation between
probabilities.

SOURCES
Stahl, S. M. (2018). Beyond the dopamine hypothesis of schizophrenia to three neural networks of psychosis: dopamine, serotonin, 
  and glutamate. CNS spectrums, 23(3), 187-191.

NOTE: This is a hypothetical example and not an empirically validated theory.

© Jean-Christophe Rohner 2020


*/% SETUP--------------------------------------------------------------------------------------------------------------------------------------------

:-include('theoryToolbox2.pl').


% THEORY---------------------------------------------------------------------------------------------------------------------------------------------

% INPUT
% model(M)
% M = endogenousModel ∨ drugModel


% MAIN CLAUSES

% Endogenous model

disorder(psychosis, X1) ⇐ behavior(auditoryHallucinations, X2) ∧ behavior(paranoidDelusions, X3) ∧ {X1 = X2 * X3}.
disorder(psychosis, X1) ⇐ behavior(visualHallucinations, X2) ∧ behavior(paranoidDelusions, X3) ∧ {X1 = X2 * X3}.

behavior(auditoryHallucinations, X1) ⇐ action(d2Receptor, ventralStriatum, X2) ∧ {X1 = 1 * X2}.
behavior(paranoidDelusions, X1) ⇐ action(d2Receptor, ventralStriatum, X2) ∧ {X1 = 1 * X2}.
behavior(visualHallucinations, X1) ⇐ action(glutamate, visualCortex, X2) ∧ {X1 = 1 * X2}.

action(d2Receptor, ventralStriatum, X1) ⇐ action(glutamate, vta, X2) ∧ {X1 = 1 * X2}.
action(glutamate, vta, X1) ⇐ action(nmdaReceptor, prefrontalCortex, X2) ∧ {X1 = 1 - X2}.
action(glutamate, vta, X1) ⇐ action(fiveHt2aReceptor, cerebralCortex, X2) ∧ {X1 = 1 * X2}.
action(glutamate, visualCortex, X1) ⇐ action(fiveHt2aReceptor, cerebralCortex, X2) ∧ {X1 = 1 * X2}.
action(nmdaReceptor, prefrontalCortex, X) ⇐ model(endogenousModel) ∧ (X = 0.1 ∨ X = 0.9).
action(fiveHt2aReceptor, cerebralCortex, X) ⇐ model(endogenousModel) ∧ (X = 0.1 ∨ X = 0.9).


 % Drug model

action(d2Receptor, ventralStriatum, X1) ⇐ drugAction(cocaine, X2) ∧ {X1 = 1 * X2}. 
action(d2Receptor, ventralStriatum, X1) ⇐ drugAction(amphetamine, X2) ∧ {X1 = 1 * X2}.
action(d2Receptor, ventralStriatum, X1) ⇐ drugAction(chlorpromazine, X2) ∧ {X1 = 1 - X2}.
action(nmdaReceptor, prefrontalCortex, X1) ⇐ drugAction(pcp, X2) ∧ {X1 = 1 - X2}.
action(nmdaReceptor, prefrontalCortex, X1) ⇐ drugAction(ketamine, X2) ∧ {X1 = 1 - X2}.
action(fiveHt2aReceptor, cerebralCortex, X1) ⇐ drugAction(lsd, X2) ∧ {X1 = 1 * X2}.
action(fiveHt2aReceptor, cerebralCortex, X1) ⇐ drugAction(psilocybin, X2) ∧ {X1 = 1 * X2}.
action(fiveHt2aReceptor, cerebralCortex, X1) ⇐ drugAction(primavanserin, X2) ∧ {X1 = 1 - X2}.
action(fiveHt2aReceptor, cerebralCortex, X1) ⇐ drugAction(clozapine, X2) ∧ {X1 = 1 - X2}.

drugAction(_, X) ⇐ model(drugModel) ∧ (X = 0.1 ∨ X = 0.9).


% EXAMPLE QUERIES------------------------------------------------------------------------------------------------------------------------------------

q1 ⇐    GOAL = disorder(psychosis, X)
    ∧ INPUT = [
        model(endogenousModel)
    ]
    ∧ maxValue(X, GOAL, INPUT, RESULT)
    ∧ showMaxValue(RESULT, color).

q2 ⇐    GOAL = disorder(psychosis, X)
    ∧ INPUT = [
        model(endogenousModel)
    ]
    ∧ minValue(X, GOAL, INPUT, RESULT)
    ∧ showMinValue(RESULT, color).

q3 ⇐    GOAL = behavior(paranoidDelusions, X)
    ∧ INPUT = [
        model(drugModel)
    ]
    ∧ maxValue(X, GOAL, INPUT, RESULT)
    ∧ showMaxValue(RESULT, color).

q4 ⇐    GOAL = behavior(visualHallucinations, X)
    ∧ INPUT = [
        model(drugModel)
    ]
    ∧ maxValue(X, GOAL, INPUT, RESULT)
    ∧ showMaxValue(RESULT, color).
 
q5 ⇐    GOAL = action(d2Receptor, _, X)
    ∧ INPUT = [
        model(endogenousModel)
    ]
    ∧ maxValue(X, GOAL, INPUT, RESULT)
    ∧ showMaxValue(RESULT, color).