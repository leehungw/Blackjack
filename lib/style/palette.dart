// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A palette of colors to be used in the game.
///
/// The reason we're not going with something like Material Design's
/// `Theme` is simply that this is simpler to work with and yet gives
/// us everything we need for a game.
///
/// Games generally have more radical color palettes than apps. For example,
/// every level of a game can have radically different colors.
/// At the same time, games rarely support dark mode.
///
/// Colors taken from this fun palette:
/// https://lospec.com/palette-list/crayola84
///
/// Colors here are implemented as getters so that hot reloading works.
/// In practice, we could just as easily implement the colors
/// as `static const`. But this way the palette is more malleable:
/// we could allow players to customize colors, for example,
/// or even get the colors from the network.
class Palette {
  static const Color titleTextGradientTop = Color(0xFFFEE60F);
  static const Color titleTextGradientBottom = Color(0xFFF4FD8B);
  static const Color textFieldBorderFocus = Color(0xFF2CFF35);
  static const Color textFieldBorderUnfocus = Color(0xFF97FF9B);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color buttonContainerBg = Color(0xFFC3B6B6);
  static const Color accountBackgroundGradientTop = Color(0xFF5F1313);
  static const Color accountBackgroundGradientBottom = Color(0xFFDD4444);
  static const Color buttonConfirmBackground = Color(0xFF440682);
  static const Color black = Color(0xFF000101);
  static const Color homeBackgroundGradientBottom = Color(0xFF8A88FE);
  static const Color homeBackgroundGradientTop = Color(0xFFFF6D6D);
  static const Color numberText = Color(0xFF262398);
  static const Color buttonStartBackgroundGradientTop = Color(0xFF02C9E5);
  static const Color buttonStartBackgroundGradientBottom = Color(0xFF054A7B);
  static const Color buttonPracticeBackgroundGradientBottom = Color(0xFF0F7B05);
  static const Color buttonExitBackgroundGradientTop = Color(0xFF6E6D6C);
  static const Color buttonExitBackgroundGradientBottom = Color(0xFFAB9C8B);
  static const Color homeDialogBackgroundGradientTop = Color(0xFF4996B8);
  static const Color homeDialogBackgroundGradientBottom = Color(0xFFFCABF9);
  static const Color homeDialogPrimaryButtonBackgroundGradientTop =
      Color(0xFFD87500);
  static const Color homeDialogPrimaryButtonBackgroundGradientBottom =
      Color(0xFFFBB958);
  static const Color homeDialogSecondaryButtonBackgroundGradientTop =
      Color(0xFFD800CF);
  static const Color homeDialogSecondaryButtonBackgroundGradientBottom =
      Color(0xFFFF7EFA);
  static const Color settingText = Color(0xFF1D0070);
  static const Color settingDialogButtonBackgroundGradientTop =
      Color(0xFFFFD779);
  static const Color settingDialogButtonBackgroundGradientBottom =
      Color(0xFFFEEDC2);
  static const Color rollCallIcon = Color(0xFF1102BE);
  static const Color coinGrind = Color(0xFFF4B325);
}
