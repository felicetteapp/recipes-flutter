import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class LocalizationService extends GetxController {
  static const localeEN = Locale('en', 'US');
  static const localeES = Locale('es', 'AR');

  static const supportedLocales = [localeEN, localeES];

  static const localeKey = 'locale';

  final Rx<Locale> _currentLocale = localeEN.obs;

  Locale get currentLocale => _currentLocale.value;

  @override
  void onInit() {
    super.onInit();
    _loadLocaleFromStorage();
  }

  void _loadLocaleFromStorage() {
    // TODO: Implement loading locale from persistent storage
    _currentLocale.value = localeEN;
  }

  void changeLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      _currentLocale.value = locale;
      Get.updateLocale(locale);
      _saveLocaleToStorage(locale);
    }
  }

  void _saveLocaleToStorage(Locale locale) {
    // TODO: Implement saving locale to persistent storage
  }

  String getLocaleName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
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
