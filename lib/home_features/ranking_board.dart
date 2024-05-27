import 'dart:math';
import 'package:card/main.dart';
import 'package:card/models/user.dart';
import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_small.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_text/stroke_text.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({super.key});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen>
    with SingleTickerProviderStateMixin {
  final PlayerRepo _playerRepo = PlayerRepo();
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);
    _tabController?.addListener(tabSelectionChanged);
    super.initState();
  }

  void tabSelectionChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController?.removeListener(tabSelectionChanged);
    _tabController?.dispose();
    super.dispose();
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
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Palette.homeDialogBackgroundGradientBottom,
                      Palette.homeDialogBackgroundGradientTop
                    ],
                  ),
                ),
                child: FutureBuilder(
                    future: Future.wait([
                      _playerRepo.getAllPlayers(),
                      _playerRepo
                          .getPlayerById(FirebaseAuth.instance.currentUser!.uid)
                    ]),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        List<Player> coinPlayers =
                            snapshot.data[0] as List<Player>;
                        Player currentPlayer = snapshot.data[1] as Player;
                        coinPlayers.sort((player1, player2) =>
                            player2.money.compareTo(player1.money));
                        int currentPlayerRankCoin =
                            coinPlayers.indexOf(currentPlayer);

                        List<Player> levelPlayers = List.from(coinPlayers);
                        levelPlayers.sort((player1, player2) =>
                            player2.level.compareTo(player1.level));
                        int currentPlayerRankLevel =
                            levelPlayers.indexOf(currentPlayer);

                        return SingleChildScrollView(
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            const Gap(30),
                            Text(
                              "Bảng Xếp Hạng",
                              style: TextStyles.screenTitle
                                  .copyWith(color: Palette.black),
                            ),
                            const Gap(50),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: TabBar(
                                  controller: _tabController,
                                  indicator: UnderlineTabIndicator(
                                      borderSide: BorderSide.none),
                                  dividerHeight: 2,
                                  dividerColor: Colors.white,
                                  tabs: [
                                    Tab(
                                      child: StrokeText(
                                        text: 'Coin',
                                        textStyle: TextStyles.bigButtonText,
                                        textColor: Colors.white,
                                        strokeColor: Palette.coinGrind,
                                        strokeWidth:
                                            _tabController?.index == 0 ? 5 : 0,
                                      ),
                                    ),
                                    Tab(
                                      child: StrokeText(
                                        text: 'Level',
                                        textStyle: TextStyles.bigButtonText,
                                        textColor: Colors.white,
                                        strokeColor: Palette
                                            .settingTextButtonGradientLeft,
                                        strokeWidth:
                                            _tabController?.index == 1 ? 5 : 0,
                                      ),
                                    ),
                                  ]),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: SizedBox(
                                  //Add this to give height
                                  height:
                                      MediaQuery.of(context).size.height - 400,
                                  child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        Column(
                                          children: [
                                            const Gap(30),
                                            ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: coinPlayers.length,
                                              itemBuilder: (context, index) {
                                                Player player =
                                                    coinPlayers[index];
                                                if (index == 0) {
                                                  return _rankingItem(
                                                      player, index, true);
                                                } else {
                                                  return _rankingItem(
                                                      player, index, true);
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Gap(30),
                                            ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              itemCount: levelPlayers.length,
                                              itemBuilder: (context, index) {
                                                Player player =
                                                    levelPlayers[index];
                                                if (index == 0) {
                                                  return _rankingItem(
                                                      player, index, false);
                                                } else {
                                                  return _rankingItem(
                                                      player, index, false);
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ])),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Column(children: [
                                Container(
                                  color: Colors.white,
                                  height: 2,
                                ),
                                const Gap(10),
                                _rankingItem(
                                    currentPlayer,
                                    _tabController?.index == 0
                                        ? currentPlayerRankCoin
                                        : currentPlayerRankLevel,
                                    _tabController?.index == 0 ? true : false),
                              ]),
                            ),
                            const Gap(40),
                            CustomElevatedButtonSmall(
                              width: 150,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: const [
                                  Palette
                                      .settingDialogButtonBackgroundGradientBottom,
                                  Palette
                                      .settingDialogButtonBackgroundGradientTop
                                ],
                              ),
                              onPressed: () {
                                context.pop();
                              },
                              text: "Thoát",
                            ),
                          ]),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
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

  Widget _rankingItem(Player player, int index, bool isCoinRanking) {
    const double constXExp = 0.05;
    String rankInfo = "";
    if (isCoinRanking) {
      rankInfo = player.money < 1000
          ? player.money.toString()
          : player.money < 1000000
              ? "${(player.money / 1000 * 1.0).toStringAsFixed(1)}K"
              : player.money < 1000000000
                  ? "${(player.money / 1000000 * 1.0).toStringAsFixed(1)}M"
                  : "${(player.money / 1000000000 * 1.0).toStringAsFixed(1)}B";
    } else {
      rankInfo = "Lv.${(constXExp * sqrt(player.level)).floor()}";
    }
    return Row(
      children: [
        const Gap(5),
        StrokeText(
          text: "${index + 1}.",
          textColor: Colors.white,
          textStyle: TextStyles.instructions.copyWith(color: Colors.white),
          strokeColor: index == 0
              ? Palette.coinGrind
              : index == 1
                  ? Palette.ranking2nd
                  : Palette.accountBackgroundGradientBottom,
          strokeWidth: (index >= 0 && index < 3) ? 4 : 0,
        ),
        const Gap(10),
        SizedBox(
          width: 200,
          child: StrokeText(
            text: player.userName,
            textColor: Colors.white,
            textStyle: TextStyles.instructions.copyWith(color: Colors.white),
            strokeColor: index == 0
                ? Palette.coinGrind
                : index == 1
                    ? Palette.ranking2nd
                    : Palette.accountBackgroundGradientBottom,
            strokeWidth: index >= 0 && index < 3 ? 4 : 0,
          ),
        ),
        const Gap(10),
        Text(
          rankInfo,
          style: TextStyles.instructions.copyWith(
              color: isCoinRanking
                  ? Palette.titleTextGradientTop
                  : Palette.settingTextButtonGradientLeft),
        ),
      ],
    );
  }
}
