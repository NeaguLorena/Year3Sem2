perm(L, [H|R]):-
    append(A, [H|T], L),
    append(A, T, L1),
    perm(L1, R).
perm([], []).

%trace of "append(A, [H|T], [1, 2, 3]), append(A, T, R)" showed that if we want to take 
%randomly elements of a list we can set a value for the result and if the input is not 
%assigned a value it will take the values from the result,
%meaning it takes all possible combinations for A, [H,T] to give result [1,2,3]
%trace of "perm([1, 2, 3], L)" will result all possible permutations for list [1,2,3]
%if i run "append(A, T, R),append(A, [H|T], [1, 2, 3])" output will be the same as the 
%eversed clauses for perm("[1,2,3],L)" thought i get a " Stack limit exceeded" error

is_ordered([_]).
is_ordered([H1, H2|T]):-
    H1 =< H2,
    is_ordered([H2|T]).

sel_sort(L, [M|R]):-
    min_list(L, M),
    delete(L, M, L1),
    sel_sort(L1, R),
    write(R).
sel_sort([], []).
%sel_sort first finds the min element and then deletes it from the list so the next recursive call would
%find the next minimum until list is empty. All found min values are appended to the result as recursive calls return
%by adding the write() predicate we can also view the partial results: we can see that the result list is created as recursion
%returns that the list is created backwards.
delete_min(L, R):-
     min_list(L, M),
    delete(L, M, R).

ins_sort([H|T], R):- 
    ins_sort(T, R1),
    insert_ord(H, R1, R).
ins_sort([], []).
insert_ord(X, [H|T], [H|R]):-
    X>H, 
    !,
    insert_ord(X, T, R),
    write(R).
insert_ord(X, T, [X|T]).
%append on each call the value that's supposed to be inserted in the correct place
%case we have "insert_ord(3, [1, 3, 3, 4], R)" appends in front of first occurence of 3 and then stops.

bubble_sort(L, R):-
    one_pass(L, R1, F),
    nonvar(F),
    !,
    bubble_sort(R1, R).
bubble_sort(L, L).
one_pass([H1, H2|T], [H2|R], F):-
    H1>H2,
    !,
    F = 1,
    one_pass([H1|T], R, F).
one_pass([H1|T], [H1|R], F):-
    one_pass(T, R, F).
one_pass([], [] ,_).
%"bubble_sort([2, 3, 1, 4], R)" will output => [1,2,3,4].
%one_pass stops when a swap is done and sets the flag to 1, else flag will be 0 when there
%are no more swaps to be done and the predicate returns the sorted array.

quick_sort([H|T], R):-
    partition(H, T, Sm, Lg),
    quick_sort(Sm, SmS),
    quick_sort(Lg, LgS),
    append(SmS, [H|LgS], R).
quick_sort([], []).

partition(H, [X|T], [X|Sm], Lg):-
    X<H,
    !,
    partition(H, T, Sm, Lg).
partition(H, [X|T], Sm, [X|Lg]):-
    partition(H, T, Sm, Lg).
partition(_, [], [], []).

merge_sort(L, R):-
    split(L, L1, L2),
    merge_sort(L1, R1),
    merge_sort(L2, R2),
    merge(R1, R2, R).
merge_sort([H], [H]).
merge_sort([], []).
split(L, L1, L2):-
    length(L, Len),
    Len>1,
    K is Len/2,
    splitK(L, K, L1, L2).
splitK([H|T], K, [H|L1], L2):- 
    K>0, !,
    K1 is K-1,
    splitK(T, K1, L1, L2).
splitK(T, _, [], T).
merge([H1|T1], [H2|T2], [H1|R]):-
    H1<H2, !,
    merge(T1, [H2|T2], R).
merge([H1|T1], [H2|T2], [H2|R]):-
    merge([H1|T1], T2, R).
merge([], L, L).
merge(L, [], L).

%Quiz exercises

%1.
extract_elem_k([_|T], K, X):-
    K > 0,
    !,
    K1 is K-1,
    extract_elem_k(T, K1, X).
extract_elem_k([X|_],0,X).

extract_delete_randomly(L, L1, X, K):-
    extract_elem_k(L, K, X),
	delete(L, X, L1).
extract_delete_randomly(L, L1, X, K):-
    length(L,Len),
    Len>=K,
    !,
    K1 is K+1,
    extract_delete_randomly(L, L1, X, K1).
%perm1 takes each element from the list and extract one by one, then forms the permutations by extracting and deleting that element from the list and appending it at the front of the resulted list.
perm1([], []).
perm1(L, [X|R]):-
    extract_delete_randomly(L, L1, X, 0),
    perm1(L1, R).

%2.
%selects max element from the unsorted part of the array appending it to the sorted part. This will sort the list in descending order, same efficiency as with min.
sel_sort_max(L, [M|R]):-
    max_list(L, M),
    delete(L, M, L1),
    sel_sort_max(L1, R),
    write(R).
sel_sort_max([], []).

%3.
%always use an accumulator for forward recursion
%efficiency in comparison with the backward recursive version: faster because it uses an accumulator that stores each element from the original list in the correct position.
ins_sort_fw_pretty(L, R):-
    ins_sort_fw(L, R, []).
ins_sort_fw([H|T], R, Acc):- 
    insert_ord(H, Acc, Acc1),
    ins_sort_fw(T, R, Acc1).
ins_sort_fw([], R, R).

%4
%perform bubble sort on n number of passes, N would be the length of the list
bubble_sort_n_pretty(L, R):-
    length(L, Len),
    bubble_sort_n(L, R, Len).
bubble_sort_n(L, R, N):-
    one_pass(L, R1, _),
    N > 0,
    !,
    N1 is N-1,
    bubble_sort_n(R1, R, N1).
bubble_sort_n(L, L, _).

%Problems
%1
sort_chars([H|T], R):-
    sort_chars(T, R1),
    insert_ord_char(H, R1, R).
sort_chars([], []).
insert_ord_char(X, [H|T], [H|R]):-
    char_code(X, CodeX),
    char_code(H, CodeH),
    CodeX>CodeH,
    !,
    insert_ord_char(X, T, R).
insert_ord_char(X, T, [X|T]).

%2
sort_len([H|T], R):-
    partition_len(H, T, Sm, Lg),
    sort_len(Sm, SmS),
    sort_len(Lg, LgS),
    append(SmS, [H|LgS], R).
sort_len([], []).

partition_len(H, [X|T], [X|Sm], Lg):-
    length(X,Len1),
    length(H,Len2),
    Len1<Len2, 
    partition_len(H, T, Sm, Lg).
partition_len(H, [X|T], Sm, [X|Lg]):-
    partition_len(H, T, Sm, Lg).
partition_len(_, [], [], []).



  