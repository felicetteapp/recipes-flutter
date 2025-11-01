import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FRUtils {
  static Future<void> showAboutDialog(BuildContext context) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (!context.mounted) return;
    Get.dialog(
      AboutDialog(
        applicationName: TranslationKeys.applicationName.tr,
        applicationVersion:
            '${packageInfo.version} (${packageInfo.buildNumber})',
        applicationIcon: Image.asset(
          'assets/images/felicette_recipes_logo.png',
          width: 50,
          height: 50,
        ),
        children: [
          RichText(
            text: TextSpan(
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              children: [
                TextSpan(
                  text: '${TranslationKeys.applicationDescription.tr}\n\n',
                ),
                TextSpan(text: TranslationKeys.developedWith.tr),
                TextSpan(text: ' '),
                TextSpan(
                  text: TranslationKeys.loveAndCats.tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' '),
                TextSpan(text: TranslationKeys.developedIn.tr),
                TextSpan(text: ' '),
                TextSpan(
                  text: '${TranslationKeys.developedBy.tr}\n\n',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: TranslationKeys.checkoutGithub.tr),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      // Open GitHub link
                    },
                    child: Text(
                      'github.com/felicetteapp/recipes-flutter',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: '\n\n'),
                TextSpan(text: packageInfo.packageName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
