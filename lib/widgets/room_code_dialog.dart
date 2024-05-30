import 'dart:ffi';

import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../GameObject/game_online_manager.dart';
import 'custom_elevated_button_big.dart';

class RoomCodeDialog extends StatefulWidget {
  const RoomCodeDialog({super.key});

  @override
  State<RoomCodeDialog> createState() => _RoomCodeDialogState();
}

class _RoomCodeDialogState extends State<RoomCodeDialog> {
  TextEditingController roomCodeController = TextEditingController();

  String? roomCodeValidate(String? code) {
    if (code!.contains('.') || code.contains(',')) {
      return "hâhhaha";
    }
    return null;
  }

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
              const Gap(30),
              Row(
                children: [
                  Text(
                    "Nhập mã phòng: ",
                    style: TextStyles.bigButtonText,
                  )
                ],
              ),
              const Gap(15),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Palette.primaryText),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 8),
                      child: TextFormField(
                        validator: roomCodeValidate,
                        controller: roomCodeController,
                        style: TextStyles.textFieldStyle.copyWith(
                            color: Palette.black, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: Palette.buttonConfirmBackground),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: Palette.buttonConfirmBackground),
                          ),
                        ),
                        obscureText: false,
                        onEditingComplete: () async {
                          //TODO: Enter Room code compelted handle
                        },
                      ),
                    ),
                  ),
                ),
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
                  Navigator.of(context).pop();
                  String id = FirebaseAuth.instance.currentUser!.uid;
                  bool result = await GameOnlineManager.instance.initialize(id, int.parse(roomCodeController.value.toString()));
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
                },
                text: "Vào Phòng",
              ),
            ],
          ),
        ),
      ]),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}
