import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // Constructor cannot be called
  AppTheme._();

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.4, 1],
    colors: [
      Color(0xffF6F6F6),
      Color(0xffD9EBE4),
      Color(0xffBCDDB5),
    ],
  );

  static const backgroundImage = DecorationImage(
    image: AssetImage('assets/images/Background.jpg'),
    fit: BoxFit.cover
  );

  static final lightTheme = ThemeData(
      primaryColor: const Color(0xff43B05C),
      primaryColorLight: const Color(0xff49B889),
      primaryColorDark: const Color(0xff427664));

  static const chipsColor = Color(0xffEA8F3D);
  static const chipsBackgroundColor = Color(0xffFFF3E5);
}
