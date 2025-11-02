import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/services/app_service.dart';
import 'package:felicette_recipes/app/utils/snackbar.dart';
import 'package:flutter/material.dart' hide DrawerController;
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/common/widgets/drawer/drawer_controller.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';
import 'package:felicette_recipes/app/services/localization_service.dart';

class FRDrawer extends StatelessWidget {
  final groupServices = Get.find<GroupsService>();
  FRDrawer({super.key});

  List<Widget> _buildGroupListTiles(BuildContext context) {
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
            trailing: IconButton(
              onPressed: () {
                Get.toNamed(AppRoutes.groupDetails(group.id));
              },
              icon: Icon(Icons.edit),
            ),
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
        trailing: TextButton(
          child: Text(TranslationKeys.createGroup.tr),
          onPressed: () async {
            if (groupServices.availableGroups.length >= 3) {
              FRSnackbar.error(
                TranslationKeys.error.tr,
                TranslationKeys.groupCreationLimitReached.tr,
              );
              return;
            }

            final name = await Get.dialog<String>(
              ObxValue(
                (nameState) => SimpleDialog(
                  title: Text(TranslationKeys.createGroup.tr),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextField(
                        autofocus: true,
                        onChanged: (value) => nameState.value = value,
                        decoration: InputDecoration(
                          labelText: TranslationKeys.groupName.tr,
                        ),
                        onSubmitted: (value) {
                          Get.back(result: value);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(TranslationKeys.cancel.tr),
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              onPressed:
                                  nameState.value.trim().isEmpty
                                      ? null
                                      : () {
                                        Get.back(
                                          result: nameState.value.trim(),
                                        );
                                      },
                              child: Text(TranslationKeys.create.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                ''.obs,
              ),
            );

            if (name != null && name.trim().isNotEmpty) {
              final createdGroup = await groupServices.createGroup(name.trim());
              await Future.delayed(const Duration(seconds: 1));
              Get.toNamed(AppRoutes.groupDetails(createdGroup.id));
            }
          },
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
      },
    );
  }

  Widget _buildThemeListTile(BuildContext context) {
    final appService = Get.find<AppService>();

    final isDarkMode = Get.isDarkMode;
    return ListTile(
      leading: Icon(Icons.brightness_6),
      title: Text(TranslationKeys.theme.tr),
      subtitle: Text(
        isDarkMode ? TranslationKeys.darkMode.tr : TranslationKeys.lightMode.tr,
      ),
      onTap: () async {
        await appService.toggleTheme();
        Get.offAndToNamed(AppRoutes.home);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    final DrawerController controller = Get.put<DrawerController>(
      DrawerController(),
      permanent: true,
    );
    return Drawer(
      child: Obx(() {
        return ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
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
                              color: Get.theme.colorScheme.onSecondary,
                            ),
                          ),
                          TextSpan(
                            text: ' Recipes',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Get.theme.colorScheme.onSecondary,
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
            _buildThemeListTile(context),
            const Divider(),
            Obx(() {
              return ListTile(
                leading: Icon(Icons.logout),
                title: Text(TranslationKeys.logout.tr),
                subtitle: Text(authService.currentUser.value?.email ?? ''),
                onTap: () {
                  authService.logout();
                },
              );
            }),
            const Divider(),
            Obx(() {
              return AboutListTile(
                applicationName: TranslationKeys.applicationName.tr,
                applicationVersion:
                    '${controller.packageInfo.value?.version ?? ''} (${controller.packageInfo.value?.buildNumber ?? ''})',
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
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        TextSpan(text: '\n\n'),
                        TextSpan(
                          text: controller.packageInfo.value?.packageName ?? '',
                        ),
                      ],
                    ),
                  ),
                ],
                icon: Icon(Icons.info_outline),
                child: Text(TranslationKeys.about.tr),
              );
            }),
          ],
        );
      }),
    );
  }
}
