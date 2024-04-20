// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:card/home_features/home_screen.dart';
import 'package:card/home_features/instruction_screen.dart';
import 'package:card/main_menu/signup_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import 'style/my_transition.dart';
import 'style/palette.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) =>
          const InstructionScreen(key: Key('login screen')),
      routes: [
        GoRoute(
          path: 'signup',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('signup'),
            color: Palette.accountBackgroundGradientBottom,
            child: const SignupScreen(
              key: Key('signup'),
            ),
          ),
          // routes: [
          //   GoRoute(
          //     path: 'verification',
          //     pageBuilder: (context, state) => buildMyTransition<void>(
          //       key: ValueKey('verification'),
          //       color: context.watch<Palette>().backgroundPlaySession,
          //       child: const PincodeScreen(
          //         key: Key('verification'),
          //       ),
          //     ),
          //   )
          // ],
        ),
      ],
    ),
  ],
);
