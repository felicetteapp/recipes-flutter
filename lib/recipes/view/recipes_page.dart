import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/recipes/bloc/recipes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  static NavigationDestination navigationDestination(BuildContext context) {
    final s = S.of(context);
    return NavigationDestination(
      icon: const Icon(Icons.book),
      label: s.recipe(1).capitalize(),
    );
  }

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.recipes,
      builder: (context, state) => const RecipesPage(),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);
    final recipesBloc = context.watch<RecipesBloc>();

    final isSelecting = recipesBloc.state.isSelecting;

    return FRAppbar(
      selectingMode: isSelecting,
      leading: !isSelecting
          ? null
          : IconButton(
              onPressed: () {
                recipesBloc.add(const RecipesSelectionToggled());
              },
              icon: const Icon(Icons.close),
            ),
      title: isSelecting
          ? Text(
              s.items_selected(
                recipesBloc.state.selectedGroupCurrentListRecipeIds.length,
              ),
            )
          : Text(s.recipe(1).capitalize()),
      actions: [
        if (!isSelecting)
          TextButton(
            onPressed: () {
              recipesBloc.add(const RecipesSelectionToggled());
            },
            child: Text(s.select_recipes),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const _RecipesPageContent();
  }
}

class _FloatingActionButton extends StatelessWidget {
  const _FloatingActionButton();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final recipesBloc = context.watch<RecipesBloc>();

    if (recipesBloc.state.isSelecting) {
      return FloatingActionButton.large(
        key: const Key('recipesPage_floatingActionButton_bulkActions'),
        heroTag: 'recipesPage_fab_bulkActions',
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        child: const Icon(Icons.save),
        onPressed: () {
          // TODO: Implement bulk actions
        },
      );
    }

    return FloatingActionButton.extended(
      key: const Key('recipesPage_floatingActionButton_addRecipe'),
      heroTag: 'recipesPage_fab_addRecipe',
      onPressed: () {
        context.push(AppRoutes.newRecipe);
      },
      icon: const Icon(Icons.add),
      label: Text(s.add_recipe),
    );
  }
}

class _RecipesPageContent extends StatelessWidget {
  const _RecipesPageContent();

  @override
  Widget build(BuildContext context) {
    final recipesBloc = context.watch<RecipesBloc>();
    return Scaffold(
      floatingActionButton: const _FloatingActionButton(),
      body: ListView.builder(
        padding: const .only(bottom: 92, top: 4),
        itemBuilder: (context, index) {
          final recipe = recipesBloc.state.recipes[index];
          return _ListItem(
            recipe: recipe,
            first: index == 0,
            last: index == recipesBloc.state.recipes.length - 1,
          );
        },
        itemCount: recipesBloc.state.recipes.length,
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  const _ListItem({
    required this.recipe,
    this.first = false,
    this.last = false,
  });

  final FRRecipe recipe;
  final bool first;
  final bool last;

  String get id => recipe.id;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final recipesBloc = context.watch<RecipesBloc>();
    final selectionModeIsEnabled = recipesBloc.state.isSelecting;
    final isSelected = recipesBloc.state.selectedRecipeIds.contains(id);
    final isInList = recipesBloc.state.selectedGroupCurrentListRecipeIds
        .contains(id);

    final ingredientsBloc = context.watch<IngredientsBloc>();
    final recipesIngredientIds = recipe.ingredients
        .map((e) => e.ingredientId)
        .toSet();
    final recipesIngredients = ingredientsBloc.state.ingredients
        .where((ing) => recipesIngredientIds.contains(ing.id))
        .toList();

    return Padding(
      padding: const .symmetric(vertical: 1, horizontal: 8),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: .only(
            topLeft: .circular(first ? 16 : 4),
            topRight: .circular(first ? 16 : 4),
            bottomLeft: .circular(last ? 16 : 4),
            bottomRight: .circular(last ? 16 : 4),
          ),
        ),
        tileColor: colorScheme.surfaceContainer,
        visualDensity: .compact,
        contentPadding: .only(
          left: selectionModeIsEnabled ? 4 : 20,
          right: selectionModeIsEnabled ? 24 : 4,
        ),
        isThreeLine: true,
        leading: selectionModeIsEnabled
            ? Padding(
                padding: const .only(left: 8),
                child: Checkbox(
                  visualDensity: .compact,
                  materialTapTargetSize: .shrinkWrap,
                  value: isSelected,
                  onChanged: (checked) {
                    recipesBloc.add(RecipesToggleRecipeSelection(id));
                  },
                  activeColor: colorScheme.secondary,
                ),
              )
            : null,
        trailing: !selectionModeIsEnabled
            ? Row(
                spacing: 4,
                mainAxisSize: .min,
                children: [
                  IconButton(
                    onPressed: () {
                      // TODO: Implement edit recipe
                    },
                    icon: const Icon(Icons.edit),
                  ),
                ],
              )
            : null,
        title: Wrap(
          spacing: 8,
          crossAxisAlignment: .center,
          children: [
            Text(recipe.name),
            if (isInList && !selectionModeIsEnabled)
              Container(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: .circular(8),
                ),
                padding: const .symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  mainAxisAlignment: .center,
                  mainAxisSize: .min,
                  spacing: 2,
                  children: [
                    Icon(
                      Icons.list,
                      size: 14,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    Text(
                      s.on_list.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        height: 0.8,
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: .bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        subtitle: Text(recipesIngredients.map((e) => e.name).join(', ')),
        onTap: selectionModeIsEnabled
            ? () {
                recipesBloc.add(RecipesToggleRecipeSelection(id));
              }
            : null,
        onLongPress: selectionModeIsEnabled
            ? null
            : () {
                recipesBloc.add(const RecipesSelectionToggled());
              },
      ),
    );
  }
}
