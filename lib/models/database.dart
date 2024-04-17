import 'RoomModel.dart';
import 'FirebaseRequest.dart';

class Database {
  static List<RoomModel> rooms = [];

  static refreshDB() async {
    rooms = (FirebaseRequest.readRooms()) as List<RoomModel>;
    rooms.sort((a, b) => a.roomID! - b.roomID!);
  }

  static int getAvailableRoomID() {
    refreshDB();
    if (rooms.isEmpty){
      return 0;
    }
    return rooms.last.roomID! + 1;
  }

  static RoomModel? getRoomByID(int id){
    refreshDB();
    try {
      RoomModel room =
          rooms.where((roomCheck) => roomCheck.roomID! == id)
              .first;
      return room;
    } catch (e) {
      return null;
    }
  }
}