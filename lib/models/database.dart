import 'package:card/models/PlayerModel.dart';

import 'RoomModel.dart';
import 'FirebaseRequest.dart';

class Database {
  static List<RoomModel> rooms = [];
  static List<PlayerModel> players = [];

  static Future<void> refreshDB() async {

    await FirebaseRequest.readRooms().forEach((element) { rooms = element; });
    rooms.sort((a, b) => a.roomID! - b.roomID!);

    await FirebaseRequest.readPlayers().forEach((element) { players = element; });
  }

  static Future<int> getAvailableRoomID() async {
    await refreshDB();
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