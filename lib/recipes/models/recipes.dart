import 'dart:developer';

import 'package:formz/formz.dart';
import 'package:recipe_repository/recipe_repository.dart';

enum RecipetNameValidationError { empty }

class RecipeName extends FormzInput<String, RecipetNameValidationError> {
  const RecipeName.pure() : super.pure('');
  const RecipeName.dirty([super.value = '']) : super.dirty();

  @override
  RecipetNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : RecipetNameValidationError.empty;
  }
}

enum RecipeIngredientsValidationError { invalid, empty }

class RecipeIngredients
    extends
        FormzInput<List<FRRecipeIngredient>, RecipeIngredientsValidationError> {
  const RecipeIngredients.pure() : super.pure(const []);
  const RecipeIngredients.dirty([super.value = const []]) : super.dirty();

  @override
  RecipeIngredientsValidationError? validator(List<FRRecipeIngredient> value) {
    log(
      'Validating RecipeIngredients with ${value.length} items',
      name: 'RecipeIngredients.validator',
    );
    if (value.isEmpty) {
      log(
        'Validation failed: RecipeIngredients is empty',
        name: 'RecipeIngredients.validator',
      );
      return RecipeIngredientsValidationError.empty;
    }
    for (final ingredient in value) {
      log(
        'Validating ingredient with ID: ${ingredient.ingredientId} and quantity: ${ingredient.quantity}',
        name: 'RecipeIngredients.validator',
      );
      if (ingredient.ingredientId.isEmpty) {
        log(
          'Validation failed: Ingredient with empty ID found',
          name: 'RecipeIngredients.validator',
        );
        return RecipeIngredientsValidationError.invalid;
      }
    }
    return null;
  }
}
