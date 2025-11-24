import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/recipes/bloc/recipes_bloc.dart';
import 'package:felicette_recipes/recipes/edit/bloc/edit_cubit.dart';
import 'package:felicette_recipes/recipes/models/recipes.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:uuid/uuid.dart';

class EditRecipePage extends StatelessWidget {
  const EditRecipePage({required this.recipeId, super.key});
  final String recipeId;

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.editRecipe,
      builder: (context, state) => EditRecipePage(
        recipeId: state.pathParameters['recipeId']!,
      ),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      showBackButton: true,
      title: Text(s.edit_recipe.capitalize()),
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
    final initialRecipe = context
        .read<RecipesBloc>()
        .state
        .recipes
        .firstWhereOrNull(
          (recipe) => recipe.id == recipeId,
        );

    log(
      'Building EditRecipePage for recipe: ${initialRecipe?.name}, with ${initialRecipe?.ingredients.length} ingredients',
      name: 'EditRecipePage',
    );
    return BlocProvider(
      create: (context) =>
          EditRecipeCubit(
            recipeRepository: context.read<RecipeRepository>(),
            initialState: const EditRecipeState(),
          )..initEdit(
            groupId: context.read<IngredientsBloc>().state.selectedGroupId!,
            recipeId: recipeId,
            initialRecipe: initialRecipe,
          ),
      child: _WithRecipeBlocListener(
        recipeId: recipeId,
        child: const _EditRecipePageContent(),
      ),
    );
  }
}

class _WithRecipeBlocListener extends StatelessWidget {
  const _WithRecipeBlocListener({
    required this.recipeId,
    required this.child,
  });

  final String recipeId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<RecipesBloc, RecipesState>(
      bloc: context.read<RecipesBloc>(),
      listener: (context, state) {
        final recipe = state.recipes.firstWhereOrNull(
          (recipe) => recipe.id == recipeId,
        );
        log(
          'Recipe updated: ${recipe?.name}, with ${recipe?.ingredients.length} ingredients',
          name: '_WithRecipeBlocListener',
        );
      },
      child: child,
    );
  }
}

class _EditRecipePageContent extends StatelessWidget {
  const _EditRecipePageContent();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocListener<EditRecipeCubit, EditRecipeState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          GoRouter.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.recipe_updated_successfully),
              ),
            );
        } else if (state.status.isFailure) {
          final snackBar = SnackBar(
            content: Text(s.error),
            backgroundColor: theme.colorScheme.error,
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: EditRecipePage.appbar(context),
        body: const SingleChildScrollView(
          padding: .symmetric(vertical: 16),
          child: Column(
            spacing: 16,
            children: [
              _NameInput(),
              _IngredientsQuantityInput(
                key: Key('editRecipePage_ingredientsQuantityInput'),
              ),
            ],
          ),
        ),
        bottomNavigationBar: CrudBottomNavigation(
          actions: [
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
                label: Text(
                  s.cancel,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
            ),
            const Expanded(
              child: _EditButton(),
            ),
            const Expanded(
              child: _ExcludeButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _IngredientsQuantityInput extends StatelessWidget {
  const _IngredientsQuantityInput({super.key});

  String? getErrorMessage(
    RecipeIngredients fieldState,
    S s,
  ) {
    if (fieldState.displayError == RecipeIngredientsValidationError.empty) {
      return s.recipes_should_have_at_least_one_ingredient;
    } else if (fieldState.displayError ==
        RecipeIngredientsValidationError.invalid) {
      return s.recipe_ingredients_error;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final newCubit = context.watch<EditRecipeCubit>();
    final ingredientRepository = context.read<IngredientRepository>();
    final fieldState = newCubit.state.recipeIngredients;

    log(
      '_IngredientsQuantityInput build called with ${fieldState.value.length} items',
      name: '_IngredientsQuantityInput',
    );

    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        children: [
          IngredientsQuantityInput(
            key: const Key('editRecipePage_ingredientsQuantityInput'),
            errorMessage: getErrorMessage(
              fieldState,
              s,
            ),
            generateEmpty: () {
              final uuid = const Uuid().v4();
              return FRRecipeIngredient(
                ingredientId: '',
                quantity: '',
                uuid: uuid,
              );
            },
            createIngredient: ({required String name}) async {
              final newIngredient = await ingredientRepository.createIngredient(
                newCubit.state.groupId,
                FRIngredient(id: '', name: name),
              );
              return newIngredient;
            },
            onChanged: (newValue) {
              log(
                'IngredientsQuantityInput onChanged called with ${newValue.length} items',
                name: 'EditRecipePage._IngredientsQuantityInput',
              );
              newCubit.recipeIngredientsChanged(newValue);
            },
            initialValue: fieldState.value,
          ),
        ],
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  const _EditButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final newCubit = context.watch<EditRecipeCubit>();
    final isSending = newCubit.state.status.isInProgressOrSuccess;

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: newCubit.state.isValid && !isSending
          ? () {
              log('updating recipe...', name: 'EditRecipePage');
              // Save logic here
              newCubit.updateRecipe();
            }
          : null,
      icon: isSending
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.save),
      label: Text(
        s.save.capitalize(),
        maxLines: 1,
        overflow: .ellipsis,
      ),
    );
  }
}

class _ExcludeButton extends StatelessWidget {
  const _ExcludeButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final newCubit = context.watch<EditRecipeCubit>();
    final isSending = newCubit.state.removeStatus.isInProgressOrSuccess;

    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.error,
      ),
      onPressed: isSending
          ? null
          : () async {
              log('removing recipe...', name: 'EditRecipePage');
              // Remove logic here

              final confirmedExclusion = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(s.confirm_recipe_deletion),
                  content: Text(s.confirm_recipe_deletion_message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(s.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(s.delete),
                    ),
                  ],
                ),
              );

              if (confirmedExclusion != null && confirmedExclusion) {
                await newCubit.excludeRecipe();
              } else {
                return;
              }

              if (!context.mounted) return;
              GoRouter.of(context).pop();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(s.recipe_deleted_successfully),
                  ),
                );
            },
      icon: isSending
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.delete),
      label: Text(
        s.delete.capitalize(),
        maxLines: 1,
        overflow: .ellipsis,
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final newCubit = context.watch<EditRecipeCubit>();
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: TextFormField(
        initialValue: newCubit.state.recipeName.value,
        key: const Key('editRecipePage_name_textFormField'),
        decoration: InputDecoration(
          labelText: s.recipe_name.capitalize(),
          errorText: newCubit.state.recipeName.displayError != null
              ? s.input_required_error
              : null,
        ),
        autovalidateMode: .onUserInteraction,
        onChanged: newCubit.recipeNameChanged,
      ),
    );
  }
}
