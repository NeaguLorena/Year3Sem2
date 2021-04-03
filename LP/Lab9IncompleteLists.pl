tree1(t(7, t(5, t(3, _, _), t(6, _, _)), t(11, _, _))).

member1_cl(X, [X|_]):-
    !.
member1_cl(X, [_|T]):-
    member1(X, T).

% must test explicitly for the end of the list, and fail 
member_il(_, L):-
    var(L), 
    !,
    fail.
% these 2 clauses are the same as for the member1 predicate 
member_il(X, [X|_]):-
    !.
member_il(X, [_|T]):-
    member_il(X, T).
% trace of L = [1, 2, 3|_], member_il(X, L).=> X = 1

%insert_il(X, L):-   %this clause can be removed because in clause 2 the element 
%to be inserted will be put in the list when the list reaches the free vriable and it
%will be unified with it's value
%    var(L), 
%    !, 
%    L=[X|_]. %found end of list, add element
insert_il(X, [X|_]):-
    !. %found element, stop
insert_il(X, [_|T]):- 
    insert_il(X, T). % traverse input list to reach end/X
%trace of:The  L = [1, 2, 3|_], insert_il(X, L). => L = [1, 2, 3, X|_]

delete_il(_, L, L):-
    var(L), !. % reached end, stop
delete_il(X, [X|T], T):-
    !. % found element, remove it and stop 
delete_il(X, [H|T], [H|R]):-
    delete_il(X, T, R). % search for the element

%Incomplete binary search trees

search_it(_, T):-
    var(T),
    !,
    fail.
search_it(Key, t(Key, _, _)):-
    !.
search_it(Key, t(K, L, R)):-
    Key<K, 
    !, 
  	search_it(Key, L).
search_it(Key, t(_, _, R)):-
    search_it(Key, R).

insert_it(Key, t(Key, _, _)):-
    !.
insert_it(Key, t(K, L, R)):-
    Key<K, 
    !, 
    insert_it(Key, L).
insert_it(Key, t(_, _, R)):- 
    insert_it(Key, R).

delete_it(Key, T, T):-
    var(T), 
    !, 
    write(Key), 
    write(' not in tree\n'). 
delete_it(Key, t(Key, L, R), L):-
    var(R), 
    !.
delete_it(Key, t(Key, L, R), R):-
    var(L), 
    !.
delete_it(Key, t(Key, L, R), t(Pred, NL, R)):-
    !, 
    get_pred(L, Pred, NL). 
delete_it(Key, t(K, L, R), t(K, NL, R)):-
    Key<K, 
    !, 
    delete_it(Key, L, NL). 
delete_it(Key, t(K, L, R), t(K, L, NR)):- 
    delete_it(Key, R, NR).
get_pred(t(Pred, L, R), Pred, L):-
    var(R), 
    !.
get_pred(t(Key, L, R), Pred, t(Key, L, NR)):-
    get_pred(R, Pred, NR).

%Quiz exercises

%appends two incomplete lists
append_il(L,R,R):-
    var(L),
    !.
append_il([H|T],L,[H|R]):-
    append_il(T,L,R).

%reverses an incomplete list
rev_il_pretty([H|T], R):-
    rev_il(T, [H|_], R).
rev_il(L,R,R):-
    var(L),
    !.
rev_il([H|T],R1, R):-
    rev_il(T,[H|R1],R).

%transforms an incomplete list into a complete list.
transform_iltocl(L, []):-
	var(L),
	!,
	L = [].
transform_iltocl([H|T], [H|R]):-   
	transform_iltocl(T, R).

%performs a preorder traversal on an incomplete tree, and collects the 
%keys in an incomplete list
preorder(t(K,L,R), List):-
    var(L),
    var(R),
    !,
    List = [K|_].
preorder(t(K,L,R), List):-
    var(L),
    !,
    preorder(R, LR),
    List = [K|LR].
preorder(t(K,L,R), List):-
    var(R),
    !,
    preorder(L, LL),
    List = [K|LL].
preorder(t(K,L,R), List):-
    preorder(L,LL), 
    preorder(R, LR), 
    append([K|LL], LR, List).

%computes the height of an incomplete binary tree.
max(A, B, A):-
    A>B, 
    !. 
max(_, B, B).
height(T, 0):-
    var(T), !.
height(t(_, L, R), H):-
    height(L, H1),
    height(R, H2), 
    max(H1, H2, H3),
	H is H3+1.

%transforms an incomplete tree into a complete tree
transform_ittoct(T):-
    var(T), !,
    T=nil.
transform_ittoct(t(_, L, R)):-
    transform_ittoct(L), 
    transform_ittoct(R).

%Problems
%%predicate which flattens an incomplete deep list(any list, at any level, ends in a variable)
flat_il(L,L):-
    var(L),
    !.
flat_il([H|T], [H|R]):- 
    atomic(H),
    !,
    flat_il(T,R).
flat_il([H|T], R):-
    flat_il(H,R1),
    flat_il(T,R2),
    append(R1,R2,R).

%diameter of bst
diameter(L, 0):-
	var(L),
	!,
	L = [].
diameter(t(_, L, R), D):-
    height(L, H1), 
    height(R, H2), 
    Temp is H1 + H2 + 2,
    diameter(L, D1), 
    diameter(R, D2),
    max(D1, D2, D3), 
    max(D3, Temp, D).
