import 'package:flutter/material.dart';

const mainColor = Color(0xFF92cdcf);

final colorScheme = ColorScheme.fromSeed(
  seedColor: mainColor,
  brightness: Brightness.dark,
);

final theme = ThemeData(
  colorScheme: colorScheme,
  fontFamily: 'NunitoSans',
  useMaterial3: true,
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.surfaceContainer, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: colorScheme.surfaceContainer, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(
        color: mainColor, // Use your main color
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Colors.red, width: 2.0),
    ),
    filled: false,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    iconSize: 86,
    extendedPadding: EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    extendedSizeConstraints: BoxConstraints(
      minWidth: 64,
      minHeight: 64,
      maxWidth: 350,
      maxHeight: 250,
    ),
    extendedTextStyle: TextStyle(
      fontFamily: 'Outward',
      fontSize: 86,
      height: 1.1,
    ),
  ),
);
