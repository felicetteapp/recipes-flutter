import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/services/app_service.dart';
import 'package:felicette_recipes/app/services/localization_service.dart';
import 'package:felicette_recipes/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FRFooter extends StatelessWidget {
  const FRFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final LocalizationService localizationService =
        Get.find<LocalizationService>();
    final AppService appService = Get.find<AppService>();

    final ButtonStyle buttonStyle = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.tertiary,
    );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      alignment: Alignment.center,
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Divider()),
              Text(
                TranslationKeys.applicationName.tr,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Expanded(child: Divider()),
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            runAlignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            children: [
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.info_outline),
                onPressed: () async {
                  FRUtils.showAboutDialog(context);
                },
                label: Text(TranslationKeys.about.tr),
              ),
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.language),
                onPressed: () async {
                  final response = await Get.dialog<Locale>(
                    SimpleDialog(
                      title: Text(TranslationKeys.selectLanguage.tr),
                      children:
                          LocalizationService.supportedLocales.map((locale) {
                            return SimpleDialogOption(
                              onPressed: () {
                                Get.back(result: locale);
                              },
                              child: Text(
                                localizationService.getLocaleName(locale),
                              ),
                            );
                          }).toList(),
                    ),
                  );

                  if (response != null) {
                    localizationService.changeLocale(response);
                  }
                },
                label: Text(TranslationKeys.language.tr),
              ),
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.brightness_6),
                label: Text(TranslationKeys.theme.tr),
                onPressed: () async {
                  await appService.toggleTheme();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
