import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/recipes/models/recipes.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:recipe_repository/recipe_repository.dart';

part 'edit_state.dart';

class EditRecipeCubit extends Cubit<EditRecipeState> {
  EditRecipeCubit({
    required RecipeRepository recipeRepository,
    EditRecipeState? initialState,
  }) : _recipeRepository = recipeRepository,
       super(initialState ?? const EditRecipeState());

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

  void initEdit({
    required String recipeId,
    required String groupId,
    FRRecipe? initialRecipe,
  }) {
    log(
      'initEdit called with recipeId: $recipeId, groupId: $groupId',
      name: 'EditRecipeCubit',
    );

    emit(
      state.copyWith(
        groupId: groupId,
        recipeId: recipeId,
        recipeIngredients: initialRecipe != null
            ? RecipeIngredients.dirty(initialRecipe.ingredients)
            : const RecipeIngredients.pure(),
        recipeName: initialRecipe != null
            ? RecipeName.dirty(initialRecipe.name)
            : const RecipeName.pure(),
        isValid:
            initialRecipe != null &&
            Formz.validate([
              RecipeName.dirty(initialRecipe.name),
              RecipeIngredients.dirty(initialRecipe.ingredients),
            ]),
      ),
    );
  }

  void recipeIngredientsChanged(List<FRRecipeIngredient> value) {
    log(
      'recipeIngredientsChanged called with ${value.length} items',
      name: 'EditRecipeCubit',
    );

    for (final ingredient in value) {
      log(
        'ID: $ingredient',
        name: 'EditRecipeCubit.recipeIngredientsChanged',
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

  Future<void> updateRecipe() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      log(
        'Updating name: ${state.recipeName.value} in group: ${state.groupId}',
        name: 'EditRecipeCubit.updateRecipe',
      );
      await _recipeRepository.updateRecipe(
        state.groupId,
        FRRecipe(
          id: state.recipeId,
          name: state.recipeName.value,
          ingredients: state.recipeIngredients.value,
        ),
      );

      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      log(
        'Error updating recipe: $e',
        name: 'EditRecipeCubit.updateRecipe',
      );
      emit(
        state.copyWith(
          status: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> excludeRecipe() async {
    emit(state.copyWith(removeStatus: FormzSubmissionStatus.inProgress));
    try {
      log(
        'Excluding recipe id: ${state.recipeId} from group: ${state.groupId}',
        name: 'EditRecipeCubit.excludeRecipe',
      );
      await _recipeRepository.deleteRecipe(
        state.groupId,
        FRRecipe(id: state.recipeId, name: '', ingredients: []),
      );

      if (isClosed) {
        return;
      }
      emit(state.copyWith(removeStatus: FormzSubmissionStatus.success));
    } catch (e) {
      log(
        'Error excluding recipe: $e',
        name: 'EditRecipeCubit.excludeRecipe',
      );
      emit(
        state.copyWith(
          removeStatus: FormzSubmissionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
