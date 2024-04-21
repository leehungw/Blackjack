import 'dart:io';


import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import 'package:card/main_menu/pincode_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _imageFile = "";

  bool isSignUpButtonActive = false;

  String? _ExceptionText;

  //your name field
  final yourNameController = TextEditingController();
  FocusNode yourNameFocusNode = FocusNode();
  bool isYourNameValid = true;

  //user name field
  final userNameController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  bool isUserNameValid = true;

  //email field
  final emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  bool isEmailValid = true;
  String? _EmailValidateText;

  //password field
  final passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  bool isPasswordValid = true;

  //confirm password field
  final confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  bool isConfirmPasswordValid = true;

  void _RegisterButton(context) async {
    // bool? result;

    showDialog(
        context: context as BuildContext,
        barrierDismissible: false,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    Navigator.of(context).push(_createRoute());

    // result = await _checkIfEmailInUse(emailController.value.text);
    // Navigator.of(context).pop();
    // if (result == true) {
    //   _EmailValidateText = 'Email đã được sử dụng';
    // }
    // if (result == false) {
    //   // Chuyển hướng sang PINCODE page để xác thực tài khoản
    //   Navigator.of(context).push(_createRoute());
    // } else if (_ExceptionText != null) {
    //   String? message = _ExceptionText;
    //   ScaffoldMessenger.of(context as BuildContext)
    //       .showSnackBar(SnackBar(content: Text(message.toString())));
    // }
  }

  // Future<bool?> _checkIfEmailInUse(String emailAddress) async {
  //   try {
  //     final credential =
  //         await FirebaseAuth.instance.createUserWithEmailAndPassword(
  //       email: emailAddress,
  //       password: '123456',
  //     );
  //     await credential.user?.delete();
  //     return false;
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'email-already-in-use') {
  //       return true;
  //     } else {
  //       _ExceptionText = e.code;
  //       return null;
  //     }
  //   } catch (e) {
  //     _ExceptionText = e.toString();
  //     return null;
  //   }
  // }

  Future<void> _selectImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
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
                              image: _imageFile.isNotEmpty
                                  ? DecorationImage(
                                      image: FileImage(File(_imageFile)),
                                      fit: BoxFit.cover,
                                    )
                                  : DecorationImage(
                                      image: AssetImage(
                                          "assets/images/default_profile_picture.png"),
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
                        onTapOutside: (event) {
                          setState(() {
                            isYourNameValid =
                                _validateName(yourNameController.text);
                          });
                          yourNameFocusNode.unfocus();
                          _checkSignUpButtonState();
                        },
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 2,
                                  color: isYourNameValid
                                      ? Palette.textFieldBorderUnfocus
                                      : Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3,
                                  color: isYourNameValid
                                      ? Palette.textFieldBorderFocus
                                      : Colors.black),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Your Name",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.account_circle),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
                          helperText:
                              isYourNameValid ? " " : "Tên không hợp lệ",
                          helperStyle: TextStyle(
                              color: isYourNameValid
                                  ? Palette.textFieldBorderUnfocus
                                  : Colors.black),
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
                        onTapOutside: (event) {
                          setState(() {
                            isUserNameValid =
                                _validateUserName(userNameController.text);
                          });
                          userNameFocusNode.unfocus();
                          _checkSignUpButtonState();
                        },
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: isUserNameValid
                                    ? Palette.textFieldBorderUnfocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: isUserNameValid
                                    ? Palette.textFieldBorderFocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Name In Game",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.account_circle),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
                          helperText: isUserNameValid
                              ? " "
                              : "Tên trong game không được chứa dấu và tối đa 14 ký tự!",
                          helperStyle: TextStyle(
                              color: isUserNameValid
                                  ? Palette.textFieldBorderUnfocus
                                  : Colors.black),
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
                        onTapOutside: (event) {
                          setState(() {
                            isEmailValid = _validateEmail(emailController.text);
                          });
                          emailFocusNode.unfocus();
                          _checkSignUpButtonState();
                        },
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: isEmailValid
                                    ? Palette.textFieldBorderUnfocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: isEmailValid
                                    ? Palette.textFieldBorderFocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Email Address",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.email),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
                          helperText: isEmailValid
                              ? " "
                              : "Email không hợp lệ hoặc đã được sử dụng!",
                          helperStyle: TextStyle(
                            color: isEmailValid
                                ? Palette.textFieldBorderUnfocus
                                : Colors.black,
                          ),
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
                        onTapOutside: (event) {
                          setState(() {
                            isPasswordValid =
                                passwordController.text.length > 6;
                          });
                          passwordFocusNode.unfocus();
                          _checkSignUpButtonState();
                        },
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: isPasswordValid
                                    ? Palette.textFieldBorderUnfocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: isPasswordValid
                                    ? Palette.textFieldBorderFocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Password",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
                          helperText: isPasswordValid
                              ? " "
                              : "Mật khẩu phải có ít nhất 6 ký tự!",
                          helperStyle: TextStyle(
                            color: isPasswordValid
                                ? Palette.textFieldBorderUnfocus
                                : Colors.black,
                          ),
                        ),
                        obscureText: true,
                        obscuringCharacter: '*',
                      ),
                    ),
                    Gap(10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 35),
                      child: TextField(
                        controller: confirmPasswordController,
                        focusNode: confirmPasswordFocusNode,
                        onTapOutside: (event) {
                          setState(() {
                            isConfirmPasswordValid =
                                confirmPasswordController.text.isNotEmpty &&
                                    confirmPasswordController.text ==
                                        passwordController.text;
                          });
                          confirmPasswordFocusNode.unfocus();
                          _checkSignUpButtonState();
                        },
                        style: TextStyles.textFieldStyle
                            .copyWith(color: Palette.primaryText),
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: isConfirmPasswordValid
                                    ? Palette.textFieldBorderUnfocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 3,
                                color: isConfirmPasswordValid
                                    ? Palette.textFieldBorderFocus
                                    : Colors.black,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          labelText: "Confirm Password",
                          labelStyle: TextStyles.textFieldStyle,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          prefixIconColor: Palette.textFieldBorderUnfocus,
                          helperText: isConfirmPasswordValid
                              ? " "
                              : "Mật khẩu không khớp",
                          helperStyle: TextStyle(
                            color: isConfirmPasswordValid
                                ? Palette.textFieldBorderUnfocus
                                : Colors.black,
                          ),
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
                                image: isSignUpButtonActive
                                    ? DecorationImage(
                                        image: AssetImage(
                                            "assets/images/button_background_active.png"),
                                        fit: BoxFit.fill)
                                    : DecorationImage(
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
                            if (isSignUpButtonActive) {
                              _RegisterButton(context);
                            }
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

  void _checkSignUpButtonState() {
    setState(() {
      isSignUpButtonActive = yourNameController.text.isNotEmpty &&
          userNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty &&
          isYourNameValid &&
          isUserNameValid &&
          isEmailValid &&
          isPasswordValid &&
          isConfirmPasswordValid;
    });
  }

  bool _validateName(String name) {
    final RegExp nameRegex = RegExp(r'^[a-zA-Z\s]*$');
    return nameRegex.hasMatch(name);
  }

  bool _validateUserName(String userName) {
    if (userName.length > 14) {
      return false;
    }

    final RegExp nonAlphanumericRegex = RegExp(r'[^a-zA-Z0-9_]');
    if (nonAlphanumericRegex.hasMatch(userName)) {
      return false;
    }

    return true;
  }

  bool _validateEmail(String email) {
    return EmailValidator.validate(email);
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
