import 'dart:developer';

import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/services/app_service.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/services/wearos_service.dart';
import 'package:felicette_recipes/app/utils/utils.dart';
import 'package:felicette_recipes/authentication/bloc/authentication_bloc.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart' hide DrawerController;
import 'package:flutter_bloc/flutter_bloc.dart';

class FRDrawer extends StatelessWidget {
  const FRDrawer({super.key});
  static const EdgeInsetsGeometry listTileContentPadding = EdgeInsets.only(
    right: 8,
    left: 16,
  );

  List<Widget> _buildGroupListTiles(BuildContext context) {
    /*    final selectedGroup = groupServices.selectedGroup.value;

    final actualGroupsTiles = groupServices.availableGroups.map((group) {
      return ListTile(
        contentPadding: listTileContentPadding,
        selected: group.id == selectedGroup?.id,
        leading: Icon(
          group.id == selectedGroup?.id ? Icons.group : Icons.group_outlined,
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
        contentPadding: listTileContentPadding,
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
                              onPressed: nameState.value.trim().isEmpty
                                  ? null
                                  : () {
                                      Get.back(result: nameState.value.trim());
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
    */
    return [];
  }

  Widget _buildLanguageListTile(BuildContext context) {
    final s = S.of(context);
    final currentLocale = context.read<AppBloc>().state.locale;

    return ListTile(
      contentPadding: listTileContentPadding,
      leading: const Icon(Icons.language),
      title: Text(s.language),
      subtitle: Text(FRUtils.getLocaleName(currentLocale)),
      onTap: () async {
        await FRUtils.showLanguageSelectionDialog(context);
      },
    );
  }

  Widget _buildWearOsListTile(BuildContext context) {
    /*
    final WearOSService wearOSService = Get.find<WearOSService>();

    return ListTile(
      contentPadding: listTileContentPadding,
      leading: const Icon(Icons.watch),
      title: Text(TranslationKeys.wearOSSync.tr),
      subtitle: Text(
        wearOSService.hasConnectedWatch.value
            ? TranslationKeys.connected.tr
            : TranslationKeys.notConnected.tr,
      ),
      onTap: wearOSService.hasConnectedWatch.value
          ? () async {
              await wearOSService.sendCurrentIngredients();
            }
          : null,
    );
    */

    return SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    /*    final AuthService authService = Get.find<AuthService>();
    final DrawerController controller = Get.put<DrawerController>(
      DrawerController(),
      permanent: true,
    ); */
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const _DrawerHeader(),
          ..._buildGroupListTiles(context),
          const Divider(),
          _buildLanguageListTile(context),
          const _ThemeTile(),
          _buildWearOsListTile(context),
          const Divider(),
          const _CurrentUserTile(),
          const Divider(),
          const _AboutTile(),
        ],
      ),
    );
  }
}

class _ThemeTile extends StatelessWidget {
  const _ThemeTile();
  @override
  Widget build(BuildContext context) {
    final appBloc = context.watch<AppBloc>();
    final isDarkMode = appBloc.state.darkMode;
    final s = S.of(context);
    return ListTile(
      key: const Key('drawer_theme_list_tile'),
      contentPadding: FRDrawer.listTileContentPadding,
      leading: const Icon(Icons.brightness_6),
      title: Text(s.theme),
      subtitle: Text(
        isDarkMode ? s.dark_mode : s.light_mode,
      ),
      onTap: () async {
        appBloc.add(const AppToggleDarkMode());
      },
    );
  }
}

class _AboutTile extends StatelessWidget {
  const _AboutTile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: const Key('drawer_about_list_tile'),
      contentPadding: FRDrawer.listTileContentPadding,
      leading: const Icon(Icons.info_outline),
      title: Text(S.of(context).about),
      onTap: () async {
        await FRUtils.showAboutDialog(context);
      },
    );
  }
}

class _CurrentUserTile extends StatelessWidget {
  const _CurrentUserTile();
  @override
  Widget build(BuildContext context) {
    final authenticationBloc = context.watch<AuthenticationBloc>();
    final currentUser = authenticationBloc.state.user;

    log('Building CurrentUserTile with user: ${currentUser}');

    final s = S.of(context);

    return ListTile(
      key: const Key('drawer_current_user_list_tile'),
      contentPadding: FRDrawer.listTileContentPadding,
      leading: const Icon(Icons.logout),
      title: Text(s.logout),
      subtitle: Text(currentUser?.email ?? ''),
      onTap: () {
        authenticationBloc.add(
          AuthenticationLogoutPressed(),
        );
      },
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DrawerHeader(
      key: const Key('drawer_header'),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 100,
            height: 100,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.of(context).application_name,
              style: TextStyle(
                fontSize: 24,
                color: theme.colorScheme.onSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
