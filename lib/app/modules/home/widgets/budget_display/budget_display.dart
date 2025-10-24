import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import 'package:recipes_flutter/theme.dart';

class BudgetDisplay extends StatelessWidget {
  final double used;
  final double total;
  final String currency;

  const BudgetDisplay({
    super.key,
    required this.used,
    required this.total,
    required this.currency,
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
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8,
            children: [
              Flexible(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: ls.formatCurrency(used.toDouble(), currency),
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' used of ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
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
              SizedBox(
                height: 20,
                child: VerticalDivider(
                  thickness: 0.15,
                  color: Colors.grey,
                  width: 16,
                ),
                //                  width: 16,
              ),
              Flexible(
                child: RichText(
                  textAlign: TextAlign.right,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    children: [
                      TextSpan(
                        text: ls.formatCurrency(available.toDouble(), currency),
                        style: TextStyle(
                          color:
                              available < 0
                                  ? theme.colorScheme.error
                                  : theme.customColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' available',
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
