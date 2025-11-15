import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/services/localization_service.dart';
import 'package:felicette_recipes/theme.dart';

class BudgetDisplay extends StatelessWidget {
  final double used;
  final double total;
  final String currency;
  final bool showBudget;

  const BudgetDisplay({
    super.key,
    required this.used,
    required this.total,
    required this.currency,
    required this.showBudget,
  });

  @override
  Widget build(BuildContext context) {
    final available = total - used;

    final theme = Get.theme;
    final ls = Get.find<LocalizationService>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          //        color: theme.colorScheme.onInverseSurface,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 32,
              right: 8,
              top: 8,
              bottom: 8,
            ),
            child: Row(
              mainAxisAlignment: showBudget
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.end,
              spacing: 8,
              children: [
                Flexible(
                  flex: 2,
                  fit: FlexFit.loose,
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                      children: [
                        TextSpan(
                          text: ls.formatCurrency(used.toDouble(), currency),
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (showBudget)
                          TextSpan(
                            text: TranslationKeys.spentOf.tr,
                            style: TextStyle(fontWeight: FontWeight.normal),
                          ),
                        if (showBudget)
                          TextSpan(
                            text: ls.formatCurrency(total.toDouble(), currency),
                            style: TextStyle(
                              color: theme.colorScheme.secondary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (showBudget)
                  Flexible(
                    fit: FlexFit.tight,
                    child: Card.filled(
                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32 - 8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface,
                            ),
                            children: [
                              TextSpan(
                                text: ls.formatCurrency(
                                  available.toDouble(),
                                  currency,
                                ),
                                style: TextStyle(
                                  color: available < 0
                                      ? theme.colorScheme.error
                                      : theme.customColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: TranslationKeys.available.tr,
                                style: TextStyle(fontWeight: FontWeight.normal),
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
