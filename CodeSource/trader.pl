/*--------------------*/
/* POSITION DU TRADER */
/*--------------------*/

% Prédicats liés à la position du Trader

/*Affichage de la position du trader par rapport aux piles */

affiche_position(Position):- 		Nbre is (Position-1),
									affiche_tab(Nbre), write('   T\n'),
									write('\nLa lettre T represente la position du Trader (position='), write(Position), write(')\n\n').

affiche_tab(0):- !.
affiche_tab(N):- write('\t'), Nbre is (N-1), affiche_tab(Nbre).


/* Modification de la position en fonction du déplacement */


changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ):- 	PositionInt is (PositionTrader + Deplacement) mod LongueurM,
																			PositionInt == 0 ,
																			NewPosition is LongueurM ,!.
changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ):- 	NewPosition is (PositionTrader + Deplacement) mod LongueurM,!.


