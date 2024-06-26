import 'dart:async';

import 'package:card/widgets/deal_picker_dialog.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

import '../GameObject/game_card.dart';
import '../GameObject/game_online_manager.dart';
import '../GameObject/game_player.dart';
import '../GameObject/game_player_online.dart';
// import '../models/user.dart';

class GameScreenOnline extends StatefulWidget {
  const GameScreenOnline({super.key});

  @override
  State<GameScreenOnline> createState() => _GameScreenOnlineState();
}

class _GameScreenOnlineState extends State<GameScreenOnline> {
  // ====================================
  int roomID = 0;
  String userID = "21520889";
  static const double buttonSize = 80;
  // ====================================
  final currencyFormatter = NumberFormat('#,###', "en_US");
  bool isManagerDisposed = false;

  GameOnlineManager gameManager = GameOnlineManager.instance;
  List<Card> playerSeats = [];
  // final _userIDController = TextEditingController();
  // final _roomIDController = TextEditingController();

  StreamSubscription? _gameLocalSubscription;

  Future<void> _startGame() async {
    _gameLocalSubscription = gameManager.allChanges.listen((event) async {
      await _update();
    });
    setState(() {});
  }

  Future<void> _update() async {
    // Room is being deleting, post notice
    if (gameManager.status == RoomStatus.deleting) {
      if (!gameManager.thisUserIsHost()) {
        await gameManager.dispose();
        isManagerDisposed = true;
        if (!mounted) return;
        await _hostLeaveDialog(context);
      }
    } else if (gameManager.outOfMoneyFlag) {
      await gameManager.dispose();
      isManagerDisposed = true;
      if (!mounted) return;
      await _OutOfMoneyDialog(context);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 100), () {
      _startGame();
      // timer = Timer.periodic(Duration(milliseconds: 100), (Timer t) => _update());
    });
  }

  @override
  void dispose() async {
    _gameLocalSubscription?.cancel();

    Future.delayed(Duration(milliseconds: 100), () {
      _startGame();
      if (!isManagerDisposed) {
        gameManager.dispose();
      }
    });
    super.dispose();
  }

  // ===================================================================================
  // TODO: THIS IS THE BUTTON AT THE MIDDLE OF THE SCREEN

  GestureDetector? getStartButton() {
    if (!gameManager.thisUserIsInRoom()) {
      return null;
    }

    AssetImage? assetImage =
        const AssetImage("assets/images/game_button_start_fade.png");

    if (gameManager.thisUserIsHost()) {
      if (gameManager.canStartGame()) {
        assetImage = const AssetImage("assets/images/game_button_start.png");
      } else if (gameManager.canCleanTable()) {
        assetImage =
            const AssetImage("assets/images/game_button_clean_table.png");
      } else if (gameManager.status == RoomStatus.ready &&
          gameManager.canStartGame() == false) {
        assetImage =
            const AssetImage("assets/images/game_button_start_fade.png");
      } else {
        return null;
      }
    } else {
      if (gameManager.playerCanReady()) {
        assetImage = const AssetImage("assets/images/game_button_ready.png");
      } else if (gameManager.playerCanCancelReady()) {
        assetImage =
            const AssetImage("assets/images/game_button_cancel_ready.png");
      } else {
        return null;
      }
    }

    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () async => {
        if (gameManager.thisUserIsHost())
          {
            if (gameManager.canStartGame())
              {await gameManager.startOnlineGame()}
            else if (gameManager.canCleanTable())
              {await gameManager.cleanTable()}
          }
        else
          {
            if (gameManager.playerCanReady())
              {
                await showDialog(
                    context: context,
                    builder: (context) => DealPickerDialog(
                        thisPlayer: gameManager.thisPlayer!.userModel!))
              }
            else if (gameManager.playerCanCancelReady())
              {gameManager.reqCancelReady()}
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
          child: null),
    );
  }

  // ===================================================================================
  // TODO: THIS IS THE LEFT ACTION BUTTON (DRAW CARD)

  Align getLeftButton() {
    return Align(
        alignment: Alignment.center,
        child: GestureDetector(
            behavior: HitTestBehavior.deferToChild,
            onTap: () async => {
                  if (gameManager.playerCanDraw())
                    {await gameManager.reqDrawCard()}
                },
            child: Container(
                width: buttonSize,
                height: buttonSize,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: gameManager.playerCanDraw()
                        ? AssetImage("assets/images/game_button_draw.png")
                        : AssetImage("assets/images/game_button_draw_fade.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: null)));
  }

  // THIS IS THE RIGHT ACTION BUTTON (STOP / EXECUTE ALL)
  Align getRightButton() {
    if (gameManager.thisUserIsHost()) {
      return Align(
          alignment: Alignment.center,
          child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () async => {
                    if (gameManager.dealerCanExecuteAllPlayer())
                      {await gameManager.dealerExecuteAll()}
                  },
              child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: gameManager.dealerCanExecuteAllPlayer()
                          ? AssetImage(
                              "assets/images/game_button_execute_all.png")
                          : AssetImage(
                              "assets/images/game_button_execute_all_fade.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: null)));
    } else {
      return Align(
          alignment: Alignment.center,
          child: GestureDetector(
              behavior: HitTestBehavior.deferToChild,
              onTap: () async => {
                    if (gameManager.playerCanEndTurn())
                      {await gameManager.reqStand()}
                  },
              child: Container(
                  width: buttonSize,
                  height: buttonSize,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: gameManager.playerCanEndTurn()
                          ? AssetImage("assets/images/game_button_stop.png")
                          : AssetImage(
                              "assets/images/game_button_stop_fade.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: null)));
    }
  }

  // =================================================================
  // TODO: MAIN PLAYER CARDS

  List<Container> createThisPlayerCards() {
    if (gameManager.thisPlayer == null) {
      return [];
    }
    GamePlayerOnline player = gameManager.thisPlayer!;

    List<Container> playerCards = [];
    for (GameCard card in player.cards) {
      playerCards.add(Container(
        width: 20,
        height: 75,
        alignment: Alignment.center,
        child: OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            child: card.getImage(60, 75)),
      ));
    }
    return playerCards;
  }

  // =================================================================
  // TODO: OUT OF MONEY DIALOG

  Future<void> _OutOfMoneyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thông báo'),
        content: Text('Bạn đã bị đuổi khỏi phòng vì hết tiền!'),
        actions: [
          FilledButton(
              onPressed: () async {
                // exit
                context.pop();
                GoRouter.of(context).go("/home");
              },
              child: Text('Rời phòng'))
        ],
      ),
    );
  }

  // =================================================================
  // TODO: HOST LEAVE DIALOG

  Future<void> _hostLeaveDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thông báo'),
        content: Text('Nhà cái đã thoát khỏi phòng!'),
        actions: [
          FilledButton(
              onPressed: () async {
                // exit
                context.pop();
                GoRouter.of(context).go("/home");
              },
              child: Text('Rời phòng'))
        ],
      ),
    );
  }

  // =================================================================
  // TODO: BACK BUTTON

  final bool _canPop = false;
  void _backButton(BuildContext context) async {
    String warn = "";
    if (gameManager.status == RoomStatus.start) {
      warn = '\n(Lưu ý: Nếu phòng đã bắt đầu, bạn sẽ bị mất tiền)';
    }
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cảnh báo'),
        content: Text('Bạn có chắc muốn rời khỏi phòng không?$warn'),
        actions: [
          FilledButton(
              onPressed: () {
                context.pop();
              },
              child: Text('Hủy')),
          FilledButton(
              onPressed: () async {
                if (await gameManager.reqLeaveRoom()) {
                  if (gameManager.thisUserIsHost()) {
                    while (!gameManager.hostCanLeave) {
                      await Future.delayed(Duration(milliseconds: 50));
                    }
                  }
                  if (!context.mounted) return;
                  context.pop();
                  GoRouter.of(context).go("/home");
                }
              },
              child: Text('Đồng ý'))
        ],
      ),
    );
  }

  // =================================================================
  // TODO: PLAYER CARD POINT COUNTER
  Align? _thisPlayerScoreCounter() {
    GamePlayerOnline? player = gameManager.thisPlayer;

    if (player == null) {
      return null;
    }

    if (player.state == PlayerState.ready) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            "Sẵn sàng",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFF95ff80),
              Color(0xFF40ff1a),
            ],
          ),
        ),
      );
    }

    if (gameManager.GameIsPlaying() == false) {
      return null;
    }

    String specialResult = "";
    switch (player.checkCardState()) {
      case PlayerCardState.ban_ban:
        specialResult = "Xì bàn";
        break;
      case PlayerCardState.ban_luck:
        specialResult = "Xì lát";
        break;
      case PlayerCardState.dragon:
        specialResult = "Ngũ linh" "(${player.getTotalValues()})";
        break;
      default:
        break;
    }

    if (player.result == PlayerResult.win) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            specialResult != ""
                ? specialResult
                : "${player.getTotalValues()} điểm",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFFFA800),
              Color(0xFFFDFFE0),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.tie) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            specialResult != ""
                ? specialResult
                : "${player.getTotalValues()} điểm",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFB9E0F8),
              Color(0xFF8BCCF4),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.lose) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            player.isBurn()
                ? "Quắc"
                : (specialResult != ""
                    ? specialResult
                    : "${player.getTotalValues()} điểm"),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFF1F1F1),
              Color(0xFFB1B1B1),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.dealer ||
        player.result == PlayerResult.uncheck) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            player.isBurn()
                ? "Quắc"
                : (specialResult != ""
                    ? specialResult
                    : "${player.getTotalValues()} điểm"),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
      );
    }

    return null;
  }

  // =================================================================
  // TODO: DEAL MONEY

  SizedBox _playerDealMoney(int seatOffset) {
    GamePlayerOnline? player = gameManager.getPlayerBySeatOffset(seatOffset);
    if (player != null && player != gameManager.dealer) {
      String dealMoney = player.dealAmount > 0
          ? "${(player.dealAmount / 1000).round()},0K"
          : "0";

      return SizedBox(
        width: 60,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (player.dealAmount > 0)
              Image.asset(
                  "assets/images/game_money_${(player.dealAmount / 1000).round()}.png",
                  width: 50,
                  height: 25)
            else
              SizedBox(width: 60, height: 25),
            Gap(7),
            Container(
                width: 60,
                height: 18,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image:
                        AssetImage("assets/images/game_deal_amount_back.png"),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Center(
                    child: Text(
                  dealMoney,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: "Montserrat",
                      color: Colors.amber),
                  textAlign: TextAlign.center,
                )))
          ],
        ),
      );
    }
    return SizedBox(width: 60, height: 160);
  }

  // =================================================================
  // TODO: BUILD FUNCTION

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        return PopScope(
          canPop: _canPop,
          onPopInvoked: (didPop) {
            if (_canPop) return;
            _backButton(context);
            // WidgetsBinding.instance.addPostFrameCallback(
            //         (_) async {
            //       _backButton(context);
            //     }
            // );
          },
          child: Scaffold(
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
                              margin:
                                  const EdgeInsets.only(top: 20.0, left: 10.0),
                              child: Text(
                                  "Phòng ${gameManager.model == null ? "???" : gameManager.model?.roomID}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontFamily: "Montserrat"),
                                  textAlign: TextAlign.center),
                            ),
                            Container(
                                margin: const EdgeInsets.only(
                                    top: 20.0, right: 10.0),
                                child: IconButton(
                                  icon: Image.asset(
                                      'assets/images/game_button_exit_room.png'),
                                  iconSize: 50,
                                  onPressed: () {
                                    _backButton(context);
                                  },
                                ))
                          ],
                        ),

                        // TODO: TABLE
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 10, height: 60),
                                  SizedBox(
                                    width: 120,
                                    height: 160,
                                    child: OverflowBox(
                                        maxHeight: double.infinity,
                                        maxWidth: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            PlayerCard(seat: 2),
                                            _playerDealMoney(2)
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    height: 160,
                                    child: OverflowBox(
                                        maxHeight: double.infinity,
                                        maxWidth: double.infinity,
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            PlayerCard(seat: 1),
                                            _playerDealMoney(1)
                                          ],
                                        )),
                                  ),
                                  DeferredPointerHandler(
                                      child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: OverflowBox(
                                            maxHeight: double.infinity,
                                            maxWidth: double.infinity,
                                            alignment: Alignment.bottomLeft,
                                            child: DeferPointer(
                                                child: getLeftButton()),
                                          ))),
                                ],
                              ),
                              // Center column
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    height: 160,
                                    child: OverflowBox(
                                        maxHeight: double.infinity,
                                        maxWidth: double.infinity,
                                        alignment: Alignment.topCenter,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            PlayerCard(seat: 3),
                                            _playerDealMoney(3)
                                          ],
                                        )),
                                  ),
                                  const SizedBox(width: 10, height: 10),
                                  DeferredPointerHandler(
                                    child: Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 40.0),
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/cards/card_back.png"),
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                        child: DeferPointer(
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: OverflowBox(
                                                maxWidth: double.infinity,
                                                maxHeight: double.infinity,
                                                child: getStartButton()),
                                          ),
                                        )),
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
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 120,
                                                height: 50,
                                                child: OverflowBox(
                                                  maxWidth: double.infinity,
                                                  maxHeight: double.infinity,
                                                  child:
                                                      _thisPlayerScoreCounter(),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children:
                                                    createThisPlayerCards(),
                                              )
                                            ],
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                              // Right column
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  const SizedBox(width: 10, height: 60),
                                  SizedBox(
                                    width: 120,
                                    height: 160,
                                    child: OverflowBox(
                                        maxHeight: double.infinity,
                                        maxWidth: double.infinity,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _playerDealMoney(4),
                                            PlayerCard(seat: 4)
                                          ],
                                        )),
                                  ),
                                  SizedBox(
                                    width: 120,
                                    height: 160,
                                    child: OverflowBox(
                                        maxHeight: double.infinity,
                                        maxWidth: double.infinity,
                                        alignment: Alignment.centerRight,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            _playerDealMoney(5),
                                            PlayerCard(seat: 5)
                                          ],
                                        )),
                                  ),
                                  DeferredPointerHandler(
                                      child: SizedBox(
                                          width: 60,
                                          height: 60,
                                          child: OverflowBox(
                                              maxHeight: double.infinity,
                                              maxWidth: double.infinity,
                                              alignment: Alignment.bottomRight,
                                              child: DeferPointer(
                                                child: getRightButton(),
                                              ))))
                                ],
                              ),
                            ],
                          ),
                        ),

                        // TODO: BOTTOM BAR
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                                colors: const [
                                  Color(0xFF262C40),
                                  Color(0xFF464C60)
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    gameManager.thisPlayer != null
                                        ? (gameManager.thisPlayer?.userModel !=
                                                null
                                            ? currencyFormatter.format(
                                                gameManager.thisPlayer!
                                                    .userModel!.money)
                                            : "")
                                        : "",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 38,
                                        fontFamily: "Montserrat",
                                        color: Colors.white))
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
              )),
        );
      }),
    );
  }
}

//===============================================================================
// TODO: PLAYER CARD
//===============================================================================

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

  // TODO: CREATE PLAYER CARDS ON HAND
  List<Container> createPlayerCards() {
    GameOnlineManager gameManager = GameOnlineManager.instance;
    GamePlayerOnline? player = gameManager.getPlayerBySeatOffset(widget.seat);
    if (player == null ||
        gameManager.GameIsPlaying() == false ||
        (gameManager.GameIsPlaying() && player.cardCount == 0)) {
      return [];
    }

    if (player.result == PlayerResult.uncheck ||
        (player.result == PlayerResult.dealer &&
            gameManager.thisPlayer!.result == PlayerResult.uncheck)) {
      return [
        Container(
            width: 40,
            height: 50,
            alignment: Alignment.center,
            child: Stack(
              children: [
                OverflowBox(
                  maxWidth: double.infinity,
                  maxHeight: double.infinity,
                  child: player.cards.firstOrNull?.getImage(40, 50),
                ),
                Positioned.fill(
                    child: Align(
                  alignment: Alignment.center,
                  child: GradientText(
                    player.cardCount.toString(),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                        fontFamily: "Montserrat"),
                    colors: const [
                      Color(0xFF79FFDF),
                      Color(0xFF79FFDF),
                    ],
                  ),
                ))
              ],
            ))
      ];
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

  // TODO: CREATE THE EXECUTE BUTTON / RESULT
  Align? getBottomWidget() {
    GameOnlineManager gameManager = GameOnlineManager.instance;
    GamePlayerOnline? player = gameManager.getPlayerBySeatOffset(widget.seat);

    if (player == null) {
      return null;
    }

    if (player.state == PlayerState.ready) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            "Sẵn sàng",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFF95ff80),
              Color(0xFF40ff1a),
            ],
          ),
        ),
      );
    }

    String specialResult = "";
    switch (player.checkCardState()) {
      case PlayerCardState.ban_ban:
        specialResult = "Xì bàn";
        break;
      case PlayerCardState.ban_luck:
        specialResult = "Xì lát";
        break;
      case PlayerCardState.dragon:
        specialResult = "Ngũ linh" "(${player.getTotalValues()})";
        break;
      default:
        break;
    }

    if (player.result == PlayerResult.win) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            specialResult != ""
                ? specialResult
                : "${player.getTotalValues()} điểm",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFFFA800),
              Color(0xFFFDFFE0),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.tie) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            specialResult != ""
                ? specialResult
                : "${player.getTotalValues()} điểm",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFB9E0F8),
              Color(0xFF8BCCF4),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.lose) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            player.isBurn()
                ? "Quắc"
                : (specialResult != ""
                    ? specialResult
                    : "${player.getTotalValues()} điểm"),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFF1F1F1),
              Color(0xFFB1B1B1),
            ],
          ),
        ),
      );
    }

    if (player.result == PlayerResult.dealer &&
        gameManager.thisPlayer!.result != PlayerResult.uncheck) {
      return Align(
        alignment: Alignment.center,
        child: Center(
          child: GradientText(
            player.isBurn()
                ? "Quắc"
                : (specialResult != ""
                    ? specialResult
                    : "${player.getTotalValues()} điểm"),
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                fontFamily: "Montserrat"),
            colors: const [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),
            ],
          ),
        ),
      );
    }

    // TODO: Player Execute button
    if (gameManager.dealerCanExecutePlayer(player)) {
      return Align(
          alignment: Alignment.center,
          child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () async => {
                    if (gameManager.dealerCanExecutePlayer(player))
                      {await gameManager.dealerExecutePlayer(player.seat)}
                  },
              child: Container(
                  width: 86,
                  height: 28,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/images/game_button_execute.png"),
                      fit: BoxFit.fill,
                    ),
                  ),
                  child: null)));
    }

    return null;
  }

  // TODO: Player Placeholder
  @override
  Widget build(BuildContext context) {
    GameOnlineManager gameManager = GameOnlineManager.instance;
    GamePlayerOnline? player = gameManager.getPlayerBySeatOffset(widget.seat);

    if (player == null) {
      return SizedBox(width: 120, height: 160);
    }

    String playerMoney = "";
    if (player.userModel != null) {
      playerMoney = player.userModel!.money < 1000
          ? player.userModel!.money.toString()
          : player.userModel!.money < 1000000
              ? "${(player.userModel!.money / 1000 * 1.0).toStringAsFixed(1)}K"
              : player.userModel!.money < 1000000000
                  ? "${(player.userModel!.money / 1000000 * 1.0).toStringAsFixed(1)}M"
                  : "${(player.userModel!.money / 1000000000 * 1.0).toStringAsFixed(1)}B";
    }

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
                  image: player == gameManager.currentPlayer
                      ? const AssetImage(
                          "assets/images/game_player_background_onturn.png")
                      : const AssetImage(
                          "assets/images/game_player_background.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: const AssetImage(
                              "assets/images/default_profile_picture.png"), // PLAYER AVATAR
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 50,
                          height: 20,
                          child: player == gameManager.dealer
                              ? Image.asset(
                                  "assets/images/game_host_banner.png",
                                  width: 50,
                                  height: 20)
                              : null,
                        ),
                      )),
                  SizedBox(
                      width: 70,
                      height: 50,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            player.userModel != null
                                ? player.userModel!.userName
                                : "",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                // fontFamily: "Montserrat",
                                color: Colors.white),
                            textAlign: TextAlign.start,
                          ),
                          GradientText(
                            playerMoney,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              fontFamily: "Montserrat",
                            ),
                            colors: const [
                              Color(0xFFFFA800),
                              Color(0xFFFDFFE0)
                            ],
                          )
                        ],
                      ))
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: createPlayerCards(),
            ),
            DeferredPointerHandler(
                child: SizedBox(
                    width: 60,
                    height: 30,
                    child: DeferPointer(
                        child: OverflowBox(
                      maxHeight: double.infinity,
                      maxWidth: double.infinity,
                      alignment: Alignment.bottomCenter,
                      child: getBottomWidget(),
                    ))))
          ],
        ));
  }
}
