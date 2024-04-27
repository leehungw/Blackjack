import 'dart:async';

import 'package:async/async.dart';
import 'package:card/GameObject/game_factory.dart';
import 'package:card/models/FirebaseRequest.dart';
import 'package:card/models/PlayerModel.dart';
import 'package:card/models/RequestModel.dart';
import 'package:card/models/RoomModel.dart';
import 'package:flutter/foundation.dart';

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

  final StreamController<void> _playerChanges = StreamController<void>.broadcast();

  final StreamController<void> _remoteChanges = StreamController<void>.broadcast();

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get playerChanges => _playerChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  RoomModel? model;
  List<RequestModel> requestList = [];

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

  void dispose() {
    _remoteChanges.close();
    _playerChanges.close();
    Database.dispose();
  }

  //================================================================
  // DATABASE INTERACTION

  Future<void> importRoomData(RoomModel newModel, bool ignoreHost) async {

    if (thisUserIsHost() && !ignoreHost){
      _remoteChanges.add(null);
      // This User is host. No need to update data from remote
      return;
    }

    model = newModel;

    _players.clear();
    _thisPlayer = null;

    for (PlayerModel playerModel in model!.players){

      // if (!overwriteUser && playerModel.playerID == _thisUserID){
      //   continue;
      // }

      GamePlayerOnline player = GameFactory.createPlayerOnline(playerModel, playerModel.playerID == _thisUserID);
      _players.add(player);
      if (player.userId == _thisUserID){
        _thisPlayer = player;
      }
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

    _remoteChanges.add(null);
  }

  Future<void> uploadData() async {
    if (thisUserIsHost() == false){
      print("Not a host! Can't upload data.");
    }

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

    model!.currentPlayer = _currentPlayer == null ? -1 : _currentPlayer!.userId;
    model!.dealer = _dealer!.userId;
    model!.players.clear();

    for (GamePlayerOnline player in _players){
      model!.players.add(player.toPlayerModel());
    }

    await Database.updateFirestoreFromLocal(model!);
    _playerChanges.add(null);
  }

  void importRequests(List<RequestModel> requestList){

    this.requestList = requestList;

    if (thisUserIsHost() == false){
      // This user isn't host. No need to handle requests.
      return;
    }

    if (_validateRequest() == false){
      Database.updateFirestoreFromLocal(model!);
      return;
    }

    _requestHandler();
  }

  //================================================================

  // void uploadThisUser(){
  //   FirebaseRequest.updatePlayer(_thisPlayer!.toPlayerModel());
  // }

  //================================================================
  // INITIALIZE

  Future<bool> initialize(int thisUserID, int roomID) async {
    _clear();
    _thisUserID = thisUserID;
    bool success;
    if (roomID < 0){
      success = await initializeNewHostRoom();
    } else {
      success = await initializeClientRoom(roomID);
    }

    if (success){
      await FirebaseRequest.setRoom(model!);
      importRoomData(model!, true);
      _playerChanges.add(null);
    }

    return success;
  }

  Future<bool> initializeNewHostRoom() async {
    _status = RoomStatus.init;
    int roomID = await Database.getAvailableRoomID();
    if (roomID == -1){
      print("Create room failed");
      return false;
    }

    PlayerModel thisUserModel = PlayerModel(
        playerID: _thisUserID,
        roomID: roomID,
        seat: 1,
        state: "none",
        result: "dealer",
        cards: []
    );

    RoomModel roomModel = RoomModel(
        key: RoomModel.formatRoomKey(roomID),
        roomID: roomID,
        players: [thisUserModel],
        dealer: _thisUserID,
        deck: [],
        status: "ready",
        currentPlayer: -1
    );

    await FirebaseRequest.setRoom(roomModel);

    // Check if room is created or not
    int timeout = 300;
    while (await FirebaseRequest.checkIfRoomExists(roomID) == false){
      timeout--;
      if (timeout <= 0){
        print("Create room time out.");
        return false;
      }
    }
    model = roomModel;
    Database.initializeDatabase(roomID);

    return true;
  }

  Future<bool> initializeClientRoom(int roomID) async {

    // Not found
    if (await FirebaseRequest.checkIfRoomExists(roomID) == false){
      print("Room not found");
      return false;
    }

    Database.initializeDatabase(roomID);

    int timeout = 300;


    // Check if Room data has been received.
    while (model == null){
      await Future.delayed(Duration(milliseconds: 50));
      timeout --;
      if (timeout <= 0){
        Database.dispose();
        print("Cannot get room data");
        return false;
      }
    }

    await reqJoinRoom();

    // Check if player already joined
    timeout = 400;
    while (thisUserIsInRoom() == false){
      await Future.delayed(Duration(milliseconds: 50));
      timeout --;
      if (timeout % 100 == 0 && timeout > 0){
        await reqJoinRoom();
      }
      if (timeout <= 0){
        Database.dispose();
        print("Join room failed");
        return false;
      }
    }

    return true;

    // if (playerExist){
    //
    //   model = room;
    //   return true;
    //
    // } else {
    //
    //   // Full
    //   if (room.players.length == 6){
    //     print("Room full");
    //     return false;
    //   }
    //
    //   List<PlayerModel> playersInRoom = await Database.getPlayersInRoom(room.roomID!);
    //   playersInRoom.sort((a, b) => a.seat - b.seat);
    //   // Get available seat
    //   int avaiableSeat = -1;
    //
    //   for (int i = 0; i < playersInRoom.length - 1; i++){
    //     if (playersInRoom[i+1].seat - playersInRoom[i].seat > 1){
    //       avaiableSeat = playersInRoom[i].seat + 1;
    //       break;
    //     }
    //   }
    //
    //   if (avaiableSeat == -1){
    //     avaiableSeat = playersInRoom.length + 1;
    //   }
    //
    //   PlayerModel thisUserModel = PlayerModel(
    //       playerID: _thisUserID,
    //       roomID: room.roomID!,
    //       seat: avaiableSeat,
    //       state: "none",
    //       result: "uncheck",
    //       cards: []
    //   );
    //
    //   room.players.add(_thisUserID);
    //
    //   FirebaseRequest.addPlayer(thisUserModel);
    //   FirebaseRequest.updateRoom(room);
    //
    //   await Future.delayed(Duration(milliseconds: 50));
    //   model = await Database.getRoomByID(room.roomID!);
    //   await Future.delayed(Duration(milliseconds: 50));
    //   // Check if player already joined room or not
    //   timeout = 300;
    //   while (model == null || model?.players.length != room.players.length){
    //     model = await Database.getRoomByID(room.roomID!);
    //     await Future.delayed(Duration(milliseconds: 50));
    //     timeout--;
    //     if (timeout <= 0){
    //       break;
    //     }
    //   }
    //
    //   return timeout > 0;
    // }
  }

  //================================================================

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
    await uploadData();
    await Future.delayed(Duration(milliseconds: 50));
    _status = RoomStatus.distributing;
    for (int i = 0; i < 2; i++){
      for (GamePlayerOnline player in _players){
        GameCard card = _deck.removeAt(0);
        player.getDistributedCard(card);
        await uploadData();
        await Future.delayed(Duration(milliseconds: 100));
      }
    }
    for (GamePlayerOnline player in _players){
      player.waitForTurn();
    }

    await uploadData();

    await checkBlackjack();

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

      await uploadData();
    }
  }

  Future<void> endOnlineGame() async {
    _status = RoomStatus.end;
    await uploadData();
  }

  // UPDATE METHODS

  // Future<void> onlineGameUpdate() async {
  //   if (_status == RoomStatus.init){
  //     return;
  //   }
  //   if (model == null){
  //     return;
  //   } else if (_thisPlayer == null || _thisPlayer?.key == ""){
  //     importData(true);
  //     return;
  //   }
  //   _updatePhaseWaitToStart();
  //   _updatePhaseDistributing();
  //   _updatePhaseWaitToTurn();
  //   _updatePhaseOnTurn();
  //   _updatePhaseStand();
  //   _updatePhaseEndGame();
  // }

  // Future<void> _updatePhaseWaitToStart() async{
  //   if (_status == RoomStatus.ready){
  //     await FirebaseRequest.refreshRoom(model!);
  //     importData(false);
  //     uploadThisUser();
  //     await Future.delayed(Duration(milliseconds: 50));
  //   }
  // }
  //
  // Future<void> _updatePhaseDistributing() async{
  //   if (_status == RoomStatus.distributing){
  //     if (_thisPlayer!.isDealer()){
  //       // This case being handled by startOnlineGame()
  //     } else {
  //       await FirebaseRequest.refreshRoom(model!);
  //       importData(true);
  //       await Future.delayed(Duration(milliseconds: 50));
  //     }
  //   }
  // }
  //
  // Future<void> _updatePhaseWaitToTurn() async{
  //   if (_status == RoomStatus.start){
  //     await FirebaseRequest.refreshRoom(model!);
  //     importData(true);
  //     await Future.delayed(Duration(milliseconds: 50));
  //   }
  // }
  //
  // Future<void> _updatePhaseOnTurn() async{
  //   if (_status == RoomStatus.start && _thisPlayer!.state == PlayerState.onTurn){
  //     await FirebaseRequest.refreshRoom(model!);
  //     uploadData();
  //     await Future.delayed(Duration(milliseconds: 50));
  //   }
  // }
  //
  // Future<void> _updatePhaseStand() async{
  //   if (_status == RoomStatus.start && _thisPlayer!.state == PlayerState.stand){
  //     await FirebaseRequest.refreshRoom(model!);
  //     importData(true);
  //     await Future.delayed(Duration(milliseconds: 50));
  //   }
  // }
  //
  // Future<void> _updatePhaseEndGame() async{
  //   if (_status == RoomStatus.end){
  //     await FirebaseRequest.refreshRoom(model!);
  //     if (_thisPlayer!.isDealer()){
  //       uploadData();
  //     } else {
  //       importData(true);
  //     }
  //     await Future.delayed(Duration(milliseconds: 50));
  //   }
  // }

  //================================================================
  // REQUEST HANDLER

  List<RequestModel> _requestCache = [];

  bool _validateRequest(){
    if (requestList.isEmpty){
      _requestCache.clear();
      return true;
    }

    List<RequestModel> duplicatedReqList = [];

    for (RequestModel model in _requestCache){
      for (RequestModel element in requestList){
        if (element.isEqual(model)){
          duplicatedReqList.add(model);
          FirebaseRequest.deleteRequest(model, this.model!.roomID!);
          break;
        }
      }
    }

    _requestCache.clear();
    _requestCache = duplicatedReqList;

    return duplicatedReqList.isEmpty;
  }

  Future<void> _requestHandler() async {
    // Handle one request per times.

    RequestModel req = requestList.first;
    _requestCache.add(req);

    switch(req.command){
      // ----------------------------------------------------------
      case RequestModel.reqJoinRoom:
        {
          // Validate if player already in room or not
          for (GamePlayerOnline player in _players){
            if (player.userId == req.playerID){
              print("Player already joined in room");
              break;
            }
          }
          int availableSeat = getAvailableSeat();
          if (_status == RoomStatus.ready && availableSeat != -1) {
            PlayerModel newPlayerModel = PlayerModel(
                playerID: req.playerID!,
                roomID: model!.roomID!,
                seat: availableSeat,
                state: "none",
                result: "uncheck",
                cards: []
            );
            GameFactory.createPlayerOnline(newPlayerModel, false);
            await uploadData();
          } else {
            print("Reject join room request");
          }
          break;
        }

      // ----------------------------------------------------------
      case RequestModel.reqReady:
        {
          if (_status != RoomStatus.ready){
            print("Ready request invalid. This room is not in \"Ready\" state.");
            break;
          }
          for (GamePlayerOnline player in _players){
            if (player.userId == req.playerID && player.state == PlayerState.none){
              player.state == PlayerState.ready;
              break;
            }
          }
          break;
        }

    // ----------------------------------------------------------
      case RequestModel.reqCancelReady:
        {
          if (_status != RoomStatus.ready){
            print("Ready request invalid. This room is not in \"Ready\" state.");
            break;
          }
          for (GamePlayerOnline player in _players){
            if (player.userId == req.playerID && player.state == PlayerState.ready){
              player.state == PlayerState.none;
              break;
            }
          }
          break;
        }

      // ----------------------------------------------------------
      case RequestModel.reqDrawCard:
        {
          if (_status != RoomStatus.start){
            print("Draw request invalid. This room hasn't started yet.");
            break;
          }
          if (_currentPlayer!.userId == req.playerID){
            await playerDrawCard();
          } else {
            print('This is not player#${req.playerID}\'s turn.');
          }
          break;
        }


      // ----------------------------------------------------------
      case RequestModel.reqStand:
        {
          if (_status != RoomStatus.start){
            print("Draw request invalid. This room hasn't started yet.");
            break;
          }
          if (_currentPlayer!.userId == req.playerID){
            await playerEndTurn();
          } else {
            print('This is not player#${req.playerID}\'s turn.');
          }
          break;
        }
    }

    await FirebaseRequest.deleteRequest(req, model!.roomID!);
  }

  //================================================================


  // ================================================
  // EXECUTE FUNCTIONS

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

  // ===========================================================
  // GET

  int getAvailableSeat(){
    List<PlayerModel> playersInRoom = model!.players;

    if (playersInRoom.length >= 6){
      return -1;
    }

    // Get available seat
    int availableSeat = 0;

    for (int i = 0; i < playersInRoom.length - 1; i++){
      if (playersInRoom[i+1].seat - playersInRoom[i].seat > 1){
        availableSeat = playersInRoom[i].seat + 1;
        break;
      }
    }

    if (availableSeat == 0){
      availableSeat = playersInRoom.length + 1;
    }

    return availableSeat;
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

  // ===========================================================
  // BOOLEAN

  bool thisUserIsHost(){
    return _thisPlayer == _dealer;
  }

  bool thisUserIsInRoom(){
    return _thisPlayer != null;
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

  bool canStartGame(){
    return _thisPlayer != null && _thisPlayer! == _dealer && canStartOnlineGame();
  }

  bool canCleanTable(){
    return _status == RoomStatus.end;
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


  // ===========================================================
  // PLAYER BEHAVIOR

  Future<void> playerDrawCard() async {
    // if (_thisPlayer != _currentPlayer){
    //   return;
    // }
    GameCard card = _deck.removeAt(0);
    _currentPlayer?.hit(card);
    if (_currentPlayer == _dealer){
      if (_currentPlayer!.isBurn() || _currentPlayer!.isDragon()){
        dealerExecuteAll();
      }
      tryEndOnlineGame();
    }
    await uploadData();
  }

  Future<void> playerEndTurn() async {
    if (currentPlayer?.isDealer() == false){
      _currentPlayer?.stand();
      _currentPlayer = _getNextPlayer(_currentPlayer!);
      _currentPlayer?.startTurn();
    }

    await uploadData();
  }

  Future<void> dealerExecutePlayer(int seatNumber) async {
    if (_thisPlayer != _dealer || _thisPlayer != _currentPlayer){
      return;
    }
    _players[seatNumber].reveal(_dealer!);
    _revealedCount ++;
    tryEndOnlineGame();

    await uploadData();
  }

  Future<void> dealerExecuteAll() async {
    for (GamePlayerOnline player in _players){
      if (player.state == PlayerState.revealed || player.isDealer()){
        continue;
      }
      player.reveal(_dealer!);
    }

    await uploadData();
  }

  //================================================================
  // ROOM CONTROL

  Future<void> cleanTable() async{
    for (GamePlayerOnline player in _players){
      player.cards.clear();
      player.state = PlayerState.none;
    }

    _deck.clear();
    _status = RoomStatus.ready;

    await uploadData();
  }

  // ===================================================================
  // SEND REQUEST

  Future<void> reqDrawCard() async {
    RequestModel req = GameFactory.createRequestDrawCard(_thisUserID);
    await FirebaseRequest.sendRequest(req, model!.roomID!);
  }

  Future<void> reqStand() async {
    RequestModel req = GameFactory.createRequestStand(_thisUserID);
    await FirebaseRequest.sendRequest(req, model!.roomID!);
  }

  Future<void> reqJoinRoom() async {
    RequestModel req = GameFactory.createRequestJoinRoom(_thisUserID);
    await FirebaseRequest.sendRequest(req, model!.roomID!);
  }

  Future<void> reqReady() async {
    RequestModel req = GameFactory.createRequestReady(_thisUserID);
    await FirebaseRequest.sendRequest(req, model!.roomID!);

    // importData(true);
    // await Future.delayed(Duration(milliseconds: 50));
    // if (_thisPlayer == null){
    //   return;
    // }
    // if (_thisPlayer!.isDealer() == false && _status == RoomStatus.ready){
    //   if (_thisPlayer!.state == PlayerState.none){
    //     _thisPlayer!.state = PlayerState.ready;
    //   }
    // }
  }

  Future<void> reqCancelReady() async {
    RequestModel req = GameFactory.createRequestCancelReady(_thisUserID);
    await FirebaseRequest.sendRequest(req, model!.roomID!);

    // importData(true);
    // await Future.delayed(Duration(milliseconds: 50));
    // if (_thisPlayer == null){
    //   return;
    // }
    // if (_thisPlayer!.isDealer() == false && _status == RoomStatus.ready){
    //   if (_thisPlayer!.state == PlayerState.ready) {
    //     _thisPlayer!.state = PlayerState.none;
    //   }
    // }
  }
}

