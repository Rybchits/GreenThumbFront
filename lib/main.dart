import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/lib/session.dart';
import 'package:green_thumb_mobile/screens/login/login_page.dart';
import 'package:green_thumb_mobile/screens/login/registration_page.dart';
import 'package:green_thumb_mobile/screens/spaces_list/space_edit_page.dart';
import 'package:green_thumb_mobile/screens/user_profile/user_page.dart';
import 'models/user_class.dart';
import 'screens/spaces_list/spaces_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/registration': (context) => const RegistrationPage(),
          '/spaces': (context) => const SpacesListPage(),
          '/space-form': (context) => const SpaceEditPage(),
          '/user-profile': (context) => UserPage(currentUser: User(
              "Топская Ирина Владимировна", "19106239@vstu.ru",
              "https://sun9-48.userapi.com/impf/fmm-Q1ZA22IAdubGy31cFfz3h0CNwq1CP0Gs5w/v5DFeC3CLms.jpg?size=1619x2021&quality=96&sign=3a0a859c5727c9517cc8186d3266b822&type=album"))
        },
        theme: AppTheme.lightTheme
    );
  }
}
