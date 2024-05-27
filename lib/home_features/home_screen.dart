import 'dart:math';

import 'package:card/main.dart';
import 'package:card/models/user.dart';
import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_big.dart';
import 'package:card/widgets/custom_icon_button.dart';
import 'package:card/widgets/start_game_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlayerRepo _playerRepo = PlayerRepo();

  static const double constXExp = 0.05;

  Future<void> signout() async {
    FirebaseAuth.instance.signOut();
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(
        builder: (context) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.transparent,
            body: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: const [
                        Palette.homeBackgroundGradientTop,
                        Palette.homeBackgroundGradientBottom
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(children: [
                      FutureBuilder(
                          future: _playerRepo.getPlayerById(
                              FirebaseAuth.instance.currentUser!.uid),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              Player player = snapshot.data as Player;

                              int level =
                                  (constXExp * sqrt(player.level)).floor();

                              int currentLevelExp =
                                  pow((level / constXExp), 2).floor();
                              int nextLevelExp =
                                  pow(((level + 1) / constXExp), 2).floor();
                              int diffExp = nextLevelExp - currentLevelExp;
                              int earnedExp = player.level - currentLevelExp;
                              double expPercentage = earnedExp / diffExp;

                              return Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                            color:
                                                Palette.titleTextGradientBottom,
                                            width: 2)),
                                    child: Row(
                                      children: [
                                        Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                    color: Palette
                                                        .titleTextGradientBottom,
                                                    width: 2)),
                                            child: Column(
                                              children: [
                                                CircleAvatar(
                                                  radius: 50,
                                                  backgroundImage:
                                                      Image.network(FirebaseAuth
                                                                  .instance
                                                                  .currentUser!
                                                                  .photoURL ??
                                                              'https://firebasestorage.googleapis.com/v0/b/lucky-card-42fae.appspot.com/o/avatar.jpg?alt=media&token=e0736d41-b937-44a6-b05e-a08e9096440f')
                                                          .image,
                                                ),
                                                Gap(10),
                                                Text(
                                                  player.userName,
                                                  style: TextStyles.defaultStyle
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                )
                                              ],
                                            )),
                                        Gap(7),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Coins: ",
                                                    style: TextStyles
                                                        .textFieldStyle
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Palette
                                                                .primaryText),
                                                  ),
                                                  TextSpan(
                                                    text:
                                                        player.money.toString(),
                                                    style: TextStyles
                                                        .textFieldStyle
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Palette
                                                                .numberText),
                                                  ),
                                                  TextSpan(
                                                      text: " VND",
                                                      style: TextStyles
                                                          .textFieldStyle
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Palette
                                                                  .black)),
                                                ],
                                              ),
                                            ),
                                            Gap(10),
                                            Row(
                                              children: [
                                                Text(
                                                  "Level: ",
                                                  style: TextStyles
                                                      .textFieldStyle
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Palette
                                                              .primaryText),
                                                ),
                                                LinearPercentIndicator(
                                                  width: 120.0,
                                                  lineHeight: 14.0,
                                                  percent: expPercentage,
                                                  barRadius:
                                                      Radius.circular(10),
                                                  backgroundColor: Palette
                                                      .buttonStartBackgroundGradientTop,
                                                  progressColor: Palette
                                                      .buttonStartBackgroundGradientBottom,
                                                ),
                                                Text(" LV.$level",
                                                    style: TextStyles
                                                        .textFieldStyle
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Palette.black))
                                              ],
                                            ),
                                            Gap(10),
                                            Row(
                                              children: [
                                                Text(
                                                  "ID:  ",
                                                  style: TextStyles
                                                      .textFieldStyle
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Palette
                                                              .primaryText),
                                                ),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    player.playerID,
                                                    style: TextStyles
                                                        .textFieldStyle
                                                        .copyWith(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Palette
                                                                .numberText),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          }),
                      Gap(30),
                      SizedBox(
                        height: 145,
                        width: 145,
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(50),
                      Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 27),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomIconButton(
                                color: Palette.black,
                                icon: Icons.settings_outlined,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: const [
                                    Palette.buttonStartBackgroundGradientTop,
                                    Palette.buttonStartBackgroundGradientBottom
                                  ],
                                ),
                                size: 40,
                                onPressed: () {
                                  GoRouter.of(context).go('/home/setting');
                                },
                                text: "Cài đặt",
                              ),
                            ),
                          ),
                          Center(
                            child: CustomElevatedButtonBig(
                              width: 150,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  Palette.buttonStartBackgroundGradientTop,
                                  Palette.buttonStartBackgroundGradientBottom
                                ],
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return StartGameDialog();
                                  },
                                );
                              },
                              text: "Bắt Đầu",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomIconButton(
                                color: Palette.titleTextGradientTop,
                                icon: FontAwesomeIcons.rankingStar,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: const [
                                    Palette.titleTextGradientTop,
                                    Palette.titleTextGradientBottom,
                                  ],
                                ),
                                size: 40,
                                onPressed: () {
                                  //TODO: Setting onpressed handle
                                },
                                text: "Xếp hạng",
                              ),
                            ),
                          )
                        ],
                      ),
                      const Gap(15),
                      Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomIconButton(
                                color: Palette.rollCallIcon,
                                icon: FontAwesomeIcons.calendar,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: const [
                                    Palette.buttonStartBackgroundGradientTop,
                                    Palette.buttonStartBackgroundGradientBottom
                                  ],
                                ),
                                size: 40,
                                onPressed: () {
                                  //TODO: rollcall onpressed handle
                                },
                                text: "Điểm danh",
                              ),
                            ),
                          ),
                          Center(
                            child: CustomElevatedButtonBig(
                              width: 150,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  Palette.textFieldBorderFocus,
                                  Palette.buttonPracticeBackgroundGradientBottom
                                ],
                              ),
                              onPressed: () async {
                                //TODO: Practice onpressed handle
                              },
                              text: "Luyện Tập",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CustomIconButton(
                                color: Palette.accountBackgroundGradientTop,
                                icon: FontAwesomeIcons.circleQuestion,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: const [
                                    Palette.titleTextGradientTop,
                                    Palette.titleTextGradientBottom,
                                  ],
                                ),
                                size: 40,
                                onPressed: () {
                                  //TODO: Instructions onpressed handle
                                },
                                text: "Hướng dẫn",
                              ),
                            ),
                          )
                        ],
                      ),
                      const Gap(15),
                      Stack(
                        fit: StackFit.passthrough,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 28),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: CustomIconButton(
                                color: Palette.coinGrind,
                                icon: Icons.money,
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: const [
                                    Palette.buttonStartBackgroundGradientTop,
                                    Palette.buttonStartBackgroundGradientBottom
                                  ],
                                ),
                                size: 40,
                                onPressed: () {
                                  //TODO: coin onpressed handle
                                },
                                text: "Tìm xu",
                              ),
                            ),
                          ),
                          Center(
                            child: CustomElevatedButtonBig(
                              width: 150,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: const [
                                  Palette.buttonExitBackgroundGradientBottom,
                                  Palette.buttonExitBackgroundGradientTop
                                ],
                              ),
                              onPressed: signout,
                              text: "Thoát",
                            ),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MyApp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
