import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import 'package:recipes_flutter/theme.dart';

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

    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment:
                showBudget ? MainAxisAlignment.center : MainAxisAlignment.end,
            spacing: 8,
            children: [
              Flexible(
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
                SizedBox(
                  height: 20,
                  child: VerticalDivider(
                    thickness: 0.15,
                    color: Colors.grey,
                    width: 16,
                  ),
                  //                  width: 16,
                ),
              if (showBudget)
                Flexible(
                  child: RichText(
                    textAlign: TextAlign.right,
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
                            color:
                                available < 0
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
            ],
          ),
        ),
      ),
    );
  }
}
