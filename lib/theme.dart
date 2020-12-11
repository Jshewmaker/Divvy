import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: Colors.blue[100],
  primaryColor: Colors.blue[100],
  appBarTheme: AppBarTheme(
      color: Colors.white,
      textTheme: TextTheme(
          headline6: TextStyle(
        color: Colors.black,
        fontSize: 22,
      )),
      iconTheme: IconThemeData(color: Colors.black)),
  accentColor: Colors.redAccent,
  scaffoldBackgroundColor: Colors.white,
  textSelectionHandleColor: Colors.black,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
);
