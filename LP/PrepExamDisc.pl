
% From a Binary Tree, collect in an ordered list using append (efficiently) the nodes from the tree which are roots of BST. (nu trebuie sa fie liniar).

% collect_bst_roots(Tree, List, Min, Max, Flag)

collect_bst_roots(T, R):-collect_bst_roots(T, L, _, _, _), sort(L, R).

tree2(t(1,t(3,nil,t(4,nil,nil)), t(6, t(10,nil,nil), t(7,nil,nil)))).

collect_bst_roots(nil, [], 1000, -1000, 1).
collect_bst_roots(t(K, nil, nil), [K], K, K, 1):-!.
collect_bst_roots(t(K, L, R), List, LMin, RMax, F):-collect_bst_roots(L, LList, LMin, LMax, LF), 
            collect_bst_roots(R, RList, RMin, RMax, RF),
            set_flag(K, LMax, RMin, LF, RF, F),
            append_if_nec(F, LList, K, RList, List).


set_flag(K, LMax, RMin, 1, 1, 1):-K > LMax, K < RMin, !.
set_flag(_, _, _, _, _, 0).

append_if_nec(1, LList, K, RList, List):-append(LList, [K|RList], List).
append_if_nec(0, LList, _, RList, List):-append(LList, RList, List).


% DFS implementation with vertex coloration (White = unvisited, Grey = currently visiting, Black = visited).

edge(1, 2).
edge(2, 3).
edge(3, 4).
edge(2, 5).

is_edge(X, Y):-edge(X, Y); edge(Y, X).

:-dynamic white/1.
:-dynamic black/1.
:-dynamic grey/1.

:-dynamic vert/1.

list_colors:-writeln("******************"), listing(white(_)), listing(grey(_)), listing(black(_)).

dfs(_, _):-is_edge(X, _),
    not(white(X)),
    assertz(white(X)),
    fail.
dfs(X, _):-retract(white(X)),
        assertz(grey(X)),
        assertz(vert(X)),
        df_search(X).
dfs(_, L):-findall(X, vert(X), L), list_colors, retractall(vert(_)), retractall(white(_)), retractall(grey(_)), retractall(black(_)).

df_search(X):-
        list_colors,
        is_edge(X, Y),
        retract(white(Y)),
        assertz(grey(Y)),
        assertz(vert(Y)),
        df_search(Y).
df_search(X):-
        list_colors,
        retract(grey(X)),
        assertz(black(X)),
        fail.


% Delete only the first singleton element from a list

delete_first_singleton(L, R):-get_dups(L, D), delete_not_dup(L, D, R).

get_dups([H|T], [H|R]):-member(H, T), get_dups(T, R), not(member(H, R)), !.
get_dups([_|T], R):-get_dups(T, R).
get_dups([], []).

delete_not_dup([H|T], D, [H|R]):-member(H, D), !, delete_not_dup(T, D, R).
delete_not_dup([_|T], _, T).


% Consider a binary tree having operators (addition, subtraction, multiplication and division) as non-terminal nodes and operands as leaves. Define a predicate that computes the value of such a tree, applying each operator to its two operands (the value of the left subtree of the operator and the value of the right subtree of the operator). For example, the object tree(+ , tree(7 , null , null) , tree(* , tree(4 , null , null) , tree(3 , null , null))) would be equivalent with the expression 7+4*3. Computing the value of the tree must end up with 19:

tree1(tree(+ , tree(7 , null , null) , tree(* , tree(4 , null , null) , tree(3 , null , null)))).


compute_from_tree(tree(K, null, null), K).
compute_from_tree(tree(K, L, R), Res):-
        compute_from_tree(L, LRes),
        compute_from_tree(R, RRes),
        F=..[K, LRes, RRes],
        Res is F.


converting(Expression , tree(K, L, R)):-
        Expression=..[K, LExpr, RExpr],
        !,
        converting(LExpr, L),
        converting(RExpr, R).
converting(Expression, tree(Expression, null, null)).