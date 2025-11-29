import 'package:felicette_recipes/app/utils/validations.dart';
import 'package:formz/formz.dart';

enum UsernameValidationError { empty, invalid }

class Username extends FormzInput<String, UsernameValidationError> {
  const Username.pure() : super.pure('');
  const Username.dirty([super.value = '']) : super.dirty();

  @override
  UsernameValidationError? validator(String value) {
    if (value.isEmpty) return UsernameValidationError.empty;
    return FRValidations.validateEmail(value) == null
        ? null
        : UsernameValidationError.invalid;
  }
}
