import 'dart:developer';

import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/utils/utils.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FRFooter extends StatelessWidget {
  const FRFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    final buttonStyle = TextButton.styleFrom(
      foregroundColor: theme.colorScheme.tertiary,
    );

    return Container(
      padding: const .symmetric(vertical: 16),
      alignment: .center,
      child: Column(
        spacing: 8,
        children: [
          Row(
            spacing: 8,
            mainAxisAlignment: .spaceBetween,
            children: [
              const Expanded(child: Divider()),
              Text(
                s.application_name,
                style: theme.textTheme.bodySmall,
              ),
              const Expanded(child: Divider()),
            ],
          ),
          Wrap(
            alignment: .center,
            runAlignment: .center,
            crossAxisAlignment: .center,
            spacing: 8,
            children: [
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.info_outline),
                onPressed: () async {
                  log('Language selection dialog opened', name: 'FRFooter');
                  await FRUtils.showAboutDialog(context);
                },
                label: Text(s.about),
              ),
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.language),
                onPressed: () async {
                  await FRUtils.showLanguageSelectionDialog(context);
                },
                label: Text(s.language),
              ),
              TextButton.icon(
                style: buttonStyle,
                icon: const Icon(Icons.brightness_6),
                label: Text(s.theme),
                onPressed: () async {
                  context.read<AppBloc>().add(const AppToggleDarkMode());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
