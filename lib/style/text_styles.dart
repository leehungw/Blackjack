import 'package:card/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyles {
  TextStyles(this.context);

  BuildContext context;

  static TextStyle defaultStyle = TextStyle(
      fontSize: 14,
      color: Palette.primaryText,
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.montserrat().fontFamily);
  static TextStyle appTitle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.montaguSlab().fontFamily);
  static TextStyle textFieldStyle = TextStyle(
      fontSize: 16,
      color: Palette.textFieldBorderUnfocus,
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.montserrat().fontFamily);
  static TextStyle linkLable = TextStyle(
      fontSize: 14,
      color: Palette.primaryText,
      fontWeight: FontWeight.w400,
      fontFamily: GoogleFonts.poppins().fontFamily);
  static TextStyle bigButtonText = TextStyle(
      fontSize: 24,
      color: Palette.primaryText,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.montserrat().fontFamily);
  static TextStyle dialogButtonText = TextStyle(
      fontSize: 16,
      color: Palette.primaryText,
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.montserrat().fontFamily);
  static TextStyle screenTitle = TextStyle(
      fontSize: 32,
      color: Palette.primaryText,
      fontWeight: FontWeight.bold,
      fontFamily: GoogleFonts.montserrat().fontFamily);
  static TextStyle iconLabel = TextStyle(
      fontSize: 13,
      color: Palette.primaryText,
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.montserrat().fontFamily);
  static TextStyle instructions = TextStyle(
      fontSize: 24,
      color: Palette.black,
      fontWeight: FontWeight.normal,
      fontFamily: GoogleFonts.montserrat().fontFamily);
}
