import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:card/auth_fucntion.dart';
import 'package:card/main_menu/signup_screen.dart';
import 'package:card/style/palette.dart';
import 'package:card/user.dart';
import 'package:card/style/text_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

Future<UserCredential?> registerWithEmailAndPassword(
    String email, String password, String displayName, String avatar) async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user!.updateDisplayName(displayName);
    await userCredential.user!.updatePhotoURL(avatar);

    return userCredential;
  } catch (e) {
    print('Error creating user: $e');
    return null;
  }
}

class PincodeScreen extends StatefulWidget {
  final String name;
  final String uname;
  final String email;
  final String pass;
  final String imagefile;
  PincodeScreen(this.name, this.uname, this.email, this.pass, this.imagefile);

  @override
  State<PincodeScreen> createState() => _PincodeScreenState();
}

class _PincodeScreenState extends State<PincodeScreen> {
  final formKey = GlobalKey<FormState>();
  bool hasError = false;
  String currentText = "";
  String pinCode = '';
  StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();
  TextEditingController textEditingController = TextEditingController();
  bool _verifySuccess = false;

  String generateRandomCode() {
    Random random = Random();
    String code = '';
    for (int i = 0; i < 6; i++) {
      code += random.nextInt(10).toString();
    }
    return code;
  }

  void sendConfirmationCode(String code) async {
    String username = "personalschedulemanager@gmail.com";
    String password = "myocgxvnvsdybuhr";

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username)
      ..recipients.add('${widget.email}')
      ..subject = 'Confirmation Code'
      ..text = 'Your confirmation code is: $code';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } catch (e) {
      print('Error: $e');
    }
  }

  void resendConfirmationCode() {
    pinCode = generateRandomCode();
    sendConfirmationCode(pinCode);
  }

  @override
  void initState() {
    super.initState();
    _verifySuccess = false;
    pinCode = generateRandomCode();
    sendConfirmationCode(pinCode);
  }

  bool _canPop = false;
  void _backButton(BuildContext context) async {
    if (!_verifySuccess) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Cảnh báo'),
          content: Text(
              'Hành động này sẽ chuyển bạn về trang đăng ký ! \n Bạn có chắc chắn không ?'),
          actions: [
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Hủy')),
            FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text('Đồng ý'))
          ],
        ),
      );
    } else {
      Navigator.of(context, rootNavigator: true).push(_createRoute());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        return Scaffold(
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
                  colors: const [
                    Palette.accountBackgroundGradientBottom,
                    Palette.accountBackgroundGradientTop
                  ],
                ),
              ),
              child: Center(
                child: Column(children: [
                  Gap(70),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            _backButton(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Palette.primaryText,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: ((MediaQuery.of(context).size.width - 250) /
                                      2 -
                                  54)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "VERIFY YOUR",
                                style: TextStyles.screenTitle,
                              ),
                              Text("ACCOUNT", style: TextStyles.screenTitle),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(34),
                  Container(
                    width: 160.0,
                    height: 160.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: widget.imagefile.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(File(widget.imagefile)),
                              fit: BoxFit.cover,
                            )
                          : DecorationImage(
                              image: AssetImage(
                                  "assets/images/default_profile_picture.png"),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  Gap(26),
                  Text(
                    "Welcome",
                    style: TextStyles.defaultStyle
                        .copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Gap(10),
                  GradientText(
                    widget.name,
                    style: TextStyles.appTitle,
                    colors: const [
                      Palette.titleTextGradientTop,
                      Palette.titleTextGradientBottom,
                    ],
                  ),
                  Gap(40),
                  Row(
                    children: [
                      Gap(33),
                      Text(
                        "Enter Your Code",
                        style: TextStyles.defaultStyle.copyWith(fontSize: 20),
                      ),
                    ],
                  ),
                  Gap(30),
                  Form(
                    key: formKey,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 30),
                        child: PinCodeTextField(
                          appContext: context,
                          pastedTextStyle: TextStyles.defaultStyle.copyWith(
                              color: Palette.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          length: 6,
                          obscureText: false,
                          animationType: AnimationType.fade,
                          validator: (v) {
                            if (v!.length < 6) {
                              return ""; // nothing to show
                            } else {
                              return null;
                            }
                          },
                          pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 50,
                            activeFillColor: hasError
                                ? Palette.textFieldBorderFocus
                                : Palette.primaryText,
                            selectedColor: Theme.of(context)
                                .colorScheme
                                .onTertiaryContainer,
                            selectedFillColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            inactiveColor: Theme.of(context).colorScheme.error,
                            inactiveFillColor:
                                Theme.of(context).colorScheme.errorContainer,
                          ),
                          cursorColor: Colors.black,
                          animationDuration: Duration(milliseconds: 300),
                          textStyle: TextStyle(fontSize: 20, height: 1.6),
                          backgroundColor: Colors.transparent,
                          enableActiveFill: true,
                          errorAnimationController: errorController,
                          controller: textEditingController,
                          keyboardType: TextInputType.number,
                          boxShadows: const [
                            BoxShadow(
                              offset: Offset(0, 1),
                              color: Palette.black,
                              blurRadius: 10,
                            )
                          ],
                          onCompleted: (value) {
                            setState(() {
                              currentText = value;
                            });
                          },
                          onChanged: (value) {},
                          beforeTextPaste: (text) {
                            print("Allowing to paste $text");
                            //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                            //but you can show anything you want here, like your pop up saying wrong paste format or etc
                            return true;
                          },
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      hasError ? "*Please fill up all the cells properly" : "",
                      style: TextStyles.defaultStyle.copyWith(
                          fontSize: 12,
                          color: Palette.accountBackgroundGradientBottom),
                    ),
                  ),
                  Gap(40),
                  GestureDetector(
                      child: Container(
                          width: 255,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            color: Colors.transparent,
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/button_background_active.png"),
                                fit: BoxFit.fill),
                          ),
                          child: Center(
                            child: Text(
                              "Confirm Code",
                              style: TextStyles.bigButtonText,
                            ),
                          )),
                      onTap: () async {
                        if (currentText == pinCode) {
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              });
                          // AuthServices.signUpUser(
                          //   widget.name,
                          //   widget.uname,
                          //   widget.email,
                          //   widget.pass,
                          //   widget.imagefile,
                          //   DateTime.now(),
                          //   context,
                          // );
                          UserCredential? userCredential =
                              await registerWithEmailAndPassword(
                            widget.email,
                            widget.pass,
                            widget.uname,
                            widget.imagefile,
                          );
                          if (userCredential != null) {
                            print("Account created successfully!");
                            Players newUser = Players(
                              yourName: widget.name,
                              userName: widget.uname,
                              email: widget.email,
                              avatar: widget.imagefile,
                              startDate: DateTime.now(),
                            );
                            addUserToFirestore(newUser);
                            GoRouter.of(context).go('/login');
                          } else {
                            print('Account creation failed!');
                          }
                          _verifySuccess = true;
                          Navigator.of(context, rootNavigator: true).pop();
                          setState(() {});
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Thông báo'),
                                content: Text(
                                  'MÃ XÁC NHẬN KHÔNG CHÍNH XÁC!!!',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SignupScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        final tween = Tween(begin: begin, end: end);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: curve,
        );

        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }
}
