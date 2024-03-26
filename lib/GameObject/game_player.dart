import 'card.dart';

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
  int _userId = -1;
  int _seat = -1;
  List<GameCard> _cards = [];
  PlayerState _state = PlayerState.none;
  PlayerResult _result = PlayerResult.uncheck;

  GamePlayer(this._userId, this._seat);

  int get userId{
    return _userId;
  }

  int get seat{
    return _seat;
  }

  PlayerState get state{
    return _state;
  }

  PlayerResult get result{
    return _result;
  }

  int get cardCount{
    return _cards.length;
  }

  List<GameCard> get cards{
    return _cards;
  }

  PlayerCardState CheckBlackjack(){
    if (_cards.length < 2){
      return PlayerCardState.error;
    }
    if (_cards[0].getValue() == 1 && _cards[1].getValue() == 1){
      return PlayerCardState.ban_ban;
    }
    if ((_cards[0].getValue() == 10 && _cards[1].getValue() == 1)
        || (_cards[0].getValue() == 1 && _cards[1].getValue() == 10)) {
      return PlayerCardState.ban_luck;
    }
    return PlayerCardState.normal;
  }

  int getTotalValues(){
    int sum = 0;
    int acesCount = 0;
    for (GameCard card in _cards){
      if (card.getValue() == 1){
        acesCount ++;
      } else {
        sum += card.getValue();
      }
    }
    if (acesCount > 0){
      switch (_cards.length){
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
    return _result == PlayerResult.dealer;
  }

  // Behavior
  void ready(){
    _state = PlayerState.ready;
  }

  void waitForTurn(){
    _state = PlayerState.wait;
  }

  void startTurn(){
    if (_state == PlayerState.wait)
      _state = PlayerState.onTurn;
  }

  void stand(){
      _state = PlayerState.stand;
  }

  void becomeDealer(){
    _result = PlayerResult.dealer;
  }

  void win(){
    _result = PlayerResult.win;
    flipCards();
    _state = PlayerState.revealed;
  }

  void lose(){
    _result = PlayerResult.lose;
    flipCards();
    _state = PlayerState.revealed;
  }

  void tie(){
    _result = PlayerResult.tie;
    flipCards();
    _state = PlayerState.revealed;
  }

  void flipCards(){
    for (GameCard card in _cards){
      if (card.hide){
        card.flip();
      }
    }
  }

  void reveal(GamePlayer dealer){
    flipCards();

    if (dealer.isDealer() == false || _result != PlayerResult.uncheck){
      return;
    }

    if (isBurn()){
      _result = dealer.isBurn() ? PlayerResult.tie : PlayerResult.lose;
      return;
    }

    if (dealer.isBurn()){
      _result = PlayerResult.win;
      return;
    }

    // Dragon
    if (isDragon()){
      if (dealer.isDragon()){
        int compareResult = compare(dealer);
        if (compareResult < 0){
          _result = PlayerResult.win;
        } else if (compareResult > 0){
          _result = PlayerResult.lose;
        } else {
          _result = PlayerResult.tie;
        }
      } else {
        _result = PlayerResult.win;
      }
      return;
    }
    int compareResult = compare(dealer);
    if (compareResult > 0){
      _result = PlayerResult.win;
    } else if (compareResult < 0){
      _result = PlayerResult.lose;
    } else {
      _result = PlayerResult.tie;
    }
    _state = PlayerState.revealed;
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
    if (_state != PlayerState.onTurn){
      return false;
    }
    if (_cards.length < 5){
      _cards.add(card);
      return true;
    }
    return false;
  }

  bool getDistributedCard(GameCard card){
    if (_state != PlayerState.ready){
      return false;
    }
    if (_cards.length < 2){
      _cards.add(card);
      return true;
    }
    return false;
  }
}