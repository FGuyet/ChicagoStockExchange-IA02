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

%PositionTrader
positionTrader(3).

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
																				positionTrader(PositionTrader),
																				reserveJoueur1(ReserveJ1),
																				reserveJoueur2(ReserveJ2).



