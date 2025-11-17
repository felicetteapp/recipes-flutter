import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class FRUtils {
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
}
