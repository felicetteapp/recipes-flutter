import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';

class FRDrawer extends StatelessWidget {
  const FRDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = Get.find<AuthService>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () {
              authService.logout();
            },
          ),
        ],
      ),
    );
  }
}
