import 'package:get/get.dart';
import 'en_translations.dart';
import 'es_translations.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    ...EnTranslations().keys,
    ...EsTranslations().keys,
  };
}
