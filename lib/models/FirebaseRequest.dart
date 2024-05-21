import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'PlayerModel.dart';
import 'RequestModel.dart';
import 'RoomModel.dart';

class FirebaseRequest {

  // static CollectionReference? referenceRooms;

  static Stream<List<RoomModel>> readRooms() => FirebaseFirestore.instance
      .collection(RoomModel.collectionName)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => RoomModel.fromJson(doc.id, doc.data())).toList());
  //
  // static Stream<List<PlayerModel>> readPlayers() => FirebaseFirestore.instance
  //     .collection(PlayerModel.collectionName)
  //     .snapshots()
  //     .map((snapshot) =>
  //     snapshot.docs.map((doc) => PlayerModel.fromJson(doc.id, doc.data())).toList());

  // static initializeDB() async {
  //   await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform);
  //   referenceRooms = await FirebaseFirestore.instance.collection('Rooms');
  // }

  static Future<void> setRoom(RoomModel model) async => FirebaseFirestore.instance
      .collection(RoomModel.collectionName)
      .doc(model.key)
      .set(model.toJson());

  static Future<void> sendRequest(RequestModel model, int roomID) async => FirebaseFirestore.instance
      .collection(RequestModel.collectionName)
      .doc(RequestModel.formatRequestCollectionKey(roomID))
      .collection("Requests")
      .doc(model.key)
      .set(model.toJson());

  static Future<void> deleteRequest(RequestModel model, int roomID) async => FirebaseFirestore.instance
      .collection(RequestModel.collectionName)
      .doc(RequestModel.formatRequestCollectionKey(roomID))
      .collection("Requests")
      .doc(model.key)
      .delete();

  // static void updateRoom(RoomModel model) => FirebaseFirestore.instance
  //     .collection(RoomModel.collectionName)
  //     .doc(model.key)
  //     .update(model.toJson());

  static Future<RoomModel> refreshRoom(RoomModel model) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection(RoomModel.collectionName).doc(model.key);

    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return RoomModel.fromJson(model.key ?? "", docSnapshot.data() as Map<String, dynamic>);
    } else {
      print("No such document!");
      return model;
    }
  }

  /// Check If Document Exists
  static Future<bool> checkIfRoomExists(int roomID) async {
    var collectionRef = FirebaseFirestore.instance.collection(RoomModel.collectionName);

    var doc = await collectionRef.doc(RoomModel.formatRoomKey(roomID)).get();
    return doc.exists;
  }

  // static void setPlayer(PlayerModel model) => FirebaseFirestore.instance
  //     .collection(PlayerModel.collectionName)
  //     .doc(model.key)
  //     .set(model.toJson());

  // static void updatePlayer(PlayerModel model) => FirebaseFirestore.instance
  //     .collection(RoomModel.collectionName)
  //     .doc(model.key)
  //     .update(model.toJson());

  // static Future<bool> refreshPlayer(PlayerModel model) async {
  //   DocumentReference docRef = FirebaseFirestore.instance.collection(PlayerModel.collectionName).doc(model.key);
  //
  //   DocumentSnapshot docSnapshot = await docRef.get();
  //
  //   if (docSnapshot.exists) {
  //     model = PlayerModel.fromJson(model.key ?? "", docSnapshot.data() as Map<String, dynamic>);
  //     return true;
  //   } else {
  //     print("No such document!");
  //     return false;
  //   }
  // }


}