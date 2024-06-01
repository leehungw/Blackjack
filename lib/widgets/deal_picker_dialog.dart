import 'package:card/GameObject/game_online_manager.dart';
import 'package:card/style/palette.dart';
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
              if (widget.thisPlayer.money > 10000) CustomElevatedButtonBig(
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
                  gameManager.reqReady(10000);
                },
                text: "10.000Đ",
              ),
              if (widget.thisPlayer.money > 10000) const Gap(30),
              if (widget.thisPlayer.money > 20000) CustomElevatedButtonBig(
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
                  gameManager.reqReady(20000);
                },
                text: "20.000Đ",
              ),
              if (widget.thisPlayer.money > 20000) const Gap(30),
              if (widget.thisPlayer.money > 50000) CustomElevatedButtonBig(
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
                  gameManager.reqReady(50000);
                },
                text: "50.000Đ",
              ),
              if (widget.thisPlayer.money > 50000) const Gap(30),
              if (widget.thisPlayer.money > 100000) CustomElevatedButtonBig(
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
                  gameManager.reqReady(100000);
                },
                text: "100.000Đ",
              ),
              if (widget.thisPlayer.money > 100000) const Gap(30),
              if (widget.thisPlayer.money > 200000) CustomElevatedButtonBig(
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
                  gameManager.reqReady(200000);
                },
                text: "200.000Đ",
              ),
              if (widget.thisPlayer.money > 200000) const Gap(30),
              if (widget.thisPlayer.money > 500000) CustomElevatedButtonBig(
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
                  gameManager.reqReady(500000);
                },
                text: "500.000Đ",
              ),
              if (widget.thisPlayer.money > 500000) const Gap(30),
            ],
          ),
        ),
      ]),
      contentPadding: EdgeInsets.all(0.0),
    );
  }
}
