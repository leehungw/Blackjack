import 'dart:math';
import 'package:card/GameObject/game_online_manager.dart';
import 'package:card/main.dart';
import 'package:card/models/RoomModel.dart';
import 'package:card/models/user.dart';
import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_small.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:stroke_text/stroke_text.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('Rooms').snapshots();
  PlayerRepo playerRepo = PlayerRepo();

  @override
  void initState() {
    super.initState();
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
                  child: SingleChildScrollView(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const Gap(30),
                      Text(
                        "Danh Sách Phòng",
                        style: TextStyles.screenTitle
                            .copyWith(color: Palette.black),
                      ),
                      const Gap(50),
                      StreamBuilder<QuerySnapshot>(
                          stream: _usersStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  'Something went wrong',
                                  style: TextStyles.screenTitle
                                      .copyWith(color: Palette.black),
                                ),
                              );
                            }

                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            List<RoomModel> rooms = snapshot.data!.docs
                                .map((doc) => RoomModel.fromJson(
                                    doc.id, doc.data() as Map<String, dynamic>))
                                .toList();
                            List<Player> hosts = [];
                            for (RoomModel room in rooms){
                              Player host = playerRepo.getPlayerById(room.dealer!) as Player;
                              hosts.add(host);
                            }

                            return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height - 300,
                                child: ListView.builder(
                                  itemCount: rooms.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                color: Palette
                                                    .buttonConfirmBackground,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  StrokeText(
                                                    text:
                                                        "Phòng ${rooms[index].roomID}",
                                                    textColor: Colors.white,
                                                    textStyle: TextStyles
                                                        .instructions
                                                        .copyWith(
                                                            color:
                                                                Colors.white),
                                                    strokeColor: Palette
                                                        .buttonStartBackgroundGradientBottom,
                                                    strokeWidth: 3,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: Palette
                                                              .dialogConfirmGradientBottom,
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                //TODO: mức cược của room
                                                                "Mức cược tối thiểu: ${"1K"}",
                                                                style: TextStyles
                                                                    .textFieldStyle
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                              ),
                                                              const Gap(10),
                                                              const Icon(
                                                                FontAwesomeIcons
                                                                    .coins,
                                                                color: Palette
                                                                    .coinGrind,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      const Gap(5),
                                                      SizedBox(
                                                        width: 150,
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              //TODO: Tên chủ phòng của room
                                                              "Chủ phòng: ${hosts[index].userName}",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyles
                                                                  .textFieldStyle
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                            StrokeText(
                                                              text:
                                                                  "Tài chó điên",
                                                              textColor:
                                                                  Colors.black,
                                                              textStyle: TextStyles
                                                                  .defaultStyle
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                              strokeColor:
                                                                  Palette
                                                                      .coinGrind,
                                                              strokeWidth: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      GestureDetector(
                                                        onTap: () async {
                                                          //TODO: handle Vào room
                                                          if (rooms[index]
                                                                      .players
                                                                      .length <
                                                                  5 &&
                                                              rooms[index]
                                                                      .status ==
                                                                  "ready") {
                                                              await _joinRoom(rooms[index]);
                                                          }
                                                        },
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5),
                                                            color: rooms[index]
                                                                            .players
                                                                            .length <
                                                                        5 &&
                                                                    rooms[index]
                                                                            .status ==
                                                                        "ready"
                                                                ? Palette
                                                                    .settingTextButtonGradientRight
                                                                : Palette
                                                                    .textFieldBackgroundGradientTop,
                                                          ),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Text(
                                                              "Vào ${rooms[index].players.length}/5",
                                                              style: TextStyles
                                                                  .textFieldStyle
                                                                  .copyWith(
                                                                      color: Colors
                                                                          .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      const Gap(5),
                                                      Text(
                                                        //TODO: Tên chủ phòng của room
                                                        rooms[index].status ==
                                                                "ready"
                                                            ? "Sẵn sàng..."
                                                            : rooms[index].status == "start" || rooms[index].status == "distributing"
                                                                ? "Đang chơi..."
                                                                : rooms[index]
                                                                            .status ==
                                                                        "end"
                                                                    ? "Kết thúc..."
                                                                    : "Tạo phòng...",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyles
                                                            .textFieldStyle
                                                            .copyWith(
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ));
                          }),
                      const Gap(40),
                      CustomElevatedButtonSmall(
                        width: 150,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: const [
                            Palette.settingDialogButtonBackgroundGradientBottom,
                            Palette.settingDialogButtonBackgroundGradientTop
                          ],
                        ),
                        onPressed: () {
                          context.pop();
                        },
                        text: "Thoát",
                      ),
                    ]),
                  )),
            ),
          );
        },
      ),
    );
  }

  // TODO: IMPLEMENT JOIN ROOM METHOD
  Future<void> _joinRoom(RoomModel room) async {
    String id = FirebaseAuth.instance.currentUser!.uid;
    bool result = await GameOnlineManager.instance.initialize(id, room.roomID!);
    if (result) {
      GoRouter.of(context).go("/home/game_screen");
    }
    else {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Thông báo'),
          content: Text(
              'Vào phòng thất bại!'),
          actions: [
            FilledButton(
                onPressed: () async {
                  // exit
                  Navigator.of(context).pop();
                }
                ,
                child: Text('Quay lại')
            )
          ],
        ),
      );
    }
  }
}
