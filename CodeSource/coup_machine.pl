
/*--------------*/
/* COUP MACHINE */
/*--------------*/	


/* Coup machine*/
coup_machine(Plateau,Coup):-	nl,write('L\'ordinateur joue son tour: ... *reflexion intense*'), nl,nl,
							 	meilleur_coup(Plateau, [_, Deplacement, Garder, Jeter]),
							 	write('Deplacement:'), write(Deplacement),nl,
							 	write('L\'ordinateur garde:'), write(Garder), nl,
							 	write('L\'ordinateur jette:'), write(Jeter),nl,nl,
							 	joueurEnCours(Joueur),
							 	Coup=[Joueur, Deplacement, Garder, Jeter].


jouer_coup_machine(	[Marchandises, Bourse, PositionTrader, ReserveJ1, ReserveJ2],
			[Joueur,Deplacement,Garder,Jeter],
			[NewMarchandises, NewBourse, NewPositionTrader, NewReserveJ1, NewReserveJ2]) :-
						length(Marchandises,LongueurM),
						changer_position(PositionTrader, Deplacement, LongueurM, NewPositionTrader),
						changer_bourse(Bourse,Jeter,NewBourse), 
						ajouter_reserve(Joueur, Garder, ReserveJ1, ReserveJ2, NewReserveJ1, NewReserveJ2), 
						changer_marchandises(Marchandises, NewPositionTrader,NewMarchandises),!.

