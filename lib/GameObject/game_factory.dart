import 'package:card/GameObject/game_player_online.dart';
import 'package:card/models/PlayerModel.dart';

import 'game_card.dart';

abstract final class GameFactory {

  static List<GameCard> createDeck(){
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

  static GameCard? createCard(String cardString, bool hide){
    return GameCard.parse(cardString, hide, false);
  }

  // Create Online Objects

  static GamePlayerOnline createPlayerOnline(PlayerModel model, bool isUser){
    GamePlayerOnline p = GamePlayerOnline("", 0, 0, 0);
    p.parseData(model, isUser);
    return p;
  }
}