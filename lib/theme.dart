import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  textTheme: GoogleFonts.openSansTextTheme(),
  primaryColorDark: const Color(0xFF0097A7),
  primaryColorLight: Colors.white,
  primaryColor: Colors.teal,
  appBarTheme: AppBarTheme(
      color: Colors.white,
      textTheme: TextTheme(headline6: TextStyle(color: Colors.black)),
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
