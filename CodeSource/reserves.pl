/*----------------------*/
/* RESERVES DES JOUEURS */
/*----------------------*/

% Prédicals liés aux réserves des joueurs

%ReserveJoueur1
reserveJoueur1([]).

%ReserveJoueur2
reserveJoueur2([]).


/* L'affichage des réserves	des joueurs*/	

affiche_joueur1(ReserveJ1) :-	write('\nVoici la reserve du Joueur1 :\n'),
				   				write('-----------------------------\n'),
				   				affiche_pile(ReserveJ1), nl.

affiche_joueur2(ReserveJ2) :- 	write('\nVoici la reserve du Joueur2 :\n'),
							  	write('-----------------------------\n'),
							  	affiche_pile(ReserveJ2), nl.


/* Ajout d'un produit à la réserve d'un joueur */

%j1
ajouter_reserve(j1,Garder, ReserveJ1, ReserveJ2, NewReserveJ1 , NewReserveJ2):- 	append(ReserveJ1,[Garder], NewReserveJ1),
																					NewReserveJ2 = ReserveJ2.

%j2
ajouter_reserve(j2,Garder, ReserveJ1, ReserveJ2, NewReserveJ1 , NewReserveJ2):-		NewReserveJ1 = ReserveJ1, 
																					append(ReserveJ2,[Garder], NewReserveJ2).


																
