import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  FocusNode emailFocus = FocusNode();
  bool firstEnterEmailTF = false;

  final passwordController = TextEditingController();
  FocusNode passwordFocus = FocusNode();
  bool firstEnterPasswordTF = false;

  final emailForgotPasswordController = TextEditingController();

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
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    content: Container(
                                      height: 230,
                                      width: 324,
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(8.0),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: LinearGradient(
                                              colors: const [
                                                Color(0xFF5D0000),
                                                Color(0xFFD40000)
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter)),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: const [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 38, left: 32),
                                                child: Text(
                                                  "Enter your email:",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: "Montserrat",
                                                      fontSize: 16),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 32, top: 13, right: 32),
                                            child: TextField(
                                              controller:
                                                  emailForgotPasswordController,
                                              keyboardType:
                                                  TextInputType.emailAddress,
                                              // onTap: () =>
                                              //     {firstEnterEmailTF = true},
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Color(0xFF97FF9B)),
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor: Color.fromARGB(
                                                    80, 217, 217, 217),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 0,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            width: 1,
                                                            color:
                                                                Colors.black),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10)),
                                                helperText: " ",
                                              ),
                                              obscureText: false,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 9, left: 32, right: 32),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.black,
                                                    backgroundColor:
                                                        Color(0xFF969292),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      side: BorderSide(
                                                          color: Color(
                                                              0xFF969292)),
                                                    ),
                                                  ),
                                                  child: SizedBox(
                                                      width: 70,
                                                      child: Center(
                                                          child:
                                                              Text('Cancel'))),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    // TODO: handle confirm forgot pw logic
                                                  },
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.white,
                                                    backgroundColor:
                                                        Color(0xFF440682),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10.0),
                                                      side: BorderSide(
                                                          color: Color(
                                                              0xFF440682)),
                                                    ),
                                                  ),
                                                  child: SizedBox(
                                                      width: 70,
                                                      child: Center(
                                                          child:
                                                              Text('Confirm'))),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(0.0),
                                  );
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
                                        "assets/images/button_background.png"),
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
                            //TODO: handle sign in logic
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
        );
      }),
    );
  }
}
