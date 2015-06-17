/*----------------------------------------*/
/* Projet de IA02: Chicago Stock Exchange */
/*  	Charlotte Haag - Florian Guyet    */
/*----------------------------------------*/



/* Le jeu se lance en rentrant écrivant la commande suivante dans GNU Prolog : jeu. */

/*enleve les joueurs en cours puis débute une partie */

jeu:- link_files, retract(joueurEnCours(_)), jeu,!.

jeu:- 	nl,nl,write('NOUVELLE PARTIE !'), nl, nl,
		demander_type_jeu(Choix),
		executer_jeu(Choix).

demander_type_jeu(Choix):- 	nl,nl,write('Quel mode voulez vous executer ?'), nl,nl,
							write('1 - Humain vs Humain.'), nl,
							write('2 - Humain vs Machine.'), nl,
							write('3 - Machine vs Machine.'), nl,
							read(ChoixSaisi), traitement_type_jeu(ChoixSaisi,Choix).

/* boucle vérifiant que le choix est égal à 1, 2 ou 3 */
traitement_type_jeu(ChoixSaisi,Choix) :-	\+jeu_possible(ChoixSaisi),
											write('Veuillez rentrer un choix egal a 1, 2 ou 3 '), nl, nl,
											demander_type_jeu(Choix),!.

traitement_type_jeu(ChoixSaisi,ChoixSaisi) :- 	jeu_possible(ChoixSaisi),!.										

jeu_possible(1) :-!.
jeu_possible(2) :-!.
jeu_possible(3) :-!.

executer_jeu(1):- jeuHH,!.
executer_jeu(2):- jeuHM,!.
executer_jeu(3):- jeuMM,!.

/* jeu Humain vs Humain */

jeuHH :- nl, nl, write('Jeu Humain vs Humain selectionne'), nl, nl,asserta(joueurEnCours(j2)), plateau_depart(P), boucle_jeuHH(P).

/* Le jeu s'arrête lorqu'il reste seulement 2 piles de Jetons dans les marchandises */

boucle_jeuHH([Marchandises,Bourse,PositionTrader,R1,R2]):- length(Marchandises, LongueurM), LongueurM < 3,nl, affiche_marchandises(Marchandises),nl, write('LE JEU EST TERMINE'), affiche_gagnant([Marchandises,Bourse,PositionTrader,R1,R2]),retract(joueurEnCours(_)),!.
boucle_jeuHH(Plateau):- affiche_plateau(Plateau), changer_joueur, demander_coup(Coup,Plateau), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuHH(NewPlateau).



/* jeu Humain vs Machine */

jeuHM :- nl, nl, write('Jeu Humain vs Machine selectionne'), nl, nl, asserta(joueurEnCours(j2)), plateau_depart(P), boucle_jeuHM(P).

/* Le jeu s'arrête lorqu'il reste seulement 2 piles de Jetons dans les marchandises */

boucle_jeuHM([Marchandises,Bourse,PositionTrader,R1,R2]):- length(Marchandises, LongueurM), LongueurM < 3,nl, affiche_marchandises(Marchandises),nl, write('LE JEU EST TERMINE'), affiche_gagnant([Marchandises,Bourse,PositionTrader,R1,R2]),retract(joueurEnCours(_)),!.
boucle_jeuHM(Plateau):- joueurEnCours(j2), affiche_plateau(Plateau), changer_joueur, demander_coup(Coup,Plateau), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuHM(NewPlateau).
boucle_jeuHM(Plateau):- joueurEnCours(j1), affiche_plateau(Plateau), changer_joueur, coup_machine(Plateau,Coup), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuHM(NewPlateau).



/* jeu Machine vs Machine */

jeuMM :- nl, nl, write('Jeu Machine vs Machine selectionne'), nl, nl,asserta(joueurEnCours(j2)), plateau_depart(P), boucle_jeuMM(P).

/* Le jeu s'arrête lorqu'il reste seulement 2 piles de Jetons dans les marchandises */

boucle_jeuMM([Marchandises,Bourse,PositionTrader,R1,R2]):- length(Marchandises, LongueurM), LongueurM < 3, nl, affiche_marchandises(Marchandises), nl, write('LE JEU EST TERMINE'), affiche_gagnant([Marchandises,Bourse,PositionTrader,R1,R2]),retract(joueurEnCours(_)),!.
boucle_jeuMM(Plateau):- affiche_plateau(Plateau), changer_joueur, coup_machine(Plateau,Coup), jouer_coup(Plateau, Coup, NewPlateau), boucle_jeuMM(NewPlateau).



affiche_gagnant(PlateauFin):- 	calcul_score_joueur(j1,PlateauFin,ScoreJ1),
								calcul_score_joueur(j2,PlateauFin,ScoreJ2),
								ScoreJ1 > ScoreJ2,
								nl,write('Le joueur j1 gagne ! ('), write(ScoreJ1), write(' vs '), write(ScoreJ2), write(')'),!.


affiche_gagnant(PlateauFin):- 	calcul_score_joueur(j1,PlateauFin,ScoreJ1),
								calcul_score_joueur(j2,PlateauFin,ScoreJ2),
								ScoreJ1 < ScoreJ2,
								nl,write('Le joueur j2 gagne ! ('), write(ScoreJ1), write(' vs '), write(ScoreJ2), write(')'),!.



affiche_gagnant(PlateauFin):- 	calcul_score_joueur(j1,PlateauFin,ScoreJ1),
								calcul_score_joueur(j2,PlateauFin,ScoreJ2),
								ScoreJ1 == ScoreJ2,
								nl,write('Les deux joueurs sont ex-aequo ! Waou ! ('), write(ScoreJ1), write(' vs '), write(ScoreJ2), write(')'),!.



/*----------------*/
/* CHANGER JOUEUR */
/*----------------*/												

/*changement dynamique dans la base de faits*/

changer_joueur:- retract(joueurEnCours(j1)), asserta(joueurEnCours(j2)),!.
changer_joueur:- retract(joueurEnCours(j2)), asserta(joueurEnCours(j1)),!.

/*changement pour passer en argument*/

changer_joueur(j1, j2):-!.
changer_joueur(j2, j1):-!.




/*Fichiers nécessaires */
link_files:-consult('plateau.pl'),
consult('marchandises.pl'),
consult('bourse.pl'),
consult('trader.pl'),
consult('reserves.pl'),
consult('coup_humain.pl'),
consult('coup_machine.pl'),
consult('IA.pl'),
consult('minimax.pl').