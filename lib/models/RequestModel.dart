import 'package:flutter/foundation.dart';

class RequestModel{

  static String collectionName = 'RoomRequests';

  String? key;
  int? playerID;
  String? command;
  List<String> params = [];

  RequestModel({
    required key,
    required playerID,
    required command,
    required params
  });

  Map<String, dynamic> toJson() => {
    'playerID': playerID,
    'command': command,
    'deck': params,
  };

  static RequestModel fromJson(Map<String, Object?> json) {
    final dataParams = json['params'] as List?;
    final listParams = List.castFrom<Object?, Map<String, Object?>>(dataParams!);

    return RequestModel(
        key: json['key'] as String,
        playerID: json['playerID'] as int,
        command:  json['command'] as String,
        params: listParams
    );
  }

  static String formatRequestCollectionKey(int roomID){
    return "Requests_room${roomID}";
  }

  static String formatRequestsKey(int playerID){
    return "request_${DateTime.now()}_p$playerID";
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

}