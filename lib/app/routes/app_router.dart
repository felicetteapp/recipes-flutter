import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/common/widgets/drawer/drawer.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/services/wearos/wearos_service.dart';
import 'package:felicette_recipes/authentication/authentication.dart';
import 'package:felicette_recipes/create_account/create_account.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/groups/groups.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:felicette_recipes/login/login.dart';
import 'package:felicette_recipes/password_recovery/password_recovery.dart';
import 'package:felicette_recipes/recipes/edit/edit.dart';
import 'package:felicette_recipes/recipes/new/new.dart';
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
  log(
    'Creating App Router',
    name: 'AppRouter',
  );
  return GoRouter(
    routes: [
      SplashPage.route(),
      LoginPage.route(),
      PasswordRecoveryPage.route(),
      CreateAccountPage.route(),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navShell) {
          return _MainShellContent(
            navShell: navShell,
            key: const Key('MainShellContent'),
          );
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
      NewRecipePage.route(),
      EditRecipePage.route(),
      EditListPage.route(),
      CreateGroupPage.route(),
      EditGroupPage.route(),
    ],
    refreshListenable: GoRouterRefreshStream(authenticationBloc.stream),
    redirect: (context, state) {
      final authState = context.read<AuthenticationBloc>().state;

      final authIsUnknown = authState.status == AuthenticationStatus.unknown;
      final isAuthenticated =
          authState.status == AuthenticationStatus.authenticated;

      final isOnSplashRoute = state.matchedLocation == AppRoutes.splash;

      if (isOnSplashRoute && authIsUnknown) {
        return null;
      }

      if (isOnSplashRoute && isAuthenticated) {
        return AppRoutes.home;
      }

      if (isOnSplashRoute && !isAuthenticated) {
        return AppRoutes.login;
      }

      final isOnProtectedRoute = protectedRoutes.contains(
        state.matchedLocation,
      );
      final isOnGuestRoute = guestRoutes.contains(state.matchedLocation);
      final isOnPublicRoute = publicRoutes.contains(state.matchedLocation);

      if (isOnPublicRoute) {
        return null;
      }

      if (!isAuthenticated && isOnProtectedRoute) {
        return AppRoutes.login;
      }
      if (isAuthenticated && isOnGuestRoute) {
        return AppRoutes.home;
      }

      return null;
    },
  );
}

class _MainShellContent extends StatelessWidget {
  const _MainShellContent({required this.navShell, super.key});
  final StatefulNavigationShell navShell;

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
    log(
      'Building MainShellContent with currentIndex: ${navShell.currentIndex}',
      name: '_MainShellContent',
    );
    final s = S.of(context);
    return BlocListener<ListBloc, ListState>(
      listener: (context, state) {
        log(
          // ignore: lines_longer_than_80_chars
          'Current ingredients in ListBloc changed: ${state.currentIngredients.length} items',
          name: 'AppView',
        );
        try {
          WearOSService.instance.sendCurrentIngredients(
            currentIngredients: state.listItemsAsIngredientDisplayType
                .where((item) {
                  return item.type == .ingredient;
                })
                .map(
                  (item) => item.ingredientItem!,
                )
                .toList(),
            s: s,
          );
        } catch (e) {
          log(
            'Error sending ingredients to WearOS: $e',
            name: 'AppView',
          );
        }
      },
      listenWhen: (previous, current) =>
          previous.listItemsAsIngredientDisplayType !=
          current.listItemsAsIngredientDisplayType,

      child: Scaffold(
        body: navShell,
        drawer: const FRDrawer(),
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
