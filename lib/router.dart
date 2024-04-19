// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/main_menu/login_screen.dart';
import 'package:card/main_menu/pincode_screen.dart';
import 'package:card/main_menu/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'game_screen/demo_screen.dart';
import 'game_screen/demo_screen_online.dart';
import 'settings/settings_screen.dart';
import 'style/my_transition.dart';
import 'style/palette.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual level.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginScreen(key: Key('login screen')),
      routes: [
        GoRoute(
          path: 'signup',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('signup'),
            color: context.watch<Palette>().backgroundPlaySession,
            child: const DemoScreenOnline(
              key: Key('signup'),
            ),
          ),
          routes: [
            GoRoute(
              path: 'verification',
              pageBuilder: (context, state) => buildMyTransition<void>(
                key: ValueKey('verification'),
                color: context.watch<Palette>().backgroundPlaySession,
                child: const PincodeScreen(
                  key: Key('verification'),
                ),
              ),
            )
          ],
        ),
        GoRoute(
          path: 'settings',
          builder: (context, state) =>
              const SettingsScreen(key: Key('settings')),
        ),
      ],
    ),
  ],
);
