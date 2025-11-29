import 'package:formz/formz.dart';

enum IngredientQuantityInputIngredientError {
  empty,
}

class IngredientQuantityInputIngredient
    extends FormzInput<String, IngredientQuantityInputIngredientError> {
  const IngredientQuantityInputIngredient.pure() : super.pure('');
  const IngredientQuantityInputIngredient.dirty([super.value = ''])
    : super.dirty();
  @override
  IngredientQuantityInputIngredientError? validator(String value) {
    return value.isNotEmpty
        ? null
        : IngredientQuantityInputIngredientError.empty;
  }
}
