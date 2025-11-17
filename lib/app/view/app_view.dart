import 'dart:developer';

import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/routes/app_router.dart';
import 'package:felicette_recipes/authentication/bloc/authentication_bloc.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

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
    _router = createAppRouter(
      context.read<AuthenticationBloc>(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppBloc>().state;
    final isDarkModeEnabled = appState.darkMode;
    final currentLocale = appState.locale;

    log(
      'Building AppView with isDarkModeEnabled: $isDarkModeEnabled, locale: $currentLocale',
      name: 'AppView',
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Felicette Recipes',
      theme: widget.themeLight,
      darkTheme: widget.themeDark,
      themeMode: isDarkModeEnabled ? ThemeMode.dark : ThemeMode.light,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: currentLocale,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return child!;
      },
    );
  }
}
