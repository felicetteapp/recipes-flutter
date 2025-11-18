import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/authentication/authentication.dart';
import 'package:felicette_recipes/create_account/create_account.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/login/login.dart';
import 'package:felicette_recipes/password_recovery/password_recovery.dart';
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

const protectedRoutes = {
  AppRoutes.home,
};

const guestRoutes = {
  AppRoutes.login,
  AppRoutes.passwordRecovery,
};

const Set<String> publicRoutes = {};

GoRouter createAppRouter(AuthenticationBloc authenticationBloc) {
  return GoRouter(
    routes: [
      SplashPage.route(),
      LoginPage.route(),
      PasswordRecoveryPage.route(),
      CreateAccountPage.route(),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => Scaffold(
          body: Column(
            mainAxisAlignment: .center,
            children: [
              const Text('Home'),
              FilledButton(
                onPressed: () {
                  context.read<AuthenticationBloc>().add(
                    AuthenticationLogoutPressed(),
                  );
                },
                child: Text(S.of(context).logout),
              ),
              FilledButton(
                onPressed: () {
                  context.read<AppBloc>().add(const AppToggleDarkMode());
                },
                child: const Text('toggle dark mode'),
              ),
            ],
          ),
        ),
      ),
    ],
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (context, state) {
      log('Redirecting based on authentication state');
      final authState = context.read<AuthenticationBloc>().state;

      log(
        'Authentication status: ${authState.status}',
        name: 'AppRouter',
      );
      final authIsUnknown = authState.status == AuthenticationStatus.unknown;
      final isAuthenticated =
          authState.status == AuthenticationStatus.authenticated;

      final isOnSplashRoute = state.matchedLocation == AppRoutes.splash;

      if (isOnSplashRoute && authIsUnknown) {
        log(
          'Authentication status is unknown and on splash route. Staying on splash.',
        );
        return null;
      }

      if (isOnSplashRoute && isAuthenticated) {
        log('User is authenticated and on splash route. Redirecting to home.');
        return AppRoutes.home;
      }

      if (isOnSplashRoute && !isAuthenticated) {
        log(
          'User is not authenticated and on splash route. Redirecting to login.',
        );
        return AppRoutes.login;
      }

      final isOnProtectedRoute = protectedRoutes.contains(
        state.matchedLocation,
      );
      final isOnGuestRoute = guestRoutes.contains(state.matchedLocation);
      final isOnPublicRoute = publicRoutes.contains(state.matchedLocation);

      log(
        'isAuthenticated: $isAuthenticated, isOnProtectedRoute: $isOnProtectedRoute, isOnGuestRoute: $isOnGuestRoute, isOnPublicRoute: $isOnPublicRoute',
      );

      if (isOnPublicRoute) {
        return null;
      }

      if (!isAuthenticated && isOnProtectedRoute) {
        log(
          'User is not authenticated and trying to access a protected route. Redirecting to login.',
        );
        return AppRoutes.login;
      }
      if (isAuthenticated && isOnGuestRoute) {
        log(
          'User is authenticated and trying to access a guest route. Redirecting to home.',
        );
        return AppRoutes.home;
      }

      return null;
    },
  );
}
