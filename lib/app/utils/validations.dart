import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:get/get.dart';

class FRValidations {
  static String? validateEmail(String? value, {bool isRequired = true}) {
    if (isRequired && (value == null || value.isEmpty)) {
      return TranslationKeys.inputRequiredError.tr;
    }
    final emailRegex = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );

    if (value == null || value.isEmpty) {
      return TranslationKeys.invalidEmailError.tr;
    }

    if (!emailRegex.hasMatch(value)) {
      return TranslationKeys.invalidEmailError.tr;
    }
    return null;
  }
}
