/*--------*/
/* BOURSE */
/*--------*/

% Prédicats liés à la bourse

bourse([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).

/*Affichage de la bourse*/

affiche_bourse(Bourse) :- 	write('\nVoici la bourse :\n'),
					write('-----------------\n'),
					affiche_valeurs(Bourse),
					nl.

affiche_valeurs([]).
affiche_valeurs([T|Q]):- affiche_valeur(T), affiche_valeurs(Q).

affiche_valeur([Nom,Valeur]):- write(Nom), write(' :\t'), write(Valeur), nl.


/* Changer la bourse selon le produit jeté */

changer_bourse([[Produit, Valeur]|Q],Produit, NewBourse) :- 	NewValeur is (Valeur-1),
																NewBourse=[[Produit, NewValeur]|Q], !.
changer_bourse([[P, Valeur]|Q],Produit, Bourse) :-		changer_bourse(Q, Produit, FinBourse),
													 	append([[P, Valeur]],FinBourse,	Bourse).


