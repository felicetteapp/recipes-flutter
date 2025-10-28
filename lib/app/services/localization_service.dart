import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:recipes_flutter/app/utils/secure_storage.dart';

class LocalizationService extends GetxController {
  static const localeEN = Locale('en', 'US');
  static const localeES = Locale('es', 'AR');
  static const localePT = Locale('pt', 'BR');

  static const supportedLocales = [localeEN, localeES, localePT];

  static const localeKey = 'locale';

  final Rx<Locale> _currentLocale = localeEN.obs;

  Locale get currentLocale => _currentLocale.value;

  List<String> get availableCurrencies => [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CNY',
    'BRL',
    'ARS',
  ];

  @override
  void onInit() {
    super.onInit();
    _currentLocale.listen((locale) {
      log('Locale changed to: $locale', name: 'LocalizationService');
      Get.updateLocale(locale);
    });
    _loadLocaleFromStorage();
  }

  void _loadLocaleFromStorage() {
    RFSecureStorage.read(key: LocalizationService.localeKey).then((value) {
      if (value != null) {
        final localeParts = value.split('_');
        if (localeParts.length == 2) {
          final locale = Locale(localeParts[0], localeParts[1]);
          if (isLocaleSupported(locale)) {
            _currentLocale.value = locale;
            Get.updateLocale(locale);
            return;
          }
        }
      }
    });
  }

  void changeLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      _currentLocale.value = locale;
      Get.updateLocale(locale);
      _saveLocaleToStorage(locale);
    }
  }

  void _saveLocaleToStorage(Locale locale) {
    RFSecureStorage.write(
      key: LocalizationService.localeKey,
      value: locale.toString(),
    );
  }

  String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español (AR)';
      case 'pt':
        return 'Português (BR)';
      default:
        return 'English';
    }
  }

  bool isLocaleSupported(Locale locale) {
    return supportedLocales.any(
      (supportedLocale) =>
          supportedLocale.languageCode == locale.languageCode &&
          supportedLocale.countryCode == locale.countryCode,
    );
  }

  String formatCurrency(double amount, String currency) {
    final lc = currentLocale.toString();
    final formatter = NumberFormat.simpleCurrency(locale: lc, name: currency);
    return formatter.format(amount);
  }
}
