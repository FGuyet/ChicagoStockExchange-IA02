

%Bourse
bourse([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).


/*Affichage de la bourse*/

affiche_bourse(Bourse) :- 	write('\nVoici la bourse :\n'),
					write('-----------------\n'),
					affiche_valeurs(Bourse),
					write('\n').

affiche_valeurs([]).
affiche_valeurs([T|Q]):- affiche_valeur(T), affiche_valeurs(Q).

affiche_valeur([Nom,Valeur]):- write(Nom), write(' :\t'), write(Valeur), write('\n').


%----------------------------------------------------------------------

%Marchandises
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
			) .



%Affichage des marchandises en imprimant chaque pile

affiche_marchandises(Marchandises):- 	write('\nVoici les piles et leur contenu :\n'),
										write('---------------------------------\n'),
										affiche_piles(Marchandises),
										write('\n').
/* X prends la valeur du parametre dans marchandises ==> puis affiche cette liste de piles grâce aux prédicats ci-dessous */ 

%Piles
affiche_piles([]).
affiche_piles([T|Q]) :- affiche_pile(T), write('\n'), affiche_piles(Q).

%Pile
affiche_pile([]).
affiche_pile([T|Q]) :- write(T), write(' '), affiche_pile(Q).





%Affichage de la première carte de chaque pile

affiche_marchandises_top(Marchandises):- 	write('\nVoici les cartes au sommet de chaque pile :\n'),
											write('-------------------------------------------\n'),
											write('|'), affiche_piles_top(Marchandises),
											write('\n').
/* X prends la valeur du parametre dans marchandises ==> puis affiche cette liste de piles grâce aux prédicats ci-dessous */ 

%Piles
affiche_piles_top([]):- !.
affiche_piles_top([T|Q]) :- affiche_pile_top(T), write('\t|'), affiche_piles_top(Q).

%Pile
affiche_pile_top([]):- write('VIDE').
affiche_pile_top([T|_]) :- write(T).




%------------------------------------------------------


/*Affichage de la position du trader par rapport aux piles */
affiche_position(Position):- 		Nbre is (Position-1),
									affiche_tab(Nbre), write('   T\n'),
									write('\nLa lettre T represente la position du Trader (position='), write(Position), write(')\n\n').

affiche_tab(0):- !.
affiche_tab(N):- write('\t'), Nbre is (N-1), affiche_tab(Nbre).



%---------------------------------------------------------

%ReserveJoueur1
reserveJoueur1([]).

%ReserveJoueur2
reserveJoueur2([]).


/* L'affichage des réserves	des joueurs*/	
affiche_joueur1(ReserveJ1) :-	write('\nVoici la reserve du Joueur1 :\n'),
				   				write('-----------------------------\n'),
				   				affiche_pile(ReserveJ1), write('\n\n').

affiche_joueur2(ReserveJ2) :- 	write('\nVoici la reserve du Joueur2 :\n'),
							  	write('-----------------------------\n'),
							  	affiche_pile(ReserveJ2), write('\n\n').


%----------------------------------------------


%Plateau ([Marchandises, Bourse, PositionTrader, ReserveJoueur1, ReserveJoueur2])
affiche_plateau([Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]):-	affiche_bourse(Bourse),
																				affiche_marchandises_top(Marchandises), 
																				affiche_position(PositionTrader),
																				affiche_joueur1(ReserveJ1),
																				affiche_joueur2(ReserveJ2).



plateau_depart([Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2]):-	bourse(Bourse),
																				marchandises(Marchandises), 
																				random(1,9,PositionTrader),
																				reserveJoueur1(ReserveJ1),
																				reserveJoueur2(ReserveJ2).




%------------------------------------------------------------------


changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ):- 	PositionInt is (PositionTrader + Deplacement) mod LongueurM,
																			PositionInt == 0 ,
																			NewPosition is 9 ,!.
changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ):- 	NewPosition is (PositionTrader + Deplacement) mod LongueurM,!.

position_droite(NewPosition, LongueurM, PositionD):- 	PositionInt is (NewPosition + 1) mod LongueurM,
														PositionInt == 0 ,
														PositionD is 9 ,!.
position_droite(NewPosition, LongueurM, PositionD):- 	PositionD is (NewPosition + 1) mod LongueurM.

position_gauche(NewPosition, LongueurM, PositionG):- 	PositionInt is (NewPosition - 1) mod LongueurM,
														PositionInt == 0 ,
														PositionG is 9 ,!.
position_gauche(NewPosition, LongueurM, PositionG):- 	PositionG is (NewPosition - 1) mod LongueurM.
														

coup_possible(	[Marchandises, _, PositionTrader, _,_],
				[_,Deplacement,Garder,Jeter]):- 
							length(Marchandises, LongueurM),
							changer_position(PositionTrader, Deplacement, LongueurM, NewPosition ),
							recuperer_droite(NewPosition, Marchandises,LongueurM,ProduitDroite),
							recuperer_gauche(NewPosition, Marchandises, LongueurM, ProduitGauche), 
							produits_a_cote(Garder, Jeter, ProduitGauche, ProduitDroite).
							
produits_a_cote(Garder, Jeter, ProduitGauche, ProduitDroite) :- ProduitGauche == Garder, 
																ProduitDroite == Jeter,!.							
		
produits_a_cote(Garder, Jeter, ProduitGauche, ProduitDroite) :-	ProduitGauche == Jeter, 
																ProduitDroite == Garder.
		

recuperer_droite(NewPosition, Marchandises, LongueurM, ProduitDroite):- position_droite(NewPosition , LongueurM, PositionDroite), 
																		nth(PositionDroite, Marchandises, PileDroite), 
																		nth(1, PileDroite, ProduitDroite).

recuperer_gauche(NewPosition, Marchandises, LongueurM, ProduitGauche):- position_gauche(NewPosition , LongueurM, PositionGauche),
																		nth(PositionGauche, Marchandises, PileGauche),
																		nth(1, PileGauche, ProduitGauche).

demander_coup([Joueur,Deplacement,Garder,Jeter], [Marchandises, _, PositionTrader, _, _]) :-		
													write('Quel joueur ?'), read(Joueur), nl,
													write('Deplacement ?'), read(Deplacement), nl,
													length(Marchandises, LongueurM),
													changer_position(PositionTrader, Deplacement, LongueurM, NewPosition),
													write(NewPosition),
													affiche_marchandises_top(Marchandises),
													affiche_position(NewPosition),
													write('Quel gardez-vous ?'), read(Garder), nl,
													write('Que jetez-vous ?'), read(Jeter), nl.
											
																		
jouer_coup(Plateau, Coup, NewPlateau) :-	\+coup_possible(Plateau,Coup),
											write('ATTENTION : Le coup n\'est pas possible \n'),
											NewPlateau is Plateau,!.
											
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

%demander_coup([Joueur,Deplacement,Garder,Jeter], Marchandises, PositionTrader, LongueurM),
						
						

% Changer Bourse
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


ajouter_reserve(j1,Garder , ReserveJ1, _, NewReserveJ1,_):- 	IntReserveJ1 = ReserveJ1,
																append(IntReserveJ1,[Garder], NewReserveJ1).


ajouter_reserve(j2,Garder , _, ReserveJ2, _, NewReserveJ2):-	IntReserveJ2 = ReserveJ2,
																append(IntReserveJ2,[Garder], NewReserveJ2).

																

%Changer Marchandises																
<<<<<<< HEAD
changer_marchandises(Marchandises, NewPosition, NewMarchandises) :- length(Marchandises, LongueurM),
																	position_droite(NewPosition, LongueurM, PositionPileD),
																	position_gauche(NewPosition, LongueurM, PositionPileG),
																	nth(PositionPileG, Marchandises, RecupGauche),
																	supprimer_tete_liste(RecupGauche, NewRecupGauche),
																	write('Nouvelle pile gauche : '), affiche_pile(NewRecupGauche), write('\n'),
																	nth(PositionPileD, Marchandises, RecupDroite),
																	supprimer_tete_liste(RecupDroite, NewRecupDroite),
																	write('Nouvelle pile droite : '), affiche_pile(NewRecupDroite),write('\n'),																				
																	construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises).
																				
%Trader en position 1
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 1,
																										nth(1,Marchandises, Pile1),				
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										write('Position trader 1'),
																										NewMarchandises = [Pile1, NewRecupDroite, Pile3, Pile4, Pile5, Pile6, Pile7, Pile8, NewRecupGauche], !.

	
%Trader en position 2
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 2,
																										nth(2,Marchandises, Pile2),
=======
changer_marchandises(Marchandises, NewPosition, NewMarchandises) :- PileD is (NewPosition+1), PileG is (NewPosition-1),
																	nth(PileG, Marchandises, RecupGauche),
																	supprimer_tete_liste(RecupGauche, NewRecupGauche),
																	write('Nouvelle pile gauche : '), affiche_pile(NewRecupGauche), write('\n'),
																	nth(PileD, Marchandises, RecupDroite),
																	supprimer_tete_liste(RecupDroite, NewRecupDroite),
																	write('Nouvelle pile droite : '), affiche_pile(NewRecupDroite),write('\n'),																				
																	construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises).
																				
%Trader en position 2
construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	nth(2,Marchandises, Pile2),
>>>>>>> origin/master
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
<<<<<<< HEAD
=======
																										NewPosition == 2,
>>>>>>> origin/master
																										write('Position trader 2'),
																										NewMarchandises = [NewRecupGauche, Pile2, NewRecupDroite, Pile4, Pile5, Pile6, Pile7, Pile8, Pile9], !.

%Trader en position 3
<<<<<<< HEAD
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 3,
																										nth(1,Marchandises, Pile1),
=======
construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	nth(1,Marchandises, Pile1),
>>>>>>> origin/master
																									    nth(3,Marchandises, Pile3),																						
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
<<<<<<< HEAD
=======
																										NewPosition == 3,
>>>>>>> origin/master
																										write('Position trader 3'),
																										NewMarchandises = [Pile1, NewRecupGauche, Pile3, NewRecupDroite, Pile5, Pile6, Pile7, Pile8, Pile9], !.																						

%Trader en position 4
<<<<<<< HEAD
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 4,
																										nth(1,Marchandises, Pile1),
=======
construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	nth(1,Marchandises, Pile1),
>>>>>>> origin/master
																										nth(2,Marchandises, Pile2),
																										nth(4,Marchandises, Pile4),
																										nth(6,Marchandises, Pile6),
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
<<<<<<< HEAD
=======
																										NewPosition == 4,
>>>>>>> origin/master
																										write('Position trader 4'),
																										NewMarchandises = [Pile1, Pile2, NewRecupGauche, Pile4, NewRecupDroite, Pile6, Pile7, Pile8, Pile9], !.

%Trader en position 5
<<<<<<< HEAD
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 5,
																										nth(1,Marchandises, Pile1),
=======
construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	nth(1,Marchandises, Pile1),
>>>>>>> origin/master
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(5,Marchandises, Pile5),																										
																										nth(7,Marchandises, Pile7),
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
<<<<<<< HEAD
=======
																										NewPosition == 5,
>>>>>>> origin/master
																										write('Position trader 5'),
																										NewMarchandises = [Pile1, Pile2, Pile3, NewRecupGauche, Pile5, NewRecupDroite, Pile7, Pile8, Pile9], !.																									
																										
																										
%Trader en position 6
<<<<<<< HEAD
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 6,
																										nth(1,Marchandises, Pile1),
=======
construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	nth(1,Marchandises, Pile1),
>>>>>>> origin/master
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),																										
																										nth(6,Marchandises, Pile6),																										
																										nth(8,Marchandises, Pile8),
																										nth(9,Marchandises, Pile9),
<<<<<<< HEAD
=======
																										NewPosition == 6,
>>>>>>> origin/master
																										write('Position trader 6'),
																										NewMarchandises = [Pile1, Pile2, Pile3, Pile4, NewRecupGauche, Pile6, NewRecupDroite, Pile8, Pile9], !.
																										
%Trader en position 7
<<<<<<< HEAD
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 7,
																										nth(1,Marchandises, Pile1),
=======
construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	nth(1,Marchandises, Pile1),
>>>>>>> origin/master
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),																										
																										nth(7,Marchandises, Pile7),																										
																										nth(9,Marchandises, Pile9),
<<<<<<< HEAD
=======
																										NewPosition == 7,
>>>>>>> origin/master
																										write('Position trader 7'),
																										NewMarchandises = [Pile1, Pile2, Pile3, Pile4, Pile5, NewRecupGauche, Pile7, NewRecupDroite, Pile9], !.
																										
%Trader en position 8
<<<<<<< HEAD
construct_marchandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	NewPosition == 8,
																										nth(1,Marchandises, Pile1),
=======
construct_machandises(Marchandises, NewRecupGauche, NewRecupDroite, NewPosition, NewMarchandises) :-	nth(1,Marchandises, Pile1),
>>>>>>> origin/master
																										nth(2,Marchandises, Pile2),
																										nth(3,Marchandises, Pile3),
																										nth(4,Marchandises, Pile4),
																										nth(5,Marchandises, Pile5),
																										nth(6,Marchandises, Pile6),																										
																										nth(8,Marchandises, Pile8),																										
<<<<<<< HEAD
																										write('Position trader 8'),
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
																										write('Position trader 9'),
																										NewMarchandises = [NewRecupDroite, Pile2, Pile3, Pile4, Pile5, Pile6, Pile7, NewRecupGauche, Pile9], !.
																										
																									
=======
																										NewPosition == 8,
																										write('Position trader 8'),
																										NewMarchandises = [Pile1, Pile2, Pile3, Pile4, Pile5, Pile6, NewRecupGauche, Pile8, NewRecupDroite], !.
																										
>>>>>>> origin/master
supprimer_tete_liste([],[]).
supprimer_tete_liste([_|Y],Y).																