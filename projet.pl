

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
									write('\nLa lettre T représente la position du Trader (position='), write(Position), write(')\n\n').

affiche_tab(0):- !.
affiche_tab(N):- write('\t'), Nbre is (N-1), affiche_tab(Nbre).



%---------------------------------------------------------

%ReserveJoueur1
reserveJoueur1([]).

%ReserveJoueur2
reserveJoueur2([]).


/* L'affichage des réserves	des joueurs*/	
affiche_joueur1(ReserveJ1) :-	write('\nVoici la réserve du Joueur1 :\n'),
				   				write('-----------------------------\n'),
				   				affiche_pile(ReserveJ1), write('\n\n').

affiche_joueur2(ReserveJ2) :- 	write('\nVoici la réserve du Joueur2 :\n'),
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

coup_possible(	[Marchandises, _, PositionTrader, _,_],
				[_,Deplacement,Garder,Jeter]):- 
							length(Marchandises, LongueurM),
							NewPosition is (PositionTrader+Deplacement) mod LongueurM,
							recuperer_droite(NewPosition, Marchandises,LongueurM,ProduitDroite),
							recuperer_gauche(NewPosition, Marchandises, LongueurM, ProduitGauche), 
							ProduitGauche == Garder, 
							ProduitDroite == Jeter.

coup_possible(	[Marchandises, _, PositionTrader, _,_],
				[_,Deplacement,Garder,Jeter]):- 
							length(Marchandises, LongueurM),
							NewPosition is (PositionTrader+Deplacement) mod LongueurM,
							recuperer_droite(NewPosition, Marchandises, LongueurM,ProduitDroite),
							recuperer_gauche(NewPosition, Marchandises, LongueurM, ProduitGauche), 
							ProduitGauche == Jeter, 
							ProduitDroite == Garder.
							
						
recuperer_droite(NewPosition, Marchandises, LongueurM, ProduitDroite):- PositionDroite is (NewPosition + 1) mod LongueurM, 
																		nth(PositionDroite, Marchandises, PileDroite), 
																		nth(1, PileDroite, ProduitDroite).

recuperer_gauche(NewPosition, Marchandises, LongueurM, ProduitGauche):- PositionGauche is (NewPosition - 1) mod LongueurM, 
																		nth(PositionGauche, Marchandises, PileGauche),
																		nth(1, PileGauche, ProduitGauche).


/*
jouer_coup(	[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2],
			[Joueur,Deplacement,Garder,Jeter],
			[NewMarchandises, NewBourse, NewPositionTrader, NewReserveJ1, NewReserveJ2]) :-
						coup_possible(	[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2],
										[Joueur,Deplacement,Garder,Jeter]),
						write('Le coup est possible\n'),
						length(Marchandises,LongueurM),
						changer_position(PositionTrader, LongueurM, Deplacement, NewPosition),
						changer_bourse(Bourse,Jeter,NewBourse), 
						ajouter_reserve(Joueur, ReserveJ1, ReserveJ2).
*/

jouer_coup(Plateau, Coup, NewPlateau) :-	\+coup_possible(Plateau,Coup),
											write('ATTENTION : Le coup n\'est pas possible \n'),
											NewPlateau is Plateau.

changer_position(OldPosition, LongueurM, Deplacement, NewPosition) :- NewPosition is (OldPosition+Deplacement) mod LongueurM.


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
