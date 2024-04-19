import 'package:card/style/palette.dart';
import 'package:card/widgets/custom_elevated_button.dart';
import 'package:card/widgets/role_picker_dialog.dart';
import 'package:card/widgets/room_code_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
              CustomElevatedButton(
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
              CustomElevatedButton(
                width: 150,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: const [
                    Palette.homeDialogSecondaryButtonBackgroundGradientBottom,
                    Palette.homeDialogSecondaryButtonBackgroundGradientTop
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return RolePickerDialog();
                    },
                  );
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
