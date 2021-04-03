add(X,LS,LE,RS,RE):-
    RS=LS,
    LE=[X|RE].
%trace of LS=[1,2,3,4|LE],add(5,LS,LE,RS,RE) will output => LE = [5|RE], LS = RS, RS = [1, 2, 3, 4, 5|RE]

tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, nil)))).
/* when we reached the end of the tree we unify the beggining and end of the partial result list – representing an empty list as a difference list */
inorder_dl(nil,L,L).
inorder_dl(t(K,L,R),LS,LE):-
/* obtain the start and end of the lists for the left and right subtrees */
  	inorder_dl(L,LSL,LEL),
  	inorder_dl(R,LSR,LER),
/* the start of the result list is the start of the left subtree list */
	LS=LSL,
/* insert the key between the end of the left subtree list and start of the right subtree list */ 
    LEL=[K|LSR],
/* the end of the result list is the end of the right subtree list */
	LE=LER.

inorder_dl2(nil,L,L).
inorder_dl2(t(K,L,R),LS,LE):-
    inorder_dl2(L,LS,[K|LT]),
    inorder_dl2(R,LT,LE).

partition(H, [X|T], [X|Sm], Lg):-
    X<H,
    !,
    partition(H, T, Sm, Lg).
partition(H, [X|T], Sm, [X|Lg]):-
    partition(H, T, Sm, Lg).
partition(_, [], [], []).

%quicksort([4,2,5,1,3],L,[]).
quicksort_dl([H|T],S,E):-
    partition(H,T,Sm,Lg),
	quicksort_dl(Sm,S,[H|L]),
	quicksort_dl(Lg,L,E).
quicksort_dl([],L,L).

:-dynamic memo_fib/2.
fib(N,F):-
    memo_fib(N,F),
    !.
fib(N,F):- 
    N>1,
    N1 is N-1,
	N2 is N-2,
	fib(N1,F1),
	fib(N2,F2),
	F is F1+F2,
    assertz(memo_fib(N,F)).
fib(0,1).
fib(1,1).

print_all:-memo_fib(N,F),
    write(N),
    write(' - '),
    write(F),
    nl,
    fail.
print_all.

perm(L, [H|R]):-
    append(A, [H|T], L),
    append(A, T, L1),
    perm(L1, R).
perm([], []).
%computes all the permutations of a list, and returns them in a separate list.
all_perm(L,_):-
    perm(L,L1),
    assertz(p(L1)),
    fail.
all_perm(_,R):-
    collect_perms(R).

collect_perms([L1|R]):-
    retract(p(L1)),
    !,
    collect_perms(R).
collect_perms([]).

%Quiz exercises
%1 incomplete <=> to difference
inc_to_diff(L, LS, LE):-
	var(L),
    !,
    LS = LE.
inc_to_diff([H|T],[H|LS],LE):-
    inc_to_diff(T,LS,LE).

diff_to_inc([H|LS],LE,[H|_]):-
    LE==LS,
    !.
diff_to_inc([H|T],LE,[H|R]):-
    diff_to_inc(T,LE,R).
%2 difference <=> complete
compl_to_diff([],LE,LE).
compl_to_diff([H|T], [H|LS], LE):-
    compl_to_diff(T,LS,LE).

diff_to_compl(LS,LE,[]):-
    LS==LE,
    !.
diff_to_compl([H|LS],LE,[H|R]):-
    diff_to_compl(LS,LE,R).
    
%3. generates a list with all the possible decompositions of a list into 2 lists, without using findall.
% query: all_decompositions([1,2,3], List).
decomp(L, R1, R2):-
    append(R1, R2, L).

all_decompositions(L,_):-
    decomp(L, R1, R2),
    assertz(d([R1, R2])),
    fail.
all_decompositions(_,R):-
    collect_decomps(R).

collect_decomps([L1|R]):-
    retract(d(L1)),
    !,
    collect_decomps(R).
collect_decomps([]).

%Problems
%1.flattens a deep list using difference lists instead of append
%diff_flatten([[1],[2],[3],[4,5],6],S,E).
diff_flatten([],LE,LE).
diff_flatten([H|T], [H|LS],LE):- 
    atomic(H),
    !,
    diff_flatten(T,LS,LE).
diff_flatten([H|T], LSS,LEE):-
    diff_flatten(H,LSS,LSE),
    diff_flatten(T,LSE,LEE).

%2.collects all even keys in a binary tree, using difference lists.
diff_keys(nil,L,L).
diff_keys(t(K,L,R),LS,LE):-
    0 is K mod 2,
    !,
    diff_keys(L,LS,[K|LT]),
    diff_keys(R,LT,LE).
diff_keys(t(_,L,R),LS,LE):-
    diff_keys(L,LS,LT),
    diff_keys(R,LT,LE).

%3. collects, from a binary incomplete search tree, all keys between K1 and K2, using difference lists.
%Uses backward recursion iot get the list on the left and right of the key and append the result using difference lists for better performance
diff_keys_k12(nil, _, _, LE, LE).
diff_keys_k12(t(K,_,R), K1, K2, LSR, LER):-
    K < K1,
    !,
    diff_keys_k12(R, K1, K2, LSR, LER).
diff_keys_k12(t(K,L,_), K1, K2, LSL, LEL):-
    K > K2,
    !,
    diff_keys_k12(L, K1, K2, LSL, LEL).
diff_keys_k12(t(K,L,R), K1, K2, LSL, LER):-
    diff_keys_k12(L, K1, K2, LSL, [K|LEL]),
    diff_keys_k12(R, K1, K2, LEL, LER).




