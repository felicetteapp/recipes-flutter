import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/routes/app_router.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/services/deep_link_service.dart';
import 'package:felicette_recipes/authentication/bloc/authentication_bloc.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/groups/bloc/groups_bloc.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:felicette_recipes/recipes/recipes.dart';
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
  late final DeepLinkService _deepLinkService;
  late final AuthenticationRepository _authenticationRepository;

  @override
  void initState() {
    super.initState();
    _router = createAppRouter(
      context.read<AuthenticationBloc>(),
    );
    _deepLinkService = DeepLinkService();
    _authenticationRepository = context.read<AuthenticationRepository>();
    _initializeDeepLinks();
  }

  void _initializeDeepLinks() {
    log(
      'Initializing deep link service',
      name: 'AppView',
    );
    _deepLinkService.initialize(
      onLink: (uri) {
        log('Deep link received: $uri', name: 'AppView');
        _handleDeepLink(uri);
      },
    );
  }

  void _handleDeepLink(Uri uri) {
    try {
      log('Checking if link is email sign-in link', name: 'AppView');

      if (_authenticationRepository.isSignInWithEmailLink(uri.toString())) {
        log(
          'Email link detected, navigating to login',
          name: 'AppView',
        );

        _router
          ..go(AppRoutes.createAccount)
          ..push<void>(
            AppRoutes.login,
            extra: uri.toString(),
          );
      } else {
        log('No action for this deep link: $uri', name: 'AppView');
      }
    } catch (e) {
      log('Error handling deep link: $e', name: 'AppView');
    }
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppBloc>().state;
    final isDarkModeEnabled = appState.darkMode;
    final currentLocale = appState.locale;

    log(
      'Building isDarkModeEnabled: $isDarkModeEnabled, locale: $currentLocale',
      name: 'AppView',
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) =>
              previous.user?.uid != current.user?.uid,
          listener: (context, state) {
            log(
              'Authentication user changed: ${state.user}',
              name: 'AppView',
            );

            context.read<GroupsBloc>().add(
              GroupAuthUserChanged(state.user),
            );
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listenWhen: (previous, current) =>
              previous.user?.metadataUpdatedAt !=
              current.user?.metadataUpdatedAt,
          listener: (context, state) {
            log(
              'Authentication state changed: ${state.user}',
              name: 'AppView',
            );
            context.read<AuthenticationBloc>().add(
              AuthenticationStatusRefreshRequested(),
            );
          },
        ),
        BlocListener<GroupsBloc, GroupsState>(
          listenWhen: (previous, current) =>
              previous.selectedGroup != current.selectedGroup,
          listener: (context, state) {
            log(
              'Selected group changed: ${state.selectedGroup}',
              name: '_MainShellContent',
            );
            final selectedGroup = state.selectedGroup;
            context.read<IngredientsBloc>().add(
              IngredientSelectedGroupChanged(selectedGroup),
            );
            context.read<RecipesBloc>().add(
              RecipesSelectedGroupChanged(selectedGroup),
            );
            context.read<ListBloc>().add(
              ListSelectedGroupChanged(selectedGroup),
            );
            context.read<ListBloc>().add(
              UpdateCurrentGroupIngredientPrices(
                selectedGroup?.ingredientsPrices ?? {},
              ),
            );
            context.read<ListBloc>().add(
              ListCurrentCheckedIngredientsChanged(
                selectedGroup?.checkedIngredients ?? [],
              ),
            );
            context.read<ListBloc>().add(
              ListShowCheckedsFirstChanged(
                showCheckedsFirst:
                    selectedGroup?.filters.showCheckedsFirst ?? false,
              ),
            );
            context.read<ListBloc>().add(
              ListShowBudgetChanged(
                showBudget: selectedGroup?.filters.showBudget ?? false,
              ),
            );
          },
        ),
        BlocListener<RecipesBloc, RecipesState>(
          listenWhen: (previous, current) =>
              previous.recipes != current.recipes,
          listener: (context, state) {
            context.read<ListBloc>().add(
              UpdateGroupRecipes(state.recipes),
            );
          },
        ),
        BlocListener<IngredientsBloc, IngredientsState>(
          listenWhen: (previous, current) =>
              previous.ingredients != current.ingredients,
          listener: (context, state) {
            context.read<ListBloc>().add(
              UpdateGroupIngredients(state.ingredients),
            );
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state.status == .authenticated) {
              context.read<GroupsBloc>().add(GroupsSubscriptionRequested());
            }
          },
        ),
      ],
      child: MaterialApp.router(
        routerConfig: _router,
        title: 'Felicette Recipes',
        theme: widget.themeLight,
        darkTheme: widget.themeDark,
        themeMode: isDarkModeEnabled ? .dark : .light,
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
      ),
    );
  }
}

class Teste {
  bool isSignInWithEmailLink(String link) {
    // Dummy implementation for testing
    return link.contains('signInWithEmailLink=true');
  }
}
