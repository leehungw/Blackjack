import 'dart:io';

import 'package:card/GameObject/game_factory.dart';
import 'package:card/models/PlayerModel.dart';
import 'package:card/models/Validator.dart';

import 'game_card.dart';

enum PlayerState {
  onTurn,
  stand,
  wait,
  ready,
  revealed,
  surrender,
  none
}

enum PlayerCardState {
  dragon,
  ban_ban,
  ban_luck,
  normal,
  burn,
  error
}

enum PlayerResult {
  win,
  lose,
  tie,
  dealer,
  uncheck
}

class GamePlayer {
  int userId = -1;
  int seat = -1;
  List<GameCard> cards = [];
  PlayerState state = PlayerState.none;
  PlayerResult result = PlayerResult.uncheck;

  GamePlayer(this.userId, this.seat);
  
  int get cardCount{
    return cards.length;
  }

  PlayerCardState CheckBlackjack(){
    if (cards.length < 2){
      return PlayerCardState.error;
    }
    if (cards[0].getValue() == 1 && cards[1].getValue() == 1){
      return PlayerCardState.ban_ban;
    }
    if ((cards[0].getValue() == 10 && cards[1].getValue() == 1)
        || (cards[0].getValue() == 1 && cards[1].getValue() == 10)) {
      return PlayerCardState.ban_luck;
    }
    return PlayerCardState.normal;
  }

  int getTotalValues(){
    int sum = 0;
    int acesCount = 0;
    for (GameCard card in cards){
      if (card.hide){
        continue;
      }
      if (card.getValue() == 1){
        acesCount ++;
      } else {
        sum += card.getValue();
      }
    }
    if (acesCount > 0){
      switch (cards.length){
        case 2:
          sum += 11;
          break;
        case 3:
        case 4:
        case 5:
          sum += acesCount - 1;
          if (sum + 11 <= 21){
            sum += 11;
          } else if (sum + 10 <= 21){
            sum += 10;
          } else {
            sum += 1;
          }
          break;
      }
    }
    return sum;
  }

  // property
  bool isDealer(){
    return result == PlayerResult.dealer;
  }

  // Behavior
  void ready(){
    state = PlayerState.ready;
  }

  void waitForTurn(){
    state = PlayerState.wait;
  }

  void startTurn(){
    state = PlayerState.onTurn;
  }

  void stand(){
    state = PlayerState.stand;
  }

  void becomeDealer(){
    result = PlayerResult.dealer;
  }

  void win(){
    result = PlayerResult.win;
    flipCards();
    state = PlayerState.revealed;
  }

  void lose(){
    result = PlayerResult.lose;
    flipCards();
    state = PlayerState.revealed;
  }

  void tie(){
    result = PlayerResult.tie;
    flipCards();
    state = PlayerState.revealed;
  }

  void flipCards(){
    for (GameCard card in cards){
      if (card.hide){
        card.flip();
      }
    }
  }

  void reveal(GamePlayer dealer){
    flipCards();

    if (dealer.isDealer() == false || result != PlayerResult.uncheck){
      return;
    }

    if (isBurn()){
      result = dealer.isBurn() ? PlayerResult.tie : PlayerResult.lose;
      return;
    }

    if (dealer.isBurn()){
      result = PlayerResult.win;
      return;
    }

    // Dragon
    if (isDragon()){
      if (dealer.isDragon()){
        int compareResult = compare(dealer);
        if (compareResult < 0){
          result = PlayerResult.win;
        } else if (compareResult > 0){
          result = PlayerResult.lose;
        } else {
          result = PlayerResult.tie;
        }
      } else {
        result = PlayerResult.win;
      }
      return;
    }
    int compareResult = compare(dealer);
    if (compareResult > 0){
      result = PlayerResult.win;
    } else if (compareResult < 0){
      result = PlayerResult.lose;
    } else {
      result = PlayerResult.tie;
    }
    state = PlayerState.revealed;
  }

  bool isDragon(){
    return cardCount == 5 && getTotalValues() <= 21;
  }

  bool isBurn(){
    return getTotalValues() > 21;
  }

  int compare(GamePlayer dealer){
    return getTotalValues() - dealer.getTotalValues();
  }

  bool hit(GameCard card){
    if (state != PlayerState.onTurn){
      return false;
    }
    if (cards.length < 5){
      cards.add(card);
      return true;
    }
    return false;
  }

  bool getDistributedCard(GameCard card) {
    if (cards.length < 2) {
      cards.add(card);
      return true;
    }
    return false;
  }
}