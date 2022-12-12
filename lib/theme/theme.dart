import 'package:flutter/material.dart';

class MyThemeData {
  static MaterialAccentColor colorPrimary = Colors.deepPurpleAccent;
  static MaterialAccentColor buttonColor = Colors.deepPurpleAccent;
  static Color iconColor = Colors.black;
  static Color textColor = Colors.black;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    // Elevated Button design
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
      ),
    ),

    // Input Fields Design e.g TextField
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: colorPrimary,
          )),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
    ),

    // AppBar Design
    appBarTheme: AppBarTheme(
      backgroundColor: colorPrimary,
    ),

    // BottomAppBAr Design
    bottomAppBarTheme: BottomAppBarTheme(color: colorPrimary),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
      ),
    ),
  );
}
