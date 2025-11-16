import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:felicette_recipes/app/common/environment.dart';
import 'package:felicette_recipes/app/routes/app_router.dart';
import 'package:felicette_recipes/app/services/app_service.dart';
import 'package:felicette_recipes/app/utils/secure_storage.dart';
import 'package:felicette_recipes/authentication/bloc/authentication_bloc.dart';
import 'package:felicette_recipes/firebase_options.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:user_repository/user_repository.dart';

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
    providerApple: Environment.firebaseAppCheckIosDebugToken.isNotEmpty
        ? const AppleDebugProvider(
            debugToken: Environment.firebaseAppCheckIosDebugToken,
          )
        : const AppleDeviceCheckProvider(),
    providerAndroid: Environment.firebaseAppCheckAndroidDebugToken.isNotEmpty
        ? const AndroidDebugProvider(
            debugToken: Environment.firebaseAppCheckAndroidDebugToken,
          )
        : const AndroidPlayIntegrityProvider(),
  );
  runApp(FRApp(initialThemeIsDark: initialThemeIsDark));
}

class FRApp extends StatelessWidget {
  const FRApp({required this.initialThemeIsDark, super.key});
  final bool initialThemeIsDark;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final actualThemeLight = getLightThemeData(lightDynamic);
        final actualThemeDark = getDarkThemeData(darkDynamic);

        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider(
              create: (_) => AuthenticationRepository(),
              dispose: (repository) => repository.dispose(),
            ),
            RepositoryProvider(create: (_) => UserRepository()),
          ],
          child: BlocProvider(
            lazy: false,
            create: (context) => AuthenticationBloc(
              authenticationRepository: context
                  .read<AuthenticationRepository>(),
              userRepository: context.read<UserRepository>(),
            )..add(AuthenticationSubscriptionRequested()),
            child: AppView(
              initialThemeIsDark: initialThemeIsDark,
              themeLight: actualThemeLight,
              themeDark: actualThemeDark,
            ),
          ),
        );
      },
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({
    required this.initialThemeIsDark,
    required this.themeLight,
    required this.themeDark,
    super.key,
  });
  final bool initialThemeIsDark;
  final ThemeData themeLight;
  final ThemeData themeDark;

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    final authenticationBloc = context.read<AuthenticationBloc>();
    _router = createAppRouter(authenticationBloc);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      title: 'Felicette Recipes',
      theme: widget.themeLight,
      darkTheme: widget.themeDark,
      themeMode: widget.initialThemeIsDark ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('en'),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
