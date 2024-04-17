
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
    'players': players,
    'dealer': dealer,
    'deck': deck,
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

    return RoomModel(
        key: key,
        roomID: json['roomID'] as int,
        players: json['players'] as List<int>,
        dealer: json['dealer'] as int,
        deck: json['deck'] as List<String>,
        status: json['status'] as String,
        currentPlayer: json['currentPlayer'] as int
    );
  }
}