import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';

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
      const Divider(),
      const ListTile(
        title: Text(
          'Your Groups',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      ...actualGroupsTiles,
    ];
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
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ..._buildGroupListTiles(context),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                authService.logout();
              },
            ),
          ],
        );
      }),
    );
  }
}
