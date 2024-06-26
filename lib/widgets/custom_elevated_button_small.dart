import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:flutter/material.dart';

class CustomElevatedButtonSmall extends StatelessWidget {
  final Gradient gradient;
  final VoidCallback onPressed;
  final String text;
  final double width;

  const CustomElevatedButtonSmall({
    super.key,
    required this.gradient,
    required this.onPressed,
    required this.text,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        gradient: gradient,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
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
          text,
          style: TextStyles.bigButtonText
              .copyWith(color: Palette.settingDialogButtonText),
        ),
      ),
    );
  }
}
