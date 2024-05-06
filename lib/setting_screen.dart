import 'dart:io';

import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:card/widgets/custom_elevated_button_small.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _obscureOldPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;
  String imagefile = '';
  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      imagefile = prefs.getString('avatar') ?? '';
    });
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
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Gap(30),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Cài Đặt',
                      style: TextStyles.settingScreenTitle,
                    ),
                  ),
                  const Gap(30),
                  Container(
                    alignment: Alignment.center,
                    child: Container(
                      width: 150,
                      height: 150,
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
                          obscureText: _obscureNewPass,
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
                          obscureText: _obscureConfirmPass,
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
                  const Gap(15),
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
                        onPressed: () {},
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
                  Text(
                    'Nhạc nền',
                    style: TextStyles.settingScreenSubTitle,
                  ),
                  const Gap(10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mặc định',
                        style: TextStyles.textInField
                            .copyWith(color: Colors.black),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: GradientText(
                          'Chọn nhạc',
                          style: TextStyles.settingTextButton,
                          colors: const [
                            Palette.settingTextButtonGradientRight,
                            Palette.settingTextButtonGradientLeft,
                          ],
                        ),
                      )
                    ],
                  ),
                  const Gap(20),
                  GestureDetector(
                    onTap: () {},
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
                          style: TextStyles.settingScreenButton,
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
                          'Đăng xuất',
                          style: TextStyles.settingScreenButton.copyWith(
                            color: Colors.red,
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
