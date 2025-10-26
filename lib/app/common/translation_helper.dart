import 'package:get/get.dart';
import 'translation_keys.dart';

const currencyToTranslationKey = {
  'USD': TranslationKeys.currencyUSD,
  'EUR': TranslationKeys.currencyEUR,
  'GBP': TranslationKeys.currencyGBP,
  'JPY': TranslationKeys.currencyJPY,
  'CNY': TranslationKeys.currencyCNY,
  'BRL': TranslationKeys.currencyBRL,
  'ARS': TranslationKeys.currencyARS,
};

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

  static String? currencyName(String code) {
    final translationKey = currencyToTranslationKey[code];
    if (translationKey != null) {
      return translationKey.tr;
    }
    return null;
  }

  static String currencyLabel(String code) {
    final currencyName = TranslationHelper.currencyName(code);
    final parts = [];
    if (currencyName != null) {
      parts.add(currencyName);
    }
    parts.add('($code)');
    return parts.join(' ');
  }

  static String plural(String key, int count, {Map<String, String>? params}) {
    return key.trPluralParams(
      TranslationKeys.pluralKey(key),
      count,
      params ?? {'count': count.toString()},
    );
  }
}
