import 'dart:async';

import 'package:async/async.dart';
import 'package:card/GameObject/game_factory.dart';
import 'package:card/models/FirebaseRequest.dart';
import 'package:card/models/PlayerModel.dart';
import 'package:card/models/RequestModel.dart';
import 'package:card/models/RoomModel.dart';
import 'package:card/models/user.dart';

import '../models/database.dart';
import 'game_card.dart';
import 'game_player.dart';
import 'game_player_online.dart';

// TODO: sửa lỗi mọi người thoát hết thì không dọn được phòng

enum RoomStatus {
  start,
  end,
  init,
  distributing,
  ready,
  deleting,
}

final class GameOnlineManager{
  static const int initializeRoomID = 0;

  static final GameOnlineManager _instance = GameOnlineManager();
  static GameOnlineManager get instance => _instance;

  late StreamController<void> _playerChanges = StreamController<void>.broadcast();

  late StreamController<void> _remoteChanges = StreamController<void>.broadcast();

  /// A [Stream] that fires an event every time a change is made _locally_,
  /// by the player.
  Stream<void> get playerChanges => _playerChanges.stream;

  /// A [Stream] that fires an event every time a change is made _remotely_,
  /// by another player.
  Stream<void> get remoteChanges => _remoteChanges.stream;

  /// A [Stream] that fires an event every time any change to this area is made.
  Stream<void> get allChanges =>
      StreamGroup.mergeBroadcast([remoteChanges, playerChanges]);

  PlayerRepo playerRepo = PlayerRepo();

  RoomModel? model;
  List<RequestModel> requestList = [];

  String _thisUserID = "";

  List<GamePlayerOnline> _players = [];
  List<GamePlayerOnline> _left_players = [];
  List<GameCard> _deck = [];
  RoomStatus _status = RoomStatus.end;
  GamePlayerOnline? _currentPlayer;
  GamePlayerOnline? _dealer;
  GamePlayerOnline? _thisPlayer;
  int _revealedCount = 0;

  bool sentRequest = false;
  bool kickedFlag = false;
  bool outOfMoneyFlag = false;
  bool hostCanLeave = false;

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

  GamePlayerOnline? get thisPlayer {
    return _thisPlayer;
  }

  RoomStatus get status {
    return _status;
  }

  // bool get isStart {
  //   return _status == RoomStatus.init || _status == RoomStatus.start;
  // }

  void _clear(){
    _thisUserID = "";
    _thisPlayer = null;
    _players.clear();
    _currentPlayer = null;
    _dealer = null;
    _revealedCount = 0;
    _status = RoomStatus.end;
  }

  Future<void> dispose() async {
    _remoteChanges.close();
    _playerChanges.close();
    Database.dispose();
    await Future.delayed(Duration(milliseconds: 50));
    _clear();
    hostCanLeave = false;
    kickedFlag = false;
    outOfMoneyFlag = false;
    model = null;
    requestList.clear();
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

      GamePlayerOnline player = await GameFactory.createPlayerOnline(playerModel, playerModel.playerID == _thisUserID);
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
      case "deleting":
        _status = RoomStatus.deleting;
        break;
    }

    // Show player cards when they have already been executed.
    int showedCount = 0;
    for (GamePlayerOnline player in _players){
      if (player == _dealer || player.result == PlayerResult.dealer){
        showedCount ++;
        if (player == _thisPlayer || _thisPlayer!.result != PlayerResult.uncheck){
          player.flipCards();
        }
        continue;
      } else {
        if (player.result != PlayerResult.uncheck){
          showedCount++;
          player.flipCards();
        } else if (player == _thisPlayer){
          player.flipCards();
        }
      }
    }
    // if (showedCount == _players.length){
    //   _dealer!.flipCards();
    // }

    _remoteChanges.add(null);
  }

  Future<void> uploadData() async {
    if (thisUserIsHost() == false){
      print("Not a host! Can't upload data.");
    }
    print(_players);

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
      case RoomStatus.deleting:
        model!.status = "deleting";
    }

    model!.currentPlayer = _currentPlayer == null ? "" : _currentPlayer!.userId;
    model!.dealer = _dealer!.userId;
    model!.players.clear();

    for (GamePlayerOnline player in _players){
      model!.players.add(player.toPlayerModel());
    }

    await Database.updateFirestoreFromLocal(model!);
    _playerChanges.add(null);
  }

  Future<void> importRequests(List<RequestModel> requestList) async {

    this.requestList = requestList;

    if (thisUserIsHost() == false){
      // Handle kick request
      RequestModel? kickRequest = requestList.cast<RequestModel?>().firstWhere((element) =>
        element!.command == RequestModel.reqKick
        && element.params[0] == _thisPlayer!.userId
      , orElse: () => null
      );

      if (kickRequest != null){
        await _kickRequestHandler(kickRequest);
      }

      // This user isn't host. No need to handle other requests.

      _remoteChanges.add(null);

      // if the request has been handled, remove the protection
      // This will avoid multiple pressing problem
      if (requestList.isEmpty && sentRequest){
        sentRequest = false;
      }


      return;
    }

    if (_validateRequest() == false){
      Database.updateFirestoreFromLocal(model!);
      return;
    }

    await _requestHandler();
  }

  //================================================================

  // void uploadThisUser(){
  //   FirebaseRequest.updatePlayer(_thisPlayer!.toPlayerModel());
  // }

  //================================================================
  // INITIALIZE

  Future<bool> initialize(String thisUserID, int roomID) async {
    _clear();
    _playerChanges = StreamController<void>.broadcast();
    _remoteChanges = StreamController<void>.broadcast();
    _thisUserID = thisUserID;
    bool success;
    if (roomID == initializeRoomID){
      success = await initializeNewHostRoom();
    } else {
      success = await initializeClientRoom(roomID);
    }


    if (success){
      //await FirebaseRequest.setRoom(model!);
      //await importRoomData(model!, true);
      _playerChanges.add(null);
    } else {
      dispose();
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
        cards: [],
        deal: 0
    );

    RoomModel roomModel = RoomModel(
        key: RoomModel.formatRoomKey(roomID),
        roomID: roomID,
        players: [thisUserModel],
        dealer: _thisUserID,
        // deck: [],
        status: "ready",
        currentPlayer: ""
    );

    await FirebaseRequest.deleteRequestCollection(roomID);
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
    print("initialize room success");
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

    // Player already joined this room before
    if (thisUserIsInRoom()){
      return true;
    }

    // Send join room request

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
        if (player == _thisPlayer){
          card.flip();
        }
        await uploadData();
        await Future.delayed(Duration(milliseconds: 500));
      }
    }
    for (GamePlayerOnline player in _players){
      player.waitForTurn();
    }

    await uploadData();

    if (await checkBlackjack() == false){
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
    if (_status == RoomStatus.end){
      return;
    }
    _status = RoomStatus.end;
    await uploadData();
  }

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

  Future<void> _kickRequestHandler(RequestModel req) async {
    // TODO: only non-host player can handle this case
    switch(req.command) {
      case RequestModel.reqKick:
        {
          if (thisUserIsHost()){
            return;
          }
          switch (req.params[1]){
            case ReqKickFlag.hostKicked:
              {
                await reqLeaveRoom();
                kickedFlag = true;
                break;
              }
            case ReqKickFlag.outOfMoney:
              {
                await reqLeaveRoom();
                outOfMoneyFlag = true;
                break;
              }
          }
          break;
        }
    }
    await FirebaseRequest.deleteRequest(req, model!.roomID!);
    _remoteChanges.add(null);
  }

  Future<void> _requestHandler() async {
    if (requestList.isEmpty){
      return;
    }
    // Handle one request per times
    RequestModel req = requestList.first;
    _requestCache.add(req);

    switch(req.command){
      // ----------------------------------------------------------
      case RequestModel.reqJoinRoom:
        {
          // Validate if player already in room or not
          bool playerExist = false;
          for (GamePlayerOnline player in _players){
            if (player.userId == req.playerID){
              print("Player already joined in room");
              playerExist = true;
              break;
            }
          }
          if (playerExist) break;

          int availableSeat = getAvailableSeat();
          if (_status == RoomStatus.ready && availableSeat != -1) {
            PlayerModel newPlayerModel = PlayerModel(
                playerID: req.playerID!,
                roomID: model!.roomID!,
                seat: availableSeat,
                state: "none",
                result: "uncheck",
                cards: [],
                deal: 0
            );

            _players.add(await GameFactory.createPlayerOnline(newPlayerModel, false));
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
              player.state = PlayerState.ready;
              player.dealAmount = int.parse(req.params[0]);
              await uploadData();
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
              player.state = PlayerState.none;
              player.dealAmount = 0;
              await uploadData();
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

    // ----------------------------------------------------------
      case RequestModel.reqLeave:
        {
          // TODO: Host handler

          if (_thisPlayer!.userId == req.playerID){

            if (_status == RoomStatus.start){
              // Handle transaction
              for (GamePlayerOnline player in _players){
                if (player.result == PlayerResult.uncheck){
                  player.win();
                  await handleTransaction(player, 1);
                }
              }
            }

            _status = RoomStatus.deleting;
            await uploadData();
            await Future.delayed(Duration(milliseconds: 100));

            await FirebaseRequest.deleteRequest(req, model!.roomID!);
            await FirebaseRequest.deleteRoom(model!);
            hostCanLeave = true;
            return;
          }

          // TODO: Other player handler

          // Remove player safely because the game isn't started
          if (_status == RoomStatus.ready){
            _players.removeWhere((element) => element.userId == req.playerID);
            await uploadData();
            break;
          }

          // Room already started
          GamePlayerOnline? target = _players.firstWhere((element) => element.userId == req.playerID);

          if (_status == RoomStatus.start){
            if (_currentPlayer!.userId == req.playerID){
              _currentPlayer?.lose();
              _left_players.add(_currentPlayer!);

              // Handle transaction
              await handleTransaction(_currentPlayer!, 1);
              //
              await playerEndTurn();
            } else {
              target.lose();
              _left_players.add(target);
              // Handle transaction
              await handleTransaction(target, 1);
              //
              await uploadData();
            }

            if (_left_players.length == _players.length - 1){
              await endOnlineGame();
              break;
            }

            break;
          }

          // Room already ended
          _left_players.add(target);
          break;
        }
    }

    await FirebaseRequest.deleteRequest(req, model!.roomID!);
  }

  //================================================================


  // ================================================
  // EXECUTE FUNCTIONS

  Future<bool> tryEndOnlineGame() async {
    if (_revealedCount >= _players.length - 1){
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
      PlayerCardState result = player.checkBlackjack();
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
        await handleTransaction(player, 2);
      }
      for (GamePlayerOnline player in ban_luck_players){
        player.tie();
        await handleTransaction(player, 2);
      }
      for (GamePlayerOnline player in normal_players){
        player.lose();
        await handleTransaction(player, 2);
      }
      endOnlineGame();
      return true;
    }
    // dealer got ban_ban
    if (dealerResult == PlayerCardState.ban_ban){
      for (GamePlayerOnline player in ban_ban_players){
        player.tie();
        await handleTransaction(player, 3);
      }
      for (GamePlayerOnline player in ban_luck_players){
        player.lose();
        await handleTransaction(player, 3);
      }
      for (GamePlayerOnline player in normal_players){
        player.lose();
        await handleTransaction(player, 3);
      }
      await endOnlineGame();
      return true;
    }

    // player got ban_ban or ban_luck
    for (GamePlayerOnline player in ban_luck_players){
      player.win();
      await handleTransaction(player, 2);
      _revealedCount++;
    }
    for (GamePlayerOnline player in ban_ban_players){
      player.win();
      await handleTransaction(player, 3);
      _revealedCount++;
    }

    if (await tryEndOnlineGame()){
      return true;
    }

    // All is normal
    await uploadData();
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

  GamePlayerOnline? getPlayerBySeat(int seat){
    for (GamePlayerOnline player in players){
      if (player.seat == seat){
        return player;
      }
    }
    return null;
  }

  GamePlayerOnline? getPlayerBySeatOffset(int seatOffset){
    if (_thisPlayer == null) {
      return null;
    }
    int seat = _thisPlayer!.seat + seatOffset;
    seat = seat > 6 ? seat - 6 : seat;
    for (GamePlayerOnline player in players){
      if (player.seat == seat){
        return player;
      }
    }
    return null;
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
    if (_left_players.contains(result)){
      return _getNextPlayer(result);
    }
    return result;
  }

  // ===========================================================
  // BOOLEAN

  bool thisUserIsHost(){
    return _thisPlayer != null && _thisPlayer == _dealer;
  }

  bool thisUserIsInRoom(){
    for (GamePlayerOnline player in _players){
      if (player.userId == _thisUserID){
        return true;
      }
    }
    return false;
  }

  bool isPlayerLeft(GamePlayerOnline player){
    return _left_players.contains(player);
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
          && _thisPlayer!.getTotalValues() != 21
          && _thisPlayer!.cardCount < 5;
  }

  // check all
  bool dealerCanExecuteAllPlayer(){
    if (_status != RoomStatus.start){
      return false;
    }
    return
      _thisPlayer != null
          && _thisPlayer == _dealer
          && _thisPlayer?.state == PlayerState.onTurn
          && _thisPlayer!.getTotalValues() >= 16;
  }

  bool dealerCanExecutePlayer(GamePlayerOnline player){
    if (_status != RoomStatus.start){
      return false;
    }
    return
      _thisPlayer != null
          && _thisPlayer == _dealer
          && players.contains(player)
          && player.result == PlayerResult.uncheck
          && _thisPlayer?.state == PlayerState.onTurn
          && _thisPlayer!.getTotalValues() >= 16;
  }

  bool canStartGame(){
    return _thisPlayer != null && _thisPlayer! == _dealer && canStartOnlineGame();
  }

  bool canCleanTable(){
    return
      _status == RoomStatus.end
      && _thisPlayer != null
      && _thisPlayer == _dealer;
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

  bool playerCanLeaveRoom() {
    return
      _status != RoomStatus.distributing
      && _status != RoomStatus.init
      && _thisPlayer != null;
  }

  bool GameIsPlaying(){
    return status == RoomStatus.start || status == RoomStatus.end || status == RoomStatus.distributing;
  }

  // ===========================================================
  // PLAYER BEHAVIOR

  Future<void> playerDrawCard() async {
    // if (_thisPlayer != _currentPlayer){
    //   return;
    // }
    GameCard card = _deck.removeAt(0);
    if (_currentPlayer == _thisPlayer){
      card.flip();
    }
    _currentPlayer?.hit(card);
    if (_currentPlayer == _dealer){
      if (_currentPlayer!.isBurn() || _currentPlayer!.isDragon()){
        await dealerExecuteAll();
      }
      await tryEndOnlineGame();
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
    GamePlayerOnline? player = getPlayerBySeat(seatNumber);
    if (player == null){
      print("Player at seat $seatNumber doesn't exist!");
      return;
    }
    player.reveal(_dealer!);
    _revealedCount ++;
    await handleTransaction(player, player.isDragon() ? 2 : 1);

    await tryEndOnlineGame();

    await uploadData();
  }

  Future<void> dealerExecuteAll() async {
    for (GamePlayerOnline player in _players){
      if (player.state == PlayerState.revealed || player.isDealer()){
        continue;
      }
      player.reveal(_dealer!);
      _revealedCount++;
      await handleTransaction(player, player.isDragon() ? 2 : 1);
    }
    await tryEndOnlineGame();
    await uploadData();
  }

  Future<void> handleTransaction(GamePlayerOnline player, int multiplier) async {
    switch (player.result){
      case PlayerResult.win:
        {
          await playerRepo.addMoneyToPlayer(player.userId, player.dealAmount * multiplier);
          await playerRepo.drawMoneyFromPlayer(dealer!.userId, player.dealAmount * multiplier);
          await playerRepo.addExpToPlayer(player.userId, ExpGainAmount.win * multiplier);
          await playerRepo.addExpToPlayer(dealer!.userId, ExpGainAmount.dealerLose);
          break;
        }
      case PlayerResult.tie:
        {
          await playerRepo.addExpToPlayer(player.userId, ExpGainAmount.tie * multiplier);
          await playerRepo.addExpToPlayer(dealer!.userId, ExpGainAmount.dealerTie);
          break;
        }
      case PlayerResult.lose:
        {
          await playerRepo.drawMoneyFromPlayer(player.userId, player.dealAmount);
          await playerRepo.addMoneyToPlayer(dealer!.userId, player.dealAmount);
          await playerRepo.addExpToPlayer(player.userId, ExpGainAmount.lose);
          await playerRepo.addExpToPlayer(dealer!.userId, ExpGainAmount.dealerWin);
          break;
        }
      default:
        {
          print("This player has invalid result");
        }
    }
    await dealer!.connectToUserModel();
    await player.connectToUserModel();
    _remoteChanges.add(null);
  }

  //================================================================
  // ROOM CONTROL

  Future<void> cleanTable() async{

    for (GamePlayerOnline player in _left_players){
      _players.remove(player);
    }
    _left_players.clear();

    for (GamePlayerOnline player in _players){
      player.cards.clear();
      player.state = PlayerState.none;
      if (player.isDealer() == false){
        player.result = PlayerResult.uncheck;
      }
      if (player.userModel!.money < 10000){
        await reqKick(player, ReqKickFlag.outOfMoney);
      }
    }

    _revealedCount = 0;
    _deck.clear();
    _status = RoomStatus.ready;

    await uploadData();
  }

  // ===================================================================
  // SEND REQUEST

  Future<bool> trySendRequest(RequestModel req) async{
    try {
      await FirebaseRequest.sendRequest(req, model!.roomID!);
      sentRequest = true;
      return true;
    }
    catch (e){
      print(e);
      return false;
    }
  }

  Future<void> reqDrawCard() async {
    RequestModel req = GameFactory.createRequestDrawCard(_thisUserID);
    await trySendRequest(req);
  }

  Future<void> reqStand() async {
    RequestModel req = GameFactory.createRequestStand(_thisUserID);
    await trySendRequest(req);
  }

  Future<void> reqJoinRoom() async {
    RequestModel req = GameFactory.createRequestJoinRoom(_thisUserID);
    await trySendRequest(req);
  }

  Future<void> reqReady(int amount) async {
    RequestModel req = GameFactory.createRequestReady(_thisUserID, amount);
    await trySendRequest(req);
  }

  Future<void> reqCancelReady() async {
    RequestModel req = GameFactory.createRequestCancelReady(_thisUserID);
    await trySendRequest(req);
  }

  Future<bool> reqLeaveRoom() async {
    RequestModel req = GameFactory.createRequestLeaveRoom(_thisUserID);
    return await trySendRequest(req);
  }

  Future<bool> reqKick(GamePlayerOnline target, String flag) async {
    RequestModel req = GameFactory.createRequestKick(_thisUserID, target.userId, flag);
    return await trySendRequest(req);
  }
}

abstract final class ExpGainAmount{
  static const win = 400;
  static const tie = 200;
  static const lose = 100;
  static const dealerWin = 200;
  static const dealerTie = 100;
  static const dealerLose = 50;
}