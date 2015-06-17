/*--------------*/
/* MARCHANDISES */
/*--------------*/

%Predicats liés aux Marchandises

liste_marchandises_dispo( [ ble, ble, ble, ble, ble, ble, 
							mais, mais, mais, mais, mais, mais, 
							riz, riz, riz, riz, riz, riz,
							sucre, sucre, sucre, sucre, sucre, sucre,
							cafe, cafe, cafe, cafe, cafe, cafe,
							cacao, cacao, cacao, cacao, cacao, cacao
							]
						).


/* melanger_lise prend la Liste, la mélange et met la nouvelle liste mélangée dans Marchandises */

melanger_liste(Liste, MT, Marchandises) :- Liste=[_|[]], nth(1, Liste, Marchandise), append([Marchandise], MT, Marchandises), !.

melanger_liste(Liste, MT, Marchandises) :-     length(Liste, LongueurListe), 
											   Liste\=[_|[]],											   
											   random(1,LongueurListe,PositionListe), 											   
											   nth(PositionListe, Liste, Marchandise),
											   supprimer_element(Marchandise, Liste, NewListe),											   
											   append([Marchandise], MT, MT2),											   
											   melanger_liste(NewListe, MT2, Marchandises), !.


/* Décompose la liste en 9 sous listes */

creer_sous_liste([], NM, NM). 

creer_sous_liste([E1, E2, E3, E4|Q], NMTemp, NM) :- append([[E1, E2, E3, E4]], NMTemp, NMTemp2),
													        creer_sous_liste(Q, NMTemp2, NM).

		


/*Affichage des marchandises en imprimant chaque pile*/

affiche_marchandises(Marchandises):- 	write('\nVoici les piles et leur contenu :\n'),
										write('---------------------------------\n'),
										affiche_piles(Marchandises),
										nl.

%Piles
affiche_piles([]).
affiche_piles([T|Q]) :- affiche_pile(T), nl, affiche_piles(Q).

%Pile
affiche_pile([]).
affiche_pile([T|Q]) :- write(T), write(' '), affiche_pile(Q).


/*Affichage de la première carte de chaque pile*/

affiche_marchandises_top(Marchandises):- 	write('\nVoici les cartes au sommet de chaque pile :\n'),
											write('-------------------------------------------\n'),
											write('|'), affiche_piles_top(Marchandises),
											nl.

%Piles
affiche_piles_top([]):- !.
affiche_piles_top([T|Q]) :- affiche_pile_top(T), write('\t|'), affiche_piles_top(Q).

%Pile
affiche_pile_top([]):- write('VIDE').
affiche_pile_top([T|_]) :- write(T).



/* Changer Marchandises */

changer_marchandises(Marchandises, NewPosition, NewMarchandises) :- length(Marchandises, LongueurM),
																	position_droite(NewPosition, LongueurM, PositionPileD),
																	position_gauche(NewPosition, LongueurM, PositionPileG),
																	nth(PositionPileG, Marchandises, RecupGauche),
																	supprimer_tete_liste(RecupGauche, NewRecupGauche),
																	nth(PositionPileD, Marchandises, RecupDroite),
																	supprimer_tete_liste(RecupDroite, NewRecupDroite),
																	construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises).
					

/* Reconstruction des Marchandises en fonction de la position du Trader (on enleve un produit à droite et à gauche) */
																		
supprimer_tete_liste([],[]).
supprimer_tete_liste([_|Y],Y).	

ajout_tete_vide([],L, L).
ajout_tete_vide(X,L,[X|L]).


supprimer_dernier_element(Liste, []) :- 			length(Liste, LongueurL), LongueurL ==1,!.
supprimer_dernier_element([T|Q], DebutListe) :- 	supprimer_dernier_element(Q, DebutListeInt), 
													append([T],DebutListeInt,DebutListe).

decouper_liste_deux_derniers(Liste, [], Liste) :- length(Liste, LongueurL), LongueurL ==2,!.
decouper_liste_deux_derniers([T|Q], DebutListe, FinListe) :- 	decouper_liste_deux_derniers(Q, DebutListeInt, FinListe), 
																append([T],DebutListeInt,DebutListe).

/*Quand le trader se trouve sur la derniere pile des marchandises : cas spécial*/


/*cas NewPosition ==1 */

construct_marchandises([_|Q], [], NewRecupDroite, 1, NewMarchandises):-
			supprimer_dernier_element(Q, DebutListeQ),
			supprimer_tete_liste(DebutListeQ, DebutListeQ2),
			ajout_tete_vide(NewRecupDroite,DebutListeQ2,NewMarchandises),!.

construct_marchandises([_|Q], NewRecupGauche, NewRecupDroite, 1, NewMarchandises):-
			supprimer_dernier_element(Q, DebutListeQ),
			supprimer_tete_liste(DebutListeQ, DebutListeQ2),
			ajout_tete_vide(NewRecupDroite,DebutListeQ2,NewDebutListe),
			append(NewDebutListe, [NewRecupGauche], NewMarchandises),!.


/*autres cas (NewPosition !=1) */

construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises):-
			construct_marchandises2(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises).
	

construct_marchandises2(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-  length(Marchandises, LongueurM), LongueurM==NewPosition,
																									decouper_liste_deux_derniers(Marchandises, DebutListe, FinListe),
																									supprimer_tete_liste(DebutListe, DebutListeInt),
																									supprimer_tete_liste(FinListe, FinListeInt),
																									ajout_tete_vide(NewRecupDroite, DebutListeInt, NewDebutListe),
																									ajout_tete_vide(NewRecupGauche, FinListeInt, NewFinListe),
																									append(NewDebutListe, NewFinListe, NewMarchandises),!.

																							
																							
construct_marchandises2([_|QM], _, NewRecupDroite, NewPosition, NewMarchandises) :- 	NewRecupDroite==[],NewPosition==0, 
																									NewMarchandises=QM, !.																							
construct_marchandises2([_|QM], _, NewRecupDroite, NewPosition, NewMarchandises) :- 	NewPosition==0, 
																									NewMarchandises=[NewRecupDroite|QM], !.

																							
construct_marchandises2([_|QM], NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :- 	NewRecupGauche==[], NewPosition==2, 
																									NewPositionDec is (NewPosition-1),
																									construct_marchandises2(QM, NewRecupGauche, NewRecupDroite, NewPositionDec, NewMarchandisesInt), 
																									NewMarchandises=NewMarchandisesInt,!.																				
construct_marchandises2([_|QM], NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :- 	NewPosition==2, NewPositionDec is (NewPosition-1),
																									construct_marchandises2(QM, NewRecupGauche, NewRecupDroite, NewPositionDec, NewMarchandisesInt),																							
																									NewMarchandises=[NewRecupGauche|NewMarchandisesInt],!.																							
																							

construct_marchandises2([TM|QM], NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :- 	NewPositionDec is (NewPosition-1),
																									construct_marchandises2(QM, NewRecupGauche, NewRecupDroite, NewPositionDec, NewMarchandisesInt),
																									NewMarchandises=[TM|NewMarchandisesInt].


