import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';

class FRDrawer extends StatelessWidget {
  const FRDrawer({super.key});

  List<Widget> _buildGroupListTiles(BuildContext context) {
    final groupServices = Get.find<GroupsService>();

    final selectedGroup = groupServices.selectedGroup.value;

    final actualGroupsTiles =
        groupServices.availableGroups.map((group) {
          return ListTile(
            selected: group.id == selectedGroup?.id,
            leading: Icon(
              group.id == selectedGroup?.id
                  ? Icons.group
                  : Icons.group_outlined,
            ),
            title: Text(group.name),
            onTap: () {
              groupServices.selectGroup(group);
              Navigator.pop(context);
            },
          );
        }).toList();

    return [
      ListTile(
        title: Text(
          TranslationKeys.yourGroups.tr,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ...actualGroupsTiles,
    ];
  }

  Widget _buildLanguageListTile(BuildContext context) {
    final localizationService = Get.find<LocalizationService>();

    return ListTile(
      leading: Icon(Icons.language),
      title: Text(TranslationKeys.language.tr),
      subtitle: Text(
        localizationService.getLocaleName(localizationService.currentLocale),
      ),
      onTap: () async {
        final response = await Get.dialog<Locale>(
          SimpleDialog(
            title: Text(TranslationKeys.selectLanguage.tr),
            children:
                LocalizationService.supportedLocales.map((locale) {
                  return SimpleDialogOption(
                    onPressed: () {
                      Get.back(result: locale);
                    },
                    child: Text(localizationService.getLocaleName(locale)),
                  );
                }).toList(),
          ),
        );

        if (response != null) {
          localizationService.changeLocale(response);
        }
        // Open language selection dialog
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    return Drawer(
      child: Obx(() {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Row(
                spacing: 8,
                children: [
                  Image.asset(
                    'assets/images/felicette_recipes_logo.png',
                    width: 100,
                    height: 100,
                  ),
                  Expanded(
                    child: RichText(
                      softWrap: true,
                      maxLines: 2,
                      text: TextSpan(
                        style: TextStyle(fontSize: 24),
                        children: [
                          TextSpan(
                            text: 'Felicette',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Get.theme.colorScheme.primary,
                            ),
                          ),
                          TextSpan(
                            text: ' Recipes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ..._buildGroupListTiles(context),
            const Divider(),
            _buildLanguageListTile(context),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(TranslationKeys.logout.tr),
              onTap: () {
                authService.logout();
              },
            ),
            const Divider(),
            AboutListTile(
              applicationName: TranslationKeys.applicationName.tr,
              // TODO: get current version from pubspec.yaml
              applicationVersion: '1.0.0',
              applicationIcon: Image.asset(
                'assets/images/felicette_recipes_logo.png',
                width: 50,
                height: 50,
              ),
              aboutBoxChildren: [
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text:
                            '${TranslationKeys.applicationDescription.tr}\n\n',
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
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              icon: Icon(Icons.info_outline),
              child: Text(TranslationKeys.about.tr),
            ),
          ],
        );
      }),
    );
  }
}
