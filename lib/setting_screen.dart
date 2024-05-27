import 'dart:io';
import 'dart:math';

import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_small.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _obscureOldPass = true;
  TextEditingController _oldPassController = TextEditingController();
  bool _obscureNewPass = true;
  TextEditingController _newPassController = TextEditingController();
  bool _obscureConfirmPass = true;
  TextEditingController _confirmPassController = TextEditingController();
  String imagefile = '';
  String emailPref = '';
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagefile = prefs.getString('avatar') ?? '';
      emailPref = prefs.getString('email') ?? '';
    });
  }

  void _changePassword() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    // Lấy mật khẩu hiện tại từ trường TextField
    String oldPassword = _oldPassController.text.trim();

    // Lấy mật khẩu mới từ trường TextField
    String newPassword = _newPassController.text.trim();

    // Lấy xác nhận mật khẩu từ trường TextField
    String confirmPassword = _confirmPassController.text.trim();

    // Kiểm tra mật khẩu hiện tại có chính xác hay không
    // Sử dụng currentUser để xác định người dùng hiện tại đang đăng nhập
    User? user = FirebaseAuth.instance.currentUser;

    AuthCredential credential =
        EmailAuthProvider.credential(email: emailPref, password: oldPassword);
    try {
      await user!.reauthenticateWithCredential(credential);
    } catch (error) {
      // Nếu xảy ra lỗi, hiển thị dialog thông báo lỗi
      Navigator.of(context, rootNavigator: true).pop();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              padding: EdgeInsets.all(15),
              height: 150,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Palette.dialogConfirmGradientTop,
                    Palette.dialogConfirmGradientBottom,
                  ],
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mật khẩu hiện tại không chính xác',
                      style: TextStyles.dialogText.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.textFieldBackgroundGradientTop,
                            Palette.textFieldBackgroundGradientBottom,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Đóng',
                          style: TextStyles.settingScreenButton.copyWith(
                            color: Colors.red,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        },
      );
      return;
    }

    // Kiểm tra mật khẩu mới
    if (newPassword.length < 6 || newPassword.contains(' ')) {
      Navigator.of(context, rootNavigator: true).pop();
      // Nếu mật khẩu mới không đạt yêu cầu, hiển thị dialog thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              padding: EdgeInsets.all(15),
              height: 150,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Palette.dialogConfirmGradientTop,
                    Palette.dialogConfirmGradientBottom,
                  ],
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mật khẩu mới phải có ít nhất 6 ký tự và không chứa khoảng trắng!',
                      style: TextStyles.dialogText.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.textFieldBackgroundGradientTop,
                            Palette.textFieldBackgroundGradientBottom,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Đóng',
                          style: TextStyles.settingScreenButton.copyWith(
                            color: Colors.red,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        },
      );
      return;
    }

    // Kiểm tra xác nhận mật khẩu
    if (newPassword != confirmPassword) {
      Navigator.of(context, rootNavigator: true).pop();
      // Nếu xác nhận mật khẩu không khớp, hiển thị dialog thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              padding: EdgeInsets.all(15),
              height: 150,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Palette.dialogConfirmGradientTop,
                    Palette.dialogConfirmGradientBottom,
                  ],
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Xác nhận mật khẩu không khớp với mật khẩu mới!',
                      style: TextStyles.dialogText.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.textFieldBackgroundGradientTop,
                            Palette.textFieldBackgroundGradientBottom,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Đóng',
                          style: TextStyles.settingScreenButton.copyWith(
                            color: Colors.red,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        },
      );
      return;
    }

    // Thay đổi mật khẩu
    try {
      await user.updatePassword(newPassword);
      Navigator.of(context, rootNavigator: true).pop();
      // Nếu thay đổi thành công, hiển thị dialog thông báo thành công
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              padding: EdgeInsets.all(15),
              height: 150,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Palette.dialogConfirmGradientTop,
                    Palette.dialogConfirmGradientBottom,
                  ],
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Mật khẩu đã được thay đổi thành công!',
                      style: TextStyles.dialogText.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.textFieldBackgroundGradientTop,
                            Palette.textFieldBackgroundGradientBottom,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _oldPassController.clear();
                          _newPassController.clear();
                          _confirmPassController.clear();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Đóng',
                          style: TextStyles.settingScreenButton.copyWith(
                            color: Colors.red,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        },
      );
    } catch (error) {
      Navigator.of(context, rootNavigator: true).pop();
      // Nếu xảy ra lỗi trong quá trình thay đổi mật khẩu, hiển thị dialog thông báo lỗi
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.all(0),
            content: Container(
              padding: EdgeInsets.all(15),
              height: 150,
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Palette.dialogConfirmGradientTop,
                    Palette.dialogConfirmGradientBottom,
                  ],
                ),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Đã xảy ra lỗi khi thay đổi mật khẩu!\nVui lòng thử lại sau!',
                      style: TextStyles.dialogText.copyWith(
                        fontSize: 18,
                      ),
                    ),
                    Container(
                      width: 140,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.textFieldBackgroundGradientTop,
                            Palette.textFieldBackgroundGradientBottom,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Đóng',
                          style: TextStyles.settingScreenButton.copyWith(
                            color: Colors.red,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
          );
        },
      );
    }
  }

  Future<void> launchEmailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'personalschedulemanager@gmail.com',
      queryParameters: {
        'subject': 'Góp_Ý_Của_Người_Dùng',
      },
    );

    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              contentPadding: EdgeInsets.all(0),
              content: Container(
                padding: EdgeInsets.all(15),
                height: 150,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Palette.dialogConfirmGradientTop,
                      Palette.dialogConfirmGradientBottom,
                    ],
                  ),
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Thiết bị của bạn không có ứng dụng email nào!',
                        style: TextStyles.dialogText.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Palette.textFieldBackgroundGradientTop,
                              Palette.textFieldBackgroundGradientBottom,
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Đóng',
                            style: TextStyles.settingScreenButton.copyWith(
                              color: Colors.red,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                    ]),
              ),
            );
          });
    }
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Container(
            padding: EdgeInsets.all(15),
            height: 150,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Palette.dialogConfirmGradientTop,
                  Palette.dialogConfirmGradientBottom,
                ],
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Bạn muốn đăng xuất?',
                    style: TextStyles.dialogText,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Palette.textFieldBackgroundGradientTop,
                              Palette.textFieldBackgroundGradientBottom,
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Hủy',
                            style: TextStyles.settingScreenButton.copyWith(
                              color: Colors.red,
                              fontSize: 26,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Palette
                                  .settingDialogButtonBackgroundGradientBottom,
                              Palette.settingDialogButtonBackgroundGradientTop,
                            ],
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Xác nhận',
                            style: TextStyles.settingScreenButton,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
          ),
        );
      },
    );
  }

  void _logout() {
    FirebaseAuth.instance.signOut();
    GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: size.height,
            width: size.width,
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
          ),
          Center(
            child: Container(
              alignment: Alignment.center,
              width: size.width * 0.5,
              height: size.width * 0.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: Offset(15, 15),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset('assets/images/backgroundlogo.png'),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            height: size.height,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Cài Đặt',
                      style: TextStyles.settingScreenTitle,
                    ),
                  ),
                  const Gap(20),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: imagefile.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imagefile),
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
                  const Gap(20),
                  Text(
                    'Đổi mật khẩu',
                    style: TextStyles.settingScreenSubTitle,
                  ),
                  const Gap(15),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Palette.textFieldBackgroundGradientTop,
                          Palette.textFieldBackgroundGradientBottom,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: _oldPassController,
                          obscureText: _obscureOldPass,
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          style: TextStyles.textInField,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Mật khẩu hiện tại',
                            hintStyle: TextStyles.textInField.copyWith(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureOldPass = !_obscureOldPass;
                            });
                          },
                          icon: Icon(
                            _obscureOldPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Palette.textFieldBackgroundGradientTop,
                          Palette.textFieldBackgroundGradientBottom,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: _newPassController,
                          obscureText: _obscureNewPass,
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          style: TextStyles.textInField,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Mật khẩu mới',
                            hintStyle: TextStyles.textInField.copyWith(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureNewPass = !_obscureNewPass;
                            });
                          },
                          icon: Icon(
                            _obscureNewPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    alignment: Alignment.centerLeft,
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Palette.textFieldBackgroundGradientTop,
                          Palette.textFieldBackgroundGradientBottom,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        TextField(
                          controller: _confirmPassController,
                          obscureText: _obscureConfirmPass,
                          onTapOutside: (event) {
                            FocusScope.of(context).unfocus();
                          },
                          style: TextStyles.textInField,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Xác nhận mật khẩu mới',
                            hintStyle: TextStyles.textInField.copyWith(
                              color: Colors.black.withOpacity(0.3),
                            ),
                            contentPadding: EdgeInsets.all(0),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPass = !_obscureConfirmPass;
                            });
                          },
                          icon: Icon(
                            _obscureConfirmPass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 160,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.settingDialogButtonBackgroundGradientBottom,
                            Palette.settingDialogButtonBackgroundGradientTop,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Xác nhận',
                          style: TextStyles.settingScreenButton,
                        ),
                      ),
                    ),
                  ),
                  const Gap(20),
                  GestureDetector(
                    onTap: launchEmailApp,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Trợ giúp',
                          style: TextStyles.settingScreenSubTitle,
                        ),
                        const Gap(5),
                        Icon(
                          Icons.help_outline,
                          color: Colors.white,
                          size: 30,
                        ),
                      ],
                    ),
                  ),
                  const Gap(20),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 160,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.settingDialogButtonBackgroundGradientBottom,
                            Palette.settingDialogButtonBackgroundGradientTop,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Thoát',
                          style: TextStyles.settingScreenButton
                              .copyWith(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const Gap(10),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 160,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Palette.textFieldBackgroundGradientTop,
                            Palette.textFieldBackgroundGradientBottom,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: _showLogoutConfirmationDialog,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: EdgeInsets.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          'Đăng xuất',
                          style: TextStyles.settingScreenButton.copyWith(
                            color: Colors.red,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Gap(50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
