import 'package:card/models/PlayerModel.dart';

import 'RoomModel.dart';
import 'FirebaseRequest.dart';

class Database {
  static List<RoomModel> rooms = [];
  static List<PlayerModel> players = [];

  static Future<void> refreshDB() async {

    FirebaseRequest.readRooms().forEach((element) { rooms = element; });
    rooms.sort((a, b) => a.roomID! - b.roomID!);

    FirebaseRequest.readPlayers().forEach((element) { players = element; });
  }

  static Future<int> getAvailableRoomID() async {
    int timeout = 10;

    while (timeout > 0){
      try {
        await refreshDB();
        break;
      } catch (e) {
        print(e);
        timeout--;
        await Future.delayed(Duration(milliseconds: 50));
      }
    }

    if (rooms.isEmpty){
      return 0;
    }
    return rooms.last.roomID! + 1;
  }

  static Future<RoomModel?> getRoomByID(int id) async {
    await refreshDB();
    try {
      RoomModel room =
          rooms.where((roomCheck) => roomCheck.roomID! == id)
              .first;
      return room;
    } catch (e) {
      return null;
    }
  }

  static Future<List<PlayerModel>> getPlayersInRoom(int roomID) async {
    await refreshDB();
    try {
      List<PlayerModel> result = [];
      for (PlayerModel player in players){
        if (player.roomID == roomID){
          result.add(player);
        }
      }
      return result;
    } catch (e) {
      return [];
    }
  }
}