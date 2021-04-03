%%%%%% seminar 5

%1. height bst

tree(t(6, t(4, t(2, nil, nil), t(5, nil, nil)), t(9, t(7, t(6, nil, t(6, nil, nil)), nil), nil))). 

max(A, B, A):-A>=B,!.
max(_, B, B).

% a=2, b=2, c=1 => O(n)
height(nil, 0).
height(t(_, L, R), H):-
    height(L, H1),
    height(R, H2),
    max(H1, H2, H12),
    H is H12+1.

%2. height left > height right

% a=2, b=2, c=1 => O(nlogn)
eqheight1(nil, nil).
eqheight1(t(K, L, R), t(K, NL, NR)):-
    height(L, H1),
    height(R, H2),
    H1 >= H2, !,
    eqheight1(L, NL),
    eqheight1(R, NR).

eqheight1(t(K, L, R), t(K, NR, NL)):-
                 eqheight1(L, NL),
                 eqheight1(R, NR).

% a=2, b=2, c=1 => O(n)
eqheight2(nil, nil, 0).
eqheight2(t(K, L, R), t(K, NNL, NNR), H):-
    eqheight2(L, NL, HL),
    eqheight2(R, NR, HR),
    setRoots(NL, NR, HL, HR, NNL, NNR, H).

setRoots(L, R, HL, HR, L, R, H):-
    HL >= HR,!,
    H is HL+1.
setRoots(L, R, _, HR, R, L, H):-
    H is HR+1.
    
% 3. BST with Lists as Keys

%a.) first occurence of an element

tree1(t([7,8,9], t([1, 2, 3], nil, nil), t([10, 11, 12], nil, nil))).
tree2(t([7,8,9|_], t([1, 2, 3|_], nil, nil), t([10, 11, 12|_], nil, nil))).
tree3(t([7,8,9], t([1, 2, 3], _, _), t([10, 11, 12], _, _))).
tree4(t([7,8,9|_], t([1, 2, 3|_], _, _), t([10, 11, 12|_], _, _))).

% X < H => caut in stanga
search_elem(t([H|_], L, _), X):-
     X < H, !,
     search_elem(L, X).

% caut in lista curenta
search_elem(t(List, _, _), X):-
    member(X, List), !. % cea mai eficienta variata ar fi sa merg cu member pana gasesc un element
                        % mai mare ca elementul meu, daca lista este ordonata

% daca X > ultimul element din lista curenta, caut pe dreapta
search_elem(t(List, _, R), X):-
    get_last(List, Y),
    X > Y, !,
    search_elem(R, X).


get_last([_|T], X):-
    get_last(T, X).

get_last([H], [H]).
    
%b. collect in inorder all keys

inorder(nil, []).
inorder(t(K, L, R), List):-
    inorder(L, L1),
    inorder(R, R1),
    append(K, R1, KR),
    append(L1, KR, List).

%c. inorder with diff lists

in_dif(nil, L, L).
in_dif(t(K, L, R), LS1, RE1):-
     in_dif(L, LS1, KS),
     in_dif(R, KE, RE1),
     list_to_dif(K, KS, KE).

list_to_dif([], L, L).
list_to_dif([H|T], [H|LS], LE):-
    list_to_dif(T, LS, LE).
    
%d. repeat 1-3 when Lists are incomplete lists

% X < H => caut in stanga

search_elem1(t([H|_], L, _), X):-
     X < H, !,
     search_elem1(L, X).

% caut in lista curenta
search_elem1(t(List, _, _), X):-
    member1(X, List), !. % cea mai eficienta variata ar fi sa merg cu member pana gasesc un element
                        % mai mare ca elementul meu, daca lista este ordonata

% daca X > ultimul element din lista curenta, caut pe dreapta
search_elem1(t(List, _, R), X):-
    get_last1(List, Y),
    X > Y, !,
    search_elem1(R, X).


member1(_, L):-var(L), !, fail. %case when the incomplete lists ends => variable
member1(X, [X|_]):-!. %case when found
member1(X, [_|T]):-member1(X, T). %continue the search on tail

get_last1([H|T], [H]):-var(T), !.
get_last1([_|T], X):-
    get_last1(T, X).

% b

inorder1(nil, []).
inorder1(t(K, L, R), List):-
    inorder1(L, L1),
    inorder1(R, R1),
    append1(K, R1, KR),
    append(L1, KR, List).
      
%L1 incompleta, L2 completa, L completa
append1(V, L, L):-var(V), !.
append1([H1|T1], L2, [H1|L]):-
      append1(T1, L2, L).

in_dif1(nil, L, L).
in_dif1(t(K, L, R), LS1, RE1):-
     in_dif1(L, LS1, KS),
     in_dif1(R, KE, RE1),
     incomplete_to_dif(K, KS, KE).

incomplete_to_dif(V, L, L):-var(V), !.
incomplete_to_dif([H1|T1], [H1|LS], LE):-
    incomplete_to_dif(T1, LS, LE).
    
%e. incomplete tree

%a. search 

% X < H => caut in stanga

search_elem2(T, _):-var(T), !, fail.

search_elem2(t([H|_], L, _), X):-
     X < H, !,
     search_elem2(L, X).

% caut in lista curenta
search_elem2(t(List, _, _), X):-
    member(X, List), !. % cea mai eficienta variata ar fi sa merg cu member pana gasesc un element
                        % mai mare ca elementul meu, daca lista este ordonata

% daca X > ultimul element din lista curenta, caut pe dreapta
search_elem2(t(List, _, R), X):-
    get_last(List, Y),
    X > Y, !,
    search_elem2(R, X).

inorder2(T, []):-var(T), !.
inorder2(t(K, L, R), List):-
    inorder2(L, L1),
    inorder2(R, R1),
    append(K, R1, KR),
    append(L1, KR, List).
      
in_dif2(T, L, L):- var(T), !.
in_dif2(t(K, L, R), LS1, RE1):-
     in_dif2(L, LS1, KS),
     in_dif2(R, KE, RE1),
     list_to_dif(K, KS, KE).    
    
% f

% X < H => caut in stanga

search_elem3(T, _):-var(T), !, fail.

search_elem3(t([H|_], L, _), X):-
     X < H, !,
     search_elem3(L, X).

% caut in lista curenta
search_elem3(t(List, _, _), X):-
    member1(X, List), !. % cea mai eficienta variata ar fi sa merg cu member pana gasesc un element
                        % mai mare ca elementul meu, daca lista este ordonata

% daca X > ultimul element din lista curenta, caut pe dreapta
search_elem3(t(List, _, R), X):-
    get_last1(List, Y),
    X > Y, !,
    search_elem3(R, X).

inorder3(T, []):-var(T), !.
inorder3(t(K, L, R), List):-
    inorder3(L, L1),
    inorder3(R, R1),
    append1(K, R1, KR),
    append(L1, KR, List).
      
in_dif3(T, L, L):- var(T), !.
in_dif3(t(K, L, R), LS1, RE1):-
     in_dif3(L, LS1, KS),
     in_dif3(R, KE, RE1),
     incomplete_to_dif(K, KS, KE).  


    
    