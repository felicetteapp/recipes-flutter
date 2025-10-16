import 'package:get/get.dart';
import 'translation_keys.dart';

class TranslationHelper {
  static String getMinLengthError(int minLength) {
    return TranslationKeys.nameMinLength.trParams({
      'min': minLength.toString(),
    });
  }

  static String getMaxLengthError(int maxLength) {
    return TranslationKeys.nameMaxLength.trParams({
      'max': maxLength.toString(),
    });
  }
}
