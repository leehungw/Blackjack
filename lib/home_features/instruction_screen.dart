import 'package:card/config/game_instructions.dart';
import 'package:card/main.dart';
import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_small.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

class InstructionScreen extends StatefulWidget {
  const InstructionScreen({super.key});

  @override
  State<InstructionScreen> createState() => _InstructionScreenState();
}

class _InstructionScreenState extends State<InstructionScreen> {
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
                      Palette.homeBackgroundGradientTop,
                      Palette.homeBackgroundGradientBottom
                    ],
                  ),
                ),
                child: Stack(children: [
                  Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 145,
                      width: 145,
                      child: Image.asset('assets/images/logo.png',
                          fit: BoxFit.cover,
                          opacity: AlwaysStoppedAnimation(0.15)),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Column(children: [
                      const Gap(30),
                      Text(
                        "Hướng Dẫn",
                        style: TextStyles.screenTitle
                            .copyWith(color: Palette.black),
                      ),
                      const Gap(30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          GameInstructions.instructions,
                          style: TextStyles.instructions,
                        ),
                      ),
                      const Gap(20),
                      Row(children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyles.instructions,
                              children: [
                                TextSpan(
                                  text: 'Tham khảo thêm tại: ',
                                ),
                                TextSpan(
                                  text: '\nHướng dẫn cơ bản BlackJack',
                                  style: TextStyles.instructions.copyWith(
                                      color: Palette.numberText,
                                      decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      launchUrl(
                                          GameInstructions.instructionsLink);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                      const Gap(30),
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
                          //TODO: Context.pop()
                        },
                        text: "Đã Hiểu",
                      ),
                    ]),
                  ),
                ]),
              ),
            ),
          );
        },
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const MyApp(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }
}
