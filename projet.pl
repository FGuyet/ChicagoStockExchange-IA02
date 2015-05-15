%Bourse
bourse([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).

affiche_bourse :- bourse(X) , print(X).

%Marchandises
marchandises([[maïs, riz, ble, ble],
[ble, maïs, sucre, riz],
[cafe, sucre, cacao, riz],
[cafe, maïs, sucre, maïs],
[cacao, maïs, ble, sucre],
[riz, cafe, sucre, ble],
[cafe, ble, sucre, cacao],
[maïs, cacao, cacao, cafe],
[riz,riz,cafe,cacao]]) .



/*--------------------
Affichage des marchandises en imprimant chaque pile
*/

affiche_marchandises:- 	write('\nVoici les piles et leur contenu :\n'),
						write('---------------------------------\n'),
						marchandises(X), affiche_piles(X), write('\n\n').
/* X prends la valeur du parametre dans marchandises ==> puis affiche cette liste de piles grâce aux prédicats ci-dessous */ 

%Piles
affiche_piles([]):- !.
affiche_piles([T|Q]) :- affiche_pile(T), write('\n'), affiche_piles(Q).

%Pile
affiche_pile([]).
affiche_pile([T|Q]) :- write(T), write(' '), affiche_pile(Q).

/*------------------------------*/



/*--------------------
Affichage de la première carte de chaque pile
*/

affiche_marchandises_top:- 	write('\nVoici les cartes au sommet de chaque pile :\n'),
							write('-------------------------------------------\n'),
							write('|'), marchandises(X), affiche_piles_top(X), write('\n\n').
/* X prends la valeur du parametre dans marchandises ==> puis affiche cette liste de piles grâce aux prédicats ci-dessous */ 

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