import 'package:cloud_firestore/cloud_firestore.dart';

class Players {
  String yourName;
  String userName;
  String email;
  String avatar;
  int level;
  int money;
  DateTime startDate;
  int duration;

  Players({
    required this.yourName,
    required this.userName,
    required this.email,
    required this.avatar,
    this.level = 0,
    this.money = 10000,
    required this.startDate,
    this.duration = 0,
  });

  // Phương thức để chuyển đổi dữ liệu thành một Map để lưu trữ trên Firestore
  Map<String, dynamic> toMap() {
    return {
      'yourName': yourName,
      'userName': userName,
      'email': email,
      'avatar': avatar,
      'level': level,
      'money': money,
      'startDate': Timestamp.fromDate(startDate),
      'duration': duration,
    };
  }

  // Phương thức tạo một đối tượng User từ một tài liệu Firestore
  factory Players.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Players(
      yourName: data['yourName'] as String,
      userName: data['userName'] as String,
      email: data['email'] as String,
      avatar: data['avatar'] as String,
      level: data['level'] as int ?? 0,
      money: data['money'] as int ?? 10000,
      startDate: (data['startDate'] as Timestamp).toDate(),
      duration: data['duration'] as int ?? 0,
    );
  }
}

// Để lưu trữ thông tin người dùng lên Firestore
void addUserToFirestore(Players user) async {
  try {
    Map<String, dynamic> userData = user.toMap();
    print('UserData: $userData'); // In ra dữ liệu để kiểm tra
    DocumentReference docRef =
        await FirebaseFirestore.instance.collection('users').add(userData);
    print('User added to Firestore with ID: ${docRef.id}');
  } catch (e) {
    print('Error adding user to Firestore: $e');
  }
}
