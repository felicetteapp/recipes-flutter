import 'dart:developer';

import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/utils/utils.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// TODO: fix services

class localizationService {
  static String getLocaleName(Locale locale) {
    return locale.countryCode.toString();
  }

  static List<Locale> get supportedLocales {
    return [
      const Locale('en', 'US'),
      const Locale('es', 'ES'),
      const Locale('fr', 'FR'),
    ];
  }

  static void changeLocale(Locale locale) {}
}

class appService {
  static Future<void> toggleTheme() async {}
}

class FRFooter extends StatelessWidget {
  const FRFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.tertiary,
    );
    return Container(
      padding: const .symmetric(vertical: 16.0),
      alignment: .center,
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: .spaceBetween,
            children: [
              const Expanded(child: Divider()),
              Text(
                S.of(context).application_name,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Expanded(child: Divider()),
            ],
          ),
          Wrap(
            alignment: .center,
            runAlignment: .center,
            crossAxisAlignment: .center,
            spacing: 8,
            children: [
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.info_outline),
                onPressed: () async {
                  log('Language selection dialog opened', name: 'FRFooter');
                  await FRUtils.showAboutDialog(context);
                },
                label: Text(S.of(context).about),
              ),
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.language),
                onPressed: () async {
                  /*   final response = await Get.dialog<Locale>(
                    SimpleDialog(
                      title: const Text(TranslationKeys.selectLanguage),
                      children: LocalizationService.supportedLocales.map((
                        locale,
                      ) {
                        return SimpleDialogOption(
                          onPressed: () {},
                          child: Text(
                            localizationService.getLocaleName(locale),
                          ),
                        );
                      }).toList(),
                    ),
                  ); 

                  if (response != null) {
                    localizationService.changeLocale(response);
                  } */
                },
                label: Text(S.of(context).language),
              ),
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.brightness_6),
                label: Text(S.of(context).theme),
                onPressed: () async {
                  context.read<AppBloc>().add(const AppToggleDarkMode());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
