import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../firebase_options.dart';
import 'PlayerModel.dart';
import 'RoomModel.dart';

class FirebaseRequest {

  // static CollectionReference? referenceRooms;

  static Stream<List<RoomModel>> readRooms() => FirebaseFirestore.instance
      .collection(RoomModel.collectionName)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => RoomModel.fromJson(doc.id, doc.data())).toList());

  static Stream<List<PlayerModel>> readPlayers() => FirebaseFirestore.instance
      .collection(PlayerModel.collectionName)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => PlayerModel.fromJson(doc.id, doc.data())).toList());

  // static initializeDB() async {
  //   await Firebase.initializeApp(
  //       options: DefaultFirebaseOptions.currentPlatform);
  //   referenceRooms = await FirebaseFirestore.instance.collection('Rooms');
  // }

  static void addRoom(RoomModel model) => FirebaseFirestore.instance
      .collection(RoomModel.collectionName)
      .add(model.toJson());

  static void updateRoom(RoomModel model) => FirebaseFirestore.instance
      .collection(RoomModel.collectionName)
      .doc(model.key)
      .update(model.toJson());

  static Future<RoomModel> refreshRoom(RoomModel model) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('your_collection_name').doc(model.key);

    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      return RoomModel.fromJson(model.key ?? "", docSnapshot.data() as Map<String, dynamic>);
    } else {
      print("No such document!");
      return model;
    }
  }

  static void addPlayer(PlayerModel model) => FirebaseFirestore.instance
      .collection(PlayerModel.collectionName)
      .add(model.toJson());

  static void updatePlayer(PlayerModel model) => FirebaseFirestore.instance
      .collection(RoomModel.collectionName)
      .doc(model.key)
      .update(model.toJson());

  static Future<bool> refreshPlayer(PlayerModel model) async {
    DocumentReference docRef = FirebaseFirestore.instance.collection('your_collection_name').doc(model.key);

    DocumentSnapshot docSnapshot = await docRef.get();

    if (docSnapshot.exists) {
      model = PlayerModel.fromJson(model.key ?? "", docSnapshot.data() as Map<String, dynamic>);
      return true;
    } else {
      print("No such document!");
      return false;
    }
  }


}