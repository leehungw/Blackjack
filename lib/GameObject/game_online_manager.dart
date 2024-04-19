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

  Future<void> importData(bool overwriteUser) async {
    model = await FirebaseRequest.refreshRoom(model!);
    List<PlayerModel> playersInRoom = await Database.getPlayersInRoom(model!.roomID!);

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
    _thisUserID = thisUserID;
    bool success;
    if (roomID < 0){
      success = await initializeNewHostRoom();
    } else {
      success = await initializeClientRoom(roomID);
    }

    if (success){
      await importData(true);
    }

    return success;
  }

  Future<bool> initializeNewHostRoom() async {
    _status = RoomStatus.init;
    RoomModel roomModel = RoomModel(
        roomID: await Database.getAvailableRoomID(),
        players: [_thisUserID],
        dealer: _thisUserID,
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

    FirebaseRequest.addRoom(roomModel);
    FirebaseRequest.addPlayer(thisUserModel);
    await Future.delayed(Duration(milliseconds: 50));
    model = await Database.getRoomByID(roomModel.roomID!);
    await Future.delayed(Duration(milliseconds: 50));
    // Check if room is created or not
    int timeout = 300;
    while (model == null || model?.status != "ready"){
      model = await Database.getRoomByID(roomModel.roomID!);
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
    while ((room = await Database.getRoomByID(roomID)) == null){
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

    return true;
  }

  bool canStartOnlineGame(){
    if (_players.length <= 1){
      return false;
    }
    for (GamePlayerOnline player in _players) {
      if (player == _dealer){
        continue;
      }
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
    await Future.delayed(Duration(milliseconds: 50));
    _status = RoomStatus.distributing;
    for (int i = 0; i < 2; i++){
      for (GamePlayerOnline player in _players){
        GameCard card = _deck.removeAt(0);
        player.getDistributedCard(card);
        uploadData();
        await Future.delayed(Duration(milliseconds: 100));
      }
    }
    for (GamePlayerOnline player in _players){
      player.waitForTurn();
    }

    uploadData();
    await Future.delayed(Duration(milliseconds: 50));

    await checkBlackjack();
    await Future.delayed(Duration(milliseconds: 50));

    if (_status == RoomStatus.start){
      _status = RoomStatus.start;
      for (int i = 0; i < _players.length; i++){
        if (_players[i].isDealer()){
          if (i == _players.length - 1){
            _currentPlayer = _players.first;
          } else {
            _currentPlayer = _players[i + 1];
          }
        }
      }
      _currentPlayer?.startTurn();

      uploadData();
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  Future<void> endOnlineGame() async {
    _status = RoomStatus.end;
    uploadData();
    await Future.delayed(Duration(milliseconds: 50));
  }

  // UPDATE METHODS

  Future<void> onlineGameUpdate() async {
    if (model == null || _thisPlayer == null){
      return;
    }
    _updatePhaseWaitToStart();
    _updatePhaseDistributing();
    _updatePhaseWaitToTurn();
    _updatePhaseOnTurn();
    _updatePhaseStand();
    _updatePhaseEndGame();
  }

  Future<void> _updatePhaseWaitToStart() async{
    if (_status == RoomStatus.ready){
      await FirebaseRequest.refreshRoom(model!);
      importData(false);
      uploadThisUser();
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  Future<void> _updatePhaseDistributing() async{
    if (_status == RoomStatus.distributing){
      if (_thisPlayer!.isDealer()){
        // This case being handled by startOnlineGame()
      } else {
        await FirebaseRequest.refreshRoom(model!);
        importData(true);
        await Future.delayed(Duration(milliseconds: 50));
      }
    }
  }

  Future<void> _updatePhaseWaitToTurn() async{
    if (_status == RoomStatus.start){
      await FirebaseRequest.refreshRoom(model!);
      importData(true);
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  Future<void> _updatePhaseOnTurn() async{
    if (_status == RoomStatus.start && _thisPlayer!.state == PlayerState.onTurn){
      await FirebaseRequest.refreshRoom(model!);
      uploadData();
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  Future<void> _updatePhaseStand() async{
    if (_status == RoomStatus.start && _thisPlayer!.state == PlayerState.stand){
      await FirebaseRequest.refreshRoom(model!);
      importData(true);
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  Future<void> _updatePhaseEndGame() async{
    if (_status == RoomStatus.end){
      await FirebaseRequest.refreshRoom(model!);
      if (_thisPlayer!.isDealer()){
        uploadData();
      } else {
        importData(true);
      }
      await Future.delayed(Duration(milliseconds: 50));
    }
  }

  // ================================================

  Future<bool> tryEndOnlineGame() async {
    if (_revealedCount == _players.length){
      await endOnlineGame();
      return true;
    }
    return false;
  }

  // void distributeCard(){
  //   for (int i = 0; i < 2; i++){
  //     for (GamePlayerOnline player in _players){
  //       player.getDistributedCard(_deck.first);
  //       _deck.remove(_deck.first);
  //       if (player.cardCount == 2){
  //         player.waitForTurn();
  //       }
  //     }
  //   }
  // }

  Future<bool> checkBlackjack() async {
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
      await endOnlineGame();
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
    uploadData();
    await Future.delayed(Duration(milliseconds: 50));
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
    GamePlayerOnline result = _players.first;
    for (int i = 0; i < _players.length; i++){
      if (_players[i] == player){
        if (i == _players.length - 1){
          result = _players.first;
        } else {
          result = _players[i + 1];
        }
      }
    }
    return result;
  }

  bool playerCanEndTurn(){
    if (_status != RoomStatus.start || _currentPlayer == _dealer){
      return false;
    }
    return
      _thisPlayer != null
      && _thisPlayer == _currentPlayer
      && _thisPlayer!.getTotalValues() > 15;
  }

  bool playerCanDraw(){
    if (_status != RoomStatus.start){
      return false;
    }
    return
      _thisPlayer != null
      && _thisPlayer! == _currentPlayer
      && _thisPlayer!.isBurn() == false
      && _thisPlayer!.getTotalValues() != 21;
  }

  void dealerExecutePlayer(int seatNumber){
    if (_thisPlayer != _dealer || _thisPlayer != _currentPlayer){
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
    return
      _thisPlayer != null
      && _thisPlayer == _dealer
      && _thisPlayer?.state == PlayerState.onTurn
      && _thisPlayer!.getTotalValues() > 16;
  }

  // ROOM CONTROL

  bool canStartGame(){
    return _thisPlayer != null && _thisPlayer! == _dealer && canStartOnlineGame();
  }

  bool canCleanTable(){
    return _status == RoomStatus.end;
  }

  Future<void> cleanTable() async{
    for (GamePlayerOnline player in _players){
      player.cards.clear();
      player.state = PlayerState.none;
    }
    _deck.clear();
    _status = RoomStatus.ready;

    uploadData();
    await Future.delayed(Duration(milliseconds: 50));
  }

  bool playerCanReady() {
    return
      _status == RoomStatus.ready
      && _thisPlayer != null
      && _thisPlayer != _dealer
      && _thisPlayer!.state == PlayerState.none;
  }

  bool playerCanCancelReady() {
    return
      _status == RoomStatus.ready
      && _thisPlayer != null
      && _thisPlayer != _dealer
      && _thisPlayer!.state == PlayerState.ready;
  }

  Future<void> playerReady() async {
    importData(true);
    await Future.delayed(Duration(milliseconds: 50));
    if (_thisPlayer == null){
      return;
    }
    if (_thisPlayer!.isDealer() == false && _status == RoomStatus.ready){
      if (_thisPlayer!.state == PlayerState.none){
        _thisPlayer!.state == PlayerState.ready;
      }
    }
  }

  Future<void> playerCancelReady() async {
    importData(true);
    await Future.delayed(Duration(milliseconds: 50));
    if (_thisPlayer == null){
      return;
    }
    if (_thisPlayer!.isDealer() == false && _status == RoomStatus.ready){
      if (_thisPlayer!.state == PlayerState.ready) {
        _thisPlayer!.state == PlayerState.none;
      }
    }
  }
}

