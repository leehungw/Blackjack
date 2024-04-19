import 'dart:io';

import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import 'package:card/main_menu/pincode_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _imageFile = "assets/images/default_profile_picture.png";
  //your name field
  final yourNameController = TextEditingController();
  FocusNode yourNameFocusNode = FocusNode();

  //user name field
  final userNameController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();

  //email field
  final emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();

  //password field
  final passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();

  //confirm password field
  final confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();

  Future<void> _selectImageFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Builder(builder: (context) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SingleChildScrollView(
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
                              color: Palette.primaryText,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 55),
                            child: Text(
                              "REGISTER",
                              style: TextStyles.screenTitle,
                            ),
                          )
                        ],
                      ),
                    ),
                    Gap(34),
                    Stack(
                      children: [
                        GestureDetector(
                          onTap: _selectImageFromGallery,
                          child: Container(
                            width: 80.0,
                            height: 80.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage(_imageFile),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -12.0,
                          right: -12.0,
                          child: IconButton(
                            onPressed: _selectImageFromGallery,
                            icon: Icon(Icons.camera_alt),
                            color: Palette.primaryText,
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
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Palette.textFieldBorderUnfocus),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Palette.textFieldBorderFocus),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Your Name",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.account_circle),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
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
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Palette.textFieldBorderUnfocus),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Palette.textFieldBorderFocus),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "User Name",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.account_circle),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
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
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Palette.textFieldBorderUnfocus),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Palette.textFieldBorderFocus),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Email Address",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.email),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
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
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Palette.textFieldBorderUnfocus),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Palette.textFieldBorderFocus),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Password",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
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
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: Palette.textFieldBorderUnfocus),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: Palette.textFieldBorderFocus),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Confirm Password",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
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
                                  style: TextStyles.bigButtonText,
                                ),
                              )),
                          onTap: () {
                            //GoRouter.of(context).go('/signup/verification');
                          }),
                    ),
                  ]),
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
      pageBuilder: (context, animation, secondaryAnimation) => PincodeScreen(
          yourNameController.value.text,
          userNameController.value.text,
          emailController.value.text,
          passwordController.value.text,
          _imageFile),
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
