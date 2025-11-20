import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/common/widgets/drawer/drawer.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/authentication/authentication.dart';
import 'package:felicette_recipes/create_account/create_account.dart';
import 'package:felicette_recipes/groups/bloc/groups_bloc.dart';
import 'package:felicette_recipes/ingredients/edit/edit.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/ingredients/new/new.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:felicette_recipes/login/login.dart';
import 'package:felicette_recipes/password_recovery/password_recovery.dart';
import 'package:felicette_recipes/recipes/recipes.dart';
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
  AppRoutes.recipes,
  AppRoutes.list,
  AppRoutes.ingredients,
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
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) {
          return _MainShellContent(navShell: navShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              RecipesPage.route(),
            ],
          ),
          StatefulShellBranch(
            routes: [
              ListPage.route(),
            ],
          ),
          StatefulShellBranch(
            routes: [
              IngredientsPage.route(),
            ],
          ),
        ],
      ),
      NewIngredientPage.route(),
      EditIngredientPage.route(),
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

class _MainShellContent extends StatelessWidget {
  const _MainShellContent({required this.navShell, super.key});
  final StatefulNavigationShell navShell;

  Widget? _floatingActionButton(BuildContext context) {
    if (navShell.currentIndex == 0) {
      return RecipesPage.floatingActionButton(context);
    }
    return null;
  }

  FRAppbar _appBar(BuildContext context) {
    if (navShell.currentIndex == 0) {
      return RecipesPage.appbar(context);
    } else if (navShell.currentIndex == 1) {
      return ListPage.appbar(context);
    } else {
      return IngredientsPage.appbar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            log(
              'AuthenticationBloc state changed: $state',
              name: 'AppRouter',
            );
            if (state.status == AuthenticationStatus.authenticated) {
              log(
                'User authenticated: ${state.user} - Groups subscription requested',
                name: 'AppRouter',
              );
              context.read<GroupsBloc>().add(GroupsSubscriptionRequested());
            }
          },
        ),
        BlocListener<GroupsBloc, GroupsState>(
          listener: (context, state) {
            log(
              'GroupsBloc state changed: $state',
              name: 'AppRouter',
            );

            final selectedGroup = state.selectedGroup;
            context.read<IngredientsBloc>().add(
              IngredientSelectedGroupChanged(selectedGroup),
            );
          },
        ),
      ],
      child: Scaffold(
        body: navShell,
        drawer: const FRDrawer(),
        floatingActionButton: _floatingActionButton(context),
        appBar: _appBar(context),
        bottomNavigationBar: NavigationBar(
          selectedIndex: navShell.currentIndex,
          onDestinationSelected: navShell.goBranch,
          destinations: [
            RecipesPage.navigationDestination(context),
            ListPage.navigationDestination(context),
            IngredientsPage.navigationDestination(context),
          ],
        ),
      ),
    );
  }
}
