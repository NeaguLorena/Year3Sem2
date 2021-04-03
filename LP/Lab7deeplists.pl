%L1 = [1,2,3,[4]].
% L2 = [[1],[2],[3],[4,5]]
% L4 = [[[[1]]],1, [1]].
% L5 = [1,[2],[[3]],[[[4]]],[5,[6,[7,[8,[9],10],11],12],13]].
%a. ? - member( 2 ,L5). => false
%b. ? – member( [2] , L5). => true
%c. ? – member(X, L5). => all 
%d. ? – append(L1,R,L2). => false
%e. ? – append(L4,L5,R). => R = [[[[1]]], 1, [1], 1, [2], [[3]], [[[4]]], [5, [6, [7, [8, [9], 10], 11], 12], 13]].
%f. ? – delete(L4, 1, R). => R = [[[[1]]], [1]]
%g. ? – delete(13,L5,R). => L5 = R


%a. ? – atomic(apple). => true
%b. ? – atomic(4). => true
%c. ? – atomic(X). => false
%d. ? – atomic( apple(2)). => false
%e. ? – atomic( [1,2,3]). => false
%f. ? – atomic( []). => true

%Depth computation
%1. We arrived at the empty list. The depth is 1.
%2. We have an atomic head, we ignore it, since it doesn’t influence the depth.
%The depth of the list will be equal to the depth of the tail.
%c. We have a list in the head of the deep list. In this case the depth of the list will be either the depth of the tail, or the depth of the head increased by one
depth([],1).
depth([H|T],R):-
    atomic(H),
	!,
	depth(T,R).
depth([H|T],R):- 
    depth(H,R1), 
    depth(T,R2), 
    R3 is R1+1,
    R is max(R3,R2).

flatten([],[]).
flatten([H|T], [H|R]) :- 
    atomic(H),
    !,
    flatten(T,R).
flatten([H|T], R) :-
    flatten(H,R1),
    flatten(T,R2),
    append(R1,R2,R).

%Returns all atomic elements which are at the head of a shallow list
heads3([],[],_).
heads3([H|T],[H|R],1):-
    atomic(H),
    !,
   	heads3(T,R,0).
heads3([H|T],R,0):-
    atomic(H),
    !,
    heads3(T,R,0).
heads3([H|T],R,_):-
    heads3(H,R1,1),
    heads3(T,R2,0),
    append(R1,R2,R).
heads_pretty(L,R) :-
    heads3(L, R,1).

%considers as member all elements appearing in the list,
%atomic or complex structure at any level
member1(H,[H|_]).
    member1(X,[H|_]):-
    member1(X,H).
    member1(X,[_|T]):-
    member1(X,T).

%function to find only atomic elements
member2(X,L):-
    flatten(L,L1),
    member(X,L1).

%Quiz exercises
%1. Predicate computes the number of atomic elements in a deep list
nb_elems_atomic([],C,C).
nb_elems_atomic([H|T],C,C1):-
    atomic(H),
    !,
    C2 is C+1,
    nb_elems_atomic(T,C2,C1).
nb_elems_atomic([_|T],C,C1):-
    nb_elems_atomic(T,C,C1).
nb_elems_atomic_pretty(L,C1):-
    nb_elems_atomic(L,0,C1).

%2. Predicate computes the sum of atomic elements from a deep list
%if atom is "apple" ?
sum_elems_atomic([],S,S).
sum_elems_atomic([H|T],S,S1):-
    atomic(H),
    !,
    S2 is H+S,
    sum_elems_atomic(T,S2,S1).
sum_elems_atomic([_|T],S,S1):-
    sum_elems_atomic(T,S,S1).
sum_elems_atomic_pretty(L,S1):-
    sum_elems_atomic(L,0,S1).

%3. Deterministic version of the member predicate
%determinstic – if one predicate in a test fails then the test should fail without further backtracking.
member_det(X, [X|_]):-
    !.
member_det(X, [_|Xs]):-
    member_det(X, Xs).

%Problems
%1. Predicate returns the atomic elements from a deep lists, which are at the end of a shallow list 

getLastAtomic([], []).
getLastAtomic([H, H2|T], R):-
    atomic(H), !, 
    getLastAtomic([H2|T], R).
getLastAtomic([H|T], [H|R]):-
    atomic(H), !, 
    getLastAtomic(T,R).
getLastAtomic([H|T], R):-
    getLastAtomic(H, R1),
    getLastAtomic(T, R2),
    append(R1, R2, R).

%2.Predicate for replacing an element/list/deep list in a deep list with another expression

replaceWithExpression(H, N, [H|T], [N|R]):-
    !, replaceWithExpression(H, N, T, R).
replaceWithExpression(_, _, [], []).
replaceWithExpression(X, N, [H|T], [H|R]):-
    atomic(H), !,
    replaceWithExpression(X, N, T, R).
replaceWithExpression(X, N, [H|T], R):-
    replaceWithExpression(X, N, H, H1),
    replaceWithExpression(X, N, T, T1),
    append(H1, T1, R).

%3.Predicate for ordering the elements of a deep list by depth;
%when 2 sublists have the same depth, order them in lexicographic order, after the order of elements
lexicographic([H|T1], [H|T2]):-
    lexicographic(T1, T2).
lexicographic([H1|_], [H2|_]):-
    H1<H2.
lexicographic(X, Y):-
    atomic(X),
    atomic(Y),
    X<Y.

orderByDepth([H|T], R):-
    partition(H, T, Sm, Lg),
    orderByDepth(Sm, SmS),
    orderByDepth(Lg, LgS),
    append(SmS, [H|LgS], R).
orderByDepth([], []).

partition(H, [X|T], [X|Sm], Lg):-
    depth(X, D1), 
    depth(H, D2),
    D1<D2,
    !,
    partition(H, T, Sm, Lg).
partition(H, [X|T], Sm, [X|Lg]):-
    depth(X, D1),
    depth(H, D2),
    D2>D1, 
    !, 
    partition(H, T, Sm, Lg).
partition(H, [X|T], [X|Sm], Lg):-
    lexicographic(X,H), 
    !, 
    partition(H, T, Sm, Lg).
partition(H, [X|T], Sm, [X|Lg]):-
    partition(H, T, Sm, Lg).
partition(_, [], [], []).
