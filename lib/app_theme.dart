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

  static final lightTheme = ThemeData(
      primaryColorLight: const Color(0xff49B889),
      primaryColorDark: const Color(0xff427664)
  );
}
