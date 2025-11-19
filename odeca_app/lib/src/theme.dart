
import 'package:flutter/material.dart';

class OdecaTheme {
  static const Color red = Color(0xFFC0332A); // warm red
  static const Color black = Colors.black;
  static const Color white = Colors.white;

  static ThemeData light() {
    return ThemeData(
      primaryColor: red,
      scaffoldBackgroundColor: white,
      appBarTheme: AppBarTheme(
        color: red,
        elevation: 0,
        iconTheme: IconThemeData(color: white),
        titleTextStyle: TextStyle(color: white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      textTheme: TextTheme(
        headline6: TextStyle(color: black, fontSize: 20, fontWeight: FontWeight.bold),
        bodyText1: TextStyle(color: black),
        bodyText2: TextStyle(color: black),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
          foregroundColor: white,
          shape: StadiumBorder(),
          padding: EdgeInsets.symmetric(horizontal:16, vertical:12),
        ),
      ),
    );
  }
}
