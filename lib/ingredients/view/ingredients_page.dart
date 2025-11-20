import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

class IngredientsPage extends StatelessWidget {
  const IngredientsPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.ingredients,
      builder: (context, state) => const IngredientsPage(),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      title: Text(s.ingredient(0).capitalize()),
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
    return const _IngredientsPageContent();
  }
}

class _IngredientsPageContent extends StatelessWidget {
  const _IngredientsPageContent();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final ingredientsBloc = context.watch<IngredientsBloc>();
    final ingredients = ingredientsBloc.state.ingredients;

    final actualIngredients = ingredients
        .where((ing) => ing.actualIngredient)
        .toList();
    final nonActualIngredients = ingredients
        .where((ing) => !ing.actualIngredient)
        .toList();

    final itemCount = ingredients.length + 2;

    if (ingredients.isEmpty) {
      return const _ListEmptyState();
    }

    return Scaffold(
      body: ListView.builder(
        padding: const .only(bottom: 100),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: Text(
                s.actual_ingredients,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.kitchen_outlined),
              subtitle: Text(s.actual_ingredients_subtitle),
            );
          }

          if (index == actualIngredients.length + 1) {
            return ListTile(
              title: Text(
                s.non_actual_ingredients,

                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.shopping_cart_outlined),
              subtitle: Text(s.non_actual_ingredients_subtitle),
            );
          }

          if (index <= actualIngredients.length) {
            final ingredient = actualIngredients[index - 1];
            return _ListItem(ingredient: ingredient);
          } else {
            final ingredient =
                nonActualIngredients[index - actualIngredients.length - 2];
            return _ListItem(ingredient: ingredient);
          }
        },
        itemCount: itemCount,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Action to add a new ingredient
          context.push(AppRoutes.newIngredient);
        },
        tooltip: s.add_ingredient,
        icon: const Icon(Icons.add),
        label: Text(s.add_ingredient),
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({required FRIngredient ingredient})
    : _ingredient = ingredient;

  final FRIngredient _ingredient;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ListTile(
      visualDensity: .compact,
      contentPadding: const .only(left: 4, right: 4),
      title: Text(_ingredient.name),
      leading: Padding(
        padding: const .only(left: 12, right: 6),
        child: Icon(
          _ingredient.actualIngredient ? Icons.kitchen : Icons.shopping_cart,
          color: _ingredient.actualIngredient
              ? colorScheme.primary
              : colorScheme.secondary,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          context.push(
            AppRoutes.toEditIngredient(_ingredient.id),
          );

          /*          Get.dialog(
            EditIngredientModal(
              groupId: groupsService.selectedGroup.value!.id,
              ingredient: ingredient,
            ),
            useSafeArea: false,
          ); */
        },
        icon: const Icon(Icons.edit),
      ),
    );
  }
}

class _ListEmptyState extends StatelessWidget {
  const _ListEmptyState();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: const .all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: .center,
                children: [
                  Text(
                    s.no_ingredients_created,
                    style: textTheme.titleMedium,
                    textAlign: .center,
                  ),
                  Text(
                    s.no_ingredients_created_description,
                    style: textTheme.bodyMedium,
                    textAlign: .center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
