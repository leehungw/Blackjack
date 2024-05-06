
import 'package:card/models/RoomModel.dart';
import 'package:flutter/foundation.dart';

class PlayerModel {

  //String? key;
  int playerID;
  int roomID;
  int seat;
  String? state;
  String? result;
  List<String> cards = [];

  static String collectionName = 'Players';

  PlayerModel(
    {
      //this.key,
      required this.playerID,
      required this.roomID,
      required this.seat,
      required this.state,
      required this.result,
      required this.cards
    }
  );

  Map<String, dynamic> toJson() => {
    'playerID': playerID,
    'roomID': roomID,
    'seat': seat,
    'state': state,
    'result': result,
    'cards': cards.toString()
  };

  static PlayerModel fromJson(Map<String, dynamic> json) {

    String cardsString = json['cards'] as String;
    cardsString = cardsString.replaceAll("[", "");
    cardsString = cardsString.replaceAll("]", "");
    cardsString = cardsString.replaceAll(" ", "");
    List<String> cardsList = cardsString.split(",");

    return PlayerModel(
        //key: key,
        playerID: json['playerID'] as int,
        roomID: json['roomID'] as int,
        seat: json['seat'] as int,
        state: json['state'] as String,
        result: json['result'] as String,
        cards: cardsList
    );
  }

  static PlayerModel? getPlayerByID(List<PlayerModel> list, int id){
    try {
      PlayerModel player =
          list.where((playerCheck) => playerCheck.playerID == id)
              .first;
      return player;
    } catch (e) {
      return null;
    }

  }

  bool isEqual(PlayerModel obj){
    return
      playerID == obj.playerID
      && roomID == obj.roomID
      && seat == obj.seat
      && state == obj.state
      && result == obj.state
      && listEquals(cards, obj.cards)
    ;
  }
}