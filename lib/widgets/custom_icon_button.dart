import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Color color;
  final Gradient gradient;
  final String text;
  final double size;
  final IconData icon;

  const CustomIconButton({
    super.key,
    required this.onPressed,
    this.text = "",
    this.size = 50,
    required this.icon,
    required this.gradient,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed;
      },
      child: Column(
        children: [
          Icon(
            icon,
            size: size,
            // gradient: gradient,
            color: color,
          ),
          Gap(5),
          Text(
            text,
            style: TextStyles.defaultStyle.copyWith(
              fontWeight: FontWeight.normal,
              fontSize: 15,
              color: Palette.labelFunctionText,
            ),
          ),
        ],
      ),
    );
  }
}
