import 'package:flutter/foundation.dart';

class RequestModel{

  static String collectionName = 'RoomRequests';

  String? key;
  String? playerID;
  String? command;
  List<String> params = [];

  RequestModel({
    required this.key,
    required this.playerID,
    required this.command,
    required this.params
  });

  Map<String, dynamic> toJson() => {
    'playerID': playerID,
    'command': command,
    'params': params,
  };

  static RequestModel fromJson(String key, Map<String, Object?> json) {
    final dataParams = json['params'] as List?;
    // final listParams = List.castFrom<Object?, <String, Object?>>(dataParams!);

    return RequestModel(
        key: key,
        playerID: json['playerID'] as String,
        command:  json['command'] as String,
        params: List.castFrom(dataParams!)
    );
  }

  static String formatRequestCollectionKey(int roomID){
    return "Requests_room${roomID}";
  }

  static String formatRequestsKey(String playerID){
    return ("request_${DateTime.now()}_p$playerID").replaceAll(" ", "");
  }

  bool isEqual(RequestModel obj){
    return
      key == obj.key
      && playerID == obj.playerID
      && command == obj.command
      && listEquals(params, obj.params)
    ;
  }

  // COMMAND LIST

  static const reqJoinRoom = "join";
  static const reqReady = "ready";
  static const reqCancelReady = "cancelReady";
  static const reqDrawCard = "reqDrawCard";
  static const reqStand = "reqStand";
  static const reqLeave = "reqLeave";
}