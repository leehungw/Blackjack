import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../GameObject/game_card.dart';
import '../GameObject/game_online_manager.dart';
import '../GameObject/game_player.dart';
import '../GameObject/game_player_online.dart';

class GameScreenOnline extends StatefulWidget {
  const GameScreenOnline({super.key});

  @override
  State<GameScreenOnline> createState() => _GameScreenOnlineState();
}

class _GameScreenOnlineState extends State<GameScreenOnline> {
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

  // THIS IS THE BUTTON AT THE MIDDLE OF THE SCREEN
  GestureDetector? getStartButton(){
    if (!gameManager.thisUserIsInRoom()){
      return null;
    }

    AssetImage? assetImage = const AssetImage("assets/images/game_button_start_fade.png");

    if (gameManager.thisUserIsHost()){
      if (gameManager.canStartGame()){
        assetImage = const AssetImage("assets/images/game_button_start.png");
      } else if (gameManager.canCleanTable()) {
        assetImage = const AssetImage("assets/images/game_button_clean_table.png");
      } else if (gameManager.status == RoomStatus.ready && gameManager.canStartGame() == false){
        assetImage = const AssetImage("assets/images/game_button_start_fade.png");
      } else {
        return null;
      }
    }
    else {
      if (gameManager.playerCanReady()){
        assetImage = const AssetImage("assets/images/game_button_ready.png");
      } else if (gameManager.playerCanCancelReady()){
        assetImage = const AssetImage("assets/images/game_button_cancel_ready.png");
      } else {
        return null;
      }
    }

    return GestureDetector(
      onTap: () async => {
        if (gameManager.thisUserIsHost()){
          if (gameManager.canStartGame()){
            await gameManager.startOnlineGame()
          } else if (gameManager.canCleanTable()){
            await gameManager.cleanTable()
          }
        } else {
          if (gameManager.playerCanReady()){
            gameManager.reqReady()
          } else if (gameManager.playerCanCancelReady()){
            gameManager.reqCancelReady()
          }
        }
      },
      child: Container(
        width: 116,
        height: 36,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: assetImage,
            fit: BoxFit.fill,
          ),
        ),
        child: null
      ),
    );
  }

  // THIS IS THE LEFT ACTION BUTTON (DRAW CARD)
  Align getLeftButton() {
    return Align(
      alignment: Alignment.center,
      child:  GestureDetector(
          onTap: () async => {
            if (gameManager.playerCanDraw()){
              await gameManager.reqDrawCard()
            }
          },
          child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: gameManager.playerCanDraw() ?
              AssetImage("assets/images/game_button_draw.png")
                  : AssetImage("assets/images/game_button_draw_fade.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: null
      )
        )
    );
  }

  // THIS IS THE RIGHT ACTION BUTTON (STOP / EXECUTE ALL)
  Align getRightButton() {
    if (gameManager.thisUserIsHost()){
      return Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () async => {
            if (gameManager.dealerCanExecuteAllPlayer()){
              await gameManager.dealerExecuteAll()
            }
          },
          child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: gameManager.dealerCanExecuteAllPlayer()
                      ? AssetImage("assets/images/game_button_execute_all.png")
                      : AssetImage("assets/images/game_button_execute_all_fade.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: null
          )
        )
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () async => {
            if (gameManager.playerCanEndTurn()){
              await gameManager.reqStand()
            }
          },
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: gameManager.playerCanEndTurn()
                    ? AssetImage("assets/images/game_button_stop.png")
                    : AssetImage("assets/images/game_button_stop_fade.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: null
          )
        )
      );
    }
  }

  // MAIN PLAYER CARDS
  List<Container> createThisPlayerCards(){
    if (gameManager.thisPlayer == null){
      return [];
    }
    GamePlayerOnline player = gameManager.thisPlayer!;

    List<Container> playerCards = [];
    for (GameCard card in player.cards) {
      playerCards.add(
        Container(
          width: 20,
          height: 75,
          alignment: Alignment.center,
          child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: card.getImage(60, 75)
          ),
      ));
    }
    return playerCards;
  }


  // =================================================================
  // BUILD FUNCTION
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
                        color: gameManager.dealerCanExecuteAllPlayer()
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
                  colors: const [Color(0xFFFF6D6D), Color(0xFF8A88FE)],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // TOP BAR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0, left: 10.0),
                          child:
                            Text("Phòng ${gameManager.model == null ? "???" : gameManager.model?.roomID}",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontFamily: "Montserrat"),
                                textAlign: TextAlign.center
                            ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20.0, right: 10.0),
                          child:
                            IconButton(
                              icon: Image.asset('assets/images/game_button_exit_room.png'),
                              iconSize: 50,
                              onPressed: () {},
                            )
                        )
                      ],
                    ),

                    // TABLE
                    Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 150,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/images/game_table.png"),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      child: Row(
                        // first columns
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left column
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(width: 10, height: 60),
                              PlayerCard(seat: 2),
                              PlayerCard(seat: 1),
                              SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: OverflowBox(
                                    maxHeight: double.infinity,
                                    maxWidth: double.infinity,
                                    alignment: Alignment.bottomLeft,
                                    child: getLeftButton(),
                                  )
                              )
                            ],
                          ),
                          // Center column
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              PlayerCard(seat: 3),
                              const SizedBox(width: 10, height: 10),
                              Container(
                                margin: const EdgeInsets.only(bottom: 40.0),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage("assets/images/cards/card_back.png"),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: OverflowBox(
                                    maxWidth: double.infinity,
                                    maxHeight: double.infinity,
                                    child: getStartButton()
                                  ),
                                ),
                              ),
                              const SizedBox(width: 40, height: 40),
                              Container(
                                margin: const EdgeInsets.only(bottom: 0.0),
                                width: 80,
                                height: 80,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: OverflowBox(
                                      maxWidth: double.infinity,
                                      maxHeight: double.infinity,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: createThisPlayerCards(),
                                      )
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Right column
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(width: 10, height: 60),
                              PlayerCard(seat: 4),
                              PlayerCard(seat: 5),
                              Container(
                                  width: 60,
                                  height: 60,
                                  child: OverflowBox(
                                    maxHeight: double.infinity,
                                    maxWidth: double.infinity,
                                    alignment: Alignment.bottomRight,
                                    child: getRightButton(),
                                  )
                              )

                            ],
                          ),

                        ],
                      ),
                    ),


                    // BOTTOM BAR
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: const [Color(0xFF262C40), Color(0xFF464C60)],
                          ),
                        ),
                    )
                  ],
                ),
              ),
            ),
          )
        );
      }),
    );
  }
}

class PlayerCard extends StatefulWidget {
  final int seat;
  const PlayerCard({super.key, required this.seat});

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // CREATE PLAYER CARDS ON HAND
  List<Container> createPlayerCards(){
    GameOnlineManager gameManager = GameOnlineManager.instance;
    GamePlayerOnline? player = gameManager.getPlayerBySeatOffset(widget.seat);
    if (player == null){
      return [];
    }

    List<Container> playerCards = [];
    for (GameCard card in player.cards) {
      playerCards.add(Container(
        width: 20,
        height: 50,
        alignment: Alignment.center,
        child: OverflowBox(
          maxWidth: double.infinity,
          maxHeight: double.infinity,
          child: card.getImage(40, 50),
        ),
      ));
    }
    return playerCards;
  }

  // CREATE THE EXECUTE BUTTON / RESULT
  Align? getBottomWidget() {
    GameOnlineManager gameManager = GameOnlineManager.instance;
    GamePlayerOnline? player = gameManager.getPlayerBySeatOffset(widget.seat);

    if (player == null){
      return null;
    }

    if (player.state == PlayerState.ready){
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            "Sẵn sàng",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"
            ),
            colors: const [
              Color(0xFF95ff80),
              Color(0xFF40ff1a),
            ],
          ),
        ),
      );
    }

    String specialResult = "";
    switch (player.checkBlackjack()){
      case PlayerCardState.ban_ban:
        specialResult = "Xì bàn";
        break;
      case PlayerCardState.ban_luck:
        specialResult = "Xì lát";
        break;
      case PlayerCardState.dragon:
        specialResult = "Ngũ linh";
        break;
      default:
        break;
    }

    if (player.result == PlayerResult.win){
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            specialResult != "" ?
              specialResult
              : "${player.getTotalValues()} điểm",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"
            ),
            colors: const [
              Color(0xFFFFA800),
              Color(0xFFFDFFE0),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.tie){
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            specialResult != "" ?
            specialResult
                : "${player.getTotalValues()} điểm",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"
            ),
            colors: const [
              Color(0xFFB9E0F8),
              Color(0xFF8BCCF4),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.lose){
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            player.isBurn() ?
              "Quắc"
              : ( specialResult != "" ?
                  specialResult
                : "${player.getTotalValues()} điểm"),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"
            ),
            colors: const [
              Color(0xFFF1F1F1),
              Color(0xFFB1B1B1),
            ],
          ),
        ),
      );
    }

    // Execute button
    if (gameManager.dealerCanExecutePlayer(player)){
        return Align(
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () async => {
                if (gameManager.dealerCanExecutePlayer(player)){
                  await gameManager.dealerExecutePlayer(player.seat)
                }
              },
              child: Container(
                width: 86,
                height: 28,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/game_button_execute.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: null
              )
            )
        );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 5.0),
            width: 120,
            height: 50,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage("assets/images/game_player_background.png"),
                fit: BoxFit.fill,
              ),
            ),
            child: null /* add child content here */,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: createPlayerCards(),
          ),

          Container(
              width: 60,
              height: 30,
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                alignment: Alignment.bottomCenter,
                child: getBottomWidget(),
              )
          )
        ],
      )
    );
  }
}