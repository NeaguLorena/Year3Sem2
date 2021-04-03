%deterministic version of member 
member1(X, [X|_]):-
    !.
member1(X, [_|T]):-
    member1(X, T).
%for trace "trace, X=3, member1(X, [3, 2, 4, 3, 1, 3])." , by using the cut '!', 
%the execution stops after the first call succeeded, no repeating the question
%for trace "member1(X, [3, 2, 4, 3, 1, 3])." X unifies with value 3 so it meets the cut'!'operator and execution stops there.
delete(X, [X|T], T):-!.
delete(X, [H|T], [H|R]):-
    delete(X, T, R).
delete(_, [], []).
%same with delete as above for trace of "delete(X, [3, 2, 4, 3, 1, 3], R)."
%In order to evaluate an expression, you have to use is.
length1([],0).
length1([_|T], Len):-
    length1(T,Len1),
    Len is Len1+1.
%length1 applies a backward recursive approach, by placing the recursive 
%call first and operations later, so the result is built as the recursion returns.

% when reaching the empty list, unify accumulator with the free result variable
length_fwd([], Acc, Res):-
    Res = Acc.
% as the list is decomposed, add 1 to the accumulator; pass Res unchanged
length_fwd([_|T], Acc, Res):-
    Acc1 is Acc+1,
    length_fwd(T, Acc1, Res).
length_fwd_pretty(L, Len):-
    length_fwd(L, 0, Len).
%for trace of "length_fwd_pretty([a, b, c, d], Len)." result will be Len = 4 after each call,
%first the accumulator counts and then recursion is called again until [] is found.
%The, accumulator's value will be taken by the Res variable. Lastly all recursive calles will backtrack.
%for "length_fwd([a, b, c, d], 3, Len)." the result will be 7 (Len=7) because accumulator starts counting from 3.

reverse([], []).
reverse([H|T], Res):-
    reverse(T, R1),
    append(R1, [H], Res).
% The trace "reverse([a, b, c, d], R)." showed when recursion is backtracked the heads are always appended to the last element of the list
%use accumulator to obtain forward recursion
reverse_fwd([], R, R).
reverse_fwd([H|T], Acc, R):-
    reverse_fwd(T, [H|Acc], R).
reverse_fwd_pretty(L, R):- 
    reverse_fwd(L, [], R).
%reverse_fwd([a, b, c, d], [1, 2], R) added list [1,2] to the tail of the initial list reversed

minimum([], M, M).
minimum([H|T], MP, M):-
    H<MP,
    !,
    minimum(T, H, M).
minimum([_|T], MP, M):-
    minimum(T, MP, M).
minimum_pretty([H|T], R):-
    minimum([H|T], H, R).
%for "minimum_pretty([3, 2, 6, 1, 4, 1, 5], M)." there is only one answer because of the cut "!", which not allows repeating the question once the solution is found
%here,first, the test is done then's the recursive call
minimum_bwd([H], H).
minimum_bwd([H|T], M):-
    minimum_bwd(T, M),
    H>=M.
minimum_bwd([H|T], H):-
    minimum_bwd(T, M),
    H<M.
%for the backwards recursion, first the recursion call is made and then the comparison tests
minimum_bwd1([H|T], M):-
    minimum_bwd1(T, M),
    H>=M,
    !.
minimum_bwd1([H|_], H).
%the original variation included both comparisons in the execution of the same variables, 
%in the improved one, once a comparison is made we know already what the result would be,
%so there is no need to include the opposite comparison.
%call "minimum_bwd([3, 2, 6, 1, 4, 1, 5], M)." will result false as it is no predicate for [] so it fails for both implementations

union([ ],L,L).
union([H|T],L2,R) :- 
    member(H,L2),
    !,
    union(T,L2,R).
union([H|T],L,[H|R]):-
    union(T,L,R).
%Set intersection
inters([],_,[]).
inters([H|T],L2,[H|R]):-
	member(H,L2),
    !,
    inters(T,L2,R).
inters([_|T],L2,R):-
    inters(T,L2,R).
%for "inters(L1,[1,2,3,4,5],[2,3,4])." i observed that L1 will be the result because the head of R, which is given a set,
% will be prelucrated one by one, but in this approach for other values will not work
%,for example for :inters(L1,[1,2,3,4,5],[2,3,6]). will exceed the stack limit

%Set difference
set_diff([],_,[]).
set_diff([H|T],L2,R):-
    member(H,L2),
    !,
    set_diff(T,L2,R).
set_diff([H|T],L2,[H|R]):-
	set_diff(T,L2,R).
% call "set_diff([1,2,3,4,7,8], [ 2,3,4,5],R)." will output R=[1,7,8]
%call "set_diff([1,2,3], [1,2,3,4,5],R)." will output R=[]
%call "set_diff(L, [1,2,3],[4,5])." gives "stack limit exceeded

%Quiz exercises
del_min(L,M,R):-
	minimum_pretty(L,M),
	delete(M,L,R).

rev_k_pretty(L,K,R):-
	rev_k(L,K,1,R).

rev_k([],_,_,_).
rev_k([H|T],K,Cnt,Res):-
    Cnt is K,
    !,
    reverse(T,Rev2),
    append([H],Rev2,Res),
	rev_k([],K,Cnt,R).
rev_k([H|T],K,Cnt,[H|R]):-
    C is Cnt+1,
    rev_k(T,K,C,R).

maximum([], M, M).
maximum([H|T], MP, M):-
    H>MP,
    !,
    maximum(T, H, M).
maximum([_|T], MP, M):-
    maximum(T, MP, M).
maximum_pretty([H|T], R):-
    maximum([H|T], H, R).
del_max(L,M,R):-
	maximum_pretty(L,M),
	delete(M,L,R).

%Problems
head1([H|_],H).
rle_encode([H|T],R):-
    rle_encode1(T,1,H,R).
rle_encode1([],C,H,[[H,C]]).
rle_encode1([H|T],Cnt,H2,R):-
    H is H2,
    !,
    C is Cnt+1,
    rle_encode1(T,C,H,R).
rle_encode1([H|T],C,H2,[[H2,C]|R]):-
    rle_encode1(T,1,H,R).

rotate_right(L,K,R):-
    rotate_right(L,K,0,R).
rotate_left([H|T],R):-
    append(T,[H],R).
rotate_right(L,K,C,R,R):-
    C < K,
    !,
    Cnt is C+1,
    rotate_left(Res,L),
    rotate_right(Res,K,Cnt,R).
rotate_right(R,_,_,R).
    

get_elem_k(L, K, R):-
    get_elem_k(L, 1, K, R).
get_elem_k([H|_], C, K, H):-
    C is K.
get_elem_k([_|L], C, N, R):-
    Cnt is C + 1,
    get_elem_k(L, Cnt, N, R).

rnd_select(_, 0, []).
rnd_select(L, K, [EK|R]):-
    K > 0,
    length(L, Len),
    Len1 is Len - 1,
    Rand1 is random(Len1),
    Rand is Rand1 + 1,
    Cnt is K - 1,
    get_elem_k(L, Rand, EK),
    rnd_select(L, Cnt, R).



