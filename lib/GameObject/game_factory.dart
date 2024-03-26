import 'card.dart';

abstract final class GameFactory {
  static List<GameCard> createDeck(int numberOfPlayer){
    List<GameCard> newDeck = [];
    for (int i = 1; i <= 13; i++){
      for (int j = 0; j < 4; j++){
        switch (j){
          case 0:
            newDeck.add(GameCard(i, CardType.clubs, false, true));
          case 1:
            newDeck.add(GameCard(i, CardType.diamonds, false, true));
          case 2:
            newDeck.add(GameCard(i, CardType.hearts, false, true));
          case 3:
            newDeck.add(GameCard(i, CardType.spades, false, true));
        }
      }
    }
    newDeck.shuffle();
    return newDeck;
  }

}