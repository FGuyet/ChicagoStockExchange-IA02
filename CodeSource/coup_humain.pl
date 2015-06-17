/*----------------------------*/
/* DEMANDER UN COUP AU JOUEUR */
/*----------------------------*/

%Prédicats liés aux coups d'un joueur humain

/* Interface jeu-utilisateur pour que le joueur choississe son coup */

demander_coup([Joueur,Deplacement,Garder,Jeter], [Marchandises, _, PositionTrader, _, _]) :-		
													joueurEnCours(Joueur), /* demander_joueur(Joueur), */
													write('\nC\'est au tour de '), write(Joueur), write(' de jouer !'), nl,
													demander_deplacement(Deplacement), 
													length(Marchandises, LongueurM),
													changer_position(PositionTrader, Deplacement, LongueurM, NewPosition),
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
														PositionD is LongueurM ,!.
position_droite(NewPosition, LongueurM, PositionD):- 	PositionD is (NewPosition + 1) mod LongueurM.

position_gauche(NewPosition, LongueurM, PositionG):- 	PositionInt is (NewPosition - 1) mod LongueurM,
														PositionInt == 0 ,
														PositionG is LongueurM ,!.
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
							


/*------------*/
/* JOUER COUP */
/*------------*/												

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

