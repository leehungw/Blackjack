import 'package:card/style/palette.dart';
import 'package:card/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:gradient_icon/gradient_icon.dart';
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
    return Column(
      children: [
        IconButton(
          iconSize: size,
          icon: Icon(
            icon,
            size: size,
            // gradient: gradient,
            color: color,
          ),
          onPressed: onPressed,
        ),
        GradientText(
          text,
          gradientDirection: GradientDirection.ttb,
          style: TextStyles.defaultStyle
              .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
          colors: const [
            Palette.titleTextGradientTop,
            Palette.titleTextGradientBottom,
          ],
        ),
      ],
    );
  }
}
