:- dynamic new_edge/2.

invert_edges:-
    edge(A,B),
    not(new_edge(B,A)),
    asserta(new_edge(B,A)),
    fail.

invert_edges.

collect_edges(List, Rez):-
    retract(new_edge(A,B)),!,
    collect_edges([new_edge(A,B)|List],Rez).

collect_edges(L,L).

invert_graph(Rez) :- invert_edges,collect_edges([],Rez).


/*
:-dynamic col/2.

bipartiteWrap:-edge(X, _), assertz(col(X, 0)), bipartite. 

bipartite() :- col(X, _), bfsFrom(X), !, fail.
bipartite().

bfsFrom(X):-col(X, C), compl(C, C1), assignNeigh(X, C1).

assignNeigh(X, C):-edge(X, Y), assign(Y, C), !, retractAll.


assign(X, C) :- col(X, C), !, fail.
assign(X, _) :- col(X, _), !.
assign(X, C) :- assertz(col(X, C)), fail.

compl(1, 0).
compl(0, 1).

retractAll():-retract(col(_, _)), fail.
retractAll().
*/

:-dynamic col/2.
    
edge(1, 2).
edge(1, 4).
edge(2, 4).

bip(L1, L2):-
      retractall(col(_,_)),
      edge(U, V),
      assertz(col(U, white)),
      assertz(col(V, black)),
      do_bfs(L1, L2).

do_bfs(L1, L2):-
    bfs, !, 
    findall(X, col(X, white), L1),
    findall(Y, col(Y, black), L2).
do_bfs:-write('not bipartite').

bfs:-col(U, C),
     edge(U, V),
     not(checkColour(V, C)), !,
     fail.
bfs.

checkColour(X, C):-col(X, C), !, fail. %not right colour
checkColour(X, _):-col(X, _), !. %right colour, has it assigned
checkColour(X, C):-neg(C, C1), assertz(col(X, C1)).

neg(white, black).
neg(black, white).		

%4 split graph which is a convex polygon into triangles
get_triangles(L, []):-length(L, L1), L1<3,!, fail.
get_triangles([X,Y,Z], [[X,Y,Z]]).
get_triangles(L, Rez):-
                    append(A, [X,Z|B], L),
                    append(A, [Z|B], NewL),
                    last(A, Y),
                    get_triangles(NewL, R),
                    append(R, [[Y,X,Z]], Rez).
/*
find_decompositions([A, B], _) :- !, fail.
find_decompositions([A], _) :- !, fail.
find_decompositions([], _) :- !, fail.
find_decompositions([A,B,C], [[A,B,C]]).
find_decompositions(L, Rez) :-
    append(L1, L2, L),
    find_decompositions(L1, RecursiveResult1),
    find_decompositions(L2, RecursiveResult2),
    append(RecursiveResult1, RecursiveResult2, Rez).

wrapper(L) :- find_decompositions(L, Rez), assert(result(Rez)), fail.
wrapper.
*/


