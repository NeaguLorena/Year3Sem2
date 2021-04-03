tree0(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(10,t(7,nil,nil),nil))).
tree1(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),nil))).
tree2(t(8, t(5, nil, t(7, nil, nil)), t(9, nil, t(11, nil, t(14, nil, nil))))).
tree3(t(6, t(4,t(2,nil,nil,nil),nil,t(7,nil,nil,nil)),t(5,nil,nil,nil),t(9,t(3,nil,nil,nil),nil,nil))).
tree_sim(t(6, t(4,t(2,nil,nil),t(5,nil,nil)), t(9,t(7,nil,nil),t(10,nil,nil)))).

pretty_print(nil, _).
pretty_print(t(K,L,R), D):-D1 is D+1, 
						   pretty_print(L, D1), 
						   print_key(K, D), 
						   pretty_print(R, D1). 
% predicat care afișeazăcheia K la D tab-uri fațăde marginea din stângași insereazăo linie nouă
print_key(K, D):-D>0, !, D1 is D-1, 
				 write('\t'), 
				 print_key(K, D1).
print_key(K, _):-write(K), write('\n').
% write('\n') îi echivalent cu predicatul nl

height(nil, 0).
height(t(_, L, R), H):-height(L, H1), 
					   height(R, H2),
					   max(H1, H2, H3), 
					   H is H3+1.

max(A,B,A) :- A>B,!.
max(_,B,B).


% Inaltimea subarborelui stang >= Inaltimea subarborelui drept
% Medium - O(n*n)
% Worst - O(n*n)
eqheight(nil,nil) :- !.
eqheight(t(K,L,R),t(K,NL,NR)):-eqheight(L,NL),
							   eqheight(R,NR),
							   height(NL,HL),
							   height(NR,HR),
							   HL >= HR, !.
eqheight(t(K,L,R),t(K,NR,NL)):-eqheight(L,NL),
							   eqheight(R,NR).

% Scapam de reapelarea eqheight pe stanga si dreapta
% deoarece rezultatul nu se schimba
% Medium - O(n*log(n))
% Worst - O(n*n)
eqheight2(nil,nil) :- !.
eqheight2(t(K,L,R),t(K,RL,RR)):-eqheight2(L,NL),
							    eqheight2(R,NR),
							    height(NL,HL),
							    height(NR,HR),
							    decision(HL,HR,NL,NR,RL,RR).

decision(HL,HR,NL,NR,RL,RR) :- HL >= HR, !,
							   RL = NL,
							   RR = NR.
decision(_,_,NL,NR,NR,NL).

% Integram calculul intaltimii in apelul eqheight
% Medium - O(n)
% Worst - O(n)
eqheight3(nil,nil,-1) :- !.
eqheight3(t(K,L,R),t(K,RL,RR),H):-eqheight3(L,NL,HL),
							      eqheight3(R,NR,HR),
							      decision2(HL,HR,NL,NR,RL,RR,H).

decision2(HL,HR,NL,NR,RL,RR,H) :- HL >= HR, !,
								  H is HL + 1,
							      RL = NL,
							      RR = NR.
decision2(_,HR,NL,NR,NR,NL,H)  :- H is HR + 1.




treeList(t([3,4,5], t([2,3], nil, nil), t([5,6], nil,t([7,8], nil, nil)))).

% O(n*m) - n noduri arbore; m elemente in liste
find(t(Keys,_,_),K)  :- memberOrdered(K,Keys), !. % gasim cheia in lista ne oprim
find(t([H|_],L,_),K) :- K < H, !, find(L,K).  %cautam pe stanga, daca gasim ne oprim
find(t(_,_,R),K)     :- find(R,K).   %cautam pe dreapta daca nu am gasit


% Se opreste daca gasim un element < K
% lista trebuie ordonata
memberOrdered(K, [K|_]) :- !.
memberOrdered(K, [H|_]) :- K < H, !, fail.
memberOrdered(K, [_|T]) :- memberOrdered(K,T).
% 1 2 4 ; K = 3

memberOrdered2(_, [],    0) :- !.    % am ajuns la finalul listei si nu am gasit
memberOrdered2(K, [K|_], 1) :- !.    % am gasit
memberOrdered2(K, [H|_], 2) :- K < H, !. % nu am gasit, suntem in interiorul listei
memberOrdered2(K, [_|T], F) :- memberOrdered2(K,T,F).

% O(m * log(n))
find2(t([H|_],L,_),K) :- K < H, !, find2(L,K).  %cautam pe stanga, daca gasim ne oprim
find2(t(Keys,_,R),K)  :- memberOrdered2(K,Keys,F),
						( 
						  (F = 1, !);        %am gasit elementul, ne oprim
						  (F = 2, !, fail);  %ne oprim, pe dreapta nu mai poate fi
						  (F = 0, find2(R,K)) %cautam pe dreapta daca nu am gasit
						). 

collect_list(nil, []).						
collect_list(t(K,L,R),List) :- collect_list(L,LL),
							   collect_list(R,LR),
							   append(LL,K,LI),
							   append(LI,LR,List).					 


%cand ajungem la lista vida initializam lista dif ca lista dif vida
convert_l_dl([], L, L) :- !.
%parcurgem lista si concatenam H la list start
convert_l_dl([H|T],[H|LS],LE) :- convert_l_dl(T, LS,LE).

collect_listd(nil, X, X).						
collect_listd(t(K,L,R),LF, LN) :- collect_listd(L,LLF, LLN),
							      collect_listd(R,LRF, LRN),
							      convert_l_dl(K, KF, KN),
							      LF = LLF,
							      LLN = KF,
							      KN = LRF,
							      LN = LRN.	



% Seminar 6 - P2
rotate_l(t(K,t(KK,LL,LR),R),t(KK,LL,t(K,LR,R))).

transf_t(nil, nil).
transf_t(t(K,nil,R),t(K,nil,NR)) :- transf_t(R, NR), !.
transf_t(T,RT) :- rotate_l(T,NT),
			      transf_t(NT,RT).