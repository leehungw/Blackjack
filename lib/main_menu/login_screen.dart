import 'dart:math';
import 'package:card/main.dart';
import 'package:card/main_menu/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pass = "";
  final emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  bool firstEnterEmailTF = false;

  final passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  bool firstEnterPasswordTF = false;
  bool passwordVisible = false;
  final emailForgotPasswordController = TextEditingController();

  String errorText = "";

  Future signInButtonPressed(BuildContext context) async {
    setState(() {
      firstEnterEmailTF = true;
      firstEnterPasswordTF = true;
      emailFocus.unfocus();
      passwordFocus.unfocus();
    });

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    bool result = await signIn(context);
    Navigator.of(context, rootNavigator: true).pop();

    if (result) {
      // ignore: use_build_context_synchronously
      Navigator.of(context, rootNavigator: true)
          .pushAndRemoveUntil(_createRoute(), (route) => false);
    } else {
      setState(() {
        errorText = "Tài khoản hoặc mật khẩu không chính xác!";
      });
    }
  }

  Future<bool> signIn(BuildContext context) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.value.text,
          password: passwordController.value.text);
    } on FirebaseAuthException {
      // ignore: use_build_context_synchronously
      return false;
    }
    // ignore: use_build_context_synchronously
    return true;
  }

  // void forgetPasswordTextTapped(BuildContext context) {
  //   Navigator.of(context, rootNavigator: true)
  //       .push(MaterialPageRoute(builder: (context) => const ForgotPassPage()));
  // }

  void signUpTextTapped(BuildContext context) {
    Navigator.of(context, rootNavigator: true)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  void sendResetPasswordRequest(BuildContext context) {
    String email = emailForgotPasswordController.text;

    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Reset password email sent to $email"),
      ));
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to send reset password email: $error"),
      ));
    });
  }

  @override
  void initState() {
    passwordVisible = false;
    firstEnterEmailTF = false;
    firstEnterPasswordTF = false;
    errorText = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
              reverse: true,
              child: Container(
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: const [Color(0xFFDD4444), Color(0xFF5F1313)],
                  ),
                ),
                child: Center(
                  child: Column(
                    children: [
                      Gap(157),
                      Row(
                        children: [
                          Gap(30),
                          SizedBox(
                            height: 145,
                            width: 145,
                            child: Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Gap(9),
                          Column(
                            children: [
                              GradientText(
                                'Welcome To',
                                style: TextStyle(
                                    fontSize: 26.0,
                                    fontFamily: 'Montagu Slab',
                                    fontWeight: FontWeight.bold),
                                colors: const [
                                  Color(0xFFFEE60F),
                                  Color(0xFFF4FD8B),
                                ],
                              ),
                              Gap(5),
                              GradientText(
                                'Lucky Card',
                                style: TextStyle(
                                    fontSize: 26.0,
                                    fontFamily: 'Montagu Slab',
                                    fontWeight: FontWeight.bold),
                                colors: const [
                                  Color(0xFFF4FD8B),
                                  Color(0xFFFEE60F),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                      Gap(62),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: emailController,
                          focusNode: emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          onTap: () => {firstEnterEmailTF = true},
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Color(0xFF97FF9B)),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xFF97FF9B)),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Color(0xFF2CFF35)),
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Email",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Color(0xFF97FF9B)),
                            prefixIcon: const Icon(Icons.email_outlined),
                            prefixIconColor: Color(0xFF97FF9B),
                            helperText: " ",
                          ),
                          obscureText: false,
                        ),
                      ),
                      Gap(35),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextField(
                          controller: passwordController,
                          focusNode: passwordFocus,
                          onTap: () => {firstEnterPasswordTF = true},
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(color: Color(0xFF97FF9B)),
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 2, color: Color(0xFF97FF9B)),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 3, color: Color(0xFF2CFF35)),
                                borderRadius: BorderRadius.circular(10)),
                            labelText: "Password",
                            labelStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(color: Color(0xFF97FF9B)),
                            prefixIcon: const Icon(Icons.lock_outlined),
                            prefixIconColor: Color(0xFF97FF9B),
                          ),
                          obscureText: true,
                          obscuringCharacter: '*',
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ForgotPasswordDialog(
                                      emailForgotPasswordController:
                                          emailForgotPasswordController);
                                },
                              );
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: "Montserrat"),

                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 38),
                        child: GestureDetector(
                            child: Container(
                                width: 255,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(13),
                                  color: Colors.transparent,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/button_background_inactive.png"),
                                      fit: BoxFit.fill),
                                ),
                                child: Center(
                                  child: Text(
                                    "Log In",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white,
                                        fontFamily: "Montserrat"),
                                  ),
                                )),
                            onTap: () {
                              signInButtonPressed(context);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14.0),
                        child: RichText(
                          text: TextSpan(
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                              children: <TextSpan>[
                                const TextSpan(
                                    text: "Create new account? ",
                                    style: TextStyle(fontFamily: "Montserrat")),
                                TextSpan(
                                    text: "Sign Up",
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Montserrat"),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        GoRouter.of(context).go('/signup');
                                      })
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
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
