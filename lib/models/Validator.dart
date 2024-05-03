import 'package:card/models/PlayerModel.dart';
import 'package:card/models/RoomModel.dart';

import 'RequestModel.dart';

class Validator{

  static bool validateRoom(RoomModel model){
      try {
        if (model.players.isEmpty || model.players.length > 6){
          return false;
        }
      } catch (e){
        print("ValidateRoom(Validator):$e");
        return false;
      }
      return true;
  }

  static bool validatePlayer(PlayerModel model){
      try {

      } catch (e){
        print("validate Player (validator): $e");
        return false;
      }
      return true;
  }

  static bool validatePlayerList(List<PlayerModel> listA, List<PlayerModel> listB){
    if (listA.length != listB.length) {
      return false;
    }

    for (int i = 0; i < listA.length; i++){
      if (listA[i].isEqual(listB[i]) == false){
        return false;
      }
    }

    return true;
  }

  static bool validateRequestList(List<RequestModel> listA, List<RequestModel> listB){
    if (listA.length != listB.length) {
      return false;
    }

    for (int i = 0; i < listA.length; i++){
      if (listA[i].isEqual(listB[i]) == false){
        return false;
      }
    }

    return true;
  }
}