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

  //Setting Screen
  static TextStyle settingScreenTitle = TextStyle(
    fontSize: 40,
    color: Colors.black,
    fontWeight: FontWeight.w800,
    fontFamily: 'Montserrat',
    letterSpacing: 0.01,
  );
  static TextStyle settingScreenSubTitle = TextStyle(
    fontSize: 28,
    color: Colors.white,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.inter().fontFamily,
    letterSpacing: 0.01,
  );
  static TextStyle textInField = TextStyle(
    fontSize: 20,
    color: Colors.black.withOpacity(0.85),
    fontWeight: FontWeight.w600,
    fontFamily: GoogleFonts.inter().fontFamily,
    letterSpacing: 0.01,
  );
  static TextStyle settingScreenButton = TextStyle(
    fontSize: 28,
    color: Palette.settingDialogButtonText,
    fontWeight: FontWeight.bold,
    fontFamily: GoogleFonts.inter().fontFamily,
    letterSpacing: 0.01,
  );
  static TextStyle settingTextButton = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w300,
    fontFamily: GoogleFonts.inter().fontFamily,
  );
  static TextStyle dialogText = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    fontFamily: GoogleFonts.inter().fontFamily,
    color: Colors.black,
  );
}
