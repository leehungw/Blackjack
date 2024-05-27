import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginGift extends StatelessWidget {
  const LoginGift({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDay1 = true;
    bool isDay2 = false;
    bool isDay3 = false;
    bool isDay4 = false;
    bool isDay5 = false;
    bool isDay6 = false;
    bool isDay7 = false;
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
                      GestureDetector(
                        onTap: () {},
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
                                                ..style = PaintingStyle.stroke
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
                                        visible: isDay1,
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
                                        ..color = Palette.loginGiftOutLineDay,
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

                      //Day 2
                      GestureDetector(
                        onTap: () {},
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
                                                ..style = PaintingStyle.stroke
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
                                        visible: isDay2,
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
                                        ..color = Palette.loginGiftOutLineDay,
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

                      //Day 3
                      GestureDetector(
                        onTap: () {},
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
                                                ..style = PaintingStyle.stroke
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
                                        visible: isDay3,
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
                                        ..color = Palette.loginGiftOutLineDay,
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

                      //Day 4
                      GestureDetector(
                        onTap: () {},
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
                                                ..style = PaintingStyle.stroke
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
                                        visible: isDay4,
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
                                        ..color = Palette.loginGiftOutLineDay,
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
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //Day 5
                      GestureDetector(
                        onTap: () {},
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
                                                ..style = PaintingStyle.stroke
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
                                        visible: isDay5,
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
                                        ..color = Palette.loginGiftOutLineDay,
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

                      //Day 6
                      GestureDetector(
                        onTap: () {},
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
                                                ..style = PaintingStyle.stroke
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
                                        visible: isDay6,
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
                                        ..color = Palette.loginGiftOutLineDay,
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

                      //Day 7
                      GestureDetector(
                        onTap: () {},
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
                                                ..style = PaintingStyle.stroke
                                                ..strokeWidth = 1
                                                ..color =
                                                    Palette.loginGiftCheckVip,
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
                                        visible: isDay7,
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
                                        ..color = Palette.loginGiftOutLineDay,
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
