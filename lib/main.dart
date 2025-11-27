import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/common/environment.dart';
import 'package:felicette_recipes/app/view/app_view.dart';
import 'package:felicette_recipes/authentication/bloc/authentication_bloc.dart';
import 'package:felicette_recipes/firebase_options.dart';
import 'package:felicette_recipes/groups/groups.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:felicette_recipes/recipes/recipes.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:user_repository/user_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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

  final authenticationRepository = AuthenticationRepository();
  final teste = await authenticationRepository.user.first;

  log('Current user at startup: $teste', name: 'main');

  final userRepository = UserRepository();
  final authCurrentUser = authenticationRepository.currentUser;

  log('Current authenticated user: $authCurrentUser', name: 'main');
  if (authCurrentUser != null) {
    final testeU = await userRepository.getUserFromAuthenticatedUser(
      authCurrentUser,
    );
    log('Fetched user data: $testeU', name: 'main');
  }

  final appBloc = AppBloc(
    authenticationRepository: authenticationRepository,
    userRepository: userRepository,
  );

  final initialThemeIsDark = await appBloc.getInitialDarkModeSetting();
  log(
    'Setting initial dark mode to $initialThemeIsDark',
    name: 'main',
  );
  appBloc.add(AppSetDarkMode(isDarkMode: initialThemeIsDark));

  final initialLocale = await appBloc.getInitialLocale();
  log(
    'Setting initial locale to $initialLocale',
    name: 'main',
  );
  appBloc.add(AppSetLanguage(locale: initialLocale));

  runApp(
    FRApp(
      initialThemeIsDark: initialThemeIsDark,
      authenticationRepository: authenticationRepository,
      userRepository: userRepository,
      appBloc: appBloc,
    ),
  );
}

class FRApp extends StatelessWidget {
  const FRApp({
    required this.initialThemeIsDark,
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    required AppBloc appBloc,
    super.key,
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository,
       _appBloc = appBloc;
  final bool initialThemeIsDark;
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final AppBloc _appBloc;

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        final actualThemeLight = getLightThemeData(lightDynamic);
        final actualThemeDark = getDarkThemeData(darkDynamic);

        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: _authenticationRepository),
            RepositoryProvider.value(value: _userRepository),
            RepositoryProvider(create: (context) => IngredientRepository()),
            RepositoryProvider(create: (context) => GroupRepository()),
            RepositoryProvider(create: (context) => RecipeRepository()),
          ],
          child: _getMultiProvider(
            _appBloc,
            initialThemeIsDark,
            actualThemeLight,
            actualThemeDark,
          ),
        );
      },
    );
  }
}

Widget _getMultiProvider(
  AppBloc appBloc,
  bool initialThemeIsDark,
  ThemeData actualThemeLight,
  ThemeData actualThemeDark,
) => MultiBlocProvider(
  providers: [
    BlocProvider(
      lazy: false,
      create: (context) => AuthenticationBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
        userRepository: context.read<UserRepository>(),
      )..add(AuthenticationSubscriptionRequested()),
    ),
    BlocProvider.value(value: appBloc),
    BlocProvider(
      create: (context) => RecipesBloc(
        groupRepository: context.read<GroupRepository>(),
        recipeRepository: context.read<RecipeRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => IngredientsBloc(
        ingredientRepository: context.read<IngredientRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => ListBloc(
        groupRepository: context.read<GroupRepository>(),
      ),
    ),
    BlocProvider(
      create: (context) => GroupsBloc(
        groupRepository: context.read<GroupRepository>(),
        userRepository: context.read<UserRepository>(),
      )..add(GroupsSubscriptionRequested()),
    ),
  ],
  child: AppView(
    initialThemeIsDark: initialThemeIsDark,
    themeLight: actualThemeLight,
    themeDark: actualThemeDark,
  ),
);
