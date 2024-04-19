import 'dart:convert';

class RoomModel {

  String? key;
  int? roomID;
  List<int> players = [];
  int? dealer;
  List<String> deck = [];
  String? status;
  int? currentPlayer;

  static String collectionName = 'Rooms';

  RoomModel(
      {
        this.key,
        required this.roomID,
        required this.players,
        required this.dealer,
        required this.deck,
        required this.status,
        this.currentPlayer
      }
  );

  Map<String, dynamic> toJson() => {
    'roomID': roomID,
    'players': players.toString(),
    'dealer': dealer,
    'deck': deck.toString(),
    'status': status,
    'currentPlayer': currentPlayer
  };

  RoomModel clone(){
    return RoomModel(
        key: key,
        roomID: roomID,
        players: players,
        dealer: dealer,
        deck: deck,
        status: status,
        currentPlayer: currentPlayer
    );
  }

  static RoomModel fromJson(String key, Map<String, dynamic> json) {
    String playersString = json['players'] as String;
    playersString = playersString.replaceAll("[", "");
    playersString = playersString.replaceAll("]", "");
    playersString = playersString.replaceAll(" ", "");
    List<String> playersList = playersString.split(",");
    List<int> newPlayers = [];
    for (var element in playersList)
    {
      newPlayers.add(int.parse(element));
    }

    String deckString = json['deck'] as String;
    deckString = deckString.replaceAll("[", "");
    deckString = deckString.replaceAll("]", "");
    deckString = deckString.replaceAll(" ", "");
    List<String> deckList = deckString.split(",");

    return RoomModel(
        key: key,
        roomID: json['roomID'] as int,
        players:  newPlayers,
        dealer: json['dealer'] as int,
        deck: deckList,
        status: json['status'] as String,
        currentPlayer: json['currentPlayer'] as int
    );
  }
}