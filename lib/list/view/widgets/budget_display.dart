import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

const double internalVerticalPadding = 8;
const double externalVerticalPadding = 8;
const double fontSize = 16;

class BudgetDisplay extends StatelessWidget {
  const BudgetDisplay({
    required this.used,
    required this.total,
    required this.currency,
    required this.showBudget,
    super.key,
  });
  final double used;
  final double total;
  final String currency;
  final bool showBudget;

  static double safeHeightToAvoidBudgetDisplay(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final textScaler = mediaQuery.textScaler;

    const internalVerticalPaddingTotal =
        (internalVerticalPadding + internalVerticalPadding) * 2;

    const maxLines = 2;
    const lineHeight = 1.5;

    return textScaler.scale(
          fontSize * lineHeight * maxLines,
        ) +
        internalVerticalPaddingTotal;
  }

  @override
  Widget build(BuildContext context) {
    final available = total - used;

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);
    final currentLocale = context.read<AppBloc>().state.locale;

    final currencyFormatter = NumberFormat.simpleCurrency(
      locale: currentLocale.toLanguageTag(),
      name: currency,
    );

    return Padding(
      padding: const .all(externalVerticalPadding),
      child: SizedBox(
        width: .infinity,
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: .circular(32),
          ),
          margin: .zero,
          child: Padding(
            padding: const .only(
              left: 32,
              right: 8,
              top: internalVerticalPadding,
              bottom: internalVerticalPadding,
            ),
            child: Row(
              mainAxisAlignment: showBudget ? .spaceBetween : .end,
              spacing: 8,
              children: [
                Flexible(
                  flex: 2,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: fontSize,
                        color: colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: currencyFormatter.format(used),
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: .bold,
                          ),
                        ),
                        if (showBudget)
                          TextSpan(
                            text: s.spent_of,
                            style: const TextStyle(fontWeight: .normal),
                          ),
                        if (showBudget)
                          TextSpan(
                            text: currencyFormatter.format(total),
                            style: TextStyle(
                              color: colorScheme.secondary,
                              fontWeight: .bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (showBudget)
                  Flexible(
                    fit: .tight,
                    child: Card.filled(
                      margin: .zero,
                      shape: const RoundedRectangleBorder(
                        borderRadius: .all(.circular(32 - 8)),
                      ),
                      child: Padding(
                        padding: const .symmetric(vertical: 4, horizontal: 2),
                        child: RichText(
                          textAlign: .center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: fontSize,
                              color: colorScheme.onSurface,
                            ),
                            children: [
                              TextSpan(
                                text: currencyFormatter.format(available),
                                style: TextStyle(
                                  color: available < 0
                                      ? theme.colorScheme.error
                                      : theme.customColors.success,
                                  fontWeight: .bold,
                                ),
                              ),
                              TextSpan(
                                text: s.available,
                                style: const TextStyle(
                                  fontWeight: .normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
