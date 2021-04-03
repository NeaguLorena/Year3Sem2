tree1(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, nil, nil), nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))).

inorder(t(K,L,R), List):-
    inorder(L,LL),
    inorder(R, LR),
    append(LL, [K|LR],List).
inorder(nil, []).
preorder(t(K,L,R), List):-
    preorder(L,LL), 
    preorder(R, LR), 
    append([K|LL], LR, List).
preorder(nil, []).
postorder(t(K,L,R), List):-
    postorder(L,LL), 
    postorder(R, LR),
append(LL, LR,R1), 
    append(R1, [K], List).
postorder(nil, []).

% inorder traversal
pretty_print(nil, _).
pretty_print(t(K,L,R), D):-
    D1 is D+1, 
    pretty_print(L, D1), 
    print_key(K, D),
pretty_print(R, D1).

% predicate which prints key K at D tabs from the screen left margin and then 
% proceeds to a new line
print_key(K, D):-
    D>0,
    !, 
    D1 is D-1,
    write('\u2007 \u2007'), %space
    print_key(K, D1). 
print_key(K, _):-
    write(K),
    nl.

search_key(Key, t(Key, _, _)):-
    !.
search_key(Key, t(K, L, _)):-
    Key<K, 
    !, 
    search_key(Key, L).
search_key(Key, t(_, _, R)):-
    search_key(Key, R).


insert_key(Key, nil, t(Key, nil, nil)):-
    write('Inserted '), 
    write(Key),
    nl.
insert_key(Key, t(Key, L, R), t(Key, L, R)):-
    !,
    write('Key already in tree\n').
insert_key(Key, t(K, L, R), t(K, NL, R)):-
    Key<K,
    !, 
    insert_key(Key, L, NL).
insert_key(Key, t(K, L, R), t(K, L, NR)):- 
    insert_key(Key, R, NR).



delete_key(Key, nil, nil):-
    write(Key),
    write(' not in tree\n').
delete_key(Key, t(Key, L, nil), L):-
    !. % this clause covers also case for leaf (L=nil)
delete_key(Key, t(Key, nil, R), R):-
    !.
delete_key(Key, t(Key, L, R), t(Pred, NL, R)):-
    !, 
    get_pred(L, Pred, NL).
delete_key(Key, t(K, L, R), t(K, NL, R)):-
    Key<K,
    !, 
    delete_key(Key, L, NL).
delete_key(Key, t(K, L, R), t(K, L, NR)):- 
    delete_key(Key, R, NR).
get_pred(t(Pred, L, nil), Pred, L):-
    !.
get_pred(t(Key, L, R), Pred, t(Key, L, NR)):-
    get_pred(R, Pred, NR).


% predicate which computes the maximum between 2 numbers
max(A, B, A):-
    A>B, 
    !. 
max(_, B, B).

% predicate which computes the height of a binary tree
height(nil, 0).
height(t(_, L, R), H):-
    height(L, H1),
    height(R, H2), 
    max(H1, H2, H3),
	H is H3+1.

%Ternary Trees - trees with 3 children
ternaryTree(t(6, t(4, t(2, nil, nil, nil), nil, t(7, nil, nil, nil)), t(5, nil, nil, nil), t(9, nil, nil, t(3, nil, nil, nil)))).

inorderTernary(t(K, L, M, R), List):-
    inorderTernary(L, LL),
    inorderTernary(M, LM),
    inorderTernary(R, LR),
	append(LL, [K|LM], L1),
    append(L1, LR, List).
inorderTernary(nil, []).

preorderTernary(t(K, L, M, R), List):-
    preorderTernary(L, LL),
    preorderTernary(M, LM),
    preorderTernary(R, LR),
	append([K|LL], LM, L1),
    append(L1, LR, List).
preorderTernary(nil, []).

postorderTernary(t(K, L, M, R), List):-
    postorderTernary(L, LL),
    postorderTernary(M, LM),
    postorderTernary(R, LR),
	append(LL, LM, L1),
    append(L1, LR, L2),
    append(L2, [K], List).
postorderTernary(nil, []).

pretty_print_ternary(nil, _).
pretty_print_ternary(t(K, L, M, R), D):-
    D1 is D + 1,
    print_key(K, D),
    pretty_print_ternary(L, D1),
    pretty_print_ternary(M, D1), 
    pretty_print_ternary(R, D1).

heightTernary(nil, 0).
heightTernary(t(_, L, M, R), H):-
    heightTernary(L, H1),
    heightTernary(R, H2),
    heightTernary(M, H3),
    max(H1, H2, H4),
    max(H4, H3, H5),
    H is H5 + 1.

%inorder traversal of a binary search tree such that the keys are printed on the screen
inorderPrint(nil).
inorderPrint(t(K,L,R)):-
    inorderPrint(L),
    write(K),
    write(' '),
    inorderPrint(R).

%collects in a list all the keys found in leaf nodes of a binary search tree.
collectLeavesBST(t(K, nil, nil), [K]).
collectLeavesBST(t(_, L, R), Acc):-
    collectLeavesBST(L, AccL),
    collectLeavesBST(R, AccR), 
    append(AccL, AccR, Acc).
collectLeavesBST(t(_, L, nil), Acc):-
    collectLeavesBST(L, Acc).
collectLeavesBST(t(_, nil, R), Acc):-
    collectLeavesBST(R, Acc).

%predicate which computes the diameter of a binary tree 
%(diam(Root) = max{diam(Left), diam(Right), height(Left)+height(Right)+1}).
diameter(nil, 0).
diameter(t(_, L, R), D):-
    height(L, H1), 
    height(R, H2), 
    Temp is H1 + H2 + 2,
    diameter(L, D1), 
    diameter(R, D2),
    max(D1, D2, D3), 
    max(D3, Temp, D).