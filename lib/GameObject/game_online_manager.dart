import 'package:card/GameObject/game_factory.dart';
import 'package:card/models/FirebaseRequest.dart';
import 'package:card/models/PlayerModel.dart';
import 'package:card/models/RoomModel.dart';

import '../models/database.dart';
import 'game_card.dart';
import 'game_player.dart';
import 'game_player_online.dart';

enum RoomStatus {
  start,
  end,
  init,
  distributing,
  ready,
}

final class GameOnlineManager{
  static final GameOnlineManager _instance = GameOnlineManager();
  static GameOnlineManager get instance => _instance;

  RoomModel? model;
  int _thisUserID = -1;

  List<GamePlayerOnline> _players = [];
  List<GameCard> _deck = [];
  RoomStatus _status = RoomStatus.end;
  GamePlayerOnline? _currentPlayer;
  GamePlayerOnline? _dealer;
  GamePlayerOnline? _thisPlayer;
  int _revealedCount = 0;

  GamePlayerOnline? get currentPlayer {
    if (_currentPlayer == null){
      _currentPlayer = _getPlayerOnTurn();
    } else {
      if (_currentPlayer?.state != PlayerState.onTurn){
        _currentPlayer = _getPlayerOnTurn();
      }
    }
    return _currentPlayer;
  }

  GamePlayerOnline? get dealer {
    return _dealer;
  }

  List<GamePlayerOnline> get players {
    return _players;
  }

  bool get isStart {
    return _status == RoomStatus.init || _status == RoomStatus.start;
  }

  void _clear(){
    _thisUserID = -1;
    _thisPlayer = null;
    _players.clear();
    _currentPlayer = null;
    _dealer = null;
    _revealedCount = 0;
    _status = RoomStatus.end;
  }

  void importData(bool overwriteUser){
    List<PlayerModel> playerModels = FirebaseRequest.readPlayers() as List<PlayerModel>;
    List<PlayerModel> playersInRoom = [];
    for (int id in model!.players){
      if (overwriteUser == false && id == _thisUserID){
        continue;
      }
      playersInRoom.add(playerModels.firstWhere((element) => element.playerID == id));
    }
    for (PlayerModel playerModel in playersInRoom){
      GamePlayerOnline player = GameFactory.createPlayerOnline(playerModel, playerModel.playerID == _thisUserID);
      _players.add(player);
      if (player.userId == model!.dealer){
        _dealer = player;
      }
      if (player.userId == model!.currentPlayer){
        _currentPlayer = player;
      }
    }

    _players.sort((a, b) => a.seat - b.seat);
    switch (model!.status){
      case "start":
        _status = RoomStatus.start;
        break;
      case "end":
        _status = RoomStatus.end;
        break;
      case "init":
        _status = RoomStatus.init;
        break;
      case "distributing":
        _status = RoomStatus.distributing;
        break;
      case "ready":
        _status = RoomStatus.ready;
        break;
    }
  }

  void uploadData(){
    switch (_status){
      case RoomStatus.start:
        model!.status = "start";
        break;
      case RoomStatus.end:
        model!.status = "end";
        break;
      case RoomStatus.init:
        model!.status = "init";
        break;
      case RoomStatus.distributing:
        model!.status = "distributing";
        break;
      case RoomStatus.ready:
        model!.status = "ready";
        break;
    }

    model!.currentPlayer = _currentPlayer!.userId;
    model!.dealer = _dealer!.userId;

    for (GamePlayerOnline player in _players){
      FirebaseRequest.updatePlayer(player.toPlayerModel());
    }

    FirebaseRequest.updateRoom(model!);
  }

  void uploadThisUser(){
    FirebaseRequest.updatePlayer(_thisPlayer!.toPlayerModel());
  }

  Future<bool> initialize(int thisUserID, int roomID) async {
    _thisUserID = thisUserID;
    _clear();

    bool success;
    if (roomID < 0){
      success = await initializeNewHostRoom();
    } else {
      success = await initializeClientRoom(roomID);
    }

    if (success){
      importData(true);
    }

    return success;
  }

  Future<bool> initializeNewHostRoom() async {
    _status = RoomStatus.init;
    RoomModel roomModel = RoomModel(
        roomID: Database.getAvailableRoomID(),
        players: [_thisUserID],
        dealer: -1,
        deck: [],
        status: "ready",
        currentPlayer: -1
    );

    PlayerModel thisUserModel = PlayerModel(
        playerID: _thisUserID,
        roomID: roomModel.roomID!,
        seat: 1,
        state: "none",
        result: "dealer",
        cards: []
    );

    model = roomModel.clone();
    model?.status = "init";

    FirebaseRequest.addRoom(roomModel);
    FirebaseRequest.addPlayer(thisUserModel);

    // Check if room is created or not
    int timeout = 300;
    while (await FirebaseRequest.refreshRoom(model!) == false || model!.status != "ready"){
      await Future.delayed(Duration(milliseconds: 50));
      timeout--;
      if (timeout <= 0){
        break;
      }
    }

    return timeout > 0;
  }

  Future<bool> initializeClientRoom(int roomID) async {
    RoomModel? room;
    int timeout = 300;
    while ((room = Database.getRoomByID(roomID)) == null){
      await Future.delayed(Duration(milliseconds: 50));
      timeout--;
      if (timeout <= 0){
        break;
      }
    }

    // Not found
    if (room == null){
      print("Room not found");
      return false;
    }

    // Full
    if (room.players.length == 6){
      print("Room full");
      return false;
    }

    model = room;
    importData(true);

    return true;
  }

  bool canStartOnlineGame(){
    for (GamePlayerOnline player in _players) {
      if (player.state != PlayerState.ready){
        return false;
      }
    }
    return true;
  }

  Future<void> startOnlineGame() async {
    if (!canStartOnlineGame()){
      print("Wait for all players ready");
      return;
    }

    // create deck
    _deck = GameFactory.createDeck();
    uploadData();

    _status = RoomStatus.distributing;
    for (int i = 0; i < 2; i++){
      for (GamePlayerOnline player in _players){
        GameCard card = _deck.removeAt(0);
        player.getDistributedCard(card);
      }
    }
    for (GamePlayerOnline player in _players){
      player.waitForTurn();
    }
    _status = RoomStatus.start;
    checkBlackjack();
    if (_status == RoomStatus.start){
      _currentPlayer = _players.first;
      if (_currentPlayer!.state != PlayerState.wait){
        _currentPlayer = _getNextPlayer(_currentPlayer!);
      }
      _currentPlayer?.startTurn();
    }
  }

  void endOnlineGame(){
    _status = RoomStatus.end;
  }

  Future<void> onlineGameUpdate() async {
    if (model == null){
      return;
    }
    if (_currentPlayer?.userId != _thisUserID){
      await FirebaseRequest.refreshRoom(model!);
      importData(true);
    }
  }

  bool tryEndOnlineGame(){
    if (_revealedCount == _players.length){
      endOnlineGame();
      return true;
    }
    return false;
  }

  void distributeCard(){
    for (int i = 0; i < 2; i++){
      for (GamePlayerOnline player in _players){
        player.getDistributedCard(_deck.first);
        _deck.remove(_deck.first);
        if (player.cardCount == 2){
          player.waitForTurn();
        }
      }
    }
  }

  bool checkBlackjack(){
    List<GamePlayerOnline> ban_ban_players = [];
    List<GamePlayerOnline> ban_luck_players = [];
    List<GamePlayerOnline> normal_players = [];
    PlayerCardState dealerResult = PlayerCardState.normal;
    for (GamePlayerOnline player in _players){
      PlayerCardState result = player.CheckBlackjack();
      if (player.isDealer()){
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
      for (GamePlayerOnline player in ban_ban_players){
        player.win();
      }
      for (GamePlayerOnline player in ban_luck_players){
        player.tie();
      }
      for (GamePlayerOnline player in normal_players){
        player.lose();
      }
      endOnlineGame();
      return true;
    }
    // dealer got ban_ban
    if (dealerResult == PlayerCardState.ban_ban){
      for (GamePlayerOnline player in ban_ban_players){
        player.tie();
      }
      for (GamePlayerOnline player in ban_luck_players){
        player.lose();
      }
      for (GamePlayerOnline player in normal_players){
        player.lose();
      }
      endOnlineGame();
      return true;
    }

    // player got ban_ban or ban_luck
    for (GamePlayerOnline player in ban_luck_players){
      player.win();
      _revealedCount++;
    }
    for (GamePlayerOnline player in ban_ban_players){
      player.win();
      _revealedCount++;
    }

    // All is normal
    return false;
  }

  // Get player on turn
  GamePlayerOnline? _getPlayerOnTurn(){
    for (GamePlayerOnline player in _players){
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
      tryEndOnlineGame();
    }
  }

  void playerEndTurn(){
    if (currentPlayer?.isDealer() == false){
      _currentPlayer?.stand();
      _currentPlayer = _getNextPlayer(_currentPlayer!);
      _currentPlayer?.startTurn();
    }
  }

  GamePlayerOnline _getNextPlayer(GamePlayerOnline player){
    GamePlayerOnline result;
    if (player == _players.last){
      result = _players.first;
    } else {
      result = _players[(player.seat ?? -1)];
    }
    return result.state == PlayerState.wait || result.isDealer() ? result : _getNextPlayer(player);
  }

  bool playerCanEndTurn(){
    if (_status != RoomStatus.start || _currentPlayer == _dealer){
      return false;
    }
    return currentPlayer != null && currentPlayer!.getTotalValues() > 15;
  }

  bool playerCanDraw(){
    if (_status != RoomStatus.start){
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
    tryEndOnlineGame();
  }

  void dealerExecuteAll(){
    for (GamePlayerOnline player in _players){
      if (player.state == PlayerState.revealed || player.isDealer()){
        continue;
      }
      player.reveal(_dealer!);
    }
  }

  bool dealerCanExecutePlayer(){
    if (_status != RoomStatus.start){
      return false;
    }
    return dealer != null && dealer?.state == PlayerState.onTurn && dealer!.getTotalValues() > 16;
  }
}

