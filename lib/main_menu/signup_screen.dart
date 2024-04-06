import 'dart:io';

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
  bool _firstEnterNameField = false;
  bool _nameCorrect = false;
  String? _NameValidateText;

  //user name field
  final userNameController = TextEditingController();
  FocusNode userNameFocusNode = FocusNode();
  bool _firstEnterUserNameField = false;
  bool _userNameCorrect = false;
  String? _UserNameValidateText;

  //email field
  final emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  bool _firstEnterEmailField = false;
  bool _emailCorrect = false;
  String? _EmailValidateText;

  //password field
  final passwordController = TextEditingController();
  FocusNode passwordFocusNode = FocusNode();
  bool _firstEnterPasswordField = false;
  bool _passwordCorrect = false;
  String? _PasswordValidateText;
  bool _PasswordVisible = false;

  //confirm password field
  final confirmPasswordController = TextEditingController();
  FocusNode confirmPasswordFocusNode = FocusNode();
  bool _firstEnterConfirmPasswordField = false;
  bool _confirmPasswordCorrect = false;
  String? _ConfirmPasswordValidateText;
  bool _ConfirmPasswordVisible = false;

  String? _ExceptionText;

  // VALIDATING
  String? _NameValidating(String value) {
    String? errorText;
    if (!_firstEnterNameField) {
      return null;
    } else {
      if (value.isEmpty) {
        _nameCorrect = false;
        errorText = "Vui lòng nhập Họ & tên";
      } else {
        _nameCorrect = true;
      }
    }
    return yourNameFocusNode.hasFocus ? null : errorText;
  }

  String? _UserNameValidating(String value) {
    String? errorText;
    if (!_firstEnterUserNameField) {
      return null;
    } else {
      if (value.isEmpty) {
        _userNameCorrect = false;
        errorText = "Vui lòng nhập tên người dùng";
      } else {
        _userNameCorrect = true;
      }
    }
    return userNameFocusNode.hasFocus ? null : errorText;
  }

  String? _EmailValidating(String value) {
    String? errorText;
    if (!_firstEnterEmailField) {
      return null;
    } else {
      if (value.isEmpty) {
        _emailCorrect = false;
        errorText = "Vui lòng nhập Email";
      } else if (!EmailValidator.validate(value)) {
        _emailCorrect = false;
        errorText = "Email không hợp lệ";
      } else {
        _emailCorrect = true;
      }
    }
    return emailFocusNode.hasFocus ? null : errorText;
  }

  String? _PasswordValidating(String value) {
    String? errorText;
    if (!_firstEnterPasswordField) {
      return null;
    } else {
      if (value.isEmpty) {
        _passwordCorrect = false;
        errorText = "Vui lòng nhập mật khẩu";
      } else if (value.length < 6) {
        _passwordCorrect = false;
        errorText = "Mật khẩu phải có ít nhất 6 ký tự";
      } else {
        _passwordCorrect = true;
      }
    }
    return passwordFocusNode.hasFocus ? null : errorText;
  }

  String? _ConfirmPasswordValidating(String value) {
    String? errorText;
    if (!_firstEnterConfirmPasswordField) {
      return null;
    } else {
      if (value.isEmpty) {
        _confirmPasswordCorrect = false;
        errorText = "Vui lòng xác nhận mật khẩu";
      } else if (value != passwordController.text) {
        _confirmPasswordCorrect = false;
        errorText = "Mật khẩu không khớp";
      } else {
        _confirmPasswordCorrect = true;
      }
    }
    return confirmPasswordFocusNode.hasFocus ? null : errorText;
  }

  // SIGN UP

  void _RegisterButton(context) async {
    yourNameFocusNode.unfocus();
    emailFocusNode.unfocus();
    passwordFocusNode.unfocus();
    confirmPasswordFocusNode.unfocus();
    userNameFocusNode.unfocus();

    setState(() {
      _NameValidateText = _NameValidating(yourNameController.value.text);
      _EmailValidateText = _EmailValidating(emailController.value.text);
      _PasswordValidateText =
          _PasswordValidating(passwordController.value.text);
      _ConfirmPasswordValidateText =
          _ConfirmPasswordValidating(confirmPasswordController.value.text);
      _UserNameValidateText =
          _UserNameValidating(userNameController.value.text);
    });
    if (_nameCorrect &&
        _emailCorrect &&
        _passwordCorrect &&
        _confirmPasswordCorrect &&
        _userNameCorrect) {
      bool? result;

      showDialog(
          context: context as BuildContext,
          barrierDismissible: false,
          builder: (context) {
            return const Center(child: CircularProgressIndicator());
          });

      result = await _checkIfEmailInUse(emailController.value.text);
      Navigator.of(context).pop();
      if (result == true) {
        _EmailValidateText = 'Email đã được sử dụng';
      }
      if (result == false) {
        // Chuyển hướng sang PINCODE page để xác thực tài khoản
        Navigator.of(context).push(_createRoute());
      } else if (_ExceptionText != null) {
        String? message = _ExceptionText;
        ScaffoldMessenger.of(context as BuildContext)
            .showSnackBar(SnackBar(content: Text(message.toString())));
      }
    }

    setState(() {
      _firstEnterConfirmPasswordField = true;
      _firstEnterEmailField = true;
      _firstEnterPasswordField = true;
      _firstEnterNameField = true;
      _firstEnterUserNameField = true;
    });
  }

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

  Future<bool?> _checkIfEmailInUse(String emailAddress) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: '123456',
      );
      await credential.user?.delete();
      return false;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return true;
      } else {
        _ExceptionText = e.code;
        return null;
      }
    } catch (e) {
      _ExceptionText = e.toString();
      return null;
    }
  }

  @override
  void initState() {
    _PasswordVisible = false;
    _ConfirmPasswordVisible = false;
    _firstEnterNameField = false;
    _firstEnterEmailField = false;
    _firstEnterPasswordField = false;
    _firstEnterConfirmPasswordField = false;
    _firstEnterUserNameField = false;
    _nameCorrect = false;
    _emailCorrect = false;
    _passwordCorrect = false;
    _confirmPasswordCorrect = false;
    _userNameCorrect = false;

    // add listener
    yourNameFocusNode.addListener(() {
      if (yourNameFocusNode.hasFocus) {
        _firstEnterNameField = true;
        _NameValidateText = null;
      } else {
        _NameValidateText = _NameValidating(yourNameController.value.text);
        setState(() {});
      }
    });

    emailFocusNode.addListener(() {
      if (emailFocusNode.hasFocus) {
        _EmailValidateText = null;
        _firstEnterEmailField = true;
      } else {
        _EmailValidateText = _EmailValidating(emailController.value.text);
        setState(() {});
      }
    });

    passwordFocusNode.addListener(() {
      if (passwordFocusNode.hasFocus) {
        _firstEnterPasswordField = true;
        _PasswordValidateText = null;
      } else {
        _PasswordValidateText =
            _PasswordValidating(passwordController.value.text);
        setState(() {});
      }
    });

    confirmPasswordFocusNode.addListener(() {
      if (confirmPasswordFocusNode.hasFocus) {
        _firstEnterConfirmPasswordField = true;
        _ConfirmPasswordValidateText = null;
      } else {
        _ConfirmPasswordValidateText =
            _ConfirmPasswordValidating(confirmPasswordController.value.text);
        setState(() {});
      }
    });

    userNameFocusNode.addListener(() {
      if (userNameFocusNode.hasFocus) {
        _firstEnterUserNameField = true;
        _UserNameValidateText = null;
      } else {
        _UserNameValidateText =
            _UserNameValidating(userNameController.value.text);
        setState(() {});
      }
    });

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
            onTap: () => FocusScope.of(context).unfocus(),
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
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFF97FF9B)),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF2CFF35)),
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
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFF97FF9B)),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF2CFF35)),
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
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFF97FF9B)),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF2CFF35)),
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
                              borderSide: BorderSide(
                                  width: 2, color: Color(0xFF97FF9B)),
                              borderRadius: BorderRadius.circular(10)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF2CFF35)),
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
                            _RegisterButton(context);
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
