import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

const mainColor = Color(0xFF92cdcf);
const secondaryColor = Color(0xFFcfa7c2);
const tertiaryColor = Color(0xFF445878);

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
      success: .lerp(success, other.success, t)!,
      onSuccess: .lerp(onSuccess, other.onSuccess, t)!,
      successContainer: .lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: .lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(
      success: success.harmonizeWith(dynamic.primary),
      onSuccess: onSuccess.harmonizeWith(dynamic.primary),
      successContainer: successContainer.harmonizeWith(dynamic.primary),
      onSuccessContainer: onSuccessContainer.harmonizeWith(dynamic.primary),
    );
  }
}

final ColorScheme colorSchemeDark = .fromSeed(
  seedColor: mainColor,
  secondary: secondaryColor,
  tertiary: tertiaryColor,
  brightness: .dark,
);

final ColorScheme colorSchemeLight = .fromSeed(
  seedColor: mainColor,
  secondary: secondaryColor,
  tertiary: tertiaryColor,
);

extension ThemeDataExtensions on ThemeData {
  CustomColors get customColors => extension<CustomColors>()!;
}

ThemeData getDarkThemeData(ColorScheme? darkDynamic) {
  var colorSchema = colorSchemeDark;

  if (darkDynamic != null) {
    colorSchema = .fromSeed(
      seedColor: Color(darkDynamic.primary.toARGB32()),
      brightness: .dark,
      secondary: darkDynamic.secondary,
      tertiary: darkDynamic.tertiary,
    );
    colorSchema = colorSchema.harmonized();
  }

  final customColors = CustomColors(
    success: const .fromARGB(255, 109, 226, 109),
    onSuccess: colorSchema.surface,
    successContainer: const .fromARGB(255, 165, 192, 165),
    onSuccessContainer: colorSchema.surface,
  ).harmonized(colorSchema);

  final themeDark = ThemeData(
    colorScheme: colorSchema,
    fontFamily: 'NunitoSans',
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[customColors],
    snackBarTheme: const SnackBarThemeData(
      behavior: .floating,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(color: colorSchema.outlineVariant, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(color: colorSchema.outlineVariant, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(
          color: mainColor.harmonizeWith(
            colorSchema.primary,
          ), // Use your main color
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(
          color: Colors.red.harmonizeWith(colorSchema.primary),
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(
          color: Colors.red.harmonizeWith(colorSchema.primary),
          width: 2,
        ),
      ),
      filled: false,
      contentPadding: const .symmetric(horizontal: 16, vertical: 12),
    ),
  );
  return themeDark;
}

ThemeData getLightThemeData(ColorScheme? lightDynamic) {
  var colorSchema = colorSchemeLight;

  if (lightDynamic != null) {
    colorSchema = .fromSeed(
      seedColor: Color(lightDynamic.primary.toARGB32()),
      secondary: lightDynamic.secondary,
      tertiary: lightDynamic.tertiary,
    );
    colorSchema = colorSchema.harmonized();
  }

  final customColors = CustomColors(
    success: const .fromARGB(255, 27, 160, 27),
    onSuccess: colorSchema.surface,
    successContainer: const .fromARGB(255, 144, 219, 144),
    onSuccessContainer: colorSchema.onSurface,
  ).harmonized(colorSchema);

  final themeLight = ThemeData(
    colorScheme: colorSchema,
    fontFamily: 'NunitoSans',
    useMaterial3: true,
    extensions: <ThemeExtension<dynamic>>[customColors],
    snackBarTheme: const SnackBarThemeData(
      behavior: .floating,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(color: colorSchema.outlineVariant, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(color: colorSchema.outlineVariant, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(
          color: mainColor.harmonizeWith(colorSchema.primary),
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(
          color: Colors.red.harmonizeWith(colorSchema.primary),
          width: 2,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: .circular(8),
        borderSide: BorderSide(
          color: Colors.red.harmonizeWith(colorSchema.primary),
          width: 2,
        ),
      ),
      filled: false,
      contentPadding: const .symmetric(horizontal: 16, vertical: 12),
    ),
  );
  return themeLight;
}
