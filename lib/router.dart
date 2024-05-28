// Copyright 2023, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
import 'package:card/home_features/home_screen.dart';
import 'package:card/home_features/instruction_screen.dart';
import 'package:card/home_features/ranking_board.dart';
import 'package:card/home_features/room_list.dart';
import 'package:card/main_menu/login_screen.dart';
import 'package:card/main_menu/signup_screen.dart';
import 'package:card/setting_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'style/my_transition.dart';
import 'style/palette.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      redirect: (BuildContext context, GoRouterState state) {
        if (FirebaseAuth.instance.currentUser != null) {
          return '/home';
        } else {
          return '/login';
        }
      },
    ),
    GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(key: Key('login')),
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
        ]),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(key: Key('home')),
      routes: [
        GoRoute(
          path: 'setting',
          builder: (context, state) => const SettingScreen(key: Key('setting')),
        ),
        GoRoute(
          path: 'rank',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('rank'),
            color: Palette.homeDialogBackgroundGradientTop,
            child: const RankingScreen(
              key: Key('rank'),
            ),
          ),
        ),
        GoRoute(
          path: 'instruction',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('instruction'),
            color: Palette.homeBackgroundGradientBottom,
            child: const InstructionScreen(
              key: Key('instruction'),
            ),
          ),
        ),
        GoRoute(
          path: 'room_list',
          pageBuilder: (context, state) => buildMyTransition<void>(
            key: ValueKey('room_list'),
            color: Palette.homeDialogBackgroundGradientTop,
            child: const RoomListScreen(
              key: Key('room_list'),
            ),
          ),
        )
      ],
    ),
  ],
);
