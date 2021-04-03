% Lista ordonata a cheilor nodurilor care au subtrees PBT

collect_pbt_roots_sorted(T, R):-collect_pbt_roots(T, L, _), qsort(L, R).

collect_pbt_roots(t(K, nil, nil), [K], 1):-!.
collect_pbt_roots(t(K, L, nil), List, 0):-!, collect_pbt_roots(L, LList, _), append(LList, [K], List).
collect_pbt_roots(t(K, nil, R), [K|RList], 0):-!, collect_pbt_roots(R, RList, _).
collect_pbt_roots(t(K, L, R), List, F):-collect_pbt_roots(L, LList, LF), collect_pbt_roots(R, RList, RF), manage_flags(LF, RF, LList, K, RList, List, F).

manage_flags(1,1,LList, K, RList, List, 1):-!, append(LList, [K|RList], List).
manage_flags(_, _, LList, _, RList, List, 0):-append(LList, RList, List).


tree1(t(6, t(4, t(2, _, _), t(5, _, _)), t(9, t(7, _, _), _))).
tree2(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).

edge(a,c).
edge(b,c).
edge(c,d).
edge(c,e).
edge(e,f).
edge(c,f).
edge(f,a).

is_edge(X, Y):-edge(X, Y); edge(Y, X).

:-dynamic vert/1.


collect_all([X|L]):- 
    retract(vert(X)),
    !,
    collect_all(L).
collect_all([]).

%1.
%Given an incomplete deep list (list of lists of any depth, incomplete at all levels), write the Prolog predicate(s) to generate the (complete) list of heads.
%Ex: [1,2,[3,[4,5|_],6,[7|_],8,9|_]|_] generates [1,3,4,7]

%use difference lists for efficiency instead of using append
heads_deep(L, R, _):- 
	heads_deep(L, R, []).

heads_deep(L,LE,LE):- %stopping condition is free variable
	var(L),
    !.
heads_deep([H|T],[H|LS],LE):-%head, add it to the result
    atomic(H),
    !,
    heads_deep(T,LS,LE).
heads_deep([H|T],LS,LE):-%h is atomic element but not head
    atomic(H),
    !,
    heads_deep(T,LS,LE).
heads_deep([H|T],LS,LE):-% non atomic h must go recursively on H and T 
	heads_deep(H,LS,LEE),
	heads_deep(T,LEE,LE).

%2.
%Number of roots with diameter given Diam
%tree1(t(6, t(4, t(2, _, _), t(5, _, _)), t(9, t(7, _, _), _))).

a=2, b=2,c=0 => O(n)
diameter(K, -1, 0, Cnt, Diam):- var(K),!. %stopping condition for incomplete  treestructure
%diameter is max height on left + right +1
diameter(t(_,L,R),D,H,Cnt, Diam):-
    diameter(L,DL,HL,Cnt1, Diam),
    diameter(R,DR,HR,Cnt2, Diam),
    RH is max(HL,HR),
    H is RH + 1,
    DD is HR + HL + 1,
    D1 is max(DL,DR),
    D is max(DD,D1),
    D = Diam,
    !
    Cnt is Cnt1 + Cnt2 + 1.
diameter(t(_,L,R),D,H, Cnt, Diam):-
    diameter(L,DL,HL, Cnt1, Diam),
    diameter(R,DR,HR, Cnt2, Diam),
    RH is max(HL,HR),
    H is RH + 1,
    DD is HR + HL + 1,
    D1 is max(DL,DR),
    D is max(DD,D1),
    Cnt is Cnt1 + Cnt2.



diameter(K, -1, 0):- var(K),!.
diameter(t(_,L,R),D,H):-
    diameter(L,DL,HL),
    diameter(R,DR,HR),
    RH is max(HL,HR),
    H is RH + 1,
    DD is HR + HL + 1,
    D1 is max(DL,DR),
    D is max(DD,D1).

%continents(country_name,continent)

%can use failure driven to get all possible continents and for each continent collect the countries that match that continent
collect_all([country|L]):- 
    retract(countries(country,continent)),
    !,
    collect_all(L).
collect_all([]).

findall(X):-
	continent(X),
	!,
	fail.


% Lista ordonata a cheilor nodurilor care au subtrees PBT
tree1(t(6, t(4, t(2, _, _), t(5, _, _)), t(9, t(7, _, _), t(10, _, _)))).
tree2(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).

%would use difference lists for a better performance
%if the tree is binary then take nodes that are pbt in preorder traversal
%here not so optimal(not linear time) as i covered case for any tree and sort the keys after
%without the sort in this version, time with difference lists would be O(n) but with apppend complexity increases as in order to insert an element at end we go through all elements
generate_pbt_roots_sorted(T, R):-
	generate_pbt_roots(T, L, _), 
	sort(L, R).
generate_pbt_roots(t(K, L, R), [K], 1):- 
	nonvar(K),var(L),var(R),!.
generate_pbt_roots(t(K, L, R), List, 0):-
	var(R),!, 
	generate_pbt_roots(L, LList, _),
	append(LList, [K], List).
generate_pbt_roots(t(K, L, R), [K|RList], 0):-
	var(L),!, 
	generate_pbt_roots(R, RList, _).
generate_pbt_roots(t(K, L, R), List, F):-
	generate_pbt_roots(L, LList, LF), 
	generate_pbt_roots(R, RList, RF), 
	manage_case(LF, RF, LList, K, RList, List, F).

manage_case(1,1,LList, K, RList, List, 1):-
	!, 
	append(LList, [K|RList], List).
manage_case(_, _, LList, _, RList, List, 0):-
	append(LList, RList, List).

%An efficient solution to identify an odd length cycle in an undirected graph would be to start generating the cylcles present in the graph, compute it's length and stop at first odd length found.
%by stopping at the first we cut the complexity of computing all solutions, and stop at the first solution
%find a cycle in a graph from a given vertex

find_cycle(X,[X|Cycle]):-
			edge(X,Z),
			path(Z,X,Cycle),
			length(Cycle, L),
			L>=3.


