import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/recipes/bloc/recipes_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RecipesPage extends StatelessWidget {
  const RecipesPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.recipes,
      builder: (context, state) => const RecipesPage(),
    );
  }

  static Widget floatingActionButton(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final recipesBloc = context.watch<RecipesBloc>();

    if (recipesBloc.state.isSelecting) {
      return FloatingActionButton.large(
        key: const Key('recipes_page_fab_bulk_actions'),
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
        child: const Icon(Icons.save),
        onPressed: () {
          // TODO: Implement bulk actions
        },
      );
    }

    return FloatingActionButton.extended(
      key: const Key('recipes_page_fab_bulk_actions'),
      onPressed: () {
        // TODO: Implement add recipe
      },
      icon: const Icon(Icons.add),
      label: Text(s.add_recipe),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);
    final recipesBloc = context.watch<RecipesBloc>();

    return FRAppbar(
      selectingMode: recipesBloc.state.isSelecting,
      leading: !recipesBloc.state.isSelecting
          ? null
          : IconButton(
              onPressed: () {
                recipesBloc.add(const RecipesSelectionToggled());
              },
              icon: const Icon(Icons.close),
            ),
      title: Text(s.recipe(1).capitalize()),
      actions: [
        if (!recipesBloc.state.isSelecting)
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

class _RecipesPageContent extends StatelessWidget {
  const _RecipesPageContent();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(S.of(context).recipe(1).capitalize()),
    );
  }
}
