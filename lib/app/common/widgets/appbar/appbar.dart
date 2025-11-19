import 'package:flutter/material.dart';

class FRAppbar extends StatelessWidget implements PreferredSizeWidget {
  const FRAppbar({
    required this.title,
    super.key,
    this.showBackButton = false,
    this.leading,
    this.actions,
    this.selectingMode = false,
  });
  final Widget? title;
  final bool showBackButton;
  final Widget? leading;
  final List<Widget>? actions;
  final bool selectingMode;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return AppBar(
      backgroundColor: selectingMode ? colorScheme.secondary : null,
      foregroundColor: selectingMode ? colorScheme.onSecondary : null,
      title: title,
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
          Navigator.of(context).pop();
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
