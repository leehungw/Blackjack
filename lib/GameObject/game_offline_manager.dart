import 'package:card/GameObject/game_factory.dart';

import 'card.dart';
import 'game_player.dart';

final class GameOfflineManager{
  static final GameOfflineManager _instance = GameOfflineManager();
  static get instance => _instance;

  // Offline Manager
  List<GamePlayer> _players = [];
  List<Card> _deck = [];
  bool _start = false;
  GamePlayer? _currentPlayer = null;
  GamePlayer? _dealer;

  GamePlayer? get currentPlayer {
    if (_currentPlayer == null){
      _currentPlayer = _getPlayerOnTurn();
    } else {
      if (_currentPlayer?.state != PlayerState.onTurn){
        _currentPlayer = _getPlayerOnTurn();
      }
    }
    return _currentPlayer;
  }

  GamePlayer? get dealer {
    return _dealer;
  }

  List<GamePlayer> get players {
    return _players;
  }

  bool get isStart {
    return _start;
  }

  void newOfflineGame(){
    for (int i = 0; i < 6; i++){
      _players.add(GamePlayer(i,i));
    }
    _deck = GameFactory.createDeck(6);
    _players.last.becomeDealer();
    _dealer = _players.last;
    _start = false;
  }

  void startOfflineGame(){
    for (GamePlayer player in _players){
      player.ready();
    }
  }

  void EndOfflineGame(){
    _start = false;
  }

  void OfflineGame_Update(){
    if (_start){

    }
  }

  void distributeCard(){
    for (int i = 0; i < 2; i++){
      for (GamePlayer player in _players){
        player.getDistributedCard(_deck.first);
        _deck.remove(_deck.first);
        if (player.cardCount == 2){
          player.waitForTurn();
        }
      }
    }
  }

  bool CheckBlackjack(){
    List<GamePlayer> ban_ban_players = [];
    List<GamePlayer> ban_luck_players = [];
    List<GamePlayer> normal_players = [];
    GamePlayer? dealer;
    PlayerCardState dealerResult = PlayerCardState.normal;
    for (GamePlayer player in _players){
      PlayerCardState result = player.CheckBlackjack();
      if (player.isDealer()){
        dealer = player;
        dealerResult = result;
        continue;
      }
      switch (result){
        case PlayerCardState.ban_ban:
          ban_ban_players.add(player);
          break;
        case PlayerCardState.ban_luck:
          ban_luck_players.add(player);
          break;
        default:
          normal_players.add(player);
      }
    }

    // dealer got ban_luck
    if (dealerResult == PlayerCardState.ban_luck){
      for (GamePlayer player in ban_ban_players){
        player.win();
      }
      for (GamePlayer player in ban_luck_players){
        player.tie();
      }
      for (GamePlayer player in normal_players){
        player.lose();
      }
      EndOfflineGame();
      return true;
    }
    // dealer got ban_ban
    if (dealerResult == PlayerCardState.ban_ban){
      for (GamePlayer player in ban_ban_players){
        player.tie();
      }
      for (GamePlayer player in ban_luck_players){
        player.lose();
      }
      for (GamePlayer player in normal_players){
        player.lose();
      }
      EndOfflineGame();
      return true;
    }
    // All is normal
    return false;
  }

  // Get player on turn
  GamePlayer? _getPlayerOnTurn(){
    for (GamePlayer player in _players){
      if (player.state == PlayerState.onTurn){
        _currentPlayer = player;
        return _currentPlayer;
      }
    }
    return null;
  }


  // PLAYER BEHAVIOR
  void playerDrawCard(){
    if (currentPlayer == null){
      return;
    }
    currentPlayer?.hit(_deck.first);

  }

  void playerEndTurn(){
    if (currentPlayer?.isDealer() == false){
      if (currentPlayer == _players.last){
        _currentPlayer?.stand();
        _currentPlayer = _players.first;
        _currentPlayer?.startTurn();
      } else {
        _currentPlayer = _players[(_currentPlayer?.seat ?? -1) + 1];
      }
    }
  }

  void dealerExecutePlayer(int seatNumber){
    if (_players[seatNumber].isDealer() || _dealer?.state != PlayerState.onTurn){
      return;
    }
    _players[seatNumber].reveal(_dealer!);
  }
}
