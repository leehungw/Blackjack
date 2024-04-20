import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_big.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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
                        onEditingComplete: () {
                          //TODO: Enter Room code compelted handle
                        },
                      ),
                    ),
                  ),
                ),
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
