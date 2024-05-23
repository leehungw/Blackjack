import 'dart:async';

import 'package:card/GameObject/game_player_online.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../GameObject/game_card.dart';
import '../GameObject/game_online_manager.dart';
import '../GameObject/game_player.dart';

class DemoScreenOnline extends StatefulWidget {
  const DemoScreenOnline({super.key});

  @override
  State<DemoScreenOnline> createState() => _DemoScreenOnlineState();
}

class _DemoScreenOnlineState extends State<DemoScreenOnline> {
  // ====================================
  int roomID = 0;
  int userID = 21520889;
  // ====================================

  GameOnlineManager gameManager = GameOnlineManager.instance;
  List<Card> playerSeats = [];
  final _userIDController = TextEditingController();
  final _roomIDController = TextEditingController();

  StreamSubscription? _gameLocalSubscription;

  Future<void> _startGame() async {
    // Join room dialog
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Join room"),
              content: Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "User ID"),
                    controller: _userIDController,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(hintText: "Room ID"),
                    controller: _roomIDController,
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      userID = int.parse(_userIDController.text);
                      roomID = int.parse(_roomIDController.text);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Find room"))
              ],
            ));

    await gameManager.initialize(userID, roomID);
    _gameLocalSubscription = gameManager.allChanges.listen((event) {
      setState(() {});
    });
    setState(() {});
  }

  // Future<void> _update() async {
  //   await gameManager.onlineGameUpdate();
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      _startGame();
      // timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => _update());
    });
  }

  @override
  void dispose() {
    _gameLocalSubscription?.cancel();
    gameManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    playerSeats.clear();

    for (int i = 0; i < gameManager.players.length; i++) {
      GamePlayerOnline player = gameManager.players[i];
      // Get player Cards
      List<Container> playerCards = [];
      for (GameCard card in player.cards) {
        playerCards.add(Container(
          width: 40,
          height: 50,
          child: card.getImage(40, 50),
        ));
      }

      // Create seat
      Card playerSeat = Card(
        color: player.result == PlayerResult.dealer
            ? Colors.blueAccent
            : (player.result == PlayerResult.win
                ? Colors.greenAccent
                : (player.result == PlayerResult.lose
                    ? Colors.black26
                    : (player.result == PlayerResult.tie
                        ? Colors.yellow
                        : Colors.deepPurpleAccent.shade200))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: GestureDetector(
                  child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: gameManager.dealerCanExecutePlayer(player)
                            ? Colors.deepOrange
                            : Colors.black45,
                        // image: DecorationImage(
                        //     image: AssetImage(
                        //         "assets/images/button_background_inactive.png"),
                        //     fit: BoxFit.fill),
                      ),
                      child: Center(
                        child: Text(
                          "Xét",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                              fontFamily: "Montserrat"),
                        ),
                      )),
                  onTap: () async {
                    if (gameManager.dealerCanExecutePlayer(player)) {
                      await gameManager.dealerExecutePlayer(i);
                      setState(() {});
                    }
                  }),
            ),
            Gap(5),
            Container(
              width: 100,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(13),
                color: gameManager.players[i].state == PlayerState.onTurn
                    ? Colors.green
                    : (gameManager.players[i].state == PlayerState.wait
                        ? Colors.red
                        : Colors.black),
                // image: DecorationImage(
                //     image: AssetImage(
                //         "assets/images/button_background_inactive.png"),
                //     fit: BoxFit.fill),
              ),
              child: Text("Người chơi ${player.seat}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                      fontFamily: "Montserrat"),
                  textAlign: TextAlign.center),
            ),
            Gap(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: playerCards,
            )
          ],
        ),
      );

      playerSeats.add(playerSeat);
    }

    return SafeArea(
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            reverse: true,
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [Color(0xFFDD4444), Color(0xFF5F1313)],
                ),
              ),
              child: Center(
                child: Column(children: [
                  // ROOM
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Button Start Game
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            child: Container(
                                width: 120,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: gameManager.canStartGame()
                                      ? Colors.indigo
                                      : Colors.black45,
                                  // image: DecorationImage(
                                  //     image: AssetImage(
                                  //         "assets/images/button_background_inactive.png"),
                                  //     fit: BoxFit.fill),
                                ),
                                child: Center(
                                  child: Text(
                                    "Bắt đầu",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                  ),
                                )),
                            onTap: () async {
                              if (gameManager.canStartGame()) {
                                await gameManager.startOnlineGame();
                                setState(() {});
                              }
                            }),
                      ),

                      Gap(10),
                      // Button ready
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            child: Container(
                                width: 120,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: gameManager.playerCanReady()
                                      ? Colors.teal
                                      : (gameManager.playerCanCancelReady()
                                          ? Colors.redAccent
                                          : Colors.black45),
                                  // image: DecorationImage(
                                  //     image: AssetImage(
                                  //         "assets/images/button_background_inactive.png"),
                                  //     fit: BoxFit.fill),
                                ),
                                child: Center(
                                  child: Text(
                                    "Sẵn sàng",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                  ),
                                )),
                            onTap: () async {
                              if (gameManager.playerCanReady()) {
                                await gameManager.reqReady();
                                setState(() {});
                              } else if (gameManager.playerCanCancelReady()) {
                                await gameManager.reqCancelReady();
                                setState(() {});
                              }
                            }),
                      ),
                      Gap(10),
                      // Button Clean Table
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            child: Container(
                                width: 120,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: gameManager.canCleanTable()
                                      ? Colors.deepPurple
                                      : Colors.black45,
                                  // image: DecorationImage(
                                  //     image: AssetImage(
                                  //         "assets/images/button_background_inactive.png"),
                                  //     fit: BoxFit.fill),
                                ),
                                child: Center(
                                  child: Text(
                                    "Dọn bàn",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                  ),
                                )),
                            onTap: () async {
                              if (gameManager.canCleanTable()) {
                                await gameManager.cleanTable();
                                setState(() {});
                              }
                            }),
                      ),
                    ],
                  ),

                  Gap(10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Button Draw card
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            child: Container(
                                width: 120,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: gameManager.playerCanDraw()
                                      ? Colors.indigo
                                      : Colors.black45,
                                  // image: DecorationImage(
                                  //     image: AssetImage(
                                  //         "assets/images/button_background_inactive.png"),
                                  //     fit: BoxFit.fill),
                                ),
                                child: Center(
                                  child: Text(
                                    "Bọt bài",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                  ),
                                )),
                            onTap: () async {
                              if (gameManager.playerCanDraw()) {
                                await gameManager.reqDrawCard();
                                setState(() {});
                              }
                            }),
                      ),

                      Gap(10),
                      // Button Stop
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: GestureDetector(
                            child: Container(
                                width: 120,
                                height: 90,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: gameManager.playerCanEndTurn()
                                      ? Colors.teal
                                      : Colors.black45,
                                  // image: DecorationImage(
                                  //     image: AssetImage(
                                  //         "assets/images/button_background_inactive.png"),
                                  //     fit: BoxFit.fill),
                                ),
                                child: Center(
                                  child: Text(
                                    "Dừng",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                  ),
                                )),
                            onTap: () async {
                              if (gameManager.playerCanEndTurn()) {
                                await gameManager.reqStand();
                                setState(() {});
                              }
                            }),
                      ),
                    ],
                  ),

                  Gap(10),
                  Column(
                    children: playerSeats,
                  )
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
