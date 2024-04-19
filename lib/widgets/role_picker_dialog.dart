import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class RolePickerDialog extends StatefulWidget {
  const RolePickerDialog({super.key});

  @override
  State<RolePickerDialog> createState() => _RolePickerDialogState();
}

class _RolePickerDialogState extends State<RolePickerDialog> {
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
                    "Chọn vai trò: ",
                    style: TextStyles.bigButtonText,
                  )
                ],
              ),
              const Gap(15),
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
                  //TODO: Host handle
                },
                text: "Nhà Cái",
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
                  //TODO: Player handle
                },
                text: "Người Chơi",
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
