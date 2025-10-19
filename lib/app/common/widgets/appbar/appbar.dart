import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';

class FRAppbar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool showBackButton;
  final Widget? leading;
  final List<Widget>? actions;
  final bool selectingMode;

  const FRAppbar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.leading,
    this.actions,
    this.selectingMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: selectingMode ? Get.theme.colorScheme.secondary : null,
      foregroundColor: selectingMode ? Get.theme.colorScheme.onSecondary : null,
      title: title,
      centerTitle: true,
      leading: getLeading(context),
      actions: actions,
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
