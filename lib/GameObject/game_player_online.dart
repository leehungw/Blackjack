import 'package:card/GameObject/game_player.dart';

import '../models/PlayerModel.dart';
import 'game_card.dart';
import 'game_factory.dart';

class GamePlayerOnline extends GamePlayer {

  String key;
  int roomID;

  GamePlayerOnline(this.key, this.roomID, super.userId, super.seat);

  // Online Method

  void parseData(PlayerModel model, bool isUser){
    // if (!Validator.validatePlayer(model)){
    //   return;
    // }
    key = model.key!;
    userId = model.playerID;
    seat = model.seat;

    // Get state
    switch (model.state){
      case "onTurn":
        state = PlayerState.onTurn;
        break;
      case "stand":
        state = PlayerState.stand;
        break;
      case "wait":
        state = PlayerState.wait;
        break;
      case "ready":
        state = PlayerState.ready;
        break;
      case "revealed":
        state = PlayerState.revealed;
        break;
      case "surrender":
        state = PlayerState.surrender;
        break;
      case "none":
        state = PlayerState.none;
        break;
    }

    // Get Result
    switch (model.result){
      case "win":
        result = PlayerResult.win;
        break;
      case "lose":
        result = PlayerResult.lose;
        break;
      case "tie":
        result = PlayerResult.tie;
        break;
      case "dealer":
        result = PlayerResult.dealer;
        break;
      case "uncheck":
        result = PlayerResult.uncheck;
        break;
    }

    // Get card

    List<String> cardsData = model.cards.getRange(0, model.cards.length).toList();
    for (GameCard card in cards){
      String textCard = card.toString();
      if (cardsData.firstWhere((element) => element == textCard, orElse: () => "") != ""){
        cardsData.remove(textCard);
      }
    }

    if (cardsData.isEmpty){
      // no update
    } else {
      for (String card in cardsData){
        GameCard? newCard = GameFactory.createCard(card, true);
        if (newCard == null){
          continue;
        }
        cards.add(newCard);
      }
    }
  }

  PlayerModel toPlayerModel(){

    String stateStr;

    switch (state){
      case PlayerState.onTurn:
        stateStr = "onTurn";
        break;
      case PlayerState.stand:
        stateStr = "stand";
        break;
      case PlayerState.wait:
        stateStr = "wait";
        break;
      case PlayerState.ready:
        stateStr = "ready";
        break;
      case PlayerState.revealed:
        stateStr = "revealed";
        break;
      case PlayerState.surrender:
        stateStr = "surrender";
        break;
      case PlayerState.none:
        stateStr = "none";
        break;
    }

    // Get Result

    String resultStr;

    switch (result){
      case PlayerResult.win:
        resultStr = "win";
        break;
      case PlayerResult.lose:
        resultStr = "lose";
        break;
      case PlayerResult.tie:
        resultStr = "tie";
        break;
      case PlayerResult.dealer:
        resultStr = "dealer";
        break;
      case PlayerResult.uncheck:
        resultStr = "uncheck";
        break;
    }

    // Get card

    List<String> cardsData = [];
    for (GameCard card in cards){
      cardsData.add(card.toString());
    }

    return PlayerModel(
        key: key,
        playerID: userId,
        roomID:  roomID,
        seat: seat,
        state: stateStr,
        result: resultStr,
        cards: cardsData
    );
  }
}