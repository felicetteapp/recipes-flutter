import 'package:flutter/material.dart';

const mainColor = Color(0xFF92cdcf);
const secondaryColor = Color(0xFFcfa7c2);

// Custom colors extension
@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
  });

  final Color success;
  final Color successContainer;
  final Color onSuccess;
  final Color onSuccessContainer;

  @override
  CustomColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
  }) {
    return CustomColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer:
          Color.lerp(successContainer, other.successContainer, t)!,
      onSuccessContainer:
          Color.lerp(onSuccessContainer, other.onSuccessContainer, t)!,
    );
  }
}

final colorSchemeDark = ColorScheme.fromSeed(
  seedColor: mainColor,
  secondary: secondaryColor,
  brightness: Brightness.dark,
);

final colorSchemeLight = ColorScheme.fromSeed(
  seedColor: mainColor,
  secondary: secondaryColor,
  brightness: Brightness.light,
);

final themeLight = ThemeData(
  colorScheme: colorSchemeLight,
  fontFamily: 'NunitoSans',
  useMaterial3: true,
  extensions: <ThemeExtension<dynamic>>[
    CustomColors(
      success: Color.fromARGB(255, 27, 160, 27),
      onSuccess: colorSchemeLight.onSurface,
      successContainer: Color.fromARGB(255, 144, 219, 144),
      onSuccessContainer: colorSchemeLight.onSurface,
    ),
  ],
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: colorSchemeLight.surfaceContainer,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: colorSchemeLight.surfaceContainer,
        width: 1.5,
      ),
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
);

final themeDark = ThemeData(
  colorScheme: colorSchemeDark,
  fontFamily: 'NunitoSans',
  useMaterial3: true,
  extensions: <ThemeExtension<dynamic>>[
    CustomColors(
      success: Color.fromARGB(255, 109, 226, 109),
      onSuccess: colorSchemeDark.surface,
      successContainer: Color.fromARGB(255, 165, 192, 165),
      onSuccessContainer: colorSchemeDark.surface,
    ),
  ],
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: colorSchemeDark.surfaceContainer,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: colorSchemeDark.surfaceContainer,
        width: 1.5,
      ),
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
);

extension ThemeDataExtensions on ThemeData {
  CustomColors get customColors => extension<CustomColors>()!;
}
