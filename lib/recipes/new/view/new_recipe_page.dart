import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/recipes/models/recipes.dart';
import 'package:felicette_recipes/recipes/new/new.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:uuid/uuid.dart';

class NewRecipePage extends StatelessWidget {
  const NewRecipePage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.newRecipe,
      builder: (context, state) => const NewRecipePage(),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      showBackButton: true,
      title: Text(s.create_recipe.capitalize()),
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
    final uuid = const Uuid().v4();
    return BlocProvider(
      create: (context) =>
          NewRecipeCubit(
            recipeRepository: context.read<RecipeRepository>(),
            initialState: NewRecipeState(
              recipeIngredients: .dirty([
                FRRecipeIngredient(ingredientId: '', quantity: '', uuid: uuid),
              ]),
            ),
          )..defineGroupId(
            context.read<IngredientsBloc>().state.selectedGroupId!,
          ),
      child: const _NewRecipePageContent(),
    );
  }
}

class _NewRecipePageContent extends StatelessWidget {
  const _NewRecipePageContent();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocListener<NewRecipeCubit, NewRecipeState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          GoRouter.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.ingredient_created_successfully),
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
        appBar: NewRecipePage.appbar(context),
        body: const SingleChildScrollView(
          padding: .symmetric(vertical: 16),
          child: Column(
            spacing: 16,
            children: [
              _NameInput(),
              _IngredientsQuantityInput(
                key: Key('newRecipePage_ingredientsQuantityInput'),
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
              child: _CreateButton(),
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
    final newCubit = context.watch<NewRecipeCubit>();
    final ingredientRepository = context.read<IngredientRepository>();
    final fieldState = newCubit.state.recipeIngredients;

    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: Column(
        children: [
          IngredientsQuantityInput(
            key: const Key('newRecipePage_ingredientsQuantityInput'),
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
                name: 'NewRecipePage._IngredientsQuantityInput',
              );
              newCubit.recipeIngredientsChanged(newValue);
            },
            initialValue: newCubit.state.recipeIngredients.value,
          ),
        ],
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final newCubit = context.watch<NewRecipeCubit>();
    final isSending = newCubit.state.status.isInProgressOrSuccess;

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: newCubit.state.isValid && !isSending
          ? () {
              log('Creating ingredient...', name: 'NewIngredientPage');
              // Save logic here
              newCubit.createRecipe();
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
          : const Icon(Icons.add),
      label: Text(
        s.create,
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
    final newCubit = context.watch<NewRecipeCubit>();
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: TextFormField(
        initialValue: newCubit.state.recipeName.value,
        key: const Key('newRecipePage_name_textFormField'),
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
