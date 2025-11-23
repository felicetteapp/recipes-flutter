import 'dart:math';

import 'package:flutter/material.dart';

class CrudBottomNavigation extends StatelessWidget {
  const CrudBottomNavigation({
    required this.actions,
    super.key,
  });
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final safeAreaBottom = mediaQuery.padding.bottom;
    const double minBottomPadding = 16;

    return Padding(
      padding: EdgeInsets.only(
        bottom: max(minBottomPadding, 8 + bottomInset + safeAreaBottom),
        left: 16,
        right: 16,
        top: 8,
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        spacing: 8,
        children: actions,
      ),
    );
  }
}
