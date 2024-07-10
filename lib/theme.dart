import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlexandriaTheme {
  static const Color _blue = Color(0xFF39AABF);
  static const Color _green = Color(0xFF55C0A4);

  static final _theme = ThemeData(
    textTheme: GoogleFonts.robotoTextTheme(),
    appBarTheme: const AppBarTheme(
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(18),
          bottomRight: Radius.circular(18),
        ),
      ),
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 25,
        color: Colors.black,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: _blue,
      secondary: _green,
      background: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: _green,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: _green,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: _green,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
    ),
    canvasColor: Colors.white,
  );

  static get blue => _blue;
  static get primaryColor => _blue;
  static get green => _green;
  static get secondaryColor => _green;
  static get data => _theme;
}
