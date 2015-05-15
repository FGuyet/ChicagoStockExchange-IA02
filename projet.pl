%Bourse
bourse([[ble,7],[riz,6],[cacao,6],[cafe,6],[sucre,6],[mais,6]]).
affiche_bourse :- bourse(X) , print(X).

%Marchandises
marchandises([[maïs, riz, ble, ble],
[ble, maïs, sucre, riz],
[cafe, sucre, cacao, riz],
[cafe, maïs, sucre, maïs],
[cacao, maïs, ble, sucre],
[riz, cafe, sucre, ble],
[cafe, ble, sucre, cacao],
[maïs, cacao, cacao, cafe],
[riz,riz,cafe,cacao]]) .
affiche_marchandises :- marchandises(X) , print(X).

%PositionTrader
positionTrader(1).

%ReserveJoueur1
reserveJoueur1([]).

%ReserveJoueur2
reserveJoueur2([]).

%PlateauDepart
plateau(append(bourse,marchandises, positionTrader, reserveJoueur1,reserveJoueur2)).
affiche_plateau :- plateau(X) , print(X).