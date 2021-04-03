edge(a, b).
edge(b, a).
edge(b, c).
edge(c, b).

is_edge(X,Y):-
    edge(X,Y),
    edge(Y,X).
neighbor(a, [b, d]). % an example graph – 1 s t connected component of the
neighbor(b, [a, c, d]). % example graph
neighbor(c, [b, d]).

neighb_to_edge:-
    neighbor(Node,List),
    process(Node,List),
    fail.
neighb_to_edge.

process(Node, [H|T]):- 
    assertz(edge(Node, H)),
    process(Node, T).
process(_, []).

%The graph is initially stored in the predicate database. 
%Predicate neighb_to_edge reads one clause of predicate neighbor at a time,
% and processes the information in each clause separately; 
% process traverses the neighbor list of the current node, and asserts a 
% new fact for predicate edge for each new neighbor of the current node.

path(X, Y, Path):-
    path(X, Y, [X], Path).
path(X, Y, PPath, FPath):-
    is_edge(X,Z),
    \+(member(Z, PPath)),
    path(Z, Y, [Z|PPath], FPath).
path(X, X, PPath, PPath).
%forward recursion for finding a path(or more alternatives if repeated) from X to Y

%predicate which searches for a restricted path between two nodes in a graph, 
%i.e. the path must pass through certain nodes, in a certain order , and
%nodes are specified in a list.
%
%restricted_path(Source,Target,RestrictionsList,Path) 
%%check_restrictions(RestrictionsList,Path)
restricted_path(X, Y, LR, P):- 
    path(X, Y, P),
    check_restrictions(LR, P).

%when ! is removed from first clause then the path result is showed twice
%the path is actually reversed than irl because the edges are added in front as they are met
check_restrictions([], _):-!.
check_restrictions([H|T], [H|R]):-
    !, check_restrictions(T, R).
check_restrictions(T, [_|L]):-
    check_restrictions(T, L).

%optimal_path(Source,Target,Path)
:- dynamic sol_part/2.

optimal_path(X, Y, _):-
    asserta(sol_part([], 100)),
    path2(X, Y, [X], 1).
optimal_path(_, _, Path):-
    retract(sol_part(Path, _)).

%The predicate path/4 generates, via backtracking, all paths which are
% better than the current partial solution, and updates the current partial 
% solution whenever a shorter path is found. Once a better solution than the 
% current optimal solution is found, the predicate replaces the old optimal 
% in the predicate base (clause 1) and then continues the search, by launching
% the backtracking mechanism (using fail).
path1(X, X, Path, LPath):-
    retract(sol_part(_, _)),!,
    asserta(sol_part(Path, LPath)),
    fail.
path1(X, Y, PPath, LPath):-
    is_edge(X, Z),
    \+(member(Z, PPath)),
    LPath1 is LPath + 1,
    sol_part(_, Lopt),
    LPath1 < Lopt,
    path1(Z, Y, [Z|PPath], LPath1).

%hamilton(NbNodes, Source, Path)
hamilton(NN, X, Path):-
    NN1 is NN - 1,
    hamilton_path(NN1, X, X, [X], Path).
%searches for a closed path from X of length NN1 = nb nodes-1
hamilton_path(NN1, X, X, [X], Path):-
    hamilton_path(NN1, 0, X, X, [X], Path).
hamilton_path(NN, K, X, Y, PPath, FPath):-
    is_edge(X, Z),
    \+(member(Z, PPath)),
    KK is K + 1,
    hamilton_path(NN, KK, Z, Y, [Z|PPath], FPath).
hamilton_path(NN, K, X, Y, L, [Y|L]):-
    is_edge(X, Y),
    K is NN.

%Quiz exercises
%1. perform the conversion between the edge-clause representation to neighbor 
% list-list representation

edge_cl_to_neighbors_list_list(R):-
    edge_cl_to_neighbors_list_list([], [], R),
    !.
edge_cl_to_neighbors_list_list(V, Acc, R):-
    is_edge(X, _),
    \+(X = nil),
    \+(member(X, V)),
    findall(Y, is_edge(X, Y), N),
    edge_cl_to_neighbors_list_list([X|V], [n(X, N)|Acc], R).
edge_cl_to_neighbors_list_list(_, R, R).

%2.
edge(a, b, 1).
edge(b, a, 2).
edge(b, c, 3).
edge(c, b, 4).

is_w_edge(X,Y,W):-
    edge(X,Y,W),
    edge(Y,X,W).

:- dynamic sol_part_weight/2.
optimal_path_weight(X, Y, _):-
    asserta(sol_part_weight([], 100)),
    path_weight(X, Y, [X], 0).
optimal_path_weight(_, _, Path):-
    retract(sol_part_weight(Path, _)).
%compute optimal path by computing the path with minimum edge weight cost
path_weight(X, X, PPath, W):-
    retract(sol_part_weight(_, _)),
    !,
    asserta(sol_part_weight(PPath, W)),
    fail.
path_weight(X, Y, PPath, Weight):-
    is_w_edge(X,Z, W),
    \+(member(Z, PPath)),
    W1 is W + Weight,
    sol_part_weight(_, MIN),
    W1 < MIN,
    path_weight(Z, Y, [Z|PPath], W1).

%Problems
%1. find a closed path (cycle) P starting at a given node A in the graph G.
cycle(X, Path):-
    cycle(X, X, [X], Path).
cycle(X, Y, PPath, FPath):-
    is_edge(X, Z),
    \+(member(Z, PPath)),
    cycle(Z, Y, [Z|PPath], FPath).
cycle(X, Y, L, [Y|L]):-
    is_edge(X, Y).


