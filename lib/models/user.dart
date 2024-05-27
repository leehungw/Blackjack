import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String playerID;
  String yourName;
  String userName;
  String email;
  int level;
  int money;
  DateTime startDate;
  int duration;

  Player({
    required this.playerID,
    required this.yourName,
    required this.userName,
    required this.email,
    this.level = 0,
    this.money = 10000,
    required this.startDate,
    this.duration = 0,
  });

  // Phương thức để chuyển đổi dữ liệu thành một Map để lưu trữ trên Firestore
  Map<String, dynamic> toMap() {
    return {
      'playerID': playerID,
      'yourName': yourName,
      'userName': userName,
      'email': email,
      'level': level,
      'money': money,
      'startDate': Timestamp.fromDate(startDate),
      'duration': duration,
    };
  }

  // Phương thức tạo một đối tượng User từ một tài liệu Firestore
  factory Player.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Player(
      playerID: data['playerID'] as String,
      yourName: data['yourName'] as String,
      userName: data['userName'] as String,
      email: data['email'] as String,
      level: data['level'] as int,
      money: data['money'] as int,
      startDate: (data['startDate'] as Timestamp).toDate(),
      duration: data['duration'] as int,
    );
  }
}

// Để lưu trữ thông tin người dùng lên Firestore
class PlayerRepo {
  void addUserToFirestore(Player user) async {
    try {
      Map<String, dynamic> userData = user.toMap();
      print('UserData: $userData'); // In ra dữ liệu để kiểm tra
      DocumentReference docRef =
          FirebaseFirestore.instance.collection("Users").doc(user.playerID);
      await docRef.set({
        'playerID': user.playerID,
        'yourName': user.yourName,
        'userName': user.userName,
        'email': user.email,
        'level': user.level,
        'money': user.money,
        'startDate': Timestamp.fromDate(user.startDate),
        'duration': user.duration,
      }).whenComplete(() => print('User added to Firestore'));
      print('User added to Firestore with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding user to Firestore: $e');
    }
  }

  Future<Player> getPlayerById(String id) async {
    final DocumentReference<Map<String, dynamic>> collectionRef =
        FirebaseFirestore.instance.collection('Users').doc(id);
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await collectionRef.get();

    final Player player = Player.fromFirestore(documentSnapshot);
    return player;
  }

  Future<bool> addExpToPlayer(String id, int addedExp) async {
    Player player = await getPlayerById(id);
    bool isSuccess = false;
    await FirebaseFirestore.instance.collection("Users").doc(id).update(
        {"level": player.level + addedExp}).then((_) => isSuccess = true);
    return isSuccess;
  }

  Future<bool> transactionFromPlayerToPlayer(
      String fromId, String toId, int amount) async {
    Player fromPlayer = await getPlayerById(fromId);
    Player toPlayer = await getPlayerById(toId);
    if (fromPlayer.money < amount) {
      throw Exception("UserRepo: FromPlayer do not have enough money!");
    }
    bool isFromSuccess = false;
    bool isToSuccess = false;
    await FirebaseFirestore.instance.collection("Users").doc(fromId).update(
        {"money": fromPlayer.money - amount}).then((_) => isFromSuccess = true);
    await FirebaseFirestore.instance.collection("Users").doc(toId).update(
        {"money": toPlayer.money + amount}).then((_) => isToSuccess = true);
    return isFromSuccess && isToSuccess;
  }

  Future<bool> addMoneyToPlayer(String id, int amount) async {
    Player player = await getPlayerById(id);
    bool isSuccess = false;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update({"money": player.money + amount}).then((_) => isSuccess = true);

    return isSuccess;
  }

  Future<bool> drawMoneyFromPlayer(String id, int amount) async {
    Player player = await getPlayerById(id);
    bool isSuccess = false;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(id)
        .update({"money": player.money - amount}).then((_) => isSuccess = true);
    return isSuccess;
  }
}
