%Pour lancer le jeu, écrire le prédicat : lancer().

%------------------------------------------------------------------------------------------------------------------------------------------------------------
%INITIALISATION

:- dynamic grilleCourante/1.
grilleCourante([" ",4," ",1," "," "," "," "," "," "," ",3,5," "," "," ",1,9," "," "," "," "," ",6," "," ",3," "," ",7," "," ",5," "," ",8," ",8,1," "," "," ",9,6," ",9," "," ",2," "," ",7," "," ",6," "," ",9," "," "," "," "," ",8,1," "," "," ",2,4," "," "," "," "," "," "," ",4," ",9," "]).

:- dynamic solution/1.
solution([]).

:- dynamic grilleDepart/1.
grilleDepart([]).

%initialise la grille de Sudoku
initCourante():- retractall(grilleCourante(_)), assert(grilleCourante([" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "])).
initDepart():- retractall(grilleDepart(_)), assert(grilleDepart([" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "])).
initSolution():- retractall(solution(_)), assert(solution([" "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "," "])).


%charge le fichier
reset():- retractall(grilleCourante(_)),retractall(solution(_)),retractall(grilleDepart(_)),consult('sudoku.pl').


%---------------------------------------------------------------------------------------------------------------------------------------------------------------
%GESTION MEMOIRE DYNAMIQUE

updateGrilleCourante(X):-retractall(grilleCourante(_)), assert(grilleCourante(X)).
updateSolution(X):- retractall(solution(_)), assert(solution(X)).
updateGrilleDepart(X):- retractall(grilleDepart(_)),assert(grilleDepart(X)).


%------------------------------------------------------------------------------------------------------------------------------------------------------------
%AFFICHAGE

%C=1
afficherGrille([],82):- !.
afficherGrille([],C) :- mod(C,27) =:=0,!, writeln(" "),writeln("_____________________________"),Tmp is C+1,afficherGrille([],Tmp).
afficherGrille([],C) :- mod(C,9) =:= 0,!,writeln(" ") , ! ,Tmp is C +1,afficherGrille([],Tmp).
afficherGrille([],C) :- mod(C,3) =:= 0,!,write("      "),write(" |"),!,Tmp is C+1, afficherGrille([],Tmp).
afficherGrille([],C) :- write(" "), !,Tmp is C +1,afficherGrille([],Tmp).
afficherGrille([X|Y],C) :- mod(C,27) =:=0,!, write(" "),writeln(X),writeln("_____________________________"),Tmp is C+1,afficherGrille(Y,Tmp).
afficherGrille([X|Y],C) :- mod(C,9) =:= 0,!,write(" "),writeln(X), Tmp is C+1, afficherGrille(Y,Tmp).
afficherGrille([X|Y],C) :- mod(C,3) =:= 0,!,write(" "),write(X),write(" |"),!,Tmp is C+1, afficherGrille(Y,Tmp).
afficherGrille([X|Y],C) :- C =< 81, write(" "),write(X),write(" "), Tmp is C+ 1,afficherGrille(Y,Tmp).

afficherDepart():-grilleDepart(X),afficherGrille(X,1).
afficherSolution():-solution(X),afficherGrille(X,1).
afficherCourante():-grilleCourante(X),afficherGrille(X,1).


%------------------------------------------------------------------------------------------------------------------------------------------------------------
%VERIFICATION DU RESPECT DES REGLES DU SUDOKU

%C = 1 %CC = 9
valideLC([],_,_) :- !.
valideLC([],82,_) :- !.
valideLC([X|Y],C,CC) :- X=:=" ", mod(C,9) =:= 0, Tmp is CC-1, ! ,TTmp is C+1,valideLC(Y,TTmp,Tmp),!.
valideLC([X|Y],C,CC) :- X=:=" ", TTmp is C+1,valideLC(Y,TTmp,CC),!.
valideLC([X|Y],C,CC) :- mod(C,9) =:= 0,valideColonne(X,Y,1,CC),Tmp is CC-1, ! ,TTmp is C+1,valideLC(Y,TTmp,Tmp).
valideLC([X|Y],C,CC) :- Tmp is 9-mod(C,9), valideLigne(X,Y,Tmp),valideColonne(X,Y,1,CC), TTmp is C+1,valideLC(Y,TTmp,CC).

valideLigne(_,[],_) :- !.
valideLigne(_,_,0) :- !.
valideLigne(V,[V|_],_) :- ! , fail.
valideLigne(V,[_|Y],C) :-Tmp is C-1, valideLigne(V,Y,Tmp).

valideColonne(_,[],_,_) :- !.
valideColonne(_,_,_,0) :- !.
valideColonne(V,[_|Y],C,CC) :- mod(C,9) =\= 0, Tmp is C+1, ! ,valideColonne(V,Y,Tmp,CC).
valideColonne(V,[V|_],_,_) :- ! , fail.
valideColonne(V,[_|Y],C,CC) :- Tmp is C+1,TTmp is CC-1, valideColonne(V,Y,Tmp,TTmp).

%C = 1 %CC= 0
transfCarreLigne(_,_,_,3):- !.
transfCarreLigne(_,[],_,_):-!.
transfCarreLigne(Q,[_|Y],C,CC):- C=:=9,Tmp is CC +1,!,transfCarreLigne(Q,Y,1,Tmp).
transfCarreLigne([X],[X|Y],C,CC):- C=:=3,CC=:=2,!,Tmp is CC+1,transfCarreLigne(X,Y,C,Tmp).
transfCarreLigne([X|Q],[X|Y],C,CC):- C=<3 ,!,Tmp is C+1, transfCarreLigne(Q,Y,Tmp,CC).
transfCarreLigne(Q,[_|Y],C,CC):- C<9,Tmp is C+1,transfCarreLigne(Q,Y,Tmp,CC).

transfColonneLigne([X],[X|_],_,8,0):-!.
transfColonneLigne([X|Q],[X|Y],1,CC,Ok):- Ok=:=0,!,Tmp is CC+1,transfColonneLigne(Q,Y,1,Tmp,1).
transfColonneLigne(Q,[_|Y],1,CC,Ok):- Ok<9,!,Tmp is Ok+1,transfColonneLigne(Q,Y,1,CC,Tmp).
transfColonneLigne(Q,Y,1,CC,Ok):- Ok=:=9,!,transfColonneLigne(Q,Y,1,CC,0).
transfColonneLigne(Q,[_|Y],J,CC,Ok):- Tmp is J-1,!,transfColonneLigne(Q,Y,Tmp,CC,Ok).

transfLigneLigne([X],[X|_],0,8):-!.
transfLigneLigne([X|Q],[X|Y],0,C):-Tmp is C+1,!,transfLigneLigne(Q,Y,0,Tmp).
transfLigneLigne(S,[_|Y],I,C):- Tmp is I-1,!,transfLigneLigne(S,Y,Tmp,C).

trouverCarre(I,J,-1,-1,IT,JT):-!,IT is I-2,JT is J-2.
trouverCarre(I,J,II,-1,IT,JT):-!,IT is I-II,JT is J-2.
trouverCarre(I,J,-1,JJ,IT,JT):-!,IT is I-2,JT is J-JJ.
trouverCarre(I,J,3,3,IT,JT):-!,Tmp is mod(I,3)-1,Tmp2 is mod(J,3)-1,trouverCarre(I,J,Tmp,Tmp2,IT,JT).
trouverCarre(I,J,II,JJ,IT,JT):-!,IT is I-II,JT is J-JJ.

%valide un seul carré, celui où la valeur a été modifiée
valideCarreI(X,0):-!,transfCarreLigne(Ligne,X,1,0),validTteLigne(Ligne).
valideCarreI([_|Y],C):- Tmp is C-1,valideCarreI(Y,Tmp).

validTteLigne([]):- !.
validTteLigne([T|Q]):- T =:= " ", validTteLigne(Q),!.
validTteLigne([T|Q]):- valideLigne(T,Q,9), validTteLigne(Q).

%C=0 %CC=1 %Fin=0
valideCarre(_,_,_,9):- !.
valideCarre([],_,_,_):- !.
valideCarre(Y,C,CC,Fin):- C=:=0,CC=<3,!,transfCarreLigne(Ligne,Y,1,0),validTteLigne(Ligne),Tmp3 is C+1,Tmp is Fin+1,Tmp2 is CC+1,valideCarre(Y,Tmp3,Tmp2,Tmp). %test le premier carre
valideCarre([_|Y],C,CC,Fin):- C=<3,CC=<3,!,Tmp is C+1,valideCarre(Y,Tmp,CC,Fin). %+3 pour aller au carré suivant
valideCarre(Y,4,CC,Fin):- !,valideCarre(Y,0,CC,Fin).  %test carre suivant en mettant C à 0
valideCarre([_|Y],C,CC,Fin):- CC=<21,!,Tmp is CC+1,valideCarre(Y,C,Tmp,Fin). %quand on a fait 3 carré d une ligne on en saute 2 pour aller aux autres carrés
valideCarre(Y,C,_,Fin):- valideCarre(Y,C,1,Fin).

valideGrille() :- grilleCourante(X),valideLC(X,1,9),valideCarre(X,0,1,0).

valideGrille(X):- valideLC(X,1,9),valideCarre(X,0,1,0).


%------------------------------------------------------------------------------------------------------------------------------------------------------------
%AJOUT DE VALEUR DANS UNE GRILLE

%retourne dans X la valeur de la case numéro CC
caseGrille(X,[X|_],0):-!.
caseGrille(X,[_|Q],CC):-Tmp is CC -1,caseGrille(X,Q,Tmp).

%s''efface si la grille fournie en paramètre est pleine
grillePleine([]).
grillePleine([T|Q]):- T=\=" ", grillePleine(Q).

%verifie si la valeur modifier n''est pas une valeur qui est dans la grille de départ
verifModif(Num,1):-grilleDepart(Dep),\+caseVide(Dep,Num,1),!,fail.
verifModif(Num,0):-grilleDepart(Dep),\+caseVide(Dep,Num,1),!, writeln("Impossible : la valeur que vous voulez modifier appartient a la grille de depart"),fail.
verifModif(_,_).

%verifie si la valeur modifier correspond avec la solution
verifSol(Num,Val,1):- solution(Sol),caseGrille(X,Sol,Num),X=\=Val,!,fail.
verifSol(Num,Val,0):- solution(Sol),caseGrille(X,Sol,Num),X=\=Val,!,writeln("Impossible : la valeur que vous voulez inserer ne mene pas a la solution"),fail.
verifSol(_,_,_).

%modifie la grille en remplaçant la case de coordonnées (I,J) par la valeur Val. La modification n''est pas effectuée si elle rend la grille invalide.
modifier(I,J,Val):- Val <10, Val>0, grilleCourante(X),Tmp is J-1+(I-1)*9,Num is J+(I-1)*9,verifModif(Num,1),modif(Tmp,New,X,Val),valideModif(I,J,New),\+grillePleine(New),!,retract(grilleCourante(X)),assert(grilleCourante(New)), afficherCourante(),modifier(1). %grille non pleine
modifier(I,J,Val):- Val <10, Val>0, grilleCourante(X),Tmp is J-1+(I-1)*9,Num is J+(I-1)*9,verifModif(Num,0),modif(Tmp,New,X,Val),valideModif(I,J,New),!,retract(grilleCourante(X)),assert(grilleCourante(New)),afficherCourante(),writeln("Bravo vous avez gagne !"),lancer(). %grille pleine
modifier(_,_,_):- writeln("Votre choix n'est pas valide"), nl, afficherCourante(),modifier(1).

%empeche de modifier une valeur si elle n''aboutira pas à la solution (modification guidée)
modifierAide(I,J,Val):- Val <10,Val>0,grilleCourante(X),Tmp is J-1+(I-1)*9,Num is J+(I-1)*9,verifModif(Num,1),verifSol(Tmp,Val,1),modif(Tmp,New,X,Val),valideModif(I,J,New),\+grillePleine(New),!,retract(grilleCourante(X)),assert(grilleCourante(New)), afficherCourante(),modifier(2). %grille non pleine
modifierAide(I,J,Val):- Val <10,Val>0,grilleCourante(X),Tmp is J-1+(I-1)*9,Num is J+(I-1)*9,verifModif(Num,0),verifSol(Tmp,Val,0),modif(Tmp,New,X,Val),valideModif(I,J,New),!,retract(grilleCourante(X)),assert(grilleCourante(New)),afficherCourante(),writeln("Bravo vous avez gagne !"),lancer(). %grille pleine
modifierAide(_,_,_):- writeln("Votre choix n'est pas valide"),nl, afficherCourante(),modifier(2).

%modif(Num,New,Old,Val) : recopie la grille Old dans la grille New à l''exception de la case de numéro Num qui est remplacée par la valeur Val
modif(0,[Val|Y],[_|Y],Val):-!.
modif(CC,[X|Q],[X|Y],Val):- Tmp is CC-1,modif(Tmp,Q,Y,Val).

%vérifie qu''après l'ajout d'une valeur aux coordonnées (I,J), la grille X respecte encore les règles du Sudoku
valideModif(I,J,X):-transfColonneLigne(Col,X,J,0,0),validTteLigne(Col),Tmp is (I-1)*9,transfLigneLigne(Lig,X,Tmp,0),validTteLigne(Lig),trouverCarre(I,J,3,3,IC,JC),Tmp1 is (IC-1)*9+(JC-1),valideCarreI(X,Tmp1).


%------------------------------------------------------------------------------------------------------------------------------------------------------------
%GENERATION D''UNE GRILLE

%solve(New,G) : lance le solveur sur la grille G, le nouvelle grille est retournée dans New
solve(New,G):- writeln("Loading..."),solver(New,G,0).

%solver(G1,G2,C) : complète la grille G2, en mettant le résultat dans G1. C est un compteur.
solver(S,[],_):-!,grilleCourante(S).
solver(S,_,81):-!,grilleCourante(S).
solver(S,[T|Q],C):- T =\= " ",!,Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,1),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,2),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,3),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,4),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,5),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,6),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,7),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,8),Tmp is C+1,solver(S,Q,Tmp).
solver(S,[_|Q],C):- I is C//9,J is mod(C,9),modifierSolver(I,J,9),Tmp is C+1,solver(S,Q,Tmp).
solver(_,[_|_],C):- I is C//9,J is mod(C,9),modifierSolver(I,J," "),fail.

%modifie la grille en remplaçant la case de coordonnées (I,J) par la valeur Val. La modification n''est pas effectuée si elle rend la grille invalide.
modifierSolver(I,J,Val):- grilleCourante(X), Tmp is J+(I)*9, modif(Tmp,New,X,Val),II is I+1,JJ is J+1,valideModif(II,JJ,New),!,retract(grilleCourante(X)),assert(grilleCourante(New)).

%gen(X) : ajoute X valeurs aléatoires dans une grille. Cette fonction permet de générer ensuite des grilles différentes à chaque fois
gen(0):-!.
gen(Y):-Val is random(9)+1,I is random(10),J is random(10),modifierSolver(I,J,Val),!,Tmp is Y-1,gen(Tmp).
gen(Y):-gen(Y).

%genere une grille complète et la met dans X
genererSol(X):-initCourante(),gen(10), grilleCourante(G), solve(_,G),!,grilleCourante(X).
genererSol(X):-genererSol(X).

%ajouterTrous(Niveau) : lance la fonction de suppression aléatoire de certaines valeurs d''une grille. Le nombre de cases supprimées correspond au Niveau de difficulté souhaité par le joueur
ajouterTrous(3):-ajouterTrous(61,0),!.
ajouterTrous(_):-ajouterTrous(56,0). %par défaut, niveau intermédiaire

%ajouterTrous(Nb,Cpt) : supprimer Nb cases d''une grille remplie. Cpt est un compteur initialisé à 0.
ajouterTrous(Nb,Nb).
ajouterTrous(Nb,Cpt):-  supprimerCase(),  Temp is Cpt+1,ajouterTrous(Nb, Temp).

%efface le contenu d''une case aléatoire de la grille
supprimerCase():- trouverCaseASuppr(Num),grilleCourante(Old),Temp is Num-1,modif(Temp,New,Old," "),!,retract(grilleCourante(Old)),assert(grilleCourante(New)).

%renvoie le numéro d''une case non vide choisie aléatoirement
trouverCaseASuppr(Num):- grilleCourante(G), Num is random(81)+1, \+caseVide(G,Num,1),!.
trouverCaseASuppr(Num):- trouverCaseASuppr(Num).

%caseVide(G,Num, Cpt) : retourne vrai si la Num-ième case de la grille G contient " ". Cpt est un compteur initialisé à 1.
caseVide([T|_],Num, Num):- T =:= " ",!.
caseVide([_|Q],Num, Cpt):- Temp is Cpt+1, caseVide(Q,Num, Temp).


%------------------------------------------------------------------------------------------------------------------------------------------------------------
%GESTION DE L''INTERFACE

%permet de lancer le jeu. Il s''agit du prédicat d'entrée dans le programme.
lancer():-nl,writeln("Choisissez le mode d'utilisation de l'application :"),
		writeln("1 : jouer"),
		writeln("2 : fournir une grille que l'IA doit resoudre"),
		writeln("3 : quitter"),nl,
		read(Mode), jouer(Mode).
	
	
jouer(1):-nl,writeln("Choisissez la difficulte du jeu :"),
		writeln("1 : facile, 25 cases pre-remplies et l'application empeche d'inserer une valeur qui ne mene pas a la solution"),
		writeln("2 : intermediaire, 25 cases pre-remplies"),
		writeln("3 : difficile, 20 cases pre-remplies"),nl,
		read(Niveau),generer(Niveau),!.
jouer(2):-	initCourante(), initDepart(),afficherCourante(),
			nl, writeln("Remplir la grille avec les valeurs de votre choix, saisir -1 lorsque vous souhaitez declencher la resolution automatique."),
			modifier(1),!.
jouer(3):-!.
jouer(_):-writenl("Mauvaise saisie..."),lancer().


%generer une grille selon le Niveau de difficulté. Sépare le Niveau 1 des autres niveaux, car le Niveau fait appel à une aide
generer(1):-genererSol(X), updateSolution(X),ajouterTrous(1),grilleCourante(Y),updateGrilleDepart(Y),afficherCourante(),
				nl,writeln("Pour remplir une case, saisir la ligne, la colonne et la valeur. Saisissez -1 si vous souhaitez acceder au menu."), modifier(2),!.
generer(Niveau):-genererSol(X), updateSolution(X),ajouterTrous(Niveau),grilleCourante(Y),updateGrilleDepart(Y),afficherCourante(),
				nl,writeln("Pour remplir une case, saisir la ligne, la colonne et la valeur. Saisissez -1 si vous souhaitez acceder au menu."), modifier(1).

				
%permet à l'utilisateur d'insérer des valeurs dans les cases. S'il saisit -1, il peut accéder au menu intermédiaire. 
%Le paramètre permet d'appeler soit la fonction modifier (1), soit modifierAide (2) en fonction du niveau de difficulté demandé initialement au joueur.
modifier(1):- nl, write("- ligne "),read(I), nl, I=\=(-1), %si l'utilisateur saisit -1, on quitte la boucle
			write("- colonne "),read(J),nl,J=\=(-1),
			write("- valeur "),read(Val),nl, Val=\=(-1),modifier(I,J,Val),!.
modifier(2):- nl, write("- ligne "),read(I), nl, I=\=(-1), %si l'utilisateur saisit -1, on quitte la boucle
			write("- colonne "),read(J),nl,J=\=(-1),
			write("- valeur "),read(Val),nl, Val=\=(-1),modifierAide(I,J,Val),!.
modifier(N):- menuIntermediaire(N).


%menu accessible au cours d'une partie. Le paramètre N correspond au mode de jeu : sans aide (1) ou avec aide (2)
menuIntermediaire(N):-nl,writeln("Vous souhaitez :"),
			writeln("1 : reprendre"),
			writeln("2 : lancer la resolution automatique de la grille que vous avez saisie"),
			writeln("3 : afficher la solution"),
			writeln("4 : revenir au menu principal (la partie en cours sera perdue...)"),
			writeln("5 : quitter l'application"),nl,
			read(Reponse), menuIntermediaire(N,Reponse).

%permet de traiter la réponse de l'utilisateur qui correspond au second paramètre. Le premier paramètre permet de conserver en mémoire le mode de jeu (sans aide ou avec aide).
menuIntermediaire(N,1):-modifier(N),!.
menuIntermediaire(_,2):-grilleCourante(G), solve(_,G),afficherCourante(),lancer(),!.
menuIntermediaire(_,3):-afficherSolution(),lancer(),!.
menuIntermediaire(_,4):-lancer(),!.
menuIntermediaire(_,5):-!.
menuIntermediaire(N,_):-writeln("Mauvaise saisie..."),menuIntermediaire(N).