import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
    return Container(
      color: Colors.white,
      child: Container(
        width: 160.0,
        height: 160.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: imagefile.isNotEmpty
              ? DecorationImage(
                  image: NetworkImage(imagefile),
                  fit: BoxFit.cover,
                )
              : DecorationImage(
                  image:
                      AssetImage("assets/images/default_profile_picture.png"),
                  fit: BoxFit.cover,
                ),
        ),
      ),
    );
  }
}
