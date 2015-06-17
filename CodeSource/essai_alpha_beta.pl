
/*


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
						coup_score_max([CoupMinimax1,CoupMinimax2], MeilleurCoupsDeplacement),
						changer_joueur.


meilleur_coup_direct(Plateau, MeilleurCoup):- 	coups_possibles(Plateau, ListeCoupsPossibles),
												scores_coups_possibles(Plateau,ListeCoupsPossibles, ListeCoupsPossiblesScores),
												coup_score_max(ListeCoupsPossiblesScores,MeilleurCoup,ScoreMax).

*/