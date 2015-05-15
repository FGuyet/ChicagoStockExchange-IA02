%Bourse
bourse([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).


/*Affichage de la bourse*/

affiche_bourse :- 	write('\nVoici la bourse :\n'),
					write('-----------------\n'),
					bourse(X) , affiche_valeurs(X),
					write('\n').

affiche_valeurs([]).
affiche_valeurs([T|Q]):- affiche_valeur(T), affiche_valeurs(Q).

affiche_valeur([Nom,Valeur]):- write(Nom), write(' :\t'), write(Valeur), write('\n').


%Marchandises
marchandises([[ma�s, riz, ble, ble],
[ble, ma�s, sucre, riz],
[cafe, sucre, cacao, riz],
[cafe, ma�s, sucre, ma�s],
[cacao, ma�s, ble, sucre],
[riz, cafe, sucre, ble],
[cafe, ble, sucre, cacao],
[ma�s, cacao, cacao, cafe],
[riz,riz,cafe,cacao]]) .



/*--------------------
Affichage des marchandises en imprimant chaque pile
*/

affiche_marchandises:- 	write('\nVoici les piles et leur contenu :\n'),
						write('---------------------------------\n'),
						marchandises(X), affiche_piles(X),
						write('\n').
/* X prends la valeur du parametre dans marchandises ==> puis affiche cette liste de piles gr�ce aux pr�dicats ci-dessous */ 

%Piles
affiche_piles([]).
affiche_piles([T|Q]) :- affiche_pile(T), write('\n'), affiche_piles(Q).

%Pile
affiche_pile([]).
affiche_pile([T|Q]) :- write(T), write(' '), affiche_pile(Q).

/*------------------------------*/



/*--------------------
Affichage de la premi�re carte de chaque pile
*/

affiche_marchandises_top:- 	write('\nVoici les cartes au sommet de chaque pile :\n'),
							write('-------------------------------------------\n'),
							write('|'), marchandises(X), affiche_piles_top(X),
							write('\n').
/* X prends la valeur du parametre dans marchandises ==> puis affiche cette liste de piles gr�ce aux pr�dicats ci-dessous */ 

%Piles
affiche_piles_top([]):- !.
affiche_piles_top([T|Q]) :- affiche_pile_top(T), write('\t|'), affiche_piles_top(Q).

%Pile
affiche_pile_top([]):-write("VIDE").
affiche_pile_top([T|_]) :- write(T).


/*------------------------------*/


%PositionTrader
positionTrader(1).


%ReserveJoueur1
reserveJoueur1([]).

%ReserveJoueur2
reserveJoueur2([]).

%Plateau
%Plateau([Marchandises, Bourse, PositionTrader, ReserveJoueur1, ReserveJoueur2]).

/*

%PlateauDepart
plateau(append(bourse,marchandises, positionTrader, reserveJoueur1,reserveJoueur2)).
affiche_plateau :- plateau(X) , print(X).

*/