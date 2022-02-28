% NOTES----------------------------------------------------------------------------------------------------------------------------------------------

% Combining probability equations(PR), Constraint Logic Programming (CLP), and meta-interpreters (MI) is a powerful techique for theory representation 
% and inference. By using PR-CLP-MI it is possible to distinguish between a scenario in which a program entails that P is false, from a scenario 
% in which a program does not entail P. In traditional Prolog, instead, "false" is coupled with "not entailed" (the closed world assumption). 
% PR-CLP-MI also allows bidirectional reasoning: From premises to conclusion, and from conclusion to premises. That is, we can ask 
% "Given premises P, is conclusion C true (or false)?", as well as "Given conclusion P, are premises P true (or false)?". The examples below 
% illustrate the use of PR-CLP-MI. Theory Toolbox 2 implements the MI part and the CLPR module represents the CLP part (loaded by theoryToolbox2.pl).

% © Jean-Christophe Rohner 2022

% SETUP----------------------------------------------------------------------------------------------------------------------------------------------

:- include('theoryToolbox2.pl').
:- style_check(-singleton).
:- style_check(-discontiguous).

% HELLO WORLD EXAMPLE -------------------------------------------------------------------------------------------------------------------------------

% The equations relate the probabilities of being human, an animal or a thing to various properties. In q1 note that we obtain a probability value
% for each category (human, animal and thing) even if the truth or falsity of some premises is unknown (e.g. whether a cactus breathes).
% A probability of 0 in a conclusion (e.g. that a cactus is human) represents false, which the program can entails. The query q2 represents a 
% scenario in which a program entails that some of the probabilities of belonging to a category are unknown.

human(E, X1) ⇐ moves(E, X2) ∧ breathes(E, X3) ∧ speaks(E, X4) ∧ {X1 = X2 * X3 * X4}.
animal(E, X1) ⇐ moves(E, X2) ∧ breathes(E, X3) ∧ speaks(E, X4) ∧ {X1 = X2 * X3 * (1 - X4)}.
thing(E, X1) ⇐ human(E, X2) ∧ animal(E, X3) ∧ {X1 = (1 - X2) * (1 - X3)}.

q1 ⇐    GOAL = (human(E, X1), animal(E, X2), thing(E, X3)),
    INPUT = [moves(cactus, 0), breathes(cactus, X3), speaks(cactus, X4)],
    prove(GOAL, INPUT, RESULT),
    showProof(RESULT, color).

q2 ⇐    GOAL = (human(E, X1), animal(E, X2), thing(E, X3)),
    INPUT = [moves(mushroom, X4), breathes(mushroom, X5), speaks(mushroom, 0)],
    prove(GOAL, INPUT, RESULT),
    showProof(RESULT, color).

% PSYCHIATRIC DIAGNOSIS EXAMPLE ----------------------------------------------------------------------------------------------------------------------

% These clauses capture the essence of the main anxiety disorders according to the DSM5. In the query q3 note that the conclusion (in GOAL) states that 
% h has one anxiety disorder but we dont know which (the assumption is that disorders are mutually exclusive). Even if information about a lot of 
% symptoms is missing (INPUT only defines some of the symptom probabilities) the program can still arrive at a correct diagnosis.

% American Psychiatric Association (2013). Diagnostic and statistical manual of mental disorders (DSM-5®). American Psychiatric Publishers.

event(H, has, specificPhobia, X0) ⇐
    event(H, fears, object, X1)
    ∧ event(H, avoids, object, X2)
    ∧ event(object, hasProperty, dangerous, X3)
    ∧ event(H, hasProperty, functionalImpairment, X4)
    ∧ event(event(H, encounters, object, 1), causes, event(H, experiences, anxiety, 1), X5)
    ∧ {X0 = X1 * X2 * (1 - X3) * X4 * X5}.

event(H, has, socialAnxietyDisorder, X0) ⇐
    event(H, fears, socialSituations, X1)
    ∧ event(H, avoids, socialSituations, X2)
    ∧ event(socialSituations, hasProperty, dangerous, X3)
    ∧ event(H, hasProperty, functionalImpairment, X4)
    ∧ event(event(H, encounters, socialSituations, 1), causes, event(H, experiences, anxiety, 1), X5)
    ∧ {X0 = X1 * X2 * (1 - X3) * X4 * X5}.

event(H, has, agoraphobia, X0) ⇐
    event(H, fears, publicPlaces, X1)
    ∧ event(H, avoids, publicPlaces, X2)
    ∧ event(publicPlaces, hasProperty, dangerous, X3)
    ∧ event(H, hasProperty, functionalImpairment, X4)
    ∧ event(event(H, encounters, publicPlaces, 1), causes, event(H, experiences, anxiety, 1), X5)
    ∧ {X0 = X1 * X2 * (1 - X3) * X4 * X5}.

event(H, has, generalizedAnxietyDisorder, X0) ⇐
    event(H, fears, variousSituations, X1),
    event(H, worriesAbout, variousSituations, X2),
    event(H, controls, event(H, worriesAbout, variousSituations, 1), X3),
    event(variousSituations, hasProperty, dangerous, X4),
    event(H, experiences, persistentArousal, X5),
    event(H, hasProperty, functionalImpairment, X6),
    {X0 = X1 * X2 * (1 - X3) * (1 - X4) * X5 * X6}.

event(H, has, panicDisorder, X0) ⇐
    event(H, experiences, panicAttacks, X1),
    event(H, fears, panicAttacks, X2),
    event(panicAttacks, hasProperty, dangerous, X3),
    event(H, hasProperty, functionalImpairment, X4),
    {X0 = X1 * X2 * (1 - X3) * X4}.

event(H, fears, T, X).
event(H, avoids, T, X).
event(T, hasProperty, dangerous, X).
event(H, hasProperty, functionalImpairment, X).
event(event(H, encounters, T, 1), causes, event(H, experiences, anxiety, 1), X).
event(H, worriesAbout, variousSituations, X).
event(H, controls, event(H, worriesAbout, variousSituations, 1), X).
event(H, experiences, persistentArousal, X).
event(H, experiences, panicAttacks, X).

q3 ⇐
    GOAL = (
        event(H, has, specificPhobia, X1),
        event(H, has, agoraphobia, X2),
        event(H, has, socialAnxietyDisorder, X3),
        event(H, has, generalizedAnxietyDisorder, X4),
        event(H, has, panicDisorder, X5),
        {X1 + X2 + X3 + X4 + X5 = 1}
    )
    ∧ INPUT = [
        event(h, fears, S, 1),
        event(h, avoids, S, 0), 
        event(H, experiences, persistentArousal, 0)
    ]
    ∧ prove(GOAL, INPUT, RESULT)
    ∧ showProof(RESULT, color).

% CAUSAL REASONING EXAMPLE ---------------------------------------------------------------------------------------------------------------------------

% A causal relation between A and B can be inferred if A and B covary, if A precedes B and if there is no variable that is a confounder with respect 
% to A. Query q4 represents a scenario in which biological sex and personality covary; the question is which causal model that correctly explains
% this covariation (in general, covariance between A and B can occur because A causes B, because B causes A or because Z causes both A and B, a 
% so called spurious relation). Note that the program can infer the correct conclusion even if several pieces of information are missing.

causes(A, B, X1) ⇐ inferCovary(A, B, X2) ∧ inferPrecedes(A, B, X3) ∧ confounded(A, X4) ∧ {X1 = X2 * X3 * (1 - X4)}.

inferCovary(A, B, X) ⇐ covary(A, B, X).
inferCovary(A, B, X) ⇐ covary(B, A, X).

inferPrecedes(A, B, X) ⇐ precedes(A, B, X).
inferPrecedes(A, B, X1) ⇐ precedes(B, A, X2) ∧ {X1 = 1 - X2}.

q4 ⇐ GOAL = (
        causes(biologicalSex, personality, X1),
        causes(personality, biologicalSex, X2),
        causes(Z, biologicalSex, X3),
        causes(Z, personality, X4),
        var(Z),
        {X1 + X2 + X3 * X4 = 1}
    ),
    INPUT = [
        covary(biologicalSex, personality, 1),
        precedes(_, biologicalSex, 0),
        covary(Z, biologicalSex, _),
        covary(Z, personality, _),
        precedes(_, personality, _),
        confounded(_, _)
    ],
    prove(GOAL, INPUT, RESULT),
    showProof(RESULT, color).
