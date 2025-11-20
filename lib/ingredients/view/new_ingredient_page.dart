import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewIngredientPage extends StatelessWidget {
  const NewIngredientPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.newIngredient,
      builder: (context, state) => const NewIngredientPage(),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      showBackButton: true,
      title: Text(s.new_ingredient.capitalize()),
    );
  }

  static NavigationDestination navigationDestination(BuildContext context) {
    final s = S.of(context);
    return NavigationDestination(
      icon: const Icon(Icons.kitchen),
      label: s.ingredient(1).capitalize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _NewIngredientPageContent();
  }
}

class _NewIngredientPageContent extends StatelessWidget {
  const _NewIngredientPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NewIngredientPage.appbar(context),
      body: const Text('teste'),
    );
  }
}
