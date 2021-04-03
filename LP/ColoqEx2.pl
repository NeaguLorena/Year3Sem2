%Variant A - Row 1

%Replace each constant depth sequence in a deep list with its length.
%E.g: ?- len_con_depth([[1,2,3],[2],[2,[2,3,1],5],3,1],R).
%R = [[3],[1],[1,[3],1],2];
%no.

len_con_depth([],N,Acc,R):-N\=0, !, append(Acc, [N], R).
len_con_depth([],_,R,R).
len_con_depth([H|T],N,Acc,R):-atomic(H), !, N1 is N+1, len_con_depth(T, N1, Acc, R).
len_con_depth([H|T],N,Acc,R):-len_con_depth(H,R1), N\=0, !, append(Acc, [N], R2), append(R2, [R1], R3), len_con_depth(T, 0, R3, R).
len_con_depth([H|T],_,Acc,R):-len_con_depth(H,R1), append(Acc, [R1], R3), len_con_depth(T, 0, R3, R).

len_con_depth(L,R):-len_con_depth(L, 0, [], R).



%You are given a binary tree.
%a. Write a predicate which checks whether the tree is a binary search tree.
%b. Write a predicate which replaces the entire subtree of a node (whose key is
%given as argument) with a single node having as key the sum of the keys in the
%subtree of that node (if there is no such node in the tree, leave the structure
%unchanged).

tree1(
    t(14,
        t(6,
            t(4,nil,nil),
            t(12,
                t(10,nil,nil),
                nil)
            ),
        t(17,
            t(16,nil,nil),
            t(20,nil,nil)
        )
    )
).

%a.

check_binary(t(K,t(KL,LL,LR), t(KR,RL,RR))):-K>KL, K<KR, check_binary(t(KL, LL, LR)), check_binary(t(KR,RL,RR)).
check_binary(t(K,t(KL,LL,LR),nil)):-K>KL, check_binary(t(KL, LL, LR)).
check_binary(t(K,nil,t(KR,RL,RR))):-K<KR, check_binary(t(KR,RL,RR)).
check_binary(t(_,nil,nil)).


%b.

replace_subtree(SK, t(K, L, R), t(K, Res, R)):-K>SK, replace_subtree(SK, L, Res).
replace_subtree(SK, t(K, L, R), t(K, L, Res)):-K<SK, replace_subtree(SK, R, Res).
replace_subtree(K, t(K, L, R), t(Sum, nil, nil)):-obtain_sum(t(K, L, R), Sum).

obtain_sum(t(K, L, R), Sum):-obtain_sum(L, SL), obtain_sum(R, SR), Sum is SR + SL + K.
obtain_sum(nil, 0).



%Variant B - Row 2

%You are given a list having as elements incomplete lists of integers
%(the inner lists are incomplete).

%a. Write the Prolog predicate(s) which returns the inner list that contains the
%minimum integer in the entire structure.

get_list_with_min([H|T], Min, _, R):-find_min(H, M), M<Min, get_list_with_min(T, M, H, R).
get_list_with_min([_|T], Min, Acc, R):-get_list_with_min(T, Min, Acc, R).
get_list_with_min([], _, R, R).

get_list_with_min([H|T], R):-find_min(H, M), get_list_with_min(T, M, H, R).

find_min(L, M, M):-var(L), !.
find_min([H|T], Min, M):-H<Min, !, find_min(T, H, M).
find_min([_|T], Min, M):-find_min(T, Min, M).

find_min([H|T], M):-find_min(T, H, M).

%b. Write the Prolog predicate(s) to replace all the occurrences of a given atomic
%element in the entire structure, with a new element (also given).

replace_all(A,B,[H|T],[HRes|R]):-replace_all(A,B,T,R), replace_incomplete(A,B,H,HRes).
replace_all(_,_,[],[]).

replace_incomplete(_,_,L,L):-var(L), !.
replace_incomplete(A,B,[A|T],[B|R]):-!,replace_incomplete(A,B,T,R).
replace_incomplete(A,B,[H|T],[H|R]):-replace_incomplete(A,B,T,R).


%You are given a binary search tree. Write the Prolog predicate(s) which
%collects, using difference lists, all the keys having values between K1 and K2 (given)
%inclusive and found in inner nodes.

collect_keys(Low, High, t(K, L, _), LSt, LEn):-K>High, !, collect_keys(Low, High, L, LSt, LEn).
collect_keys(Low, High, t(K, _, R), LSt, LEn):-K<Low, !, collect_keys(Low, High, R, LSt, LEn).
collect_keys(_, _, t(_,nil, nil), L, L):-!.
collect_keys(_, _, nil, L, L):-!.
collect_keys(Low, High, t(K, L, R), LLSt, RLEn):-collect_keys(Low, High, L, LLSt, LLEn), collect_keys(Low, High, R, RLSt, RLEn), LLEn=[K|RLSt].