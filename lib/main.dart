import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/app_theme.dart';
import 'package:green_thumb_mobile/screens/login/login_page.dart';
import 'package:green_thumb_mobile/screens/login/registration_page.dart';
import 'package:green_thumb_mobile/screens/spaces_list/space_edit_page.dart';
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
          '/space-form': (context) => const SpaceEditPage()
        },
        theme: AppTheme.lightTheme
    );
  }
}
