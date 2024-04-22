import 'package:card/models/PlayerModel.dart';

import 'RoomModel.dart';
import 'FirebaseRequest.dart';

class Database {
  static List<RoomModel> rooms = [];
  static List<PlayerModel> players = [];

  static Future<void> refreshDB() async {
    int timeout = 300;
    bool readRoom = false;
    bool readPlayer = false;

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

    FirebaseRequest.readPlayers().listen(
        (event) {
          players = event;
          print("get Room success");
          readPlayer = true;
        },
        onError: (err) {
          print(err);
          return;
        },
        // onDone: () {
        //   print("get Room success");
        //   readPlayer = true;
        // }
    );

    while (timeout > 0 && (readRoom == false || readPlayer == false)){
        timeout--;
        await Future.delayed(Duration(milliseconds: 50));
    }

    if (timeout <= 0){
      print("Get data false");
      return;
    }

    rooms.sort((a, b) => a.roomID! - b.roomID!);
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