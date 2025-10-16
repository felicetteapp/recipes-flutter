import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';

class EnTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      TranslationKeys.nameMinLength: 'Name must be at least @min characters',
      TranslationKeys.nameMaxLength: 'Name cannot exceed @max characters',
    },
  };
}
