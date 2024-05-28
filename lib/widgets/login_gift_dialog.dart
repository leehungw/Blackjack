import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginGift extends StatefulWidget {
  const LoginGift({super.key});

  @override
  State<LoginGift> createState() => _LoginGiftState();
}

class _LoginGiftState extends State<LoginGift> {
  int _duration = 0;
  DateTime? _startDay;
  List<bool> _giftReceived = List.filled(7, false);
  DateTime _currentDate = DateTime.now();
  int distinct = 0;
  late String userID;

  @override
  void initState() {
    super.initState();
    _loadFromSharedPreferences();
  }

  _loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    userID = prefs.getString('userID') ?? '';
    print('User ID: $userID');
    int duration = prefs.getInt('duration') ?? 0;
    String? startDayString = prefs.getString('startDate');
    DateTime? startDay =
        startDayString != null ? DateTime.parse(startDayString) : null;
    //kiem tra
    print('Start Day: $startDay');
    int daysPassed = _currentDate.difference(startDay!).inDays;
    if (startDay != null) {
      if (daysPassed != duration && daysPassed != (duration - 1)) {
        print('Loi 1 day ne anh Tuong a');
        print('Duration loi 1: $duration');
        print('Days Passed loi 1: $daysPassed');
        duration = 0;
        startDay = _currentDate;
      }
      if (duration == 7 && startDay != _currentDate) {
        print('Loi 2 day ne anh Tuong a');
        duration = 0;
        startDay = _currentDate;
      }
    }

    setState(() {
      _duration = duration;
      _startDay = startDay ?? _startDay;
      distinct = daysPassed;
    });
    print('Duration: $_duration');
    print('Start Day: $_startDay');
    print('Distinct: $distinct');
  }

  _updateDatabase() async {
    await FirebaseFirestore.instance.collection('Users').doc(userID).update({
      'duration': _duration,
      'startDate': _startDay!,
    });
    await _updateSharedPreferences();
  }

  _updateSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    print('tesst ne');
    print('Duration: $_duration');
    await prefs.setInt('duration', _duration);
    print('Start Day: $_startDay');
    print('Start Day String: ${_startDay!.toString()}');
    await prefs.setString('startDate', _startDay!.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 340,
        width: 300,
        child: Stack(
          children: [
            Container(
              margin: EdgeInsets.only(top: 48),
              height: 340,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Palette.homeDialogBackgroundGradientBottom,
                    Palette.homeDialogBackgroundGradientTop,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0, 0),
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            Image.asset('assets/images/diemDanh.png'),
            Container(
              height: 65,
              alignment: Alignment.center,
              child: Text(
                'LOGIN GIFT',
                style: TextStyles.dialogText.copyWith(
                  color: Palette.loginGiftLabel,
                  fontWeight: FontWeight.w900,
                  fontSize: 22,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 48),
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
              height: 340,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Day 1
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duration = 1;
                              });
                              _updateDatabase();
                            },
                            child: Container(
                              height: 75,
                              width: 60,
                              padding: EdgeInsets.only(
                                  top: 7, left: 7, right: 7, bottom: 3),
                              decoration: BoxDecoration(
                                color: Palette.textFieldBackgroundGradientTop,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Palette.loginGiftButtonGradientTop,
                                          Palette.loginGiftButtonGradientBottom,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/500k.png',
                                            width: 36,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Text(
                                                "X1",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Palette
                                                        .loginGiftOutLineMoney,
                                                ),
                                              ),
                                              Text(
                                                "X1",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: Palette.loginGiftCheck,
                                              size: 38,
                                            ),
                                            visible: 1 <= _duration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Text(
                                        "Day 1",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: -5,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color =
                                                Palette.loginGiftOutLineDay,
                                        ),
                                      ),
                                      Text(
                                        "Day 1",
                                        style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: -5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: 1 <= _duration || 1 > distinct + 1,
                            child: Container(
                              width: 60,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Day 2
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duration = 2;
                              });
                              _updateDatabase();
                            },
                            child: Container(
                              height: 75,
                              width: 60,
                              padding: EdgeInsets.only(
                                  top: 7, left: 7, right: 7, bottom: 3),
                              decoration: BoxDecoration(
                                color: Palette.textFieldBackgroundGradientTop,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Palette.loginGiftButtonGradientTop,
                                          Palette.loginGiftButtonGradientBottom,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/500k.png',
                                            width: 36,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Text(
                                                "X1",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Palette
                                                        .loginGiftOutLineMoney,
                                                ),
                                              ),
                                              Text(
                                                "X1",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: Palette.loginGiftCheck,
                                              size: 38,
                                            ),
                                            visible: 2 <= _duration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Text(
                                        "Day 2",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: -5,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color =
                                                Palette.loginGiftOutLineDay,
                                        ),
                                      ),
                                      Text(
                                        "Day 2",
                                        style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: -5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: 2 <= _duration || 2 > distinct + 1,
                            child: Container(
                              width: 60,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Day 3
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duration = 3;
                              });
                              _updateDatabase();
                            },
                            child: Container(
                              height: 75,
                              width: 60,
                              padding: EdgeInsets.only(
                                  top: 7, left: 7, right: 7, bottom: 3),
                              decoration: BoxDecoration(
                                color: Palette.textFieldBackgroundGradientTop,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Palette.loginGiftButtonGradientTop,
                                          Palette.loginGiftButtonGradientBottom,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/500k.png',
                                            width: 36,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Text(
                                                "X2",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Palette
                                                        .loginGiftOutLineMoney,
                                                ),
                                              ),
                                              Text(
                                                "X2",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: Palette.loginGiftCheck,
                                              size: 38,
                                            ),
                                            visible: 3 <= _duration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Text(
                                        "Day 3",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: -5,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color =
                                                Palette.loginGiftOutLineDay,
                                        ),
                                      ),
                                      Text(
                                        "Day 3",
                                        style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: -5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: 3 <= _duration || 3 > distinct + 1,
                            child: Container(
                              width: 60,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Day 4
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duration = 4;
                              });
                              _updateDatabase();
                            },
                            child: Container(
                              height: 75,
                              width: 60,
                              padding: EdgeInsets.only(
                                  top: 7, left: 7, right: 7, bottom: 3),
                              decoration: BoxDecoration(
                                color: Palette.textFieldBackgroundGradientTop,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Palette.loginGiftButtonGradientTop,
                                          Palette.loginGiftButtonGradientBottom,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/500k.png',
                                            width: 36,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Text(
                                                "X3",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Palette
                                                        .loginGiftOutLineMoney,
                                                ),
                                              ),
                                              Text(
                                                "X3",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: Palette.loginGiftCheck,
                                              size: 38,
                                            ),
                                            visible: 4 <= _duration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Text(
                                        "Day 4",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: -5,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color =
                                                Palette.loginGiftOutLineDay,
                                        ),
                                      ),
                                      Text(
                                        "Day 4",
                                        style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: -5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: 4 <= _duration || 4 > distinct + 1,
                            child: Container(
                              width: 60,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Day 5
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duration = 5;
                              });
                              _updateDatabase();
                            },
                            child: Container(
                              height: 75,
                              width: 60,
                              padding: EdgeInsets.only(
                                  top: 7, left: 7, right: 7, bottom: 3),
                              decoration: BoxDecoration(
                                color: Palette.textFieldBackgroundGradientTop,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Palette.loginGiftButtonGradientTop,
                                          Palette.loginGiftButtonGradientBottom,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/500k.png',
                                            width: 36,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Text(
                                                "X4",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Palette
                                                        .loginGiftOutLineMoney,
                                                ),
                                              ),
                                              Text(
                                                "X4",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: Palette.loginGiftCheck,
                                              size: 38,
                                            ),
                                            visible: 5 <= _duration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Text(
                                        "Day 5",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: -5,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color =
                                                Palette.loginGiftOutLineDay,
                                        ),
                                      ),
                                      Text(
                                        "Day 5",
                                        style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: -5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: 5 <= _duration || 5 > distinct + 1,
                            child: Container(
                              width: 60,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Day 6
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duration = 6;
                              });
                              _updateDatabase();
                            },
                            child: Container(
                              height: 75,
                              width: 60,
                              padding: EdgeInsets.only(
                                  top: 7, left: 7, right: 7, bottom: 3),
                              decoration: BoxDecoration(
                                color: Palette.textFieldBackgroundGradientTop,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Palette.loginGiftButtonGradientTop,
                                          Palette.loginGiftButtonGradientBottom,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/500k.png',
                                            width: 36,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          width: 45,
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Text(
                                                "X5",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Palette
                                                        .loginGiftOutLineMoney,
                                                ),
                                              ),
                                              Text(
                                                "X5",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: Palette.loginGiftCheck,
                                              size: 38,
                                            ),
                                            visible: 6 <= _duration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Text(
                                        "Day 6",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: -5,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color =
                                                Palette.loginGiftOutLineDay,
                                        ),
                                      ),
                                      Text(
                                        "Day 6",
                                        style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: -5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: 6 <= _duration || 6 > distinct + 1,
                            child: Container(
                              width: 60,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Day 7
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _duration = 7;
                                _startDay = _currentDate;
                              });
                              _updateDatabase();
                            },
                            child: Container(
                              height: 75,
                              width: 130,
                              padding: EdgeInsets.only(
                                  top: 7, left: 10, right: 10, bottom: 3),
                              decoration: BoxDecoration(
                                color: Palette.textFieldBackgroundGradientTop,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    height: 45,
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Palette.loginGiftButtonGradientTop,
                                          Palette.loginGiftButtonGradientBottom,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          offset: Offset(0, 4),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        Center(
                                          child: Image.asset(
                                            'assets/images/500k.png',
                                            width: 60,
                                          ),
                                        ),
                                        Container(
                                          height: 45,
                                          padding: EdgeInsets.only(top: 15),
                                          alignment: Alignment.center,
                                          child: Stack(
                                            children: [
                                              Text(
                                                "X10",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 1
                                                    ..color = Palette
                                                        .loginGiftCheckVip,
                                                ),
                                              ),
                                              Text(
                                                "X10",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: Visibility(
                                            child: Icon(
                                              FontAwesomeIcons.check,
                                              color: Palette.loginGiftCheck,
                                              size: 38,
                                            ),
                                            visible: 7 <= _duration,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      Text(
                                        "Day 7",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          wordSpacing: -5,
                                          foreground: Paint()
                                            ..style = PaintingStyle.stroke
                                            ..strokeWidth = 1
                                            ..color =
                                                Palette.loginGiftOutLineDay,
                                        ),
                                      ),
                                      Text(
                                        "Day 7",
                                        style: TextStyle(
                                          fontSize: 16,
                                          wordSpacing: -5,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Visibility(
                            visible: 7 <= _duration || 7 > distinct + 1,
                            child: Container(
                              width: 130,
                              height: 75,
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
