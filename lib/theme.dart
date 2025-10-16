import 'package:flutter/material.dart';

const mainColor = Color(0xFF92cdcf);
const secondaryColor = Color(0xFFcfa7c2);

// Custom colors extension
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({required this.success});

  final Color success;

  @override
  CustomColors copyWith({Color? success}) {
    return CustomColors(success: success ?? this.success);
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(success: Color.lerp(success, other.success, t)!);
  }
}

final colorScheme = ColorScheme.fromSeed(
  seedColor: mainColor,
  secondary: secondaryColor,
  brightness: Brightness.dark,
);

final theme = ThemeData(
  colorScheme: colorScheme,
  fontFamily: 'NunitoSans',
  useMaterial3: true,
  extensions: <ThemeExtension<dynamic>>[
    const CustomColors(success: Color(0xFF00FF00)),
  ],
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

extension ThemeDataExtensions on ThemeData {
  CustomColors get customColors => extension<CustomColors>()!;
}
