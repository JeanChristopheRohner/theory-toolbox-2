﻿% NOTES----------------------------------------------------------------------------------------------------------------------------------------------

% Combining probability equations (PR), Constraint Logic Programming (CLP), and meta-interpreters (MI) is a powerful techique for theory/knowledge 
% representation and inference. Besides having the expressive power of Prolog, PR-CLP-MI also allows one to:

% (1) Distinguish between a scenario in which a program entails that C is false, from a scenario in which a program does not entail C. 
% In traditional Prolog, instead, "false" is coupled with "not entailed" (the closed world assumption). 

% (2) Do bidirectional reasoning: From premises to conclusion, and from conclusion to premises. That is, we can ask "Given premises P1, P2, ..., Pn, 
% is conclusion C true (or false)?", as well as in some cases "Given conclusion C, are premises P1, P2, ..., Pn true (or false)?".

% (3) Reason using unknown information. In some scenarios we may know whether premises P1, P2, ..., Pn are true or false, but not know
% whether premises Q1, Q2, ..., Qn are true or false. Sometimes we can still infer whether a conclusion that involves the Ps and Qs is true or false.

% The examples below illustrate the use of PR-CLP-MI. Theory Toolbox 2 implements the MI part and the CLPR module 
% implements the CLP part (loaded by theoryToolbox2.pl).

% © Jean-Christophe Rohner 2022


% SETUP----------------------------------------------------------------------------------------------------------------------------------------------

:- include('theoryToolbox2.pl').
:- style_check(-singleton).
:- style_check(-discontiguous).


% HELLO WORLD EXAMPLE -------------------------------------------------------------------------------------------------------------------------------

% Different animal groups have or do not have certain properties. The probability of belonging to either one of the 6 groups is 1 
% (as defined in itsa/0). Query q1 shows that it is possible to infer that i is an amphibian even if several several probabilities are 
% unknown (the Xs).

isa(E, mammal, X1) ⇐ property(E, warmBlooded, X2) ∧ property(E, hair, X3) ∧ property(E, milk, X4) ∧ property(E, backbone, X5) ∧ {X1 = X2 * X3 * X4 * X5}.
isa(E, bird, X1) ⇐ property(E, warmBlooded, X2) ∧ property(E, feathers, X3) ∧ property(E, backbone, X4) ∧ {X1 = X2 * X3 * X4}.
isa(E, reptile, X1) ⇐ property(E, warmBlooded, X2) ∧ property(E, scales, X3) ∧ property(E, backbone, X4) ∧ {X1 = (1 - X2) * X3 * X4}.
isa(E, amphibian, X1) ⇐ property(E, warmBlooded, X2) ∧ property(E, scales, X3) ∧ property(E, backbone, X4) ∧ {X1 = (1 - X2) * (1 - X3) * X4}.
isa(E, invertebrate, X1) ⇐ property(E, backbone, X2) ∧ {X1 = 1 - X2}.
isa(E, fish, X1) ⇐ property(E, warmBlooded, X2) ∧ property(E, backbone, X3) ∧ property(E, gills, X4) ∧ {X1 = (1 - X2) * X3 * X4}.

itsa ⇐ 
    isa(I, mammal, X2)
    ∧ isa(I, bird, X3)
    ∧ isa(I, reptile, X4)
    ∧ isa(I, amphibian, X5)
    ∧ isa(I, invertebrate, X6)
    ∧ isa(I, fish, X7)
    ∧ {X2 + X3 + X4 + X5 + X6 + X7 = 1}.

q1 ⇐ 
    GOAL = itsa,
    INPUT = [
        property(i, warmBlooded, 0),
        property(i, hair, X),
        property(i, milk, X),
        property(i, backbone, 1),
        property(i, feathers, X),
        property(i, scales, 0),
        property(i, gills, 0)
    ],
    prove(GOAL, INPUT, RESULT), 
    showProof(RESULT, color).


% PSYCHIATRIC DIAGNOSIS EXAMPLE ----------------------------------------------------------------------------------------------------------------------

% These clauses capture the essence of the main anxiety disorders according to the DSM5. In query q3 note that the conclusion (in GOAL) states that 
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
    event(H, fears, variousSituations, X1)
    ∧ event(H, worriesAbout, variousSituations, X2)
    ∧ event(H, controls, event(H, worriesAbout, variousSituations, 1), X3)
    ∧ event(variousSituations, hasProperty, dangerous, X4)
    ∧ event(H, experiences, persistentArousal, X5)
    ∧ event(H, hasProperty, functionalImpairment, X6)
    ∧ {X0 = X1 * X2 * (1 - X3) * (1 - X4) * X5 * X6}.

event(H, has, panicDisorder, X0) ⇐
    event(H, experiences, panicAttacks, X1)
    ∧ event(H, fears, panicAttacks, X2)
    ∧ event(panicAttacks, hasProperty, dangerous, X3)
    ∧ event(H, hasProperty, functionalImpairment, X4)
    ∧ {X0 = X1 * X2 * (1 - X3) * X4}.

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
