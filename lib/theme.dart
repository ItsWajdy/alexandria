import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AlexandriaTheme {
  static const Color _background = Color(0xFFF4F4F4);
  static const Color _highlight = Color(0xFFB0902A);
  static const Color _lightGrey = Color(0xFFD6D6D6);
  static const Color _darkGrey = Color(0xFF616161);

  static final _theme = ThemeData(
    textTheme: GoogleFonts.robotoTextTheme(),
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 25,
        color: Colors.black,
      ),
      iconTheme: IconThemeData(color: Colors.black),
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: _background,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: _darkGrey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: _highlight,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(
          color: _darkGrey,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    canvasColor: _background,
  );

  static get backgroundColor => _background;
  static get highlightColor => _highlight;
  static get lightGrey => _lightGrey;
  static get data => _theme;
}
