import 'package:formz/formz.dart';

enum IngredientNameValidationError { empty }

class IngredientName extends FormzInput<String, IngredientNameValidationError> {
  const IngredientName.pure() : super.pure('');
  const IngredientName.dirty([super.value = '']) : super.dirty();

  @override
  IngredientNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : IngredientNameValidationError.empty;
  }
}

enum IngredientQuantityValidationError { invalid }

class IngredientQuantity
    extends FormzInput<String, IngredientQuantityValidationError> {
  const IngredientQuantity.pure() : super.pure('');
  const IngredientQuantity.dirty([super.value = '']) : super.dirty();

  @override
  IngredientQuantityValidationError? validator(String value) {
    return null;
  }
}
