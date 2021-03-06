bplist00?_WebMainResource?	
_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName^WebResourceURL_WebResourceFrameNameO5<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">% PL curs 8
m(X,[X|_]):-!.
m(X,[_|T]):-m(X,T).

%some_pred_dl([],L,L).

/*
|------|   |-------|
L1S   L1E  L2S    L2E

|------------------|
RS                 RE

RS  = L1S -&gt; RS vine neinstantiat de sus (apel)
L1E = L2S -&gt; L1E e neinstantiat (L1 e lista incompleta, iar L1E e var de la final)
RE  = L2E -&gt; L2E e neinstantiat (L2 e lista incompleta, iar L2E e var de la final )

*/

reverse([H|T], Acc, Rez):- reverse(T, [H|Acc], Rez).
reverse([],Acc,Acc).

/*

 |------|
RIS    RIE

 |------|H|
 RS       RE

*/

reverse_DL([H|T], RS, RE):-reverse_DL(T, RIS, RIE),
							RIS = RS,
							RIE = [H|RE].
reverse_DL([],L,L).
							

reverse_DLi([H|T], RS, RE):-reverse_DLi(T, RS, [H|RE]).
reverse_DLi([],L,L).

diff2inc(F,L,_):- F==L,!.
diff2inc([H|T], L, [H|R]):- diff2inc(T,L,R).

%%%%%%%%%%%%%%%%%%%%% S3-4 %%%%%%%%%%%%%%%%%%%%%%%%

% sublist
/*				L
 |--------|---------------|------|
          |---------------|
          			SL
*/
%sublist(SL,L):-append3(_,SL,_,L).


% min_del backward recursion - sa stearga o aparitie a minimului

min(M, [H|T]):-min(M1, T), H&gt;M1, !, M=M1.
min(H, [H|_]).

min_del(M,[H|T],R):-min_del(M1,T,RP),H&gt;=M1,!,M=M1,R=[H|RP].
min_del(H,[H|T],T).


%bsort

bsort(L,R):-append(A,[H1,H2|B],L),
			write(H1), write(' - '), write(H2),nl,
			H1&gt;H2,
			!,
			append(A,[H2,H1|B],LL),
			write(LL),
			nl,
			bsort(LL,R).
bsort(L,L).


sel_sort_fwd(L, Acc, R):-max_del(L,M,LL), sel_sort_fwd(LL,[M|Acc], R).
sel_sort_fwd([],Acc,Acc).












</pre></body></html>Ztext/plainUUTF-8_Phttps://moodle.cs.utcluj.ro/pluginfile.php/81820/mod_resource/content/1/PL_C8.plP    ( : P n } ????1                           2