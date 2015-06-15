/*----------------------------------------*/
/* Projet de IA02: Chicago Stock Exchange */
/*  	Charlotte Haag - Florian Guyet    */
/*----------------------------------------*/



/* Le jeu se lance en rentrant écrivant la commande suivante dans GNU Prolog : jeu. */



/* jeu Humain vs Humain */

jeuHH :- 	asserta(joueurEnCours(j2)), plateau_depart(P), boucle_jeuHH(P).

/* Le jeu s'arrête lorqu'il reste seulement 2 piles de Jetons dans les marchandises */

boucle_jeuHH([Marchandises,_,_,_,_]):- length(Marchandises, LongueurM), LongueurM < 3,nl,nl, write('LE JEU EST TERMINE'), retract(joueurEnCours(_)),!.
boucle_jeuHH(Plateau):- affiche_plateau(Plateau), changer_joueur, demander_coup(Coup,Plateau), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuHH(NewPlateau).



/* jeu Humain vs Machine */

jeuHM :- asserta(joueurEnCours(j2)), plateau_depart(P), boucle_jeuHM(P).

/* Le jeu s'arrête lorqu'il reste seulement 2 piles de Jetons dans les marchandises */

boucle_jeuHM([Marchandises,_,_,_,_]):- length(Marchandises, LongueurM), LongueurM < 3,nl,nl, write('LE JEU EST TERMINE'), retract(joueurEnCours(_)),!.
boucle_jeuHM(Plateau):- joueurEnCours(j2), affiche_plateau(Plateau), changer_joueur, demander_coup(Coup,Plateau), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuHM(NewPlateau).
boucle_jeuHM(Plateau):- joueurEnCours(j1), affiche_plateau(Plateau), changer_joueur, coup_machine(Plateau,Coup), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuHM(NewPlateau).



/* jeu Machine vs Machine */

jeuMM :- asserta(joueurEnCours(j2)), plateau_depart(P), boucle_jeuMM(P).

/* Le jeu s'arrête lorqu'il reste seulement 2 piles de Jetons dans les marchandises */

boucle_jeuMM([Marchandises,_,_,_,_]):- length(Marchandises, LongueurM), LongueurM < 3, nl, nl, write('LE JEU EST TERMINE'), retract(joueurEnCours(_)),!.
boucle_jeuMM(Plateau):- affiche_plateau(Plateau), changer_joueur, coup_machine(Plateau,Coup), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuMM(NewPlateau).



/* Coup machine*/
coup_machine(Plateau,Coup):-	nl,write('L\'ordinateur joue son tour: ... *reflexion intense*'), nl,
							 	meilleur_coup(Plateau, [_, Deplacement, Garder, Jeter]),
							 	write('Déplacement:'), write(Deplacement),nl,
							 	write('L\'ordinateur garde:'), write(Garder), nl,
							 	write('L\'ordinateur jette:'), write(Jeter),nl,nl,
							 	joueurEnCours(Joueur),
							 	Coup=[Joueur, Deplacement, Garder, Jeter].



/*---------*/
/* PLATEAU */
/*---------*/

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

/*--------------*/
/* MARCHANDISES */
/*--------------*/

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


/*construct_marchandises([TM|QM], NewRecupGauche, NewRecupDroite, Position, Marchandises) :- 	length([TM|QM], longueurM),
																							Position==2, longueurM==2,
																							append(NewRecupGauche, QM, Marchandises),!.*/

decouper_liste_deux_derniers(Liste, [], Liste) :- length(Liste, LongueurL), LongueurL ==2,!.
decouper_liste_deux_derniers([T|Q], DebutListe, FinListe) :- 	decouper_liste_deux_derniers(Q, DebutListeInt, FinListe), 
																append([T],DebutListeInt,DebutListe).
																				
/*construct_marchandises([TM|QM], NewRecupGauche, NewRecupDroite, Position, Marchandises) :-
																							
construct_marchandises([TM|QM], NewRecupGauche, NewRecupDroite, Position, Marchandises) :- 	NewRecupDroite==[],Position==0, Marchandises=QM, !.

construct_marchandises([TM|QM], NewRecupGauche, NewRecupDroite, Position, Marchandises) :- 	Position==0, Marchandises=[NewRecupDroite|QM], !.

																							
construct_marchandises([TM|QM], NewRecupGauche, NewRecupDroite, Position, Marchandises) :- 	NewRecupGauche==[], Position==2, NewPosition is (Position-1),
																							construct_marchandises(QM, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises), 
																							Marchandises=NewMarchandises,!.
																							
																																														
construct_marchandises([TM|QM], NewRecupGauche, NewRecupDroite, Position, Marchandises) :- 	Position==2, NewPosition is (Position-1),
																							construct_marchandises(QM, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises),																							
																							Marchandises=[NewRecupGauche|NewMarchandises],!.
																							
																							

construct_marchandises([TM|QM], NewRecupGauche, NewRecupDroite, Position, Marchandises) :- 	NewPosition is (Position-1),
																							construct_marchandises(QM, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises),
																							Marchandises=[TM|NewMarchandises].

*/



%Trader en position 1
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 1,
																										nth(1,Marchandises, Pile1),				
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										NewMarchandises = [Pile1, NewRecupDroite, Pile3, Pile4, Pile5, Pile6, Pile7, Pile8, NewRecupGauche], !.

	
%Trader en position 2
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 2,
																										nth(2,Marchandises, Pile2),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
																										NewMarchandises = [NewRecupGauche, Pile2, NewRecupDroite, Pile4, Pile5, Pile6, Pile7, Pile8, Pile9], !.

%Trader en position 3
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 3,
																										nth(1,Marchandises, Pile1),
																									    nth(3,Marchandises, Pile3),																						
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
																										NewMarchandises = [Pile1, NewRecupGauche, Pile3, NewRecupDroite, Pile5, Pile6, Pile7, Pile8, Pile9], !.																						

%Trader en position 4
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 4,
																										nth(1,Marchandises, Pile1),
																										nth(2,Marchandises, Pile2),
																										nth(4,Marchandises, Pile4),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
																										NewMarchandises = [Pile1, Pile2, NewRecupGauche, Pile4, NewRecupDroite, Pile6, Pile7, Pile8, Pile9], !.

%Trader en position 5
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 5,
																										nth(1,Marchandises, Pile1),
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(5,Marchandises, Pile5),																										
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
																										NewMarchandises = [Pile1, Pile2, Pile3, NewRecupGauche, Pile5, NewRecupDroite, Pile7, Pile8, Pile9], !.																									
																										
																										
%Trader en position 6
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 6,
																										nth(1,Marchandises, Pile1),
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),																										
																										nth(6,Marchandises, Pile6),																										
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
																										NewMarchandises = [Pile1, Pile2, Pile3, Pile4, NewRecupGauche, Pile6, NewRecupDroite, Pile8, Pile9], !.
																										
%Trader en position 7
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 7,
																										nth(1,Marchandises, Pile1),
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),																										
																										nth(7,Marchandises, Pile7),																										
																										nth(9,Marchandises, Pile9),
																										NewMarchandises = [Pile1, Pile2, Pile3, Pile4, Pile5, NewRecupGauche, Pile7, NewRecupDroite, Pile9], !.
																										
%Trader en position 8
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 8,
																										nth(1,Marchandises, Pile1),
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),																										
																										nth(8,Marchandises, Pile8),																										
																										NewMarchandises = [Pile1, Pile2, Pile3, Pile4, Pile5, Pile6, NewRecupGauche, Pile8, NewRecupDroite], !.

%Trader en position 9
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 9,
																										nth(2,Marchandises, Pile2),				
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(9,Marchandises, Pile9),
																										NewMarchandises = [NewRecupDroite, Pile2, Pile3, Pile4, Pile5, Pile6, Pile7, NewRecupGauche, Pile9], !.																									
/*--------*/
/* BOURSE */
/*--------*/

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



/*--------------------*/
/* POSITION DU TRADER */
/*--------------------*/


/*Affichage de la position du trader par rapport aux piles */

affiche_position(Position):- 		Nbre is (Position-1),
									affiche_tab(Nbre), write('   T\n'),
									write('\nLa lettre T represente la position du Trader (position='), write(Position), write(')\n\n').

affiche_tab(0):- !.
affiche_tab(N):- write('\t'), Nbre is (N-1), affiche_tab(Nbre).


/* Modification de la position en fonction du déplacement */

changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ):- 	PositionInt is (PositionTrader + Deplacement) mod LongueurM,
																			PositionInt == 0 ,
																			NewPosition is 9 ,!.
changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ):- 	NewPosition is (PositionTrader + Deplacement) mod LongueurM,!.



/*----------------------*/
/* RESERVES DES JOUEURS */
/*----------------------*/

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


																

/*----------------------------*/
/* DEMANDER UN COUP AU JOUEUR */
/*----------------------------*/

/* Interface jeu-utilisateur pour que le joueur choississe son coup */

demander_coup([Joueur,Deplacement,Garder,Jeter], [Marchandises, _, PositionTrader, _, _]) :-		
													joueurEnCours(Joueur), /* demander_joueur(Joueur), */
													write('\nC\'est au tour de '), write(Joueur), write(' de jouer !'), nl,
													demander_deplacement(Deplacement), 
													length(Marchandises, LongueurM),
													changer_position(PositionTrader, Deplacement, LongueurM, NewPosition),
													write(NewPosition),
													affiche_marchandises_top(Marchandises),
													affiche_position(NewPosition),
													demander_garder(Garder),
													demander_jeter(Jeter).


/* demander_deplacement permet de demander le déplacement, jusque Deplacement = 1,2,3 soit rentré par l'utilisateur*/

demander_deplacement(Deplacement) :- 	write('\nQuel deplacement souhaitez vous faire ? '), read(DeplacementSaisi), 
										traitement_deplacement_saisi(DeplacementSaisi, Deplacement).

traitement_deplacement_saisi(DeplacementSaisi, Deplacement) :-	\+deplacement_possible(DeplacementSaisi),
																write('Veuillez rentrer un deplacement egal a 1, 2 ou 3 \n'),
																demander_deplacement(Deplacement),!.

traitement_deplacement_saisi(DeplacementSaisi, Deplacement) :- 	deplacement_possible(DeplacementSaisi), Deplacement = DeplacementSaisi,!.										

deplacement_possible(DeplacementSaisi) :-	DeplacementSaisi == 1,!.
deplacement_possible(DeplacementSaisi) :-	DeplacementSaisi == 2,!.
deplacement_possible(DeplacementSaisi) :-	DeplacementSaisi == 3,!.


/* demander_garder permet de demander le produit à garder, jusque le produit soit acceptable */

demander_garder(Garder):-	write('\nQuel produit voulez vous garder ? '), read(GarderSaisi), traitement_garder_saisi(GarderSaisi, Garder).


traitement_garder_saisi(GarderSaisi, Garder) :-	\+produit_possible(GarderSaisi),
												write('Veuillez rentrer un produit existant, en minuscule sans accent (ble, riz, cacao, cafe, sucre, mais)\n'),
												demander_garder(Garder),!.

traitement_garder_saisi(GarderSaisi, Garder) :- produit_possible(GarderSaisi), Garder = GarderSaisi,!.	



/* demander_jeter permet de demander le produit à jeter, jusque le produit soit acceptable */

demander_jeter(Jeter):-	write('\nQuel produit voulez vous jeter ? '), read(JeterSaisi), traitement_jeter_saisi(JeterSaisi, Jeter).


traitement_jeter_saisi(JeterSaisi, Jeter) :-	\+produit_possible(JeterSaisi),
												write('Veuillez rentrer un produit existant, en minuscule sans accent (ble, riz, cacao, cafe, sucre, mais)\n'),
												demander_jeter(Jeter),!.

traitement_jeter_saisi(JeterSaisi, Jeter) :- 	produit_possible(JeterSaisi), Jeter = JeterSaisi,!.


/*Produit possible vérifie que le produit saisi est acceptable */								

produit_possible(ProduitSaisi) :-	ProduitSaisi == ble,!.
produit_possible(ProduitSaisi) :-	ProduitSaisi == riz,!.
produit_possible(ProduitSaisi) :-	ProduitSaisi == cacao,!.
produit_possible(ProduitSaisi) :-	ProduitSaisi == cafe,!.
produit_possible(ProduitSaisi) :-	ProduitSaisi == sucre,!.
produit_possible(ProduitSaisi) :-	ProduitSaisi == mais,!.


/*---------------*/
/* COUP POSSIBLE */
/*---------------*/

coup_possible(	[Marchandises, _, PositionTrader, _,_],
				[_,Deplacement,Garder,Jeter]):- 
							length(Marchandises, LongueurM),
							changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ),
							recuperer_droite(NewPosition, Marchandises,LongueurM,ProduitDroite),
							recuperer_gauche(NewPosition, Marchandises, LongueurM, ProduitGauche), 
							produits_a_cote(Garder, Jeter, ProduitGauche, ProduitDroite).


/* Prédicats position_droite et position_gauche qui caculent les positions à droite et gauche du trader */  

position_droite(NewPosition, LongueurM, PositionD):- 	PositionInt is (NewPosition + 1) mod LongueurM,
														PositionInt == 0 ,
														PositionD is 9 ,!.
position_droite(NewPosition, LongueurM, PositionD):- 	PositionD is (NewPosition + 1) mod LongueurM.

position_gauche(NewPosition, LongueurM, PositionG):- 	PositionInt is (NewPosition - 1) mod LongueurM,
														PositionInt == 0 ,
														PositionG is 9 ,!.
position_gauche(NewPosition, LongueurM, PositionG):- 	PositionG is (NewPosition - 1) mod LongueurM.


/* Prédicats recuperer_droite et recuperer_gauche qui permettent de récupérer les produits présent à droite et à gauche du Trader */

recuperer_droite(NewPosition, Marchandises, LongueurM, ProduitDroite):- position_droite(NewPosition , LongueurM, PositionDroite), 
																		nth(PositionDroite, Marchandises, PileDroite), 
																		nth(1, PileDroite, ProduitDroite).

recuperer_gauche(NewPosition, Marchandises, LongueurM, ProduitGauche):- position_gauche(NewPosition , LongueurM, PositionGauche),
																		nth(PositionGauche, Marchandises, PileGauche),
																		nth(1, PileGauche, ProduitGauche).												


/* produits_a_cote teste si les produits à garder et à jeter sont bien à côté du Trader */

produits_a_cote(Garder, Jeter, ProduitGauche, ProduitDroite) :- ProduitGauche == Garder, 
																ProduitDroite == Jeter,!.							
		
produits_a_cote(Garder, Jeter, ProduitGauche, ProduitDroite) :-	ProduitGauche == Jeter, 
																ProduitDroite == Garder.
							


/*-------------*/
/* JOUEUR COUP */
/*-------------*/												

jouer_coup(Plateau, Coup, NewPlateau) :-	\+coup_possible(Plateau,Coup),
											write('\n\n/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\ \n'),
											write('/!\\ATTENTION : Le coup n\'est pas possible /!\\ \n'),
											write('/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\/!\\ \n'),
											changer_joueur, 
											/*permet de revenir au même joueur*/
											NewPlateau = Plateau,!. 

/* Si le coup n'est pas possible, on renvoie le plateau de départ pour que le jeu reprenne au bon endroit */
											
jouer_coup(	[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2],
			[Joueur,Deplacement,Garder,Jeter],
			[NewMarchandises, NewBourse, NewPositionTrader, NewReserveJ1, NewReserveJ2]) :-
						coup_possible(	[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2],
										[Joueur,Deplacement,Garder,Jeter]),
						write('Le coup est possible\n'),
						length(Marchandises,LongueurM),
						changer_position(PositionTrader, Deplacement, LongueurM, NewPositionTrader),
						write('New pos='), write(NewPositionTrader), nl,
						changer_bourse(Bourse,Jeter,NewBourse), 
						ajouter_reserve(Joueur, Garder, ReserveJ1, ReserveJ2, NewReserveJ1, NewReserveJ2), 
						changer_marchandises(Marchandises, NewPositionTrader,NewMarchandises),!.

jouer_coup_machine(	[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2],
			[Joueur,Deplacement,Garder,Jeter],
			[NewMarchandises, NewBourse, NewPositionTrader, NewReserveJ1, NewReserveJ2]) :-
						length(Marchandises,LongueurM),
						changer_position(PositionTrader, Deplacement, LongueurM, NewPositionTrader),
						changer_bourse(Bourse,Jeter,NewBourse), 
						ajouter_reserve(Joueur, Garder, ReserveJ1, ReserveJ2, NewReserveJ1, NewReserveJ2), 
						changer_marchandises(Marchandises, NewPositionTrader,NewMarchandises),!.


/*----------------*/
/* CHANGER JOUEUR */
/*----------------*/												

changer_joueur:- retract(joueurEnCours(j1)), asserta(joueurEnCours(j2)),!.
changer_joueur:- retract(joueurEnCours(j2)), asserta(joueurEnCours(j1)),!.





/*==================================*/
/*==================================*/
/* PARTIE INTELLIGENCE ARTIFICIELLE */
/*==================================*/
/*==================================*/


/*----------------*/
/* COUP POSSIBLES */
/*----------------*/

/*retourne tous les coups possibles*/

coups_possibles(Plateau,ListeCoupsPossibles) :- coups_par_deplacement(Plateau, 1, CoupsEn1), 
												coups_par_deplacement(Plateau, 2, CoupsEn2),
												coups_par_deplacement(Plateau, 3, CoupsEn3),
												append(CoupsEn1, CoupsEn2, CoupsEn12),
												append(CoupsEn12,CoupsEn3, ListeCoupsPossibles).

/*retourne les deux coups possibles par rapport au deplacement*/

coups_par_deplacement([Marchandises,_, PositionTrader, _, _], Deplacement, CoupsDeplacement):-
							length(Marchandises, LongueurM),
							NewPositionTrader is (PositionTrader + Deplacement),
							recuperer_gauche(NewPositionTrader, Marchandises, LongueurM, ProduitGauche),
							recuperer_droite(NewPositionTrader, Marchandises, LongueurM, ProduitDroite),
							joueurEnCours(Joueur),
							Coup1 = [Joueur, Deplacement,ProduitGauche, ProduitDroite],
							Coup2 = [Joueur, Deplacement,ProduitDroite, ProduitGauche],
							append([Coup1],[Coup2], CoupsDeplacement).

produits_regles([mais, ble, cacao, cafe, sucre, riz]).


/*---------------*/
/* MEILLEUR COUP */
/*---------------*/

meilleur_coup(Plateau, MeilleurCoup):- 	coups_possibles(Plateau, ListeCoupsPossibles),
										scores_coups_possibles(Plateau,ListeCoupsPossibles, ListeCoupsPossiblesScores),
										coup_score_max(ListeCoupsPossiblesScores,[MeilleurCoup,ScoreMax]).

/*version avec MINIMAX */
meilleur_coup2(Plateau, MeilleurCoup) :- 	liste_score_coups_possibles2(Plateau, ListeCoupsPossiblesScores),
											coup_score_max(ListeCoupsPossiblesScores,[[MeilleurCoup,MeilleurCoupOpposant],ScoreMax]).


/*calcul du score d'un joueur*/

calcul_score_joueur(j1,[_,Bourse,_,R1,_], Score):- score_reserve(Bourse, R1, Score),!.
calcul_score_joueur(j2,[_,Bourse,_,_,R2], Score):- score_reserve(Bourse, R2, Score).

/*calcul du score d'une reserve*/

score_reserve(Bourse, [], 0):-!.
score_reserve(Bourse, [T|Q], ScoreReserve):- 	score_produit(Bourse, T, ScoreProduit),
 												score_reserve(Bourse, Q, ScoreQueue),
												ScoreReserve is (ScoreProduit + ScoreQueue). 
/*calcul du score d'un produit*/

score_produit([[Produit, Valeur]|_], Produit, Valeur):-!.
score_produit([_|Q], Produit, ScoreProduit):- score_produit(Q,Produit, ScoreProduit).

/*Affichage du score d'un joueur*/

affiche_score(Joueur,Plateau):- calcul_score_joueur(Joueur, Plateau, Score),
								write('Score = '), write(Score), nl.


/*scores_coups_possibles recupere le score du joueur après chaque coup possible*/ 

scores_coups_possibles(Plateau, [], []):-!.

scores_coups_possibles(Plateau,[[Joueur|QueueCoup]|Q], ListeCoupsPossiblesScores):-
				jouer_coup_machine(Plateau,[Joueur|QueueCoup],NewPlateau),
				calcul_score_joueur(Joueur,NewPlateau, Score),
				append([[Joueur|QueueCoup]], [Score], ScoreCoup),
				scores_coups_possibles(Plateau,Q, ListeCoupsPossiblesScoresQueue),
				append(ListeCoupsPossiblesScoresQueue, [ScoreCoup] ,ListeCoupsPossiblesScores).

/*coup_score_max recupère le coup qui a le score max, avec son score*/

coup_score_max([], CoupMax, CoupMax):-!.

coup_score_max([[Coup, Score]|Q], [CoupMaxPrecedent, ScoreMaxPrecedent], CoupMax) :- 
				Score > ScoreMaxPrecedent,
				coup_score_max(Q,[Coup, Score], CoupMax),!.
		
coup_score_max([[Coup, Score]|Q], [CoupMaxPrecedent, ScoreMaxPrecedent], CoupMax) :- 
				/*Score <= ScoreMaxPrecedent,*/
				coup_score_max(Q,[CoupMaxPrecedent, ScoreMaxPrecedent], CoupMax),!.

coup_score_max(ListeScore,CoupMax):- coup_score_max(ListeScore,[_,-2000000],CoupMax).


/***********/
/* MINIMAX */
/***********/


liste_score_coups_possibles2(Plateau, ListeCoupsPossibles):- 	meilleur_coup_par_deplacement2(Plateau, 1, MeilleurCoupsEn1), 
																meilleur_coup_par_deplacement2(Plateau, 2, MeilleurCoupsEn2),
																meilleur_coup_par_deplacement2(Plateau, 3, MeilleurCoupsEn3),
																append(MeilleurCoupsEn1, MeilleurCoupsEn2, MeilleurCoupsEn12),
																append(MeilleurCoupsEn12,MeilleurCoupsEn3, ListeCoupsPossibles).

meilleur_coup_par_deplacement2([Marchandises,Bourse, PositionTrader, R1, R2], Deplacement, [MeilleurCoupsDeplacement]):-
						Plateau= [Marchandises,Bourse, PositionTrader, R1, R2],

						length(Marchandises, LongueurM),
						NewPositionTrader is (PositionTrader + Deplacement),
						recuperer_gauche(NewPositionTrader, Marchandises, LongueurM, ProduitGauche),
						recuperer_droite(NewPositionTrader, Marchandises, LongueurM, ProduitDroite),

						/*recuperation des joueurs*/
						joueurEnCours(Joueur), changer_joueur, joueurEnCours(Opposant), changer_joueur,
						
						Coup1 = [Joueur, Deplacement,ProduitGauche, ProduitDroite],

						changer_joueur,
						/*calcul du score du joueur après Coup1 */
						jouer_coup_machine(Plateau, [Joueur, Deplacement,ProduitGauche, ProduitDroite],NewPlateau),
						calcul_score_joueur(Joueur,NewPlateau, ScoreJoueur),

						
						/*recherche du meilleur_coup de l'opposant*/
						coups_possibles(NewPlateau, ListeCoupsSuivantsPossibles),

						scores_coups_possibles(NewPlateau, ListeCoupsSuivantsPossibles, ListeCoupsSuivantsPossiblesScore),
						coup_score_max(ListeCoupsSuivantsPossiblesScore, [[Opposant|QMeilleurCoupOpposant], ScoreMaxOpposant]),
						
						ScoreMinimax1 is (ScoreJoueur - ScoreMaxOpposant),
						CoupMinimax1= [[Coup1, [Opposant|QMeilleurCoupOpposant]],ScoreMinimax1],

						Coup2 = [Joueur, Deplacement,ProduitDroite, ProduitGauche],

						/*calcul du score du joueur après Coup1 */
						jouer_coup_machine(Plateau, [Joueur, Deplacement,ProduitDroite, ProduitGauche],NewPlateau2),
						calcul_score_joueur(Joueur,NewPlateau2, ScoreJoueur2),

						/*recherche du meilleur_coup de l'opposant*/
						coups_possibles(NewPlateau2, ListeCoupsSuivantsPossibles2),
						scores_coups_possibles(NewPlateau2, ListeCoupsSuivantsPossibles2, ListeCoupsSuivantsPossiblesScore2),
						coup_score_max(ListeCoupsSuivantsPossiblesScore2, [[Opposant|QMeilleurCoupOpposant2], ScoreMaxOpposant2]),
			
						ScoreMinimax2 is (ScoreJoueur2 - ScoreMaxOpposant2),
						CoupMinimax2= [[Coup2,[Opposant|QMeilleurCoupOpposant2]], ScoreMinimax2],
						coup_score_max([CoupMinimax1,CoupMinimax2], MeilleurCoupsDeplacement).


meilleur_coup_direct(Plateau, MeilleurCoup):- 	coups_possibles(Plateau, ListeCoupsPossibles),
												scores_coups_possibles(Plateau,ListeCoupsPossibles, ListeCoupsPossiblesScores),
												coup_score_max(ListeCoupsPossiblesScores,MeilleurCoup,ScoreMax).





changer_joueur(j1, j2):-!.
changer_joueur(j2, j1):-!.