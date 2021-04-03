member1(X, [X|_]).
member1(X, [_|T]):-
    member1(X,T).
%for trace  " member1(X, [1 ,2 ,3 , 4]).", by using variable X, the question may be repeated
%for "trace,  member1(X, [a, b, c, d]). " if we reverse the order of the two clauses of predicate 
%member1(X, L), variable X will take values recursively from d to a and will fail 
%only once compared to this order of clauses which fails 5 times.

append1([], L, L).
append1([H|T], L, [H|R]):-
    append1(T, L, R).
%trace "append1([1, [2]], [3|[4, 5]], R)." will result R = [1, [2], 3, 4, 5]
%achieved by putting in R the list L concatenated recursively with head H.
%when returning from each recursion: first, first list will be empty and R will be L ([3,4,5]),
%then first parameter will be [[2]], head will be [2] so R will be [[2],3,4,5],
%lastly first parameter will have [1,[2]] and the head, which is [1] will pe concatenated
%to R and will result [1,[2],3,4,5].
%for "append1(T, L, [1, 2, 3, 4, 5]).", we obtain all the possible 
%decompositions of the list in two sub-lists by repeating the query.
%for "append1(_, [X|_], [1, 2, 3, 4, 5]).", variable X will take values from 1 to 5

%changed order
append2([H|T], L, [H|R]):-
    append1(T, L, R).
append2([], L, L).
%trace "append1([1, [2]], [3|[4, 5]], R)." will result the same but order of recursion is reversed
%for "append2(_, [X|_], [1, 2, 3, 4, 5]).", variable X will take values from 2 to 5, and lastly value 1

%deletes first occurence of X
% element found in head of the list, don’t add it to the result
delete(X, [X|T], T).
%traverse the list, add the elements H≠X back to the result
delete(X, [H|T], [H|R]):-
    delete(X, T, R).
delete(_, [], []).

%deletes all occurences of X in list
delete_all(X, [X|T], R):-
    delete_all(X, T, R).
delete_all(X, [H|T], [H|R]):-
    delete_all(X, T, R). 
delete_all(_, [], []).
%for trace: "delete_all(X, [1, 2, 4], R).", X will take values 1,2,4 and will output 3 solutions when we repeat the question


%Quiz
append3(L1, L2, L3, R):-
    append1(L1,L2,R1),
    append1(R1,L3,R).

add_beginning(X,L,R):-
    append1([X],L,R).

sum_list([],Res,Res).
sum_list([H|T],R,Res):-
    R1 is R+[H],
    sum_list(T,R1,Res).
calc_sum(L,Res):-
    sum_list(L,0,Res).


%Problems
separate_parity([],[],[]).
separate_parity([H|T], [H|E], O):-
    0 is H mod 2,
    separate_parity(T,E,O).
separate_parity([H|T], E, [H|O]):- 
    1 is H mod 2,
    separate_parity(T,E,O).

remove_duplicates([],[]).
remove_duplicates([H|T],R):-
    member1(H,T),
    remove_duplicates(T,R).
remove_duplicates([H|T],[H|R]):-
    \+member1(H,T),
    remove_duplicates(T,R).

replace_all(_,_,[],[]).
replace_all(X,Y,[H|T],[Y|R]):-
    X is H,
    replace_all(X,Y,T,R).
replace_all(X,Y,[H|T],[H|R]):-
    \+X is H,
    replace_all(X,Y,T,R).

drop_k(L,X,R):-
    dropp(L,X,1,R).
dropp([],_,_,[]).
dropp([H|T],K,C,[H|R]):-
    C \= K,
    CC is C+1,
    dropp(T,K,CC,R).
dropp([_|T],K,C,R):-
    C is K,
    dropp(T,K,1,R).

    
    
    



