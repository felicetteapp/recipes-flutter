import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/recipes/models/recipes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'new_state.dart';

class NewRecipeCubit extends Cubit<NewRecipeState> {
  NewRecipeCubit({
    required RecipeRepository recipeRepository,
    NewRecipeState? initialState,
  }) : _recipeRepository = recipeRepository,
       super(initialState ?? const NewRecipeState());

  final RecipeRepository _recipeRepository;

  void recipeNameChanged(String value) {
    final recipeName = RecipeName.dirty(value);
    emit(
      state.copyWith(
        recipeName: recipeName,
        isValid: Formz.validate([recipeName, state.recipeIngredients]),
      ),
    );
  }

  void recipeIngredientsChanged(List<FRRecipeIngredient> value) {
    log(
      'NewRecipeCubit.recipeIngredientsChanged called with ${value.length} items',
      name: 'NewRecipeCubit',
    );

    for (final ingredient in value) {
      log(
        'Ingredient ID: ${ingredient.ingredientId}, Quantity: ${ingredient.quantity}, UUID: ${ingredient.uuid}',
        name: 'NewRecipeCubit.recipeIngredientsChanged',
      );
    }
    final recipeIngredients = RecipeIngredients.dirty(value);
    emit(
      state.copyWith(
        recipeIngredients: recipeIngredients,
        isValid: Formz.validate([state.recipeName, recipeIngredients]),
      ),
    );
  }

  void defineGroupId(String groupId) {
    emit(
      state.copyWith(
        groupId: groupId,
      ),
    );
  }

  Future<void> createRecipe() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _recipeRepository.createRecipe(
        state.groupId,
        FRRecipe(
          id: '',
          name: state.recipeName.value,
          ingredients: [],
        ),
      );

      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      log(
        'Error creating ingredient: $e',
        name: 'NewIngredientCubit.createIngredient',
      );
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
