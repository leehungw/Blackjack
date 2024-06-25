import 'package:card/GameObject/game_player_online.dart';
import 'package:card/models/PlayerModel.dart';
import 'package:card/models/RequestModel.dart';

import 'game_card.dart';

abstract final class GameFactory {

  static List<GameCard> createDeck(){
    List<GameCard> newDeck = [];
    for (int i = 1; i <= 13; i++){
      for (int j = 0; j < 4; j++){
        switch (j){
          case 0:
            newDeck.add(GameCard(i, CardType.clubs, true, false));
          case 1:
            newDeck.add(GameCard(i, CardType.diamonds, true, false));
          case 2:
            newDeck.add(GameCard(i, CardType.hearts, true, false));
          case 3:
            newDeck.add(GameCard(i, CardType.spades, true, false));
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

  static Future<GamePlayerOnline> createPlayerOnline(PlayerModel model, bool isUser) async {
    GamePlayerOnline p = GamePlayerOnline(0, "", 0);
    p.parseData(model, isUser);
    await p.connectToUserModel();
    return p;
  }

  // Create Request

  /// Create a request for asking the host to add this player to room
  static RequestModel createRequestJoinRoom(String thisPlayerID){
    return RequestModel(
      key: RequestModel.formatRequestsKey(thisPlayerID),
      playerID: thisPlayerID,
      command: RequestModel.reqJoinRoom,
      params: []
    );
  }

  static RequestModel createRequestReady(String thisPlayerID, amount){
    return RequestModel(
        key: RequestModel.formatRequestsKey(thisPlayerID),
        playerID: thisPlayerID,
        command: RequestModel.reqReady,
        params: [amount.toString()]
    );
  }

  static RequestModel createRequestCancelReady(String thisPlayerID){
    return RequestModel(
        key: RequestModel.formatRequestsKey(thisPlayerID),
        playerID: thisPlayerID,
        command: RequestModel.reqCancelReady,
        params: []
    );
  }

  static RequestModel createRequestDrawCard(String thisPlayerID){
    return RequestModel(
        key: RequestModel.formatRequestsKey(thisPlayerID),
        playerID: thisPlayerID,
        command: RequestModel.reqDrawCard,
        params: []
    );
  }

  static RequestModel createRequestStand(String thisPlayerID){
    return RequestModel(
        key: RequestModel.formatRequestsKey(thisPlayerID),
        playerID: thisPlayerID,
        command: RequestModel.reqStand,
        params: []
    );
  }

  static RequestModel createRequestLeaveRoom(String thisPlayerID){
    return RequestModel(
        key: RequestModel.formatRequestsKey(thisPlayerID),
        playerID: thisPlayerID,
        command: RequestModel.reqLeave,
        params: []
    );
  }

  static RequestModel createRequestKick(String thisPlayerID, String targetID, String flag){
    return RequestModel(
        key: RequestModel.formatRequestsKey(thisPlayerID),
        playerID: thisPlayerID,
        command: RequestModel.reqKick,
        params: [targetID, flag]
    );
  }
}