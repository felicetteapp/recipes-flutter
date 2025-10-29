import 'package:felicette_recipes/app/common/environment.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:felicette_recipes/app/bindings/initial_binding.dart';
import 'package:felicette_recipes/app/common/translations/app_translations.dart';
import 'package:felicette_recipes/app/routes/app_pages.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/firebase_options.dart';
import 'package:felicette_recipes/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await FirebaseAppCheck.instance.activate(
    providerAndroid:
        Environment.firebaseAppCheckAndroidDebugToken.isNotEmpty
            ? AndroidDebugProvider(
              debugToken: Environment.firebaseAppCheckAndroidDebugToken,
            )
            : AndroidPlayIntegrityProvider(),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Felicette Recipes',
      theme: theme,
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
