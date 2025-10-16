import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class FRAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool showBackButton;
  final Widget? leading;

  const FRAppbar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: true,
      leading: getLeading(context),
    );
  }

  Widget getLeading(BuildContext context) {
    if (leading != null) {
      return leading!;
    } else if (showBackButton) {
      return IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          Get.back();
        },
      );
    } else {
      return IconButton(
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
        icon: const Icon(Icons.menu),
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
