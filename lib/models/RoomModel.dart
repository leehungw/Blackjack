import 'dart:convert';

import 'package:card/models/PlayerModel.dart';
import 'package:card/models/Validator.dart';
import 'package:flutter/foundation.dart';

class RoomModel {

  String? key;
  int? roomID;
  List<PlayerModel> players = [];
  int? dealer;
  // List<String> deck = [];
  String? status;
  int? currentPlayer;

  static String collectionName = 'Rooms';

  RoomModel(
      {
        this.key,
        required this.roomID,
        required this.players,
        required this.dealer,
        // required this.deck,
        required this.status,
        this.currentPlayer
      }
  );

  Map<String, dynamic> toJson() => {
    'roomID': roomID,
    'players': players.map((player) => player.toJson()).toList(),
    'dealer': dealer,
    // 'deck': deck,
    'status': status,
    'currentPlayer': currentPlayer
  };

  RoomModel clone(){
    return RoomModel(
        key: key,
        roomID: roomID,
        players: players,
        dealer: dealer,
        // deck: deck,
        status: status,
        currentPlayer: currentPlayer
    );
  }

  static RoomModel fromJson(String key, Map<String, Object?> json) {
    final dataPlayer = json['players'] as List?;
    final listPlayer = List.castFrom<Object?, Map<String, Object?>>(dataPlayer!);
    // playersString = playersString.replaceAll("[", "");
    // playersString = playersString.replaceAll("]", "");
    // playersString = playersString.replaceAll(" ", "");
    // List<String> playersList = playersString.split(",");
    // List<int> newPlayers = [];
    // for (var element in playersList)
    // {
    //   newPlayers.add(int.parse(element));
    // }

    final dataDeck = json['deck'] as List?;
    final deck = List.castFrom<Object?, Map<String, Object?>>(dataDeck!);

    return RoomModel(
        key: key,
        roomID: json['roomID'] as int,
        players:  listPlayer.map((raw) => PlayerModel.fromJson(raw)).toList(),
        dealer: json['dealer'] as int,
        // deck: List.from(deck),
        status: json['status'] as String,
        currentPlayer: json['currentPlayer'] as int
    );
  }

  bool isEqual(RoomModel obj){
    return
      key == obj.key
      && roomID == obj.roomID
      && Validator.validatePlayerList(players, obj.players)
      && dealer == obj.dealer
      // && listEquals(deck, obj.deck)
      && status == obj.status
      && currentPlayer == obj.currentPlayer
    ;
  }

  static String formatRoomKey(int roomID){
    return "room_$roomID";
  }
}