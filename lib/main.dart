import 'dart:ui';
import 'package:felicette_recipes/app/common/environment.dart';
import 'package:felicette_recipes/app/services/app_service.dart';
import 'package:felicette_recipes/app/utils/secure_storage.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/bindings/initial_binding.dart';
import 'package:felicette_recipes/app/common/translations/app_translations.dart';
import 'package:felicette_recipes/app/routes/app_pages.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/firebase_options.dart';
import 'package:felicette_recipes/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final userHasDarkModeSettingEnabled =
      PlatformDispatcher.instance.platformBrightness == Brightness.dark;

  final storedDarkModeSetting = await FRSecureStorage.read(key: isDarkModeKey);

  final initialThemeIsDark =
      storedDarkModeSetting == 'true' ||
      (storedDarkModeSetting != 'false' && userHasDarkModeSettingEnabled);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerApple:
        Environment.firebaseAppCheckIosDebugToken.isNotEmpty
            ? AppleDebugProvider(
              debugToken: Environment.firebaseAppCheckIosDebugToken,
            )
            : AppleDeviceCheckProvider(),
    providerAndroid:
        Environment.firebaseAppCheckAndroidDebugToken.isNotEmpty
            ? AndroidDebugProvider(
              debugToken: Environment.firebaseAppCheckAndroidDebugToken,
            )
            : AndroidPlayIntegrityProvider(),
  );
  runApp(MyApp(initialThemeIsDark: initialThemeIsDark));
}

class MyApp extends StatelessWidget {
  final bool initialThemeIsDark;
  const MyApp({super.key, required this.initialThemeIsDark});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Felicette Recipes',
      theme: themeLight,
      darkTheme: themeDark,
      themeMode: initialThemeIsDark ? ThemeMode.dark : ThemeMode.light,
      translations: AppTranslations(),
      locale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: InitialBinding(),
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
