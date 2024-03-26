import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final yourNameController = TextEditingController();
  FocusNode yourNameFocusNode = FocusNode();

  final userNameController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();

  final emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  final passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  final confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();

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
                child: Column(children: [
                  Gap(40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => {Navigator.pop(context)},
                          icon: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 55),
                          child: Text(
                            "REGISTER",
                            style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                                fontSize: 32,
                                color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                  Gap(34),
                  Stack(
                    children: [
                      Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage(
                                "assets/images/default_profile_picture.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -12.0,
                        right: -12.0,
                        child: IconButton(
                          onPressed: () {
                            //TODO: Handle add img logic
                          },
                          icon: Icon(Icons.camera_alt),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  Gap(41),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      controller: yourNameController,
                      focusNode: yourNameFocusNode,
                      keyboardType: TextInputType.name,
                      onTap: () => {
                        //do sth
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF97FF9B)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF2CFF35)),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Your Name",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Color(0xFF97FF9B)),
                        prefixIcon: const Icon(Icons.account_circle),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: " ",
                      ),
                      obscureText: false,
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      controller: userNameController,
                      focusNode: userNameFocusNode,
                      keyboardType: TextInputType.name,
                      onTap: () => {
                        //do sth
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF97FF9B)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF2CFF35)),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "User Name",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Color(0xFF97FF9B)),
                        prefixIcon: const Icon(Icons.account_circle),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: " ",
                      ),
                      obscureText: false,
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      onTap: () => {
                        //do sth
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF97FF9B)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF2CFF35)),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Email Address",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(color: Color(0xFF97FF9B)),
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: " ",
                      ),
                      obscureText: false,
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      onTap: () => {
                        //do sth
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF97FF9B)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF2CFF35)),
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
                  Gap(38),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      onTap: () => {
                        //do sth
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2, color: Color(0xFF97FF9B)),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF2CFF35)),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Confirm Password",
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
                                "Sign Up",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontFamily: "Montserrat"),
                              ),
                            )),
                        onTap: () {
                          //TODO: handle sign up logic
                          GoRouter.of(context).go('/signup/verification');
                        }),
                  ),
                ]),
              ),
            ),
          ),
        );
      }),
    );
  }
}
