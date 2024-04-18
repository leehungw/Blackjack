import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _avtPath = "assets/images/default_profile_picture.png";
  bool isSignUpButtonActive = false;

  final yourNameController = TextEditingController();
  FocusNode yourNameFocusNode = FocusNode();
  bool isYourNameValid = true;

  final userNameController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  bool isUserNameValid = true;

  final emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  bool isEmailValid = true;

  final passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  bool isPasswordValid = true;

  final confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  bool isConfirmPasswordValid = true;

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
                          image: _avtPath.isNotEmpty
                              ? DecorationImage(
                                  image: FileImage(File(_avtPath)),
                                  fit: BoxFit.cover,
                                )
                              : DecorationImage(
                                  image: AssetImage(_avtPath),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: -12.0,
                        right: -12.0,
                        child: IconButton(
                          onPressed: () {
                            _getImage(context);
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
                      onTapOutside: (event) {
                        yourNameFocusNode.unfocus();
                      },
                      controller: yourNameController,
                      focusNode: yourNameFocusNode,
                      keyboardType: TextInputType.name,
                      onTap: () => {
                        //do sth
                      },
                      onChanged: (value) {
                        setState(() {
                          isYourNameValid = _validateName(value);
                        });
                        _checkSignUpButtonState();
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: isYourNameValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Color(0xFF2CFF35)),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Your Name",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: isYourNameValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                        prefixIcon: const Icon(Icons.account_circle),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: isYourNameValid ? " " : "Tên không hợp lệ",
                        helperStyle: TextStyle(
                            color: isYourNameValid
                                ? Color(0xFF97FF9B)
                                : Colors.black),
                      ),
                      obscureText: false,
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      onTapOutside: (event) {
                        userNameFocusNode.unfocus();
                      },
                      controller: userNameController,
                      focusNode: userNameFocusNode,
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        setState(() {
                          isUserNameValid = _validateUserName(value);
                        });
                        _checkSignUpButtonState();
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: isUserNameValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: isUserNameValid
                                    ? Color(0xFF2CFF35)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Name In Game",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: isUserNameValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                        prefixIcon: const Icon(Icons.account_circle),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: isUserNameValid
                            ? " "
                            : "Tên không hợp lệ hoặc quá dài",
                        helperStyle: TextStyle(
                            color: isUserNameValid
                                ? Color(0xFF97FF9B)
                                : Colors.black),
                      ),
                      obscureText: false,
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      onTapOutside: (event) {
                        emailFocusNode.unfocus();
                      },
                      controller: emailController,
                      focusNode: emailFocusNode,
                      keyboardType: TextInputType.emailAddress,
                      onTap: () => {
                        //do sth
                      },
                      onChanged: (value) {
                        setState(() {
                          isEmailValid = _validateEmail(value);
                        });
                        _checkSignUpButtonState();
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: isEmailValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: isEmailValid
                                    ? Color(0xFF2CFF35)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Email Address",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: isEmailValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: isEmailValid ? " " : "Email không hợp lệ",
                        helperStyle: TextStyle(
                            color: isEmailValid
                                ? Color(0xFF97FF9B)
                                : Colors.black),
                      ),
                      obscureText: false,
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      onTapOutside: (event) {
                        passwordFocusNode.unfocus();
                      },
                      controller: passwordController,
                      focusNode: passwordFocusNode,
                      onTap: () => {
                        //do sth
                      },
                      onChanged: (value) {
                        setState(() {
                          isPasswordValid = value.length > 6;
                        });
                        _checkSignUpButtonState();
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: isPasswordValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: isPasswordValid
                                    ? Color(0xFF2CFF35)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Password",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: isPasswordValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                        prefixIcon: const Icon(Icons.lock_outlined),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: isPasswordValid
                            ? " "
                            : "Mật khẩu phải có ít nhất 6 ký tự",
                        helperStyle: TextStyle(
                            color: isPasswordValid
                                ? Color(0xFF97FF9B)
                                : Colors.black),
                      ),
                      obscureText: true,
                      obscuringCharacter: '*',
                    ),
                  ),
                  Gap(10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: TextField(
                      onTapOutside: (event) {
                        confirmPasswordFocusNode.unfocus();
                      },
                      controller: confirmPasswordController,
                      focusNode: confirmPasswordFocusNode,
                      onTap: () => {
                        //do sth
                      },
                      onChanged: (value) {
                        setState(() {
                          isConfirmPasswordValid =
                              value == passwordController.text;
                        });
                        _checkSignUpButtonState();
                      },
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(color: Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 2,
                                color: isConfirmPasswordValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 3,
                                color: isConfirmPasswordValid
                                    ? Color(0xFF2CFF35)
                                    : Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        labelText: "Confirm Password",
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(
                                color: isConfirmPasswordValid
                                    ? Color(0xFF97FF9B)
                                    : Colors.black),
                        prefixIcon: const Icon(Icons.lock_outlined),
                        prefixIconColor: Color(0xFF97FF9B),
                        helperText: isConfirmPasswordValid
                            ? " "
                            : "Mật khẩu không khớp",
                        helperStyle: TextStyle(
                            color: isConfirmPasswordValid
                                ? Color(0xFF97FF9B)
                                : Colors.black),
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
                                  image: isSignUpButtonActive
                                      ? AssetImage(
                                          "assets/images/button_background_active.png")
                                      : AssetImage(
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

  void _getImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _avtPath = pickedImage.path;
      });
      print(pickedImage.path);
    }
  }

  void _checkSignUpButtonState() {
    setState(() {
      isSignUpButtonActive = yourNameController.text.isNotEmpty &&
          userNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          isConfirmPasswordValid &&
          isPasswordValid &&
          isEmailValid &&
          isUserNameValid &&
          isYourNameValid;
    });
  }

  bool _validateName(String name) {
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]*$');
    return nameRegex.hasMatch(name);
  }

  bool _validateUserName(String userName) {
    final RegExp vietnameseRegex = RegExp(r'[^\u0000-\u007F]');
    return !vietnameseRegex.hasMatch(userName) && userName.length <= 14;
  }

  bool _validateEmail(String email) {
    final RegExp emailRegex = RegExp(
        r"^[a-zA-Z0-9.!#$%&\'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$");

    return emailRegex.hasMatch(email);
  }
}
