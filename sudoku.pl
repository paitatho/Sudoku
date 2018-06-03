%C=1
afficherGrille([],82).
afficherGrille([],C) :- mod(C,27) =:=0,!, writeln(" "),writeln("_____________________________"),Tmp is C+1,afficherGrille([],Tmp).
afficherGrille([],C) :- mod(C,9) =:= 0,!,writeln(" ") , ! ,Tmp is C +1,afficherGrille([],Tmp).
afficherGrille([],C) :- mod(C,3) =:= 0,!,write("      "),write(" |"),!,Tmp is C+1, afficherGrille([],Tmp).
afficherGrille([],C) :- write(" "), !,Tmp is C +1,afficherGrille([],Tmp).
afficherGrille([X|Y],C) :- mod(C,27) =:=0,!, write(" "),writeln(X),writeln("_____________________________"),Tmp is C+1,afficherGrille(Y,Tmp).
afficherGrille([X|Y],C) :- mod(C,9) =:= 0,!,write(" "),writeln(X), !, Tmp is C+1, afficherGrille(Y,Tmp).
afficherGrille([X|Y],C) :- mod(C,3) =:= 0,!,write(" "),write(X),write(" |"),!,Tmp is C+1, afficherGrille(Y,Tmp).
afficherGrille([X|Y],C) :- C =< 81,!,  write(" "),write(X),write(" "), Tmp is C+ 1,afficherGrille(Y,Tmp).

:- dynamic grille/1.
grille([" ",4," ",1," "," "," "," "," "," "," ",3,5," "," "," ",1,9," "," "," "," "," ",6," "," ",3," "," ",7," "," ",5," "," ",8," ",8,1," "," "," ",9,6," ",9," "," ",2," "," ",7," "," ",6," "," ",9," "," "," "," "," ",8,1," "," "," ",2,4," "," "," "," "," "," "," ",4," ",9," "]).

%C = 1 %CC = 9
valideLC([],C,CC) :- !.
valideLC([],82,CC) :- !.
valideLC([X|Y],C,CC) :- X=:=" ", mod(C,9) =:= 0, Tmp is CC-1, ! ,TTmp is C+1,valideLC(Y,TTmp,Tmp),!.
valideLC([X|Y],C,CC) :- X=:=" ", TTmp is C+1,valideLC(Y,TTmp,CC),!.
valideLC([X|Y],C,CC) :- mod(C,9) =:= 0,valideColonne(X,Y,1,CC),Tmp is CC-1, ! ,TTmp is C+1,valideLC(Y,TTmp,Tmp).
valideLC([X|Y],C,CC) :- Tmp is 9-mod(C,9), valideLigne(X,Y,Tmp),valideColonne(X,Y,1,CC), TTmp is C+1,valideLC(Y,TTmp,CC).

valideLigne(V,[],C) :- !.
valideLigne(V,Y,0) :- !.
valideLigne(V,[X|Y],C) :- X =:= V , ! , fail.%write(V),write(" "),write(X),write(" "),write(C),writeln(" ")
valideLigne(V,[X|Y],C) :-Tmp is C-1, valideLigne(V,Y,Tmp).

valideColonne(V,[],C,CC) :- !.
valideColonne(V,Y,C,0) :- !.
valideColonne(V,[X|Y],C,CC) :- mod(C,9) =\= 0, Tmp is C+1, ! ,valideColonne(V,Y,Tmp,CC).
valideColonne(V,[X|Y],C,CC) :- X =:= V , ! , fail.%write(V),write(" "),write(X),write(" "),write(CC),writeln(" "),
valideColonne(V,[X|Y],C,CC) :- Tmp is C+1,TTmp is CC-1, valideColonne(V,Y,Tmp,TTmp).

%C = 1 %CC= 0
transfCarreLigne(Q,Y,C,3):- !.
transfCarreLigne(Q,[],C,CC):-!.
transfCarreLigne(Q,[X|Y],C,CC):- C=:=9,Tmp is CC +1,!,transfCarreLigne(Q,Y,1,Tmp).
transfCarreLigne([X],[X|Y],C,CC):- C=:=3,CC=:=2,!,Tmp is CC+1,transfCarreLigne(X,Y,C,Tmp).
transfCarreLigne([X|Q],[X|Y],C,CC):- C=<3 ,!,Tmp is C+1, transfCarreLigne(Q,Y,Tmp,CC).
transfCarreLigne(Q,[X|Y],C,CC):- C<9,Tmp is C+1,transfCarreLigne(Q,Y,Tmp,CC).

transfColonneLigne([X],[X|Y],J,8,0):-!.
transfColonneLigne([X|Q],[X|Y],1,CC,Ok):- Ok=:=0,!,Tmp is CC+1,transfColonneLigne(Q,Y,1,Tmp,1).
transfColonneLigne(Q,[X|Y],1,CC,Ok):- Ok<9,!,Tmp is Ok+1,transfColonneLigne(Q,Y,1,CC,Tmp).
transfColonneLigne(Q,Y,1,CC,Ok):- Ok=:=9,!,transfColonneLigne(Q,Y,1,CC,0).
transfColonneLigne(Q,[X|Y],J,CC,Ok):- Tmp is J-1,!,transfColonneLigne(Q,Y,Tmp,CC,Ok).

transfLigneLigne([X],[X|Y],0,8):-!.
transfLigneLigne([X|Q],[X|Y],0,C):-Tmp is C+1,!,transfLigneLigne(Q,Y,0,Tmp).
transfLigneLigne(S,[X|Y],I,C):- Tmp is I-1,!,transfLigneLigne(S,Y,Tmp,C).

trouverCarre(I,J,-1,-1,IT,JT):-!,IT is I-2,JT is J-2.
trouverCarre(I,J,II,-1,IT,JT):-!,IT is I-II,JT is J-2.
trouverCarre(I,J,-1,JJ,IT,JT):-!,IT is I-2,JT is J-JJ.
trouverCarre(I,J,3,3,IT,JT):-!,Tmp is mod(I,3)-1,Tmp2 is mod(J,3)-1,trouverCarre(I,J,Tmp,Tmp2,IT,JT).
trouverCarre(I,J,II,JJ,IT,JT):-!,IT is I-II,JT is J-JJ.

valideCarreI(X,0):-!,transfCarreLigne(Ligne,X,1,0),validTteLigne(Ligne).
valideCarreI([X|Y],C):- Tmp is C-1,valideCarreI(Y,Tmp).

validTteLigne([]):- !.
validTteLigne([T|Q]):- T =:= " ", validTteLigne(Q),!.
validTteLigne([T|Q]):- valideLigne(T,Q,9), validTteLigne(Q).

t(J):-grille(X),transfColonneLigne(Col,X,J,0,0),writeln(Col).

valideModif(I,J):-grille(X),transfColonneLigne(Col,X,J,0,0),validTteLigne(Col),Tmp is (I-1)*9,transfLigneLigne(Lig,X,Tmp,0),validTteLigne(Lig),trouverCarre(I,J,3,3,IC,JC),Tmp1 is (IC-1)*9+(JC-1),valideCarreI(X,Tmp1).
valideModif(I,J,X):-transfColonneLigne(Col,X,J,0,0),validTteLigne(Col),Tmp is (I-1)*9,transfLigneLigne(Lig,X,Tmp,0),validTteLigne(Lig),trouverCarre(I,J,3,3,IC,JC),Tmp1 is (IC-1)*9+(JC-1),valideCarreI(X,Tmp1).


%C=0 %CC=1 %Fin=0
valideCarre(Y,C,CC,9):- !.
valideCarre([],C,CC,Fin):- !.
valideCarre(Y,C,CC,Fin):- C=:=0,CC=<3,!,transfCarreLigne(Ligne,Y,1,0),validTteLigne(Ligne),Tmp3 is C+1,Tmp is Fin+1,Tmp2 is CC+1,valideCarre(Y,Tmp3,Tmp2,Tmp). %test le premier carre
valideCarre([X|Y],C,CC,Fin):- C=<3,CC=<3,!,Tmp is C+1,valideCarre(Y,Tmp,CC,Fin). %+3 pour aller au carré suivant
valideCarre(Y,C,CC,Fin):- C=:=4,!,valideCarre(Y,0,CC,Fin).  %test carre suivant en mettant C à 0
valideCarre([X|Y],C,CC,Fin):- CC=<21,!,Tmp is CC+1,valideCarre(Y,C,Tmp,Fin). %quand on a fait 3 carré d une ligne on en saute 2 pour aller aux autres carrés
valideCarre(Y,C,CC,Fin):- valideCarre(Y,C,1,Fin).

valideGrille() :- grille(X),valideLC(X,1,9),valideCarre(X,0,1,0).
afficher():- grille(X),afficherGrille(X,1).
valideGrille(X):- valideLC(X,1,9),valideCarre(X,0,1,0).
vc() :- grille(X),valideCarre(X,0,1,0).
tf():- grille(X),transfCarreLigne(L,X,1,0),writeln(L).


modif(0,[Val|Y],[X|Y],Val):-!.
modif(CC,[X|Q],[X|Y],Val):- Tmp is CC-1,modif(Tmp,Q,Y,Val).

modifier(I,J,Val):- Val <10,grille(X),Tmp is J-1+(I-1)*9,modif(Tmp,New,X,Val),valideModif(I,J,New),!,retract(grille(X)),assert(grille(New)),afficher().
modifier(I,J,Val):- writeln("votre choix n'est pas valide ou ne permet pas d'obtenir une solution"),afficher().


modifierSolver(I,J,Val):- grille(X),Tmp is J+(I)*9,modif(Tmp,New,X,Val),II is I+1,JJ is J+1,valideModif(II,JJ,New),!,retract(grille(X)),assert(grille(New)).

init():- retractall(grille(_)), assert(grille([" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "])).
reset():- retractall(grille(_)),consult('sudoku.pl').

solver(S,[],C):-!,grille(S),afficher().
solver(S,L,81):-!,grille(S),afficher().
solver(S,[T|Q],C):- T =\= " ",!,Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,1),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,2),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,3),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,4),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,5),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,6),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,7),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,8),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,9),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[T|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J," "),fail.

solve(X):- grille(Y),writeln("Loading..."),solver(X,Y,0).

gen(0):-!.
gen(Y):-Val is random(9)+1,I is random(10),J is random(10),modifierSolver(I,J,Val),!,Tmp is Y-1,gen(Tmp).
gen(Y):-gen(Y).
genererSol(X):-init(),Tmp is random(8)+1,gen(Tmp),solve(X),!.
genererSol(X):-genererSol(X).
%#########################################Fonction Utile#####################################################
%modifier(I,J,Val) met la valeur val à la case I J
%solve(X) résoud la grille stocké dans le prédicat grille() et met la solution dans X et dans le prédicat grille()
%init() met dans le prédicat grille une grille vide
%reset() recharge sudoku.pl
%afficher() affiche la grille dans le prédicat grille()
%valideGrille() valide la grille courante
%genererSol(X) genere une solution et la met dans X
