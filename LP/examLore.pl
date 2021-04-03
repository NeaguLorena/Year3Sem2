
%Se dadea o lista [a, b, a, c, d, a, b, c, a, b, d] din care trebuia sa returnez elementul cu cele mai multe aparitii.
%list_app([1,2,3,1], MaxEl).
max2(A,B,C,_,A,C):- 
    A>=B, 
   	!.
max2(_,B,_,D,B,D).

list_app(L,MaxEl):-
    remove_duplicates(L,Elems),
    find_max_app(Elems,L,_,MaxEl).

remove_duplicates([],[]).
remove_duplicates([H|T], [H|R]):-
    not(member(H,T)),
    !,
    remove_duplicates(T,R).
remove_duplicates([_|T],R):-
    remove_duplicates(T,R).

find_max_app([],_,-1,_).
find_max_app([H|T],L,Max,MaxEl):-
    find_max_app(T,L,Max1,MaxEl1),
    find_nb_appsb(L,H,N),
    max2(Max1,N,MaxEl1,H,Max,MaxEl).

find_nb_apps([],_,N,N).
find_nb_apps([E|T], E, N, Nb):-
    !,
	N1 is N+1,
	find_nb_apps(T,E,N1, Nb).
find_nb_apps([_|T],N,E, Nb):-
    find_nb_apps(T,N,E, Nb).

find_nb_appsb([],_,0).
find_nb_appsb([E|T], E, N):-
    !,
	find_nb_appsb(T,E,N1),
    N is N1+1.
find_nb_appsb([_|T],N,E):-
    find_nb_appsb(T,N,E).

%flatten deep list cu liste diferenta da numa pe depth-uri impare & doar ultimul
%L=[1,1,[2,2,2,[3,3,[4],3],2,2,[3,[4,[5,5,5]]],2]] 
flatten_deep1(L, R):-flatten(L, 1, R, []).

flatten([], _,L,L):-!.
flatten([H],D,[H|LE],LE):-
    atomic(H),
    1 is D mod 2,
    !.
flatten([H],_,LE,LE):-
    atomic(H),
    !.
flatten([H|T],D,LS,LE):-
    atomic(H),
    !,
 	flatten(T,D,LS,LE).
flatten([H|T],D,LS,LE):-
    D1 is D + 1,
	flatten(H,D1,LS,LM),
    flatten(T,D,LM,LE).

%varianta 2-vic
flatten_deep([], L,L, _):-!.
flatten_deep([H], [H|LF], LF, D):-
    atomic(H),1 is D mod 2, !.
flatten_deep([H], LF, LF, D):-
    atomic(H), 0 is D mod 2, !.
flatten_deep([H|T], LS, LF, D):-
    atomic(H), !,flatten_deep(T, LS, LF,D).
flatten_deep([H|T], LS, LF, D):-
    D1 is D + 1,
    flatten_deep(H, LS1, LF1, D1),
    flatten_deep(T, LS2, LF2, D),
    LS=LS1, LF=LF2, LF1=LS2.
    
flatten_deep(L, R):-flatten_deep(L, R, [], 1).

%heads from deep list with difference lists (+ on odd depth)
heads_deep(L, R, _ ):- heads_deep(L, R, [], 1, 1).

heads_deep([],LE,LE,_,_).
heads_deep([H|T],[H|LS],LE,1,D):-%head on odd
    atomic(H),
    1 is D mod 2,
    !,
    heads_deep(T,LS,LE,0,D).
heads_deep([H|T],LS,LE,1,D):- %head but not on odd
    atomic(H),
    !,
    heads_deep(T,LS,LE,0,D).
heads_deep([H|T],LS,LE,0,D):-
    atomic(H),
    !,
    heads_deep(T,LS,LE,0,D).
heads_deep([H|T],LS,LE,_,D):-
    D1 is D+1,
	heads_deep(H,LS,LEE,1, D1),
	heads_deep(T,LEE,LE,0, D).

%Trees
%2 Diametru la incomplete tree (sa fie eficienta implementarea)
tree1(t(6, t(4, t(2, _, _), t(5, _, _)), t(9, t(7, _, _), _))).

diameter(K, -1, 0):- var(K),!.
diameter(t(_,L,R),D,H):-
    diameter(L,DL,HL),
    diameter(R,DR,HR),
    RH is max(HL,HR),
    H is RH + 1,
    DD is HR + HL + 1,
    D1 is max(DL,DR),
    D is max(DD,D1).
            
height(nil,0).
height(t(_,nil,nil), 1).
height(t(_,L,R), H):-
    height(L,H1),
    height(R,H2),
    RH is max(H1,H2),
    H is RH + 1.
    
%3. Toate cheile care sunt root la un subtree cu nr impar de leaves (in timp liniar)

tree2(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).

collect_keys_odd_leaves1(t(_,nil,nil), E,E, 1):-!.
collect_keys_odd_leaves1(t(K,t(_,nil,nil),nil), [K|E], E, 1):-!.
collect_keys_odd_leaves1(t(K,nil,t(_,nil,nil)), [K|E], E, 1):-!.
collect_keys_odd_leaves1(t(K,L,R), [K|S], E, N):-
    collect_keys_odd_leaves1(L, S, EE, N1),
    collect_keys_odd_leaves1(R, EE, E, N2),
    N is N1 + N2,
    1 is N mod 2,
    !.
collect_keys_odd_leaves1(t(_,L,R), S, E, N):-
    collect_keys_odd_leaves1(L,S, EE, N1),
    collect_keys_odd_leaves1(R, EE, E, N2),
    N is N1 + N2.


%dfs
edge(a,b).
edge(a,c).
edge(b,c).
edge(c,d).
edge(c,e).
edge(e,f).
edge(c,f).
edge(f,a).

is_edge(X, Y):-edge(X, Y); edge(Y, X).

:-dynamic vert/1.

dfs(X):-
    edge(X,Y),
    not(vert(Y)),
    assertz(vert(Y)),
    dfs(Y).

do_dfs(X,_):- assertz(vert(X)), dfs(X).
do_dfs(_,L):- collect_all(L).

collect_all([X|L]):- 
    retract(vert(X)),
    !,
    collect_all(L).
collect_all([]).

%bfs

:-dynamic que/1.

expand(X):-
        edge(X,Y),
        not(que(Y)),
        not(vert(Y)),
        assertz(que(Y)),
        fail.
expand(X):- retract(que(X)),
            assertz(vert(X)).

bfs(L):-que(X),
        expand(X),
        bfs(L).
bfs(L):-collect_all(L).
  

do_bfs(X,L):- assertz(que(X)), bfs(L).


% Sa se returneze un ciclu simplu de cost minim dintr-un graf, pornind de la un nod 
edge_w(1, 2, 13).
edge_w(2, 3, 12).
edge_w(3, 4, 15).
edge_w(2, 5, 3).
edge_w(1, 4, 10).
edge_w(5, 1, 100).
is_edge_w(X, Y, W):-edge_w(X, Y, W); edge_w(Y, X, W).

:-dynamic best/3.
find_cycle2(X, Y, Thread, Len, Cost):-
        is_edge_w(X, Y, W),
        Len > 1, !,
        best(_, _, BCost),
        Cost1 is Cost + W,
        Cost1 < BCost,
        retract(best(_, _, _)), !,
        asserta(best([Y|Thread], Len, Cost1)),
        fail.
find_cycle2(X, Y, Thread, Len, Cost):-
        best(_, _, BCost),
        Len1 is Len + 1,
        is_edge_w(X, Z, W),
        Cost1 is Cost + W,
        Cost1 < BCost,
        not(member(Z, Thread)),
        find_cycle2(Z, Y, [Z|Thread], Len1, Cost1).

find_min_cycle(X, _, _):-
        assertz(best([], 100, 10000)),
        is_edge_w(X, Y, W),
        find_cycle2(Y, X, [Y, X], 1, W).
find_min_cycle(_, Thread, Cost):-
        retract(best(Thread,_,Cost)).

%colectarea nodurilor care au numar par de noduri interne

expand(X):-
        edge(X,Y),
        not(que(Y)),
        not(vert(Y)),
        assertz(que(Y)),
        fail.
expand(X):- retract(que(X)),
            assertz(vert(X)).

bfs(L):-que(X),%pt fiecare X iei fiecare Y din edge(Y,X) si numeri cate is
        expand(X),
        bfs(L).
bfs(L):-collect_all(L).
  

do_bfs(X,L):- assertz(que(X)), bfs(L).


