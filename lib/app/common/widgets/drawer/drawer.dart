import 'dart:developer';

import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/utils/utils.dart';
import 'package:felicette_recipes/authentication/bloc/authentication_bloc.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/groups/bloc/groups_bloc.dart';
import 'package:flutter/material.dart' hide DrawerController;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class FRDrawer extends StatelessWidget {
  const FRDrawer({super.key});
  static const EdgeInsetsGeometry listTileContentPadding = EdgeInsets.only(
    right: 8,
    left: 16,
  );

  List<Widget> _buildGroupListTiles(BuildContext context) {
    final groupsBloc = context.watch<GroupsBloc>();

    final s = S.of(context);

    final selectedGroup = groupsBloc.state.selectedGroup;

    final items = <Widget>[
      ListTile(
        contentPadding: listTileContentPadding,
        title: Text(
          s.your_groups,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: TextButton(
          child: Text(s.create_group),
          onPressed: () async {
            if (groupsBloc.state.groups.length >= 3) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(s.group_creation_limit_reached),
                ),
              );
              return;
            }
          },
        ),
      ),
      ...groupsBloc.state.groups.map((group) {
        return ListTile(
          contentPadding: listTileContentPadding,
          selected: group.id == selectedGroup?.id,
          leading: Icon(
            group.id == selectedGroup?.id ? Icons.group : Icons.group_outlined,
          ),
          title: Text(group.name),
          trailing: IconButton(
            onPressed: () {
              Navigator.pop(context);
              context.push(
                AppRoutes.toEditGroup(group.id),
              );
            },
            icon: const Icon(Icons.edit),
          ),
          onTap: () {
            groupsBloc.add(GroupSelected(group));
            Navigator.pop(context);
          },
        );
      }),
    ];

    return items;
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
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
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

    log('Building CurrentUserTile with user: $currentUser');

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
