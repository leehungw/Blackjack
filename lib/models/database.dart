import 'dart:async';

import 'package:card/GameObject/game_online_manager.dart';
import 'package:card/models/PlayerModel.dart';
import 'package:card/models/RequestModel.dart';
import 'package:card/models/Validator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

import 'RoomModel.dart';
import 'FirebaseRequest.dart';

class Database {
  static final _log = Logger('FirestoreController');

  static final FirebaseFirestore instance = FirebaseFirestore.instance;

  // static List<RoomModel> rooms = [];
  // static List<PlayerModel> players = [];

  static StreamSubscription? _roomFirestoreSubscription;

  static StreamSubscription? _requestsFirestoreSubscription;

  static late DocumentReference<List<RequestModel>> _requestsDoc;

  static late DocumentReference<RoomModel> _roomDoc;

  static void initializeDatabase(int roomID) {
    _roomDoc = instance.collection(RoomModel.collectionName)
      .doc(RoomModel.formatRoomKey(roomID))
      .withConverter<RoomModel>(
          fromFirestore: _roomFromFirestore, toFirestore: _roomToFirestore);

    // Subscribe to the remote changes (from Firestore).
    _roomFirestoreSubscription = _roomDoc.snapshots().listen((snapshot) {
      _updateLocalRoomFromFirestore(GameOnlineManager.instance, snapshot);
    });

    _requestsDoc = instance.collection(RequestModel.collectionName)
      .doc(RequestModel.formatRequestCollectionKey(roomID))
      .withConverter<List<RequestModel>>(
        fromFirestore: _requestsFromFirestore, toFirestore: _requestsToFirestore);

    _requestsFirestoreSubscription = _requestsDoc.snapshots().listen((snapshot) {
      _updateLocalRequestsFromFirestore(GameOnlineManager.instance, snapshot);
    });

    // _playersFirestoreSubscription = _playersDoc.snapshots().listen((snapshot) {
    //   _updateLocalPlayersFromFirestore(GameOnlineManager.instance, snapshot);
    // });

  }

  static void dispose() {
    _roomFirestoreSubscription?.cancel();
    _requestsFirestoreSubscription?.cancel();

    _log.fine('Disposed');
  }

  // static Future<void> refreshDB() async {
  //   int timeout = 300;
  //   bool readRoom = false;
  //   bool readPlayer = false;
  //
  //   rooms.clear();
  //   players.clear();
  //
  //   FirebaseRequest.readRooms().listen(
  //       (event) {
  //         rooms = event;
  //         print("get Room success");
  //         readRoom = true;
  //       },
  //       onError: (err) {
  //         print(err);
  //         return;
  //       },
  //       // onDone: () {
  //       //   print("get Room success");
  //       //
  //       // }
  //   );
  //
  //   FirebaseRequest.readPlayers().listen(
  //       (event) {
  //         players = event;
  //         print("get Player success");
  //         readPlayer = true;
  //       },
  //       onError: (err) {
  //         print(err);
  //         return;
  //       },
  //       // onDone: () {
  //       //   print("get Room success");
  //       //   readPlayer = true;
  //       // }
  //   );
  //
  //   while (timeout > 0 && (readRoom == false || readPlayer == false)){
  //       timeout--;
  //       await Future.delayed(Duration(milliseconds: 50));
  //   }
  //
  //   if (timeout <= 0){
  //     print("Get data false");
  //     return;
  //   }
  //
  //   rooms.sort((a, b) => a.roomID! - b.roomID!);
  // }

  static Future<int> getAvailableRoomID() async {

    List<RoomModel> rooms = [];
    bool readRoom = false;

    FirebaseRequest.readRooms().listen(
        (event) {
          rooms = event;
          print("get Room success");
          readRoom = true;
        },
        onError: (err) {
          print(err);
          return;
        },
        // onDone: () {
        //   print("get Room success");
        //
        // }
    );

    int timeout = 100;
    while (timeout > 0 && readRoom == false){
      timeout--;
      await Future.delayed(Duration(milliseconds: 50));
    }

    if (timeout <= 0){
      print("Get data false");
      return -1;
    }

    if (rooms.isEmpty){
      return 0;
    }

      rooms.sort((a, b) => a.roomID! - b.roomID!);

    return rooms.last.roomID! + 1;
  }

  // static Future<RoomModel?> getRoomByID(int id) async {
  //   await refreshDB();
  //
  //   try {
  //     RoomModel room =
  //         rooms.where((roomCheck) => roomCheck.roomID! == id)
  //             .first;
  //     return room;
  //   } catch (e) {
  //     return null;
  //   }
  // }
  //
  // static Future<List<PlayerModel>> getPlayersInRoom(int roomID) async {
  //   await refreshDB();
  //   try {
  //     List<PlayerModel> result = [];
  //     for (PlayerModel player in players){
  //       if (player.roomID == roomID){
  //         result.add(player);
  //       }
  //     }
  //     return result;
  //   } catch (e) {
  //     return [];
  //   }
  // }

  // ===================================================================

  /// Takes the raw JSON snapshot coming from Firestore and attempts to
  /// convert it into a [RoomModel].
  static RoomModel _roomFromFirestore(
      DocumentSnapshot<Map<String, Object?>> snapshot,
      SnapshotOptions? options,
  ){
    try {
      return RoomModel.fromJson(snapshot.id, snapshot.data()!);
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to parse data from Firestore: $e');
    }
  }

  /// Takes a [RoomModel] and converts it into a JSON object
  /// that can be saved into Firestore.
  static Map<String, Object?> _roomToFirestore(RoomModel room, SetOptions? options) {
    return room.toJson();
  }

  /// Takes the raw JSON snapshot coming from Firestore and attempts to
  /// convert it into a list of [PlayingCard]s.
  static List<RequestModel> _requestsFromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data()?['cards'] as List?;

    if (data == null) {
      _log.info('No data found on Firestore, returning empty list');
      return [];
    }

    final list = List.castFrom<Object?, Map<String, Object?>>(data);

    try {
      return list.map((raw) => RequestModel.fromJson(raw)).toList();
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to parse data from Firestore: $e');
    }
  }

  /// Takes a list of [RequestModel]s and converts it into a JSON object
  /// that can be saved into Firestore.
  static Map<String, Object?> _requestsToFirestore(
      List<RequestModel> requests,
      SetOptions? options,
      ) {
    return {'Requests': requests.map((c) => c.toJson()).toList()};
  }

  /// Updates the local state of [Room] with the data from Firestore.
  static void _updateLocalRoomFromFirestore(
      GameOnlineManager manager, DocumentSnapshot<RoomModel> snapshot) {
    _log.fine('Received new data from Firestore (${snapshot.data()})');

    final roomModel = snapshot.data();

    if (roomModel!.isEqual(manager.model!)) {
      _log.fine('No change');
    } else {
      _log.fine('Updating local data with Firestore data ($roomModel)');
      manager.importRoomData(roomModel, false);
    }
  }

  /// Updates the local state of [Room] with the data from Firestore.
  static void _updateLocalRequestsFromFirestore(
      GameOnlineManager manager, DocumentSnapshot<List<RequestModel>> snapshot) {
    _log.fine('Received new data from Firestore (${snapshot.data()})');

    final requestList = snapshot.data() ?? [];

    if (Validator.validateRequestList(requestList, manager.requestList)) {
      _log.fine('No change');
    } else {
      _log.fine('Updating local data with Firestore data ($requestList)');
      manager.importRequests(requestList);
    }
  }

  static Future<void> updateFirestoreFromLocal(RoomModel model) async {
    await _updateFirestoreFromLocal(model, _roomDoc);
  }

  static Future<void> _updateFirestoreFromLocal(
      RoomModel model, DocumentReference<RoomModel> ref) async {
    try {
      _log.fine('Updating Firestore with local data (room_${model.roomID}) ...');
      await ref.set(model);
      _log.fine('... done updating.');
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to update Firestore with local data (room_${model.roomID}): $e');
    }
  }

}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}