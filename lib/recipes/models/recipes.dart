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

enum RecipeIngredientsValidationError { invalid }

class RecipeIngredients
    extends
        FormzInput<List<FRRecipeIngredient>, RecipeIngredientsValidationError> {
  const RecipeIngredients.pure() : super.pure(const []);
  const RecipeIngredients.dirty([super.value = const []]) : super.dirty();

  @override
  RecipeIngredientsValidationError? validator(List<FRRecipeIngredient> value) {
    // No validation needed for ingredients list
    return null;
  }
}
