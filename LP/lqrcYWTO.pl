woman(ana). % Remember, predicate names are constant (start with lowercase letter) woman(sara).
woman(ema).
woman(maria).
woman(carmen).
woman(sara).
woman(irina).
woman(dorina).
man(andrei).
man(george).
man(alex).
man(marius).
man(mihai).
man(sergiu).
parent(marius,maria).
parent(dorina,maria).
parent(mihai,george).
parent(mihai,carmen).
parent(irina,carmen).
parent(irina,george).
parent(carmen,sara).
parent(alex,sara).
parent(carmen,ema).
parent(alex,ema).
parent(maria, ana). % maria is ana’s parent
parent(george,ana). % george also is ana’s parent
parent(maria,andrei).
parent(george,andrei).
mother(X,Y):-
    woman(X), 
    parent(X,Y). % X is Y’s mother, if X is a woman and X is the parent of Y

father(X,Y):-
    man(X), 
    parent(X,Y).

% sibling/2: X and Y are siblings if they have a common parent, and they are different
sibling(X,Y):-
    parent(Z,X), 
    parent(Z,Y), 
    X\=Y.

% sister/2: X is Y’s sister if X is a woman and X and Y are siblings
sister(X,Y):-
    sibling(X,Y),
    woman(X).
% aunt/2: X is Y’s aunt if she is the sister of Z, who is a parent for Y.
aunt(X,Y):-
    sister(X,Z),
    parent(Z,Y).

brother(X,Y):-
    sibling(X,Y),
    man(X).

uncle(X,Y):-
   	brother(X,Z),
    parent(Z,Y).

grandmother(X,Y):-
    woman(X),
    mother(X,Z),
    mother(Z,Y).

grandfather(X,Y):-
    man(X),
    father(X,Z),
    father(Z,Y).

ancestor(X,Y):-
    parent(X,Y),
    ancestor(X,Y).
    