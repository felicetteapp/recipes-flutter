import 'package:flutter/material.dart';

class FRHeader extends StatelessWidget {
  const FRHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      mainAxisAlignment: .center,
      spacing: 16,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: 100,
          height: 100,
        ),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(
              'Felicette',
              style: textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
              ),
            ),
            Text(
              'Recipes',
              style: textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
