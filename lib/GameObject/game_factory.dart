import 'card.dart';

abstract final class GameFactory {
  static List<Card> createDeck(int numberOfPlayer){
    List<Card> newDeck = [];
    for (int i = 1; i <= 13; i++){
      for (int j = 0; i < 4; j++){
        switch (j){
          case 0:
            newDeck.add(Card(i, CardType.clubs, false, true));
          case 1:
            newDeck.add(Card(i, CardType.diamonds, false, true));
          case 2:
            newDeck.add(Card(i, CardType.hearts, false, true));
          case 3:
            newDeck.add(Card(i, CardType.spades, false, true));
        }
      }
    }
    newDeck.shuffle();
    return newDeck;
  }

}