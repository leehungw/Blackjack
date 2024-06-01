import 'package:card/GameObject/game_online_manager.dart';
import 'package:card/models/FirebaseRequest.dart';
import 'package:card/style/palette.dart';
import 'package:card/widgets/custom_elevated_button_big.dart';
import 'package:card/widgets/role_picker_dialog.dart';
import 'package:card/widgets/room_code_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class StartGameDialog extends StatefulWidget {
  const StartGameDialog({super.key});

  @override
  State<StartGameDialog> createState() => _StartGameDialogState();
}

class _StartGameDialogState extends State<StartGameDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Wrap(children: [
        Container(
          constraints: const BoxConstraints(),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              gradient: LinearGradient(colors: const [
                Palette.homeDialogBackgroundGradientBottom,
                Palette.homeDialogBackgroundGradientTop
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(),
              const Gap(30),
              CustomElevatedButtonBig(
                width: 150,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Palette.homeDialogPrimaryButtonBackgroundGradientBottom,
                    Palette.homeDialogPrimaryButtonBackgroundGradientTop
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RoomCodeDialog();
                    },
                  );
                },
                text: "Vào Phòng",
              ),
              const Gap(30),
              CustomElevatedButtonBig(
                width: 150,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Palette.homeDialogSecondaryButtonBackgroundGradientBottom,
                    Palette.homeDialogSecondaryButtonBackgroundGradientTop
                  ],
                ),
                onPressed: () async {
                  String id = FirebaseAuth.instance.currentUser!.uid;
                  bool result = await GameOnlineManager.instance.initialize(id, GameOnlineManager.initializeRoomID);
                  if (!context.mounted) return;
                  if (result) {
                    GoRouter.of(context).go("/home/game_screen");
                  }
                  else {
                    await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Thông báo'),
                        content: Text(
                            'Tạo phòng thất bại!'),
                        actions: [
                          FilledButton(
                              onPressed: () async {
                                // exit
                                GoRouter.of(context).go("/home");
                              }
                              ,
                              child: Text('Quay lại')
                          )
                        ],
                      ),
                    );
                  }
                },
                text: "Tạo Phòng",
              ),
              const Gap(30),
            ],
          ),
        ),
      ]),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}
