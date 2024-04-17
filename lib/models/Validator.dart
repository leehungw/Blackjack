import 'package:card/models/PlayerModel.dart';
import 'package:card/models/RoomModel.dart';

class Validator{

  static bool validateRoom(RoomModel model){
      try {
        if (model.players.isEmpty || model.players.length > 6){
          return false;
        }
      } catch (e){
        print(e);
        return false;
      }
      return true;
  }

  static bool validatePlayer(PlayerModel model){
      try {

      } catch (e){
        print(e);
        return false;
      }
      return true;
  }
}