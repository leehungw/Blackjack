import 'package:card/GameObject/game_offline_manager.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../GameObject/card.dart';
import '../GameObject/game_player.dart';

class DemoScreen extends StatefulWidget {
  const DemoScreen({super.key});

  @override
  State<DemoScreen> createState() => _DemoScreenState();
}

class _DemoScreenState extends State<DemoScreen> {

  GameOfflineManager gameManager = GameOfflineManager.instance;
  List<Card> playerSeats = [];

  Future<void> _startGame() async {
    gameManager.newOfflineGame();
    gameManager.startOfflineGame();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      this._startGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    playerSeats.clear();

    for (int i = 0; i < gameManager.players.length; i++){
      GamePlayer player = gameManager.players[i];
      // Get player Cards
      List<Container> playerCards = [];
      for (GameCard card in player.cards){
        playerCards.add(Container(
          width: 40,
          height: 50,
          child: card.getImage(40, 50),
        ));
      }

      // Create seat
      Card playerSeat = Card(
        color: player.result == PlayerResult.dealer ? Colors.blueAccent :
                (player.result == PlayerResult.win ? Colors.greenAccent :
                  (player.result == PlayerResult.lose ? Colors.black26 :
                    (player.result == PlayerResult.tie ? Colors.yellow :
                      Colors.deepPurpleAccent.shade200
                    )
                  )
                ),
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
                        color: gameManager.dealerCanExecutePlayer() ? Colors.deepOrange : Colors.black45,
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
                  onTap: () {
                    if (gameManager.currentPlayer!.isDealer()){
                      gameManager.dealerExecutePlayer(i);
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
                color: gameManager.players[i].state == PlayerState.onTurn ? Colors.green :
                        (gameManager.players[i].state == PlayerState.wait ? Colors.red : Colors.black)
                      ,
                // image: DecorationImage(
                //     image: AssetImage(
                //         "assets/images/button_background_inactive.png"),
                //     fit: BoxFit.fill),
              ),
              child: Text(
                "Người chơi " + player.seat.toString(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                    fontFamily: "Montserrat"),
                textAlign: TextAlign.center
              ),
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
                                  color: gameManager.playerCanDraw() ? Colors.indigo : Colors.black45,
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
                            onTap: () {
                              bool test = gameManager.playerCanDraw();
                              if (gameManager.playerCanDraw()){
                                gameManager.playerDrawCard();
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
                                  color: gameManager.playerCanEndTurn() ? Colors.teal : Colors.black45,
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
                            onTap: () {
                              if (gameManager.playerCanEndTurn()){
                                gameManager.playerEndTurn();
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
