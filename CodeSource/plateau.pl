/*---------*/
/* PLATEAU */
/*---------*/

% Prédicats liés au plateau


plateau_depart([Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]):-	bourse(Bourse),
																				marchandises_depart(Marchandises), 
																				random(1,9,PositionTrader),
																				reserveJoueur1(ReserveJ1),
																				reserveJoueur2(ReserveJ2).
																				%j1commence

/* Affichage du plateau */

affiche_plateau([Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]):-	affiche_bourse(Bourse),
																				affiche_marchandises_top(Marchandises), 
																				affiche_position(PositionTrader),
																				affiche_joueur1(ReserveJ1),
																				affiche_score(j1,[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]),
																				affiche_joueur2(ReserveJ2),
																				affiche_score(j2,[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]).

marchandises_depart(NewMarchandises) :- liste_marchandises_dispo(Liste), 
										melanger_liste(Liste, [], Marchandises), 
										creer_sous_liste(Marchandises, [], NewMarchandises).
										

ajout_tete(X,L,[X|L]).

supprimer_element(_,[],[]).
supprimer_element(X, [X|Q], Q).
supprimer_element(X,[T|Q],L):- X\==T , ajout_tete(T,L2,L), supprimer_element(X,Q,L2), !.		
