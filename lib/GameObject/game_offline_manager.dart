import 'package:card/GameObject/game_factory.dart';

import 'game_card.dart';
import 'game_player.dart';

final class GameOfflineManager{
  static final GameOfflineManager _instance = GameOfflineManager();
  static GameOfflineManager get instance => _instance;

  // Offline Manager
  List<GamePlayer> _players = [];
  List<GameCard> _deck = [];
  bool _start = false;
  GamePlayer? _currentPlayer = null;
  GamePlayer? _dealer;
  int _revealedCount = 0;

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
    _players.clear();
    _currentPlayer = null;
    _dealer = null;
    _revealedCount = 0;
    for (int i = 0; i < 6; i++){
      _players.add(GamePlayer(i,i + 1));
    }
    _deck = GameFactory.createDeck();
    _players.last.becomeDealer();
    _dealer = _players.last;
    _start = false;
  }

  void startOfflineGame(){
    for (GamePlayer player in _players) {
      player.ready();
    }
    for (int i = 0; i < 2; i++){
      for (GamePlayer player in _players){
        GameCard card = _deck.removeAt(0);
        player.getDistributedCard(card);
      }
    }
    for (GamePlayer player in _players){
      player.waitForTurn();
    }
    _start = true;
    CheckBlackjack();
    if (_start){
      _currentPlayer = _players.first;
      if (_currentPlayer!.state != PlayerState.wait){
        _currentPlayer = _getNextPlayer(_currentPlayer!);
      }
      _currentPlayer?.startTurn();
    }
  }

  void EndOfflineGame(){
    _start = false;
  }

  void OfflineGame_Update(){
    if (_start){

    }
  }

  bool TryEndOfflineGame(){
    if (_revealedCount == _players.length){
      EndOfflineGame();
      return true;
    }
    return false;
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

    // player got ban_ban or ban_luck
    for (GamePlayer player in ban_luck_players){
      player.win();
      _revealedCount++;
    }
    for (GamePlayer player in ban_ban_players){
      player.win();
      _revealedCount++;
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
    GameCard card = _deck.removeAt(0);
    currentPlayer?.hit(card);
    if (_currentPlayer == _dealer){
      if (_dealer!.isBurn() || _dealer!.isDragon()){
        dealerExecuteAll();
      }
      TryEndOfflineGame();
    }
  }

  void playerEndTurn(){
    if (currentPlayer?.isDealer() == false){
      _currentPlayer?.stand();
      _currentPlayer = _getNextPlayer(_currentPlayer!);
      _currentPlayer?.startTurn();
    }
  }

  GamePlayer _getNextPlayer(GamePlayer player){
    GamePlayer result;
    if (player == _players.last){
      result = _players.first;
    } else {
      result = _players[(player.seat ?? -1)];
    }
    return result.state == PlayerState.wait || result.isDealer() ? result : _getNextPlayer(player);
  }

  bool playerCanEndTurn(){
    if (!_start || _currentPlayer == _dealer){
      return false;
    }
    return currentPlayer != null && currentPlayer!.getTotalValues() > 15;
  }

  bool playerCanDraw(){
    if (!_start){
      return false;
    }
    return currentPlayer != null && currentPlayer!.isBurn() == false && currentPlayer!.getTotalValues() != 21;
  }

  void dealerExecutePlayer(int seatNumber){
    if (_players[seatNumber].isDealer() || _dealer?.state != PlayerState.onTurn){
      return;
    }
    _players[seatNumber].reveal(_dealer!);
    _revealedCount ++;
    TryEndOfflineGame();
  }

  void dealerExecuteAll(){
    for (GamePlayer player in _players){
      if (player.state == PlayerState.revealed || player.isDealer()){
        continue;
      }
      player.reveal(_dealer!);
    }
  }

  bool dealerCanExecutePlayer(){
    if (!_start){
      return false;
    }
    return dealer != null && dealer?.state == PlayerState.onTurn && dealer!.getTotalValues() > 16;
  }
}

