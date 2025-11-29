import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FRUtils {
  static List<String> availableCurrencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CNY',
    'INR',
    'BRL',
    'ARS',
  ];

  static String getCurrencyName(String currencyCode, BuildContext context) {
    final s = S.of(context);
    final currencyNames = {
      'USD': s.currency_usd,
      'EUR': s.currency_eur,
      'GBP': s.currency_gbp,
      'JPY': s.currency_jpy,
      'CNY': s.currency_cny,
      'INR': s.currency_inr,
      'BRL': s.currency_brl,
      'ARS': s.currency_ars,
    };
    return currencyNames[currencyCode] ?? currencyCode;
  }

  static String getCurrencySymbol(String currencyCode) {
    final currencySymbols = {
      'USD': r'$',
      'EUR': '€',
      'GBP': '£',
      'JPY': '¥',
      'CNY': '¥',
      'INR': '₹',
      'BRL': r'R$',
      'ARS': r'$',
    };
    return currencySymbols[currencyCode] ?? currencyCode;
  }

  static Future<void> showAboutDialog(BuildContext context) async {
    final packageInfo = await PackageInfo.fromPlatform();
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final s = S.of(context);
        return AboutDialog(
          applicationName: s.application_name,
          applicationVersion:
              '${packageInfo.version} (${packageInfo.buildNumber})',
          applicationIcon: Image.asset(
            'assets/images/logo.png',
            width: 50,
            height: 50,
          ),
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                ),
                children: [
                  TextSpan(
                    text: '${s.application_description}\n\n',
                  ),
                  TextSpan(text: s.developed_with_love),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: s.love_and_cats,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const TextSpan(text: ' '),
                  TextSpan(text: s.developed_in),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: '${s.developed_by}\n\n',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: s.checkout_github),
                  WidgetSpan(
                    child: GestureDetector(
                      onTap: () {
                        // Open GitHub link
                      },
                      child: Text(
                        'github.com/felicetteapp/recipes-flutter',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  const TextSpan(text: '\n\n'),
                  TextSpan(text: packageInfo.packageName),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  static String getLocaleName(Locale locale) {
    final languageNames = {
      'en': 'English',
      'es': 'Español',
      'pt': 'Português',
    };
    return languageNames[locale.languageCode] ?? locale.languageCode;
  }

  static Future<void> showLanguageSelectionDialog(BuildContext context) async {
    final response = await showDialog<Locale>(
      context: context,
      builder: (context) {
        final s = S.of(context);

        return SimpleDialog(
          title: Text(s.select_language),
          children: S.delegate.supportedLocales.map((
            locale,
          ) {
            return SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, locale);
              },
              child: Text(
                getLocaleName(locale),
              ),
            );
          }).toList(),
        );
      },
    );

    if (response != null) {
      if (!context.mounted) {
        return;
      }
      context.read<AppBloc>().add(
        AppSetLanguage(locale: response),
      );
    }
  }
}
