import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/lib/session.dart';
import 'package:green_thumb_mobile/screens/login/login_page.dart';
import 'package:green_thumb_mobile/screens/login/registration_page.dart';
import 'package:green_thumb_mobile/screens/spaces_list/space_edit_page.dart';
import 'package:green_thumb_mobile/screens/user_profile/user_page.dart';
import 'package:green_thumb_mobile/stores/user_store.dart';
import 'screens/spaces_list/spaces_list_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp( MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserStore()),
      ], child: const MyApp()));
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
          '/user-profile': (context) => const UserPage()
        },
        theme: AppTheme.lightTheme
    );
  }
}