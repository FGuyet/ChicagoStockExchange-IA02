/***********/
/* MINIMAX */
/***********/

% Prédicats liés au minimax

/*coup_score_max recupère le coup qui a le score max, avec son score*/

coup_score_min([], CoupMax, CoupMax):-!.

coup_score_min([[Coup, Score]|Q], [_, ScoreMaxPrecedent], CoupMax) :- 
				Score < ScoreMaxPrecedent,
				coup_score_min(Q,[Coup, Score], CoupMax),!.
		
coup_score_min([_|Q], CoupScorePrecedent, CoupMax) :- 
				/*Score >= ScoreMaxPrecedent,*/
				coup_score_min(Q,CoupScorePrecedent, CoupMax),!.

coup_score_min(ListeScore,CoupMax):- coup_score_min(ListeScore,[_,2000000],CoupMax).




/************************/
/* MINIMAX PROFONDEUR 2 */
/************************/


minimax1([Marchandises|Reste], MeilleurCoup):-
	length(Marchandises, LongueurM), LongueurM < 5,
	meilleur_coup([Marchandises|Reste], MeilleurCoup).

minimax1(Plateau, MeilleurCoup,ScoreMax):-
	coups_possibles(Plateau, ListeCoupsPossibles),
	max_min_opposant(Plateau, ListeCoupsPossibles, [MeilleurCoup,ScoreMax]).

/* maximum des coups minimum de l'adversaire */

max_min_opposant(_,[] ,CoupScorePrecedent,CoupScorePrecedent):- !.

max_min_opposant(Plateau,[[_,Deplacement, Garder, Jeter]|Q] , [_, ScoreMinPrecedent], [MeilleurCoup, ScoreMin]):-

			joueurEnCours(Joueur),
			jouer_coup_machine(Plateau, [Joueur,Deplacement, Garder, Jeter], NewPlateau),
		
			changer_joueur,
			min_score_opposant( NewPlateau ,ScoreMinCoup),
			changer_joueur,

			ScoreMinCoup > ScoreMinPrecedent, 
			

			max_min_opposant(Plateau, Q, [[Joueur,Deplacement, Garder, Jeter], ScoreMinCoup], [MeilleurCoup, ScoreMin]),!.


max_min_opposant(Plateau,[[_,Deplacement, Garder, Jeter]|Q] ,[MeilleurCoupPrecedent, ScoreMinPrecedent], [MeilleurCoup, ScoreMin]):-
			joueurEnCours(Joueur),
			jouer_coup_machine(Plateau,  [Joueur,Deplacement, Garder, Jeter], NewPlateau),

			changer_joueur,
			min_score_opposant( NewPlateau ,_),
			changer_joueur,
			
			/*ScoreMinCoup <= ScoreMinPrecedent, */ 
			max_min_opposant(Plateau, Q, [MeilleurCoupPrecedent, ScoreMinPrecedent], [MeilleurCoup, ScoreMin]),!.

max_min_opposant(Plateau, ListeCoupsPossibles, [MeilleurCoup, ScoreMin]):-

	 max_min_opposant(Plateau, ListeCoupsPossibles, [_,-30000], [MeilleurCoup, ScoreMin]),!.

/* Score minimum de l'opposant */

min_score_opposant(Plateau, ScoreMin):-
				coups_possibles(Plateau, ListeCoupsPossibles),
				scores_coups_possibles(Plateau,ListeCoupsPossibles, ListeCoupsPossiblesScores),
				coup_score_min(ListeCoupsPossiblesScores,[_,ScoreMin]).





/************************/
/* MINIMAX PROFONDEUR 4 */
/************************/

minimax2([Marchandises|Reste], MeilleurCoup):-
	length(Marchandises, LongueurM), LongueurM < 8,
	meilleur_coup([Marchandises|Reste], MeilleurCoup).

minimax2(Plateau, MeilleurCoup):-
	coups_possibles(Plateau, ListeCoupsPossibles),
	max_min_opposant2(Plateau, ListeCoupsPossibles, [MeilleurCoup, _]).

/* maximum des coups minimum de l'adversaire */

max_min_opposant2(_,[] ,[MeilleurCoupPrecedent, ScoreMinPrecedent], [MeilleurCoupPrecedent, ScoreMinPrecedent]):-!.

max_min_opposant2(Plateau,[[_,Deplacement, Garder, Jeter]|Q] , [_, ScoreMinPrecedent], [MeilleurCoup, ScoreMin]):-

			joueurEnCours(Joueur),
			jouer_coup_machine(Plateau, [Joueur,Deplacement, Garder, Jeter], NewPlateau),
		
			changer_joueur,
			min_score_opposant2( NewPlateau ,ScoreMinCoup),
			changer_joueur,

			ScoreMinCoup > ScoreMinPrecedent, 
			

			max_min_opposant2(Plateau, Q, [[Joueur,Deplacement, Garder, Jeter], ScoreMinCoup], [MeilleurCoup, ScoreMin]),!.


max_min_opposant2(Plateau,[[_,Deplacement, Garder, Jeter]|Q] ,[MeilleurCoupPrecedent, ScoreMinPrecedent], [MeilleurCoup, ScoreMin]):-
			joueurEnCours(Joueur),
			jouer_coup_machine(Plateau,  [Joueur,Deplacement, Garder, Jeter], NewPlateau),

			changer_joueur,
			min_score_opposant2( NewPlateau ,_),
			changer_joueur,
			
			/*ScoreMinCoup <= ScoreMinPrecedent, */ 
			max_min_opposant2(Plateau, Q, [MeilleurCoupPrecedent, ScoreMinPrecedent], [MeilleurCoup, ScoreMin]),!.

max_min_opposant2(Plateau, ListeCoupsPossibles, [MeilleurCoup, ScoreMin]):-

	 max_min_opposant2(Plateau, ListeCoupsPossibles, [_,-30000], [MeilleurCoup, ScoreMin]),!.

/*score minimum de l'opposant */

min_score_opposant2(Plateau, ScoreMin):-
				coups_possibles(Plateau, ListeCoupsPossibles),
				liste_sous_minimax(Plateau, ListeCoupsPossibles, ListeSousMinimax),
				coup_score_min(ListeSousMinimax,[_,ScoreMin]).

/* forme une liste des minimax1 de profondeur2 utilisé dans minimax2 */

liste_sous_minimax(_, [], []):-!.	

liste_sous_minimax(Plateau, [T|Q],ListeSousMinimax):-
				changer_joueur,
				jouer_coup_machine(Plateau,T,NewPlateau),
				minimax1(NewPlateau, MeilleurCoup, ScoreMax),
				changer_joueur,
				liste_sous_minimax(Plateau, Q,ListeSousMinimaxQueue),

				append([[MeilleurCoup, ScoreMax]],ListeSousMinimaxQueue, ListeSousMinimax),!.



/*type de jeu permettant de confronter l'IA simple à l'IA minimax de profondeur 4 */


jeuM1M2:- retract(joueurEnCours(_)), jeuM1M2,!.
jeuM1M2 :- nl, nl, write('Jeu Machine nv1 vs Machine nv2 selectionne'), nl, nl,asserta(joueurEnCours(j2)), plateau_depart(P), boucle_jeuM1M2(P).

/* Le jeu s'arrête lorqu'il reste seulement 2 piles de Jetons dans les marchandises */

boucle_jeuM1M2([Marchandises,Bourse,PositionTrader,R1,R2]):- length(Marchandises, LongueurM), LongueurM < 3,nl, affiche_marchandises_top(Marchandises),nl, write('LE JEU EST TERMINE'), affiche_gagnant([Marchandises,Bourse,PositionTrader,R1,R2]),retract(joueurEnCours(_)),!.
boucle_jeuM1M2(Plateau):- joueurEnCours(j1), affiche_plateau(Plateau), changer_joueur, coup_machine(Plateau, Coup), jouer_coup_machine(Plateau,Coup, NewPlateau),boucle_jeuM1M2(NewPlateau),!.
boucle_jeuM1M2(Plateau):- joueurEnCours(j2), affiche_plateau(Plateau), changer_joueur, coup_machine_minimax(Plateau,Coup), jouer_coup_machine(Plateau, Coup, NewPlateau), boucle_jeuM1M2(NewPlateau),!.




coup_machine_minimax(Plateau,Coup):-	nl,write('L\'ordinateur joue son tour: ... *reflexion intense*'), nl,nl,
							 			minimax2(Plateau, [_, Deplacement, Garder, Jeter]),
								 		write('Deplacement:'), write(Deplacement),nl,
								 		write('L\'ordinateur garde:'), write(Garder), nl,
								 		write('L\'ordinateur jette:'), write(Jeter),nl,nl,
								 		joueurEnCours(Joueur),
								 		Coup=[Joueur, Deplacement, Garder, Jeter].