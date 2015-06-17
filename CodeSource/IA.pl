/*==================================*/
/*==================================*/
/* PARTIE INTELLIGENCE ARTIFICIELLE */
/*==================================*/
/*==================================*/


%Prédicats liés à l'IA


/*----------------*/
/* COUP POSSIBLES */
/*----------------*/

/*retourne tous les coups possibles*/

coups_possibles([Marchandises|_],[]) :- 	length(Marchandises, LongueurM),
															LongueurM <3.

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
										coup_score_max(ListeCoupsPossiblesScores,[MeilleurCoup,_]).



/*calcul du score d'un joueur*/

calcul_score_joueur(j1,[_,Bourse,_,R1,_], Score):- score_reserve(Bourse, R1, Score),!.
calcul_score_joueur(j2,[_,Bourse,_,_,R2], Score):- score_reserve(Bourse, R2, Score).

/*calcul du score d'une reserve*/

score_reserve(_, [], 0):-!.
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

scores_coups_possibles(_, [], []):-!.

scores_coups_possibles(Plateau,[[Joueur|QueueCoup]|Q], ListeCoupsPossiblesScores):-
				jouer_coup_machine(Plateau,[Joueur|QueueCoup],NewPlateau),
				calcul_score_joueur(Joueur,NewPlateau, Score),
				append([[Joueur|QueueCoup]], [Score], ScoreCoup),
				scores_coups_possibles(Plateau,Q, ListeCoupsPossiblesScoresQueue),
				append(ListeCoupsPossiblesScoresQueue, [ScoreCoup] ,ListeCoupsPossiblesScores).

/*coup_score_max recupère le coup qui a le score max, avec son score*/

coup_score_max([], CoupMax, CoupMax):-!.

coup_score_max([[Coup, Score]|Q], [_, ScoreMaxPrecedent], CoupMax) :- 
				Score > ScoreMaxPrecedent,
				coup_score_max(Q,[Coup, Score], CoupMax),!.
		
coup_score_max([_|Q], CoupScorePrecedent, CoupMax) :- 
				/*Score <= ScoreMaxPrecedent,*/
				coup_score_max(Q,CoupScorePrecedent, CoupMax),!.

coup_score_max(ListeScore,CoupMax):- coup_score_max(ListeScore,[_,-2000000],CoupMax).
