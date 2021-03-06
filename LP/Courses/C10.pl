bplist00?_WebMainResource?	
^WebResourceURL_WebResourceFrameName_WebResourceData_WebResourceMIMEType_WebResourceTextEncodingName_Nhttps://moodle.cs.utcluj.ro/pluginfile.php/82610/mod_resource/content/1/C10.plPO?<html><head></head><body><pre style="word-wrap: break-word; white-space: pre-wrap;">
%%%%%%%% C10 PL - Graphs representation and %%%%%%%%%%%
% G = {(a,b), (a,c), ...}
% G = {n(a, [b,c]), n(b, [d, e]), ...}
edge(a,b).
edge(a,c).
edge(b,a).
edge(b,c).
edge(c,d).
edge(c,e).
edge(e,f).
edge(c,f).
edge(f,a).
%edge(g,nil).

is_edge(X,Y):-
		edge(X,Y);
		edge(Y,X).

n(a,[b,c]).
n(b,[a,c]).
n(c,[d,e,f]).
n(e,[f]).
%n(g, []).


%path(X,Y,Path) X - start node, Y - end node, Path - result 

%v1
path(X,X,_,[X]).
path(X,Y,Ppath,[X|Path]):-
					edge(X,Z),
					not(member(Z,Ppath)),
					path(Z,Y,[Z|Ppath],Path).

path(X,Y,P):-path(X,Y,[X],P).

cycle(X,[X|Cycle]):-
			edge(X,Z),
			path(Z,X,Cycle),
			length(Cycle, L),
			L&gt;=3.

%v2
ppath(X,X,P,P).
ppath(X,Y,Ppath,Path):-
					edge(X,Z),
					not(member(Z,Ppath)),
					append(Ppath, [Z], NPPath),
					ppath(Z,Y,NPPath,Path).

%Tema: combinati logica de not member si append pe un singur predicat

%v3
path_sideEff(X,Y,P):- /*retractall(vertex(_)),*/ assert(vertex(X)), pppath(X,Y,P).
path_sideEff(_,_,_):-retract(vertex(_)),!.

:- dynamic vertex/1.
pppath(X,X,[X]).   % Path):-findall(Z,vertex(Z),Path).%collect([],Path).
pppath(X,Y,[X|Path]):-
		edge(X,Z),
		check_accept(Z),
		pppath(Z,Y,Path).

check_accept(X):-
		vertex(X), 
		!,
		fail.
check_accept(X):-
		assertz(vertex(X)).
check_accept(X):-
		retract(vertex(X)),
		!,
		fail.

collect(PP,Res):-vertex(X),
			not(member(X,PP)),!,
			collect([X|PP], Res).
collect(PP,PP).

%%%%%%%%%%

findAllPaths(X,Y,_):-
			path(X,Y,Path),
			savePath(Path),
			fail.
findAllPaths(_,_,Paths):-collectPaths(Paths).


findAllPaths2(X,Y,Paths):-findall(P,path(X,Y,P),Paths).

%%%%%%%%%%%%%









</pre></body></html>Ztext/plainUUTF-8    ( 7 N ` v ? ? ???                           ?