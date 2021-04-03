% Delete all duplicates

delete_all_duplicates(L, R):-find_duplicates(L, Dups), remove_all(L, Dups, R).

find_duplicates([H|T], [H|R]):-find_duplicates(T, R), not(member(H,R)), member(H, T), !.
find_duplicates([_|T], R):-find_duplicates(T, R).
find_duplicates([],[]).

remove_all([H|T], L, R):-remove_all(T, L, R), member(H, L), !.
remove_all([H|T], L, [H|R]):-remove_all(T, L, R).
remove_all([], _, []).

% Diametru la incomplete tree (sa fie eficienta implementarea)
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(10, nil, nil)))).

max2(A, B, A):-A>=B, !.
max2(_, B, B).

diam_incomplete_tree(T, -1, 0):-var(T), !.
diam_incomplete_tree(t(_, L, R), D, H):-
        diam_incomplete_tree(L, DL, HL),
        diam_incomplete_tree(R, DR, HR),
        max2(HL, HR, Haux),
        H is Haux + 1,
        DK is HL - 1 + HR - 1 + 2,
        max2(DR, DL, Daux),
        max2(Daux, DK, D).


% Toate cheile care sunt root la un subtree cu nr impar de leaves (in timp liniar)

tree1(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).

collect_keys_odd_leaves(t(_, nil, nil), End, End, 1):-!.
collect_keys_odd_leaves(t(K, t(_, nil, nil), nil), [K|End], End, 1):-!.
collect_keys_odd_leaves(t(K, nil, t(_, nil, nil)), [K|End], End, 1):-!.
%collect_keys_odd_leaves(t(_, t(_, nil, nil), t(_, nil, nil)), End, End, 2):-!.
collect_keys_odd_leaves(t(K, L, R), Start, End, Leaves):-
        collect_keys_odd_leaves(L, Start, LEnd, LeavesL), 
        collect_keys_odd_leaves(R, RStart, End, LeavesR), 
        Leaves is LeavesL + LeavesR, 
        1 is Leaves mod 2, !, 
        LEnd = [K|RStart].
collect_keys_odd_leaves(t(_, L, R), Start, End, Leaves):-
        collect_keys_odd_leaves(L, Start, Int, LeavesL), 
        collect_keys_odd_leaves(R, Int, End, LeavesR), 
        Leaves is LeavesL + LeavesR.


% Diferenta dintre 2 grafuri aka acele muchii din G1 care nu sunt in G2

edge1(1, 2).
edge1(2, 3).
edge1(2, 4).

edge2(1, 2).

:-dynamic new_edge1/2.
graph_difference:-edge1(X, Y),
        not(edge2(X,Y)),
        assertz(new_edge1(X,Y)),
        fail.
graph_difference:-listing(new_edge1(_,_)), retractall(new_edge1(_,_)).


% avand un graf colorat sa construiesc graful din care sa elimin nodurile de anumite culori si muchiile aferente

color(1, b).
color(2, r).
color(3, g).
color(4, g).
color(5, g).

edge(1, 2).
edge(2, 3).
edge(3, 4).
edge(2, 5).
edge(1, 4).
edge(5, 1).
edge(3, 1).

:-dynamic new_color/2.
:-dynamic new_edge/2.
delete_by_color(L):-color(X, C),
        not(member(C, L)),
        assertz(new_color(X, C)),
        fail.
delete_by_color(_):-edge(X, Y),
        new_color(X, _),
        new_color(Y, _),
        assertz(new_edge(X, Y)),
        fail.
delete_by_color(_):-listing(new_color(_,_)), listing(new_edge(_,_)), retractall(new_color(_, _)), retractall(new_edge(_, _)).


% construct bst from preorder

bst_from_preorder([H|T], t(H, L, R)):-split(H, T, A, B), bst_from_preorder(A, L), bst_from_preorder(B, R).
bst_from_preorder([],nil).

split(X, [H|T], [H|A], B):-X > H, split(X, T, A, B), !.
split(_, B, [], B).


% sa generez arbore dfs al parcurgerii pe graf

is_edge(X, Y):-edge(X, Y); edge(Y, X).

:-dynamic vert/1.
:-dynamic parent/2.

dfs_to_tree(X, _):-df_search(X).
dfs_to_tree(_, _):-vert(X), findall(Y, parent(X, Y), L), assertz(children(X, L)), fail.
dfs_to_tree(X, T):-children(X, List), build_tree_from_lists_of_children(X, List, T), !,
        retractall(vert(_)), retractall(parent(_,_)), retractall(children(_,_)).

df_search(X):-
        assertz(vert(X)),
        is_edge(X, Y),
        not(vert(Y)),
        assertz(parent(X, Y)),
        df_search(Y),
        fail.

build_tree_from_lists_of_children(Root, [H|T], t(Root, [Taux|Children])):-build_tree_from_lists_of_children(Root, T, t(Root, Children)), children(H, HL), build_tree_from_lists_of_children(H, HL, Taux).
build_tree_from_lists_of_children(Root, [], t(Root, [])).

%  sa generezi ca structura de date arborele de bfs la un Graf neorientat

bf_search:- q(X), !, expand(X), bf_search.

expand(X):-is_edge(X,Y),
        \+(vert(Y)),
        asserta(vert(Y)),
        assertz(q(Y)),
        assertz(parent(X,Y)),
        fail.
expand(X):-retract(q(X)), !.

bfs_to_tree(X, _):-assertz(q(X)), asserta(vert(X)), bf_search.
bfs_to_tree(_, _):-vert(X), findall(Y, parent(X, Y), L), assertz(children(X, L)), fail.
bfs_to_tree(X, T):-children(X, List), build_tree_from_lists_of_children(X, List, T), !,
        retractall(vert(_)), retractall(parent(_,_)), retractall(children(_,_)).



% dfs

df_search(X, _):-dfs(X).
df_search(_, L):-collect_v(L).

dfs(X):-
        assertz(vert(X)),
        is_edge(X, Y),
        not(vert(Y)),
        dfs(Y).
        %fail.

collect_v([X|L]):-retract(vert(X)), !, collect_v(L).
collect_v([]).

% bfs

bf_search(X, L):-assertz(q(X)), assertz(vert(X)), bfs(L).

bfs(L):-q(X), !, expand1(X), bfs(L).
bfs(L):-collect_v(L).

expand1(X):-is_edge(X, Y),
        not(vert(Y)),
        assertz(vert(Y)),
        assertz(q(Y)),
        fail.
expand1(X):-retract(q(X)), !.


% Sa generezi eficient lista ordonata cu cheile nodurilor care sunt root de BST

tree3(t(1,t(3,t(2,nil,nil),t(4,nil,nil)), t(6, t(10,nil,nil), t(7,nil,nil)))).

collect_bst_roots(T, L):-collect_bst_roots(T, Start, [], _, _, _), qsort(Start, L).

collect_bst_roots(t(K,nil,nil), [K|End], End, 1, K, K).

collect_bst_roots(t(K, nil, R), Start, End, F, Max, K):-!, collect_bst_roots(R, RStart, End, F1, Max, Min), find_flag(K, nil, Min, 1, F1, F), add_or_not(F, RStart, K, Start).
%collect_bst_roots(t(K, nil, t(KR, L, R)), Start, End, 0):- collect_bst_roots(t(KR, L, R), Start, End, F), (KR < K; F is 0).

collect_bst_roots(t(K, L, nil), Start, End, F, K, Min):-!, collect_bst_roots(L, Start, REnd, F1, Max, Min), find_flag(K, Max, nil, F1, 1, F), add_or_not(F, REnd, K, End).
%collect_bst_roots(t(K, t(KL, L, R), nil), Start, End, 0):- collect_bst_roots(t(KR, L, R), Start, End, F), (KL > K; F is 0).

collect_bst_roots(t(K, L, R), Start, End, F, RMax, LMin):-collect_bst_roots(L, Start, LEnd, F1, LMax, LMin), collect_bst_roots(R, RStart, End, F2, RMax, RMin), find_flag(K, LMax, RMin, F1, F2, F), add_or_not(F, RStart, K, LEnd).

find_flag(K, KL, nil, 1, 1, 1):-KL < K, !.
find_flag(K, nil, KR, 1, 1, 1):-K < KR, !.
find_flag(K, KL, KR, 1, 1, 1):-K < KR, KL < K, !.
find_flag(_, _, _, _, _, 0).

add_or_not(1, Init, K, [K|Init]):-!.
add_or_not(0, Init, _, Init).

qsort([H|T], R):-pivot(H, T, Smalls, Bigs),
                qsort(Smalls, S),
                qsort(Bigs, B),
                append(S, [H|B], R).
qsort([],[]).

pivot(X, [H|T], [H|Smalls], Bigs):-H < X, !, pivot(X, T, Smalls, Bigs).
pivot(X, [H|T], Smalls, [H|Bigs]):- pivot(X, T, Smalls, Bigs).
pivot(_, [], [], []).


% topological sort on graph. Say if it's possible

find_cycle(X, X, _, [X]).
find_cycle(Y, X, Trace, [Y|Path]):-edge(Y, Z),
            (not(member(Z, Trace)); Z = X),
            find_cycle(Z, X, [Z|Trace], Path).

cycle(X, Path):-edge(X, Y), find_cycle(Y, X, [Y,X], Path).
cycle(_, []).

can_sort_topologically:-is_edge(X, _), cycle(X, Path), length(Path, L), L > 2, !, fail.
can_sort_topologically.


% sort topologically

edge3(5, 0).
edge3(5, 2).
edge3(2, 3).
edge3(3, 1).
edge3(4, 0).
edge3(4, 1).

vertex(0).
vertex(1).
vertex(2).
vertex(3).
vertex(4).
vertex(5).

:-dynamic stack/1.
:-dynamic vis/1.

top_sort(X):-assertz(vis(X)),
        edge3(X, Y),
        not(vis(Y)),
        top_sort(Y),
        fail.
top_sort(X):-asserta(stack(X)).

sort_topologically(_):-vertex(X),
        not(stack(X)),
        top_sort(X),
        fail.
sort_topologically(L):-collect_stack(L), !.

collect_stack([X|T]):-retract(stack(X)), collect_stack(T).
collect_stack([]).


% Bfs with coloring (white , grey, black ca la AF)

:-dynamic white/1.
:-dynamic black/1.
:-dynamic grey/1.

list_colors:- writeln("********************"), listing(white(_)),  listing(grey(_)),  listing(black(_)).

bfs2:-list_colors, grey(X), !, expand2(X), bfs2.
bfs2.

breadth_first_w_coloring(_):-is_edge(X,_),
        not(white(X)),
        assertz(white(X)),
        fail.
breadth_first_w_coloring(X):-list_colors, assertz(grey(X)), retract(white(X)), bfs2, retractall(black(_)).

expand2(X):-retract(grey(X)), assertz(black(X)), fail.
expand2(X):-is_edge(X, Y),
        white(Y),
        assertz(grey(Y)),
        retract(white(Y)),
        fail.
expand2(_).


% list of (ordered sublists of keys at a certain depth) in BST, the list of sublists is ordered by depth, the sublist is ordered by key.

tree4(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).

append_depth_lists([H1|T1], [H2|T2], [H|T]):-append_depth_lists(T1, T2, T), append(H1, H2, H).
append_depth_lists([], L, L).
append_depth_lists(L, [], L).

depth_lists_from_bst(t(K, L, R), [[K]|List]):-depth_lists_from_bst(L, LList), depth_lists_from_bst(R, RList), append_depth_lists(LList, RList, List).
depth_lists_from_bst(nil, []).


% Highest sum on a branch from a ternary tree.

ternaryTree(t(6, t(4, t(2, nil, nil,nil), t(7, nil, nil, nil ), nil), t(5, nil, nil,nil ), t(9, t(3, nil,nil,nil),nil,nil))). 

highest_sum_ternary_tree_branch(t(K, L, M, R), S):-
        highest_sum_ternary_tree_branch(L, SL),
        highest_sum_ternary_tree_branch(M, SM),
        highest_sum_ternary_tree_branch(R, SR),
        max2(SL, SM, Saux),
        max2(Saux, SR, Saux2),
        S is Saux2 + K.
highest_sum_ternary_tree_branch(nil, 0).

% Colect the keys from the smallest branch of a tree

tree5(t(6, t(4, t(2,nil,nil), nil), t(9, nil, nil))).

collect_smallest_branch(t(K, nil, nil), [K], 1):-!.
collect_smallest_branch(t(K, L, nil), [K|Res], D):-!, collect_smallest_branch(L, Res, D1), D is D1 + 1.
collect_smallest_branch(t(K, nil, R), [K|Res], D):-!, collect_smallest_branch(R, Res, D1), D is D1 + 1.
collect_smallest_branch(t(K, L, R), [K|Res], D):-collect_smallest_branch(L, Res1, D1), collect_smallest_branch(R, Res2, D2), assign_list_and_depth(D1, D2, Res1, Res2, Daux, Res), D is Daux + 1.

assign_list_and_depth(D1, D2, Res1, _, D1, Res1):- D1 < D2, !.
assign_list_and_depth(_, D2, _, Res2, D2, Res2).

% Delete only the first occurence of the first duplicate from a list (sa dea fail daca mai incearca).

delete_first_dup([H|T], T):-member(H, T), !.
delete_first_dup([H|T], [H|R]):-delete_first_dup(T, R).
delete_first_dup([], []).

% Given a graph (nu specifica cum), build the list of edges for which at least one of the endpoints has the degree equal to a given value.

:-dynamic good_nodes/1.
:-dynamic good_edges/2.
collect_edges_with_given_degree(_,_):-retractall(good_nodes(_)), retractall(good_edges(_,_)),fail.
collect_edges_with_given_degree(K,_):-is_edge(X, _), findall(Y, is_edge(X, Y), L), length(L, K), assertz(good_nodes(X)), fail.
collect_edges_with_given_degree(_,_):-good_nodes(X), is_edge(X, Y), not(good_edges(X, Y); good_edges(Y, X)), assertz(good_edges(X,Y)), fail.
collect_edges_with_given_degree(_,L):-findall(edge(X, Y), ((good_edges(X, Y); good_edges(Y, X)), edge(X, Y)), L).

% DFS implementation with vertex coloration (White = unvisited, Grey = currently visiting, Black = visited).

df_search_w_coloring(_):-is_edge(X,_),
        not(white(X)),
        assertz(white(X)),
        fail.
df_search_w_coloring(X):-dfs1(X).
df_search_w_coloring(_):-retractall(white(_)), retractall(black(_)), retractall(grey(_)).

dfs1(X):-
        list_colors,
        assertz(grey(X)),
        retract(white(X)),
        is_edge(X, Y),
        white(Y),
        dfs1(Y),
        fail.
dfs1(X):-retract(grey(X)),
        assertz(black(X)),
        list_colors,
        fail.

% DFS on a graph + vertex augmentation to store the parent

dfs_w_parent_augmentation(X, _):-dfs2(X, nil).
dfs_w_parent_augmentation(_, L):-collect_v_w_parents(L), !.

:-dynamic vert_w_parent/2.
dfs2(X, Par):-
        assertz(vert_w_parent(X, Par)),
        is_edge(X, Y),
        not(vert_w_parent(Y, _)),
        dfs2(Y, X),
        fail.

collect_v_w_parents([(X,Y)|R]):-retract(vert_w_parent(X, Y)), collect_v_w_parents(R).
collect_v_w_parents([]).

% Se da o lista incompleta, ordonata, de BSTs.
% a) sa se caute doar prima apariție a unui nod intr-un arbore
% b) sa se genereze lista ordonata formata din cheile tuturor arborilor din lista

% Sa se returneze un ciclu simplu de cost minim dintr-un graf, pornind de la un nod s.

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
        retract(best(_, _, _)), !,
        Cost1 is Cost + W,
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


% Lista ordonata a cheilor nodurilor care au subtrees PBT

collect_pbt_roots_sorted(T, R):-collect_pbt_roots(T, L, _), qsort(L, R).

collect_pbt_roots(t(K, nil, nil), [K], 1):-!.
collect_pbt_roots(t(K, L, nil), List, 0):-!, collect_pbt_roots(L, LList, _), append(LList, [K], List).
collect_pbt_roots(t(K, nil, R), [K|RList], 0):-!, collect_pbt_roots(R, RList, _).
collect_pbt_roots(t(K, L, R), List, F):-collect_pbt_roots(L, LList, LF), collect_pbt_roots(R, RList, RF), manage_flags(LF, RF, LList, K, RList, List, F).

manage_flags(1,1,LList, K, RList, List, 1):-!, append(LList, [K|RList], List).
manage_flags(_, _, LList, _, RList, List, 0):-append(LList, RList, List).

% Aveam un graf si trebuia sa aplic dfs ca sa gasesc back edge-urile, pe care le inseram intr-o noua baza de date.

:-dynamic backedge/2.

dfs_collect_backedges(X):-dfs3(X).
dfs_collect_backedges(_):-list_colors, retractall(black(_)), retractall(grey(_)), listing(backedge(_,_)), retractall(backedge(_, _)).

dfs3(X):-
        assertz(grey(X)),
        edge(X, Y),
        check_backedge(X, Y),
        not(grey(Y)), not(black(Y)),
        dfs3(Y).
dfs3(X):-retract(grey(X)),
        assertz(black(X)),
        fail.

check_backedge(X, Y):-grey(Y), assertz(backedge(X, Y)).
check_backedge(_, _).

% Lista cu nodurile ordonate care au ca subtree un AVL tree, eficient, folosind append (O(nlogn)) - era un inorder, prorietatea trebuia demonstrata recursiv, si pentru eficienta se facea tot ce e in afara apelurilor recursive intr-un predicat separat, si se apela doar o data, ca la seminar.

tree6(t(6, t(4, t(2, nil, t(3, nil, nil)), t(5, nil, nil)), t(9, nil, nil))).

abs(X, -X):-X<0,!.
abs(X, X).

collect_avl_trees(nil, [], 0, 1).
collect_avl_trees(t(K, L, R), Lst, H, F):-collect_avl_trees(L, LLst, HL, F1), collect_avl_trees(R, RLst, HR, F2), check_avl(HL, HR, F1, F2, LLst, K, RLst, Lst, F), max2(HL, HR, Haux), H is Haux + 1.

check_avl(HL, HR, 1, 1, LList, K, RList, Lst, 1):-Dif is HL - HR, abs(Dif, Abs), Abs < 2, !, append(LList, [K|RList], Lst).
check_avl(_, _, _, _, LList, _, RList, Lst, 0):-append(LList, RList, Lst).

% Se da un un graf conex care reprezeinta un poligon convex impartit in triunghiuri adiacente, sa se demonstreze ca orice edge din graf apartine unui triunghi (se face pe scheletul de verify() de la ultimul seminar, iei nondeterministic un edge si gasesti in alt predicat nodul din graf care e conectat cu ambele capete ale edege-ului)

% verify():-
%        is_edge(X,Y),
%        some_other_instantiation(X,Y,Z),…,
%        not(check_passes(X,Y,Z)),!,
%        do_some_side_effects(Z),
%        fail.
% verify().

edge_poly(a, b).
edge_poly(b, c).
edge_poly(c ,d).
edge_poly(d, a).
edge_poly(a, c).

is_edge_poly(X, Y):-edge_poly(X, Y); edge_poly(Y, X).

check_triangles:-
        is_edge_poly(X, Y),
        not(get_other_vertex(X, Y)),!,
        fail.
check_triangles.

get_other_vertex(X, Y):-is_edge_poly(X, Z), is_edge_poly(Y, Z).

% Sa verifici daca intr-un graf ponderat, pentru un nod x, exista un drum simplu spre orice alt nod y, astfel incat suma ponderilor din drum sa fie mai mare decat un numar dat k.

find_path_w_weight(_, K, Path, Path, Cost):-
                Cost > K.
find_path_w_weight(X, K, Path, P, Cost):-
        is_edge_w(X, Y, W),
        not(member(Y, Path)),
        Cost1 is Cost + W,
        find_path_w_weight(Y, K, [Y|Path], P, Cost1).

find_path_w_weight(X, K, Path):-find_path_w_weight(X, K, [X], P, 0), reverse(P, Path).

% Sa se returneze nodurile dintr-un BST incomplet care sunt rădăcini ale unui subtree care are un număr par de noduri cu un copil.

tree7(t(6,t(4,t(2,_,t(3,_,_)), _), t(9, t(7, _, t(8, _, _)), _))).

collect_roots_of_subtrees_w_even_one_childed(t(_, L, R), [], 0):-var(L), var(R), !.
collect_roots_of_subtrees_w_even_one_childed(t(K, L, R), List, N):-var(R), !, collect_roots_of_subtrees_w_even_one_childed(L, LList, NL), N is NL + 1, handle_append(N, LList, K, [], List).
collect_roots_of_subtrees_w_even_one_childed(t(K, L, R), List, N):-var(L), !, collect_roots_of_subtrees_w_even_one_childed(R, RList, NR), N is NR + 1, handle_append(N, [], K, RList, List).
collect_roots_of_subtrees_w_even_one_childed(t(K, L, R), List, N):-collect_roots_of_subtrees_w_even_one_childed(L, LList, NL), collect_roots_of_subtrees_w_even_one_childed(R, RList, NR), N is NL + NR, handle_append(N, LList, K, RList, List).

handle_append(N, LList, K, RList, List):-0 is N mod 2, !, append(LList, [K|RList], List).
handle_append(_, LList, _, RList, List):-append(LList, RList, List).

% Se dadea o lista [a, b, a, c, d, a, b, c, a, b, d] din care trebuia sa returnez elementul cu cele mai multe aparitii.

find_most_apps(L, X):-to_single_app(L, S), find_apps_for_each(S, L, Q), find_biggest_apps(Q, _, -1, X).

to_single_app([H|T], R):-member(H, T), !, to_single_app(T, R).
to_single_app([H|T], [H|R]):-to_single_app(T, R).
to_single_app([], []).

find_nb_apps(X, [X|T], N):-!, find_nb_apps(X, T, N1), N is N1 + 1.
find_nb_apps(X, [_|T], N):-find_nb_apps(X, T, N).
find_nb_apps(_, [], 0).

find_apps_for_each([H|T], L, [(H,Apps)|R]):-find_apps_for_each(T, L, R), find_nb_apps(H, L, Apps).
find_apps_for_each([], _, []).

find_biggest_apps([(X, Apps)|T], _, MApps, R):-Apps > MApps, !, find_biggest_apps(T, X, Apps, R).
find_biggest_apps([(_, _)|T], MX, MApps, R):-find_biggest_apps(T, MX, MApps, R).
find_biggest_apps([], X, _, X).

% Se dadea un graf (care era un poligon convex format din triunghiuri: asemanator cu problema de la seminar) prin reprezentare edge(X,Y), unde trebuie sa colectezi intr-o lista toate muchiile care nu sunt comune la mai multe triunghiuri.

:-dynamic new_poly_edge/2.
collect_triangle_edges(_):-
                is_edge_poly(X, Y),
                not(is_vis(X, Y)),
                get_other(X, Y, Z),
                assertz(new_poly_edge(X, Y)),
                assertz(new_poly_edge(Y, Z)),
                assertz(new_poly_edge(X, Z)),
                fail.
collect_triangle_edges(L):-findall((X, Y), new_poly_edge(X, Y), L1), delete_duplicate_edges(L1, L), retractall(new_poly_edge(_, _)).

get_other(X, Y, Z):-is_edge_poly(X, Z), is_edge_poly(Z, Y).

is_vis(X, Y):-new_poly_edge(X, Y); new_poly_edge(Y, X).

delete_all_edges((X, Y), [(X,Y)|T], R):-!,delete_all_edges((X, Y), T, R).
delete_all_edges((X, Y), [(Y,X)|T], R):-!,delete_all_edges((X, Y), T, R).
delete_all_edges((X, Y), [H|T], [H|R]):-delete_all_edges((X, Y), T, R).
delete_all_edges(_, [], []).

member_edge((X, Y), [(X, Y)|_]):-!.
member_edge((X, Y), [(Y, X)|_]):-!.
member_edge(X, [_|T]):-member_edge(X, T).

delete_duplicate_edges([H|T], R):-member_edge(H, T), !, delete_all_edges(H, T, T1), delete_duplicate_edges(T1, R).
delete_duplicate_edges([H|T], [H|R]):-delete_duplicate_edges(T, R).
delete_duplicate_edges([], []).


% check a graph for arborescence

edge4(2, 1).
edge4(3, 1).
edge4(3, 4).

:-dynamic vertex1/1.
check_if_path(X, X, _).
check_if_path(X, Y, Path):-
                edge4(X, Z),
                not(member(Z,Path)),
                check_if_path(Z, Y, [Z|Path]).

check_arborescence_from(X):-
                vertex1(Y),
                X \= Y,
                not(check_if_path(X, Y, [])),
                !,
                fail.
check_arborescence_from(_).

check_arborescence:-is_edge4(X, _),
                not(vertex1(X)),
                assertz(vertex1(X)),
                fail.
check_arborescence:-vertex1(X),
                check_arborescence_from(X).


is_edge4(X, Y):-edge4(X, Y); edge4(Y, X).

% Sa generez graful complementar unui graf dat.

edge5(2, 1).
edge5(3, 1).
edge5(3, 4).

:-dynamic compl_edge/2.
:-dynamic vertex2/1.
generate_compl:-is_edge5(X, _),
                not(vertex2(X)),
                assertz(vertex2(X)),
                fail.
generate_compl:-vertex2(X),
                vertex2(Y),
                X \= Y,
                not(is_edge5(X, Y)),
                not(is_compl_edge(X, Y)),
                assertz(compl_edge(X, Y)),
                fail.
generate_compl:-listing(compl_edge(_, _)), retractall(compl_edge(_, _)), retractall(vertex2(_)).

is_edge5(X, Y):-edge5(X, Y); edge5(Y, X).
is_compl_edge(X, Y):-compl_edge(X, Y); compl_edge(Y, X).

% build bst from postorder

build_bst_from_postorder(L, T):-reverse(L, R), build_postorder_tree(R, T).

build_postorder_tree([H|T], t(H, L, R)):-append(A, [BH|B], T), BH < H, !, build_postorder_tree([BH|B], L), build_postorder_tree(A, R).
build_postorder_tree([X], t(X, nil, nil)).
build_postorder_tree([], nil).

% insert in avl

avl_tree(t(8, t(2, nil, nil), t(10, nil, t(11, nil, nil)))).

height(nil, 0).
height(t(_, L, R), H):-height(L, H1), height(R, H2), max2(H1, H2, H3), H is H3+1.

avl_insert(X, nil, t(X, nil, nil), 1).
avl_insert(X, t(K, L, R), T, H):-X < K, !, 
                avl_insert(X, L, NL, HL),
                height(R, HR),
                max2(HL, HR, Haux),
                H is Haux + 1,
                B is HL - HR,
                perform_rots(B, t(K, NL, R), T).
avl_insert(X, t(K, L, R), T, H):-
                avl_insert(X, R, NR, HR),
                height(L, HL),
                max2(HL, HR, Haux),
                H is Haux + 1,
                B is HL - HR,
                perform_rots(B, t(K, L, NR), T).

perform_rots(B, t(K, t(LK, LL, LR), R), T):- B > 1, K < LK, !, rot_right(t(K, t(LK, LL, LR), R), T).
perform_rots(B, t(K, L, t(RK, RL, RR)), T):- B < -1, K < RK, !, rot_left(t(K, L, t(RK, RL, RR)), T).
perform_rots(B, t(K, t(LK, LL, LR), R), T):- B > 1, !, rot_left(t(LK, LL, LR), TX), rot_right(t(K, TX, R), T).
perform_rots(B, t(K, L, t(RK, RL, RR)), T):- B < -1, !, rot_left(t(RK, RL, RR), TX), rot_right(t(K, L, TX), T).
perform_rots(_, T, T).

rot_right(t(K, t(KL, LL, LR), R), t(KL, LL, t(K, LR, R))).
rot_left(t(K, L, t(KR, RL, RR)), t(KR, t(K, L, RL), RR)).



avl_delete(_, nil, nil).
avl_delete(X, t(K, L, R), T):- X < K, !, avl_delete(X, L, NL),
                height(NL, HL),
                height(R, HR),
                B is HL - HR,
                perform_rots(B, t(K, NL, R), T).
avl_delete(X, t(K, L, R), T):- X > K, !, avl_delete(X, R, NR), 
                height(L, HL),
                height(NR, HR),
                B is HL - HR,
                perform_rots(B, t(K, L, NR), T).
avl_delete(X, t(X, nil, R), R):-!.
avl_delete(X, t(X, L, nil), L):-!. 
avl_delete(X, t(X, L, R), T):-get_pred(L, Pred, NL), 
                height(NL, HL),
                height(R, HR),
                B is HL - HR,
                perform_rots(B, t(Pred, NL, R), T).

get_pred(t(Pred, L, nil), Pred, L):-!.
get_pred(t(Key, L, R), Pred, t(Key, L, NR)):-get_pred(R, Pred, NR).

