% 1. count numbers of lists in a deep list
count_lists([H|T], Acc, R):-atomic(H), count_lists(T, Acc, R).
count_lists([],R,R1):-R1 is R+1.
count_lists([H|T],Acc,R):-count_lists(H,R1), Acc1 is R1 + Acc, count_lists(T, Acc1, R).

count_lists(L, R):-count_lists(L, 0, R).

% 2. double the odd numbers and square the even
numbers([H|T],[H2|R]):-numbers(T,R), 0 is H mod 2, H2 is H * H.
numbers([H|T],[H2|R]):-numbers(T,R), 1 is H mod 2, H2 is 2 * H.
numbers([],[]).

% 3. Convert a number to binary (the powers of 2 grow from right to left).
to_binary(0, R, R):-!.
to_binary(N, Acc, R):-Rst is N mod 2, N1 is N / 2, floor(N1, N2), to_binary(N2, [Rst|Acc], R).
to_binary(N, R):-to_binary(N, [], R).

% 4. Replace all the occurrences of x in a difference list with the sequence y x y.
replace_all(_,End,End,_,[]).
replace_all(X, [X|T], End, Y, [Y,X,Y|R]):-!,replace_all(X,T,End,Y,R).
replace_all(X, [H|T], End, Y, [H|R]):-replace_all(X,T,End,Y,R).

% 5. Delete the occurrences of x on even positions (the position numbering starts with 1).
delete_pos_even([X|T], X, N, R):-N1 is N + 1, delete_pos_even(T, X, N1, R), 0 is N mod 2, !.
delete_pos_even([H|T], X, N, [H|R]):-N1 is N + 1, delete_pos_even(T, X, N1, R).
delete_pos_even([], _, _, []).

delete_pos_even(L, X, R):-delete_pos_even(L, X, 1, R).

% 6. Compute the divisors of a natural number.
divisor(N, N, [N]).
divisor(N, I, [I|R]):-I < N,  0 is N mod I, !, I1 is I + 1, divisor(N, I1, R).
divisor(N, I, R):-I < N, I1 is I + 1, divisor(N, I1, R).

divisor(0, alot):-!.
divisor(N, R):-N<0, Npos is -N, divisor(Npos, 1, R).
divisor(N, R):-divisor(N, 1, R).

% 7. Reverse a natural number.
reverse(0, R, R):-!.
reverse(N, Acc, R):-Rst is N mod 10, N1 is N / 10, floor(N1, N2), Acc1 is Acc * 10 + Rst, reverse(N2, Acc1, R).
reverse(N, R):-reverse(N, 0, R).

% 8. Delete each kth element from the end of the list.
delete_kth_end([_|T],1,N,R):-
      delete_kth_end(T,K,N,R), 
      K == N, 
      !.
delete_kth_end([H|T],K1,N,[H|R]):-
      delete_kth_end(T,K,N,R),
      K1 is K + 1.
delete_kth_end([],1,_,[]).

delete_kth_end(L, N, R):-
      delete_kth_end(L, _, N, R).

% 9. Separate the even elements on odd positions from the rest (the position numbering starts at 1).
separate([H|T], N, [H|Even], Rest):-N1 is N + 1, separate(T, N1, Even, Rest), 0 is H mod 2, 1 is N mod 2, !.
separate([H|T], N, Even, [H|Rest]):-N1 is N + 1, separate(T, N1, Even, Rest).
separate([],_,[],[]).

separate(L, Even, Rest):-separate(L, 1, Even, Rest).

% 10. Binary incomplete tree. Collect odd nodes with 1 child in an incomplete list.
tree(t(26,t(14,t(2,_,_),t(15,_,_)),t(50,t(35,t(29,_,_),_),t(51,_,t(58,_,_))))).

append_incomplete(L1, L2, L2):-var(L1), !.
append_incomplete([H|T], L2, [H|R]):-append_incomplete(T, L2, R).

collect_odd_from_1child(t(_, L, R), _):-var(L), var(R), !.
collect_odd_from_1child(t(K, L, R), List):-var(L), !, 1 is K mod 2, !, collect_odd_from_1child(R, Q), append_incomplete([K|_], Q, List).
collect_odd_from_1child(t(_, L, R), List):-var(L), !, collect_odd_from_1child(R, List).
collect_odd_from_1child(t(K, L, R), List):-var(R), !, 1 is K mod 2, !, collect_odd_from_1child(L, Q), append_incomplete(Q, [K|_], List).
collect_odd_from_1child(t(_, L, R), List):-var(R), !, collect_odd_from_1child(L, List).
collect_odd_from_1child(t(_,L,R), List):-collect_odd_from_1child(L, Q1), collect_odd_from_1child(R, Q2), append_incomplete(Q1, Q2, List).

% 11. Ternary incomplete tree. Collect the keys between X and Y (closed interval) in a difference list.
t_tree(t(2,t(8,_,_,_),t(3,_,_,t(4,_,_,_)),t(5,t(7,_,_,_),t(6,_,_,_),t(1,_,_,t(9,_,_,_))))).

collect_between(T, _, _, End, End):-var(T), !.
collect_between(t(K, L, M, R), Low, High, [K|Start], End):-collect_between(L, Low, High, Start, SM), collect_between(M, Low, High, SM, SR), collect_between(R, Low, High, SR, End), Low=<K, K=<High, !.
collect_between(t(_, L, M, R), Low, High, Start, End):-collect_between(L, Low, High, Start, SM), collect_between(M, Low, High, SM, SR), collect_between(R, Low, High, SR, End).

% 12. Binary Tree. Collect even keys from leaves in a difference list.
tree2(t(5,t(10,t(7,nil,nil),t(10,t(4,nil,nil),t(3,nil,t(2,nil,nil)))),t(16,nil,nil))).
collect_even_from_leaf(nil,Start,Start):-!.
collect_even_from_leaf(t(K, nil, nil), [K|End], End):- 0 is K mod 2, !.
collect_even_from_leaf(t(_, L, R), Start, End):-collect_even_from_leaf(L, Start, RStart), collect_even_from_leaf(R, RStart, End).

% 13. Replace the min element from a ternary incomplete tree with the root.
t_tree2(t(2,t(8,_,_,_),t(3,_,_,t(1,_,_,_)),t(5,t(7,_,_,_),t(6,_,_,_),t(1,_,_,t(9,_,_,_))))).

min2(A, B, A):-var(A), var(B), !.
min2(A, B, A):-var(B), !.
min2(A, B, B):-var(A), !.
min2(A, B, A):-A<B, !.
min2(_, B, B).

find_min(T, _):-var(T), !.
find_min(t(K, L, M, R), Min):-find_min(L, MinL), find_min(M, MinM), find_min(R, MinR), min2(MinL, MinM, X), min2(X, MinR, Y), min2(Y, K, Min).

replace_min(T, _, _, T):-var(T), !.
replace_min(t(K, L, M, R), K, Root, t(Root, NewL, NewM, NewR)):-!, replace_min(L, K, Root, NewL), replace_min(M, K, Root, NewM), replace_min(R, K, Root, NewR).
replace_min(t(K, L, M, R), Min, Root, t(K, NewL, NewM, NewR)):-replace_min(L, Min, Root, NewL), replace_min(M, Min, Root, NewM), replace_min(R, Min, Root, NewR).

replace_min(t(K, L, M, R), Res):-find_min(t(K, L, M, R), Min), replace_min(t(K, L, M, R), Min, K, Res).


% 14. Collect all the nodes at odd depth from a binary incomplete tree (the root has depth 0).
tree3(t(26,t(14,t(2,_,_),t(15,_,_)),t(50,t(35,t(29,_,_),_),t(51,_,t(58,_,_))))).

collect_all_odd_depth(T, _, []):-var(T), !.
collect_all_odd_depth(t(K, L, R), N, [K|Rez]):-1 is N mod 2, !, N1 is N + 1, collect_all_odd_depth(L, N1, LRez), collect_all_odd_depth(R, N1, RRez), append(LRez, RRez, Rez).
collect_all_odd_depth(t(_, L, R), N, Rez):-N1 is N + 1, collect_all_odd_depth(L, N1, LRez), collect_all_odd_depth(R, N1, RRez), append(LRez, RRez, Rez).

collect_all_odd_depth(T, R):-collect_all_odd_depth(T, 0, R).

% 15. Flatten only the elements at depth X from a deep list.

flatten_only_depth([], _, _, R, R).
flatten_only_depth([H|T], N, N, Acc, R):-atomic(H), !, append(Acc, [H], Acc1), flatten_only_depth(T, N, N, Acc1, R).
flatten_only_depth([_|T], N, N, Acc, R):-!,flatten_only_depth(T, N, N, Acc, R).
flatten_only_depth([H|T], D, N, Acc, R):-atomic(H), !, flatten_only_depth(T, D, N, Acc, R).
flatten_only_depth([H|T], D, N, Acc, R):-D1 is D + 1, flatten_only_depth(H, D1, N, [], RD), append(Acc, RD, Acc1), flatten_only_depth(T, D, N, Acc1, R).

flatten_only_depth(L, X, R):-flatten_only_depth(L, 1, X, [], R).

% 16. Delete duplicate elements that are on an odd position in a list (the position numbering starts
% at 1).

find_dups([], _, R, R).
find_dups([H|T], Acc, DupsAcc, R):-member(H, Acc), \+(member(H, DupsAcc)), !, find_dups(T, Acc, [H|DupsAcc], R).
find_dups([H|T], Acc, DupsAcc, R):-member(H, Acc), !, find_dups(T, Acc, DupsAcc, R).
find_dups([H|T], Acc, Dups, R):-find_dups(T, [H|Acc], Dups, R).

find_dups(L, R):-find_dups(L, [], [], R).

remove_dup_on_odd_pos([], _, _, []).
remove_dup_on_odd_pos([H|T], N, Dups, R):-N1 is N + 1, remove_dup_on_odd_pos(T, N1, Dups, R), 1 is N mod 2, member(H, Dups), !.
remove_dup_on_odd_pos([H|T], N, Dups, [H|R]):-N1 is N + 1, remove_dup_on_odd_pos(T, N1, Dups, R).

remove_dup_on_odd_pos(L, R):-find_dups(L, Dups), remove_dup_on_odd_pos(L, 1, Dups, R).


% 17. Determine the node/s having the median value in a ternary incomplete tree.
t_tree3(t(2,t(8,_,_,_),t(3,_,_,t(1,_,_,_)),t(5,t(7,_,_,_),t(5,_,_,_),t(1,_,_,t(9,_,_,_))))).

insert_in_order([],X,[X]).
insert_in_order([H|T], X, [X,H|T]):-X=<H, !.
insert_in_order([H|T], X, [H|R]):-insert_in_order(T, X, R).

insertion_sort([], []).
insertion_sort([H|T], R):-insertion_sort(T, Aux), insert_in_order(Aux, H, R).

get_ordered_from_ternary(T, []):-var(T), !.
get_ordered_from_ternary(t(K, L, M, R), Rez):-get_ordered_from_ternary(L, LR), get_ordered_from_ternary(M, MR), get_ordered_from_ternary(R, RR), append(LR, MR, Aux1), append(Aux1, RR, Aux2), insertion_sort([K|Aux2], Rez).

get_median([], Size, Sz, _):-Sz is Size - 1.
get_median([H|T], N, Size, H):-N1 is N + 1, get_median(T, N1, Size, _), N is floor(Size / 2) + 1, !.
get_median([H|T], N, Size, Med):-N1 is N + 1, get_median(T, N1, Size, Median), 0 is Size mod 2, N is floor(Size/2), !, Med is floor((Median + H) / 2).
get_median([_|T], N, Size, Median):-N1 is N + 1, get_median(T, N1, Size, Median).

get_median(L, M):-get_median(L, 1, _, M).

median(T, _, []):-var(T), !.
median(t(Med, L, M, R), Med, [t(Med, L, M, R)|Aux2]):-!, median(L, Med, LRez), median(M, Med, MRez), median(R, Med, RRez), append(LRez, MRez, Aux), append(Aux, RRez, Aux2).
median(t(_, L, M, R), Med, Aux2):-median(L, Med, LRez), median(M, Med, MRez), median(R, Med, RRez), append(LRez, MRez, Aux), append(Aux, RRez, Aux2).

median(T, L):-get_ordered_from_ternary(T, Ord), get_median(Ord, Med), median(T, Med, L).

% 18. Replace each node with its height in a binary incomplete tree (a leaf has height 0).

height_each(T, -1, T):-var(T), !.
height_each(t(_, L, R), H, t(H, NewL, NewR)):-height_each(L, HL, NewL), height_each(R, HR, NewR), H is max(HL, HR) + 1.

height_each(T, R):-height_each(T, _, R).

% 19. Replace each constant depth sequence in a deep list with its length.
tree4(t(2,t(4,t(5,_,_),t(7,_,_)),t(3,t(0,t(4,_,_),_),t(8,_,t(5,_,_))))).

len_con_depth([], N, Acc, R):-append(Acc,[N],R).
len_con_depth([H|T], N, Acc, R):-atomic(H), !, N1 is N + 1, len_con_depth(T, N1, Acc, R).
len_con_depth([H|T], N, Acc, R):-len_con_depth(H,R1), N \= 0, !, append(Acc, [N], Acc1), append(Acc1, [R1], Acc2), len_con_depth(T, 0, Acc2, R).
len_con_depth([H|T], _, Acc, R):-len_con_depth(H,R1), append(Acc, [R1], Acc2), len_con_depth(T, 0, Acc2, R).

len_con_depth(L, R):-len_con_depth(L, 0, [], R).

% 20. Decode a list encoded with RLE.

rle_decode([], _, 0, R, R).
rle_decode(L, Let, Nb, Acc, R):-Nb > 0, !, append(Acc, [Let], Acc1), Nb1 is Nb - 1, rle_decode(L, Let, Nb1, Acc1, R).
rle_decode([[NewLet, NewNb]|T], _, _, Acc, R):-rle_decode(T, NewLet, NewNb, Acc, R).

rle_decode([[NewLet, NewNb]|T], R):-rle_decode(T, NewLet, NewNb, [], R).

% 21. Encode a list with RLE.

rle_encode([], El, Nb, Acc, Acc1):-
      append(Acc, [[El, Nb]], Acc1).
rle_encode([H|T], H, Nb, Acc, R):-
      !,
      N is Nb +1,
      rle_encode(T, H, N, Acc, R).
rle_encode([H|T], El, Nb, Acc, R):-
      append(Acc, [[El,Nb]], Acc1),
      rle_encode(T, H, 1, Acc1, R).
rle_encode([H|T], R):-
      rle_encode(T, H, 1, [], R).

% 22. Compute the indegree and the outdegree for each node in a graph using the dynamic
%predicate info(Node, OutDegree, InDegree).

edge(1,2).
edge(2,1).
edge(1,4).
edge(1,3).
edge(3,2).

is_edge(X, Y):-edge(X, Y); edge(Y, X).

size([], 0).
size([_|T], N1):-size(T, N), N1 is N + 1.

:- dynamic info/3.
collect_edges:-retractall(info(_,_,_)),
                fail.
collect_edges:-is_edge(X,_),
            \+(info(X, _, _)),
            assertz(info(X, -1, -1)),
            fail.
collect_edges:-retract(info(X, -1, -1)),
            findall(Y, edge(X, Y), ListOut),
            findall(Y, edge(Y, X), ListIn),
            size(ListIn, In),
            size(ListOut, Out),
            assertz(info(X, Out, In)),
            fail.
collect_edges.