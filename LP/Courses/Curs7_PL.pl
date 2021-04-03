bplist00�_WebMainResource�	
_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameNameO�<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">%Incomplete trees

tree1(t(7, t(5,_,_),t(9,t(8,_,_),_))).
tree2(t(7, t(5,nil,nil),t(9,t(8,nil,nil),nil))).


search_it(_, T):-var(T),!,fail. 
search_it(Key,t(Key,_,_)):-!,
	 write('found').
search_it(Key, t(Key1,Left,_)):-
	Key&lt;Key1,!,
	search_it(Key,Left).
search_it(Key,t(_,_,Right)):-
	search_it(Key,Right).


%insert_it(Key, T):-var(T),T=t(Key,_,_),!. 
insert_it(Key,t(Key,_,_)):-!.
insert_it(Key, t(Key1,Left,_)):-
	Key&lt;Key1,!,
	insert_it(Key,Left).
insert_it(Key,t(_,_,Right)):-
	insert_it(Key,Right).


%Difference lists

insert_dl(X, LI, LE):- LE=[X|_].

%----------
%LI      LE
%
%          X
%-----------
%RI       RE


inorder_DL(nil,L,L).
inorder_DL(t(K,L,R), RS, RE):-
			inorder_DL(L, LLS, LLE), 
			inorder_DL(R, LRS, LRE),
			%append(LeftL, [K|RightL], Rez)
			RS = LLS,
			RE = LRE,
			LLE = [K|LRS].

postorder_DL(nil,L,L).
postorder_DL(t(K,L,R), RS, RE):-
			postorder_DL(L, LLS, LLE), %LLS = [...|LLE]
			postorder_DL(R, LRS, LRE), %LRS = [....|LRE]
			RS = LLS,
			LLE = LRS,
			LRE = [K|RE].

%%%%%%% TEMA %%%%%%%%
/*
0. trasati executia traversarilor pe arbori cu liste diferenta
1. Preorder cu Diff lists
2. quicksort cu difference lists
3. transformare din:
	- lista completa -&gt; lista incompleta
	- lista incompleta -&gt; lista completa
	- lista incompleta -&gt; lista diferenta
	- lista incompleta -&gt; lista diferenta
	- lista diferenta -&gt; lista completa
	- lista diferenta -&gt; lista incompleta
*/

%%%% SORTARI %%%%%
insert_fwd([H|T], Acc, Rez):- insert_ord(H, Acc, Acc1),
								insert_fwd(T, Acc1, Rez).
%....


insert_bwd([H|T], Rez):- insert_bwd(T, RI),
						 insert_ord(H, RI, Rez).

%.....

</pre></body></html>Ztext/plainUUTF-8_Shttps://moodle.cs.utcluj.ro/pluginfile.php/81594/mod_resource/content/1/Curs7_PL.plP    ( : P n } �ju{�                           �