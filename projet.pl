/*----------------------------------------*/
/* Projet de IA02: Chicago Stock Exchange */
/*  	Charlotte Haag - Florian Guyet    */
/*----------------------------------------*/


/* Le jeu se lance en rentrant écrivant la commande suivante dans GNU Prolog : jeu. */

jeu :- plateau_depart(P), boucle_jeu(P).

/* Le jeu s'arrêtre lorqu'il reste seulement 2 piles de Jetons dans les marchandises */
boucle_jeu([Marchandises,_,_,_,_]):- length(Marchandises, LongueurM), LongueurM < 3, write('Le jeu est termine'),!.
boucle_jeu(Plateau):- affiche_plateau(Plateau),  demander_coup(Coup,Plateau), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeu(NewPlateau).



/*---------*/
/* PLATEAU */
/*---------*/

plateau_depart([Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]):-	bourse(Bourse),
																				marchandises(Marchandises), 
																				random(1,9,PositionTrader),
																				reserveJoueur1(ReserveJ1),
																				reserveJoueur2(ReserveJ2).

/* Affichage du plateau */

affiche_plateau([Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]):-	affiche_bourse(Bourse),
																				affiche_marchandises_top(Marchandises), 
																				affiche_position(PositionTrader),
																				affiche_joueur1(ReserveJ1),
																				affiche_joueur2(ReserveJ2).


/*--------------*/
/* MARCHANDISES */
/*--------------*/

marchandises(	[	
				[mais, riz, ble, ble],
				[ble, mais, sucre, riz],
				[cafe, sucre, cacao, riz],
				[cafe, mais, sucre, mais],
				[cacao, mais, ble, sucre],
				[riz, cafe, sucre, ble],
				[cafe, ble, sucre, cacao],
				[mais, cacao, cacao, cafe],
				[riz,riz,cafe,cacao]
				]
			).


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
																	write('Nouvelle pile gauche : '), affiche_pile(NewRecupGauche), nl,
																	nth(PositionPileD, Marchandises, RecupDroite),
																	supprimer_tete_liste(RecupDroite, NewRecupDroite),
																	write('Nouvelle pile droite : '), affiche_pile(NewRecupDroite),nl,																				
																	construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises).
					

/* Reconstruction des Marchandises en fonction de la position du Trader (on enleve un produit à droite et à gauche) */
																		
supprimer_tete_liste([],[]).
supprimer_tete_liste([_|Y],Y).	


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

%Ble
changer_bourse(Bourse,ble,NewBourse):- 	nth(1,Bourse, Ble),
										nth(2, Ble, ValeurBle),
										NewValeurBle is ValeurBle-1,
										NewBle =[ble, NewValeurBle],
										nth(2,Bourse, Riz),
										nth(3,Bourse, Cacao),
										nth(4,Bourse, Cafe),
										nth(5,Bourse, Sucre),
										nth(6,Bourse, Mais),
										NewBourse = [NewBle, Riz, Cacao, Cafe, Sucre, Mais],!.

%Riz
changer_bourse(Bourse,riz,NewBourse):- 	nth(1,Bourse, Ble),
										nth(2,Bourse, Riz),
										nth(2, Riz, ValeurRiz),
										NewValeurRiz is ValeurRiz-1,
										NewRiz =[riz, NewValeurRiz],
										nth(3,Bourse, Cacao),
										nth(4,Bourse, Cafe),
										nth(5,Bourse, Sucre),
										nth(6,Bourse, Mais),
										NewBourse = [Ble, NewRiz, Cacao, Cafe, Sucre, Mais],!.

%Cacao
changer_bourse(Bourse,cacao,NewBourse):- nth(1,Bourse, Ble),
										nth(2,Bourse, Riz),
										nth(3,Bourse, Cacao),
										nth(2, Cacao, ValeurCacao),
										NewValeurCacao is ValeurCacao-1,
										NewCacao =[cacao, NewValeurCacao],
										nth(4,Bourse, Cafe),
										nth(5,Bourse, Sucre),
										nth(6,Bourse, Mais),
										NewBourse = [Ble, Riz, NewCacao, Cafe, Sucre, Mais],!.
%Cafe
changer_bourse(Bourse,cafe,NewBourse):- nth(1,Bourse, Ble),
										nth(2,Bourse, Riz),
										nth(3,Bourse, Cacao),
										nth(4,Bourse, Cafe),
										nth(2, Cafe, ValeurCafe),
										NewValeurCafe is ValeurCafe-1,
										NewCafe =[cafe, NewValeurCafe],
										nth(5,Bourse, Sucre),
										nth(6,Bourse, Mais),
										NewBourse = [Ble, Riz, Cacao, NewCafe, Sucre, Mais],!.

%Sucre
changer_bourse(Bourse,sucre,NewBourse):- nth(1,Bourse, Ble),
										nth(2,Bourse, Riz),
										nth(3,Bourse, Cacao),
										nth(4,Bourse, Cafe),
										nth(5,Bourse, Sucre),
										nth(2, Sucre, ValeurSucre),
										NewValeurSucre is ValeurSucre-1,
										NewSucre =[sucre, NewValeurSucre],
										nth(6,Bourse, Mais),
										NewBourse = [Ble, Riz, Cacao, Cafe, NewSucre, Mais],!.

%Mais
changer_bourse(Bourse,mais,NewBourse):- nth(1,Bourse, Ble),
										nth(2,Bourse, Riz),
										nth(3,Bourse, Cacao),
										nth(4,Bourse, Cafe),
										nth(5,Bourse, Sucre),
										nth(6,Bourse, Mais),
										nth(2, Mais, ValeurMais),
										NewValeurMais is ValeurMais-1,
										NewMais =[mais, NewValeurMais],
										NewBourse = [Ble, Riz, Cacao, Cafe, Sucre, NewMais],!.



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
				   				affiche_pile(ReserveJ1), nl, nl.

affiche_joueur2(ReserveJ2) :- 	write('\nVoici la reserve du Joueur2 :\n'),
							  	write('-----------------------------\n'),
							  	affiche_pile(ReserveJ2), nl, nl.


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
													demander_joueur(Joueur), 
													demander_deplacement(Deplacement), 
													length(Marchandises, LongueurM),
													changer_position(PositionTrader, Deplacement, LongueurM, NewPosition),
													write(NewPosition),
													affiche_marchandises_top(Marchandises),
													affiche_position(NewPosition),
													write('Quel gardez-vous ? '), read(Garder),
													write('Que jetez-vous ? '), read(Jeter).

/* demander_joueur permet de demander le joueur, jusque j1 ou j2 soit rentré par l'utilisateur*/

demander_joueur(Joueur):-	write('Quel est le joueur ? '), read(JoueurSaisi),
							traitement_joueur_saisi(JoueurSaisi,Joueur).
						
traitement_joueur_saisi(JoueurSaisi, Joueur) :-	\+joueur_possible(JoueurSaisi), write('Veuillez rentrer j1 ou j2 (j minuscule)\n'),
												demander_joueur(Joueur),!.

traitement_joueur_saisi(JoueurSaisi, Joueur) :-	joueur_possible(JoueurSaisi), Joueur = JoueurSaisi,!.

joueur_possible(JoueurSaisi):- JoueurSaisi == j1,!.
joueur_possible(JoueurSaisi):- JoueurSaisi == j2,!.


/* demander_deplacement permet de demander le déplacement, jusque Deplacement = 1,2,3 soit rentré par l'utilisateur*/

demander_deplacement(Deplacement) :- 	write(' Quel deplacement souhaitez vous faire ? '), read(DeplacementSaisi), 
										traitement_deplacement_saisi(DeplacementSaisi, Deplacement).

traitement_deplacement_saisi(DeplacementSaisi, Deplacement) :-	\+deplacement_possible(DeplacementSaisi),
																write('Veuillez rentrer un deplacement egal a 1, 2 ou 3 \n'),
																demander_deplacement(Deplacement),!.

traitement_deplacement_saisi(DeplacementSaisi, Deplacement) :- 	deplacement_possible(DeplacementSaisi), Deplacement = DeplacementSaisi,!.										

deplacement_possible(DeplacementSaisi) :-	DeplacementSaisi == 1,!.
deplacement_possible(DeplacementSaisi) :-	DeplacementSaisi == 2,!.
deplacement_possible(DeplacementSaisi) :-	DeplacementSaisi == 3,!.


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
											write('ATTENTION : Le coup n\'est pas possible \n'),
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