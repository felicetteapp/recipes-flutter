import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/authentication/authentication.dart';
import 'package:felicette_recipes/login/login.dart';
import 'package:felicette_recipes/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createAppRouter(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    routes: [
      SplashPage.route(),
      LoginPage.route(),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, __) => const Scaffold(
          body: Center(child: Text('Home')),
        ),
      ),
    ],
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (context, state) {
      log('Redirecting based on authentication state');
      final authState = context.read<AuthenticationBloc>().state;
      final isAuthenticated =
          authState.status == AuthenticationStatus.authenticated;
      final isOnLoginPage = state.matchedLocation == AppRoutes.login;
      final isOnSplashPage = state.matchedLocation == AppRoutes.splash;

      log(
        'isAuthenticated: $isAuthenticated, isOnLoginPage: $isOnLoginPage, isOnSplashPage: $isOnSplashPage',
      );

      if (!isAuthenticated && !isOnLoginPage) {
        return AppRoutes.login;
      }

      if (isAuthenticated && (isOnLoginPage || isOnSplashPage)) {
        return AppRoutes.home;
      }

      return null;
    },
  );
}
