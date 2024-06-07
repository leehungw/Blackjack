import 'package:card/GameObject/game_online_manager.dart';
import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_big.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../models/user.dart';

class DealPickerDialog extends StatefulWidget {
  final Player thisPlayer;
  const DealPickerDialog({super.key, required this.thisPlayer});

  @override
  State<DealPickerDialog> createState() => _DealPickerDialogState();
}

class _DealPickerDialogState extends State<DealPickerDialog> {
  PlayerRepo playerRepos = PlayerRepo();
  GameOnlineManager gameManager = GameOnlineManager.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // TODO: Deal level

  // TODO: MAIN WIDGET
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Wrap(children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(colors: const [
                Palette.homeDialogBackgroundGradientBottom,
                Colors.blueAccent,
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Chọn mức cược",
                  style: TextStyles.screenTitle.copyWith(
                    color: Palette.black,
                    fontSize: 26,
                  ),
                ),
              ),
              const Gap(5),
              if (widget.thisPlayer.money > 10000)
                CustomElevatedButtonBig(
                  width: 130,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color.fromARGB(255, 252, 228, 75),
                      Colors.deepOrange,
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameManager.reqReady(10000);
                  },
                  text: "10.000 Đ",
                ),
              if (widget.thisPlayer.money > 10000) const Gap(15),
              if (widget.thisPlayer.money > 20000)
                CustomElevatedButtonBig(
                  width: 130,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color.fromARGB(255, 252, 228, 75),
                      Colors.deepOrange,
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameManager.reqReady(20000);
                  },
                  text: "20.000 Đ",
                ),
              if (widget.thisPlayer.money > 20000) const Gap(15),
              if (widget.thisPlayer.money > 50000)
                CustomElevatedButtonBig(
                  width: 130,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color.fromARGB(255, 252, 228, 75),
                      Colors.deepOrange,
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameManager.reqReady(50000);
                  },
                  text: "50.000 Đ",
                ),
              if (widget.thisPlayer.money > 50000) const Gap(15),
              if (widget.thisPlayer.money > 100000)
                CustomElevatedButtonBig(
                  width: 130,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color.fromARGB(255, 252, 228, 75),
                      Colors.deepOrange,
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameManager.reqReady(100000);
                  },
                  text: "100.000 Đ",
                ),
              if (widget.thisPlayer.money > 100000) const Gap(15),
              if (widget.thisPlayer.money > 200000)
                CustomElevatedButtonBig(
                  width: 130,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color.fromARGB(255, 252, 228, 75),
                      Colors.deepOrange,
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameManager.reqReady(200000);
                  },
                  text: "200.000 Đ",
                ),
              if (widget.thisPlayer.money > 200000) const Gap(15),
              if (widget.thisPlayer.money > 500000)
                CustomElevatedButtonBig(
                  width: 130,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [
                      Color.fromARGB(255, 252, 228, 75),
                      Colors.deepOrange,
                    ],
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    gameManager.reqReady(500000);
                  },
                  text: "500.000 Đ",
                ),
              if (widget.thisPlayer.money > 500000) const Gap(15),
            ],
          ),
        ),
      ]),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}
