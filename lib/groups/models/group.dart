import 'package:formz/formz.dart';

enum GroupNameValidationError { empty }

class GroupName extends FormzInput<String, GroupNameValidationError> {
  const GroupName.pure() : super.pure('');
  const GroupName.dirty([super.value = '']) : super.dirty();

  @override
  GroupNameValidationError? validator(String value) {
    return value.isNotEmpty ? null : GroupNameValidationError.empty;
  }
}
