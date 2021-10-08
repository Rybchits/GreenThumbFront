import 'package:flutter/material.dart';
import 'package:green_thumb_mobile/screens/login/login_page.dart';
import 'package:green_thumb_mobile/screens/login/registration_page.dart';

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
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
