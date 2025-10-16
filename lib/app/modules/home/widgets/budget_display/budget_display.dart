import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import 'package:recipes_flutter/theme.dart';

class BudgetDisplay extends StatelessWidget {
  final int used;
  final int total;

  const BudgetDisplay({super.key, required this.used, required this.total});

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
                        text: ls.formatCurrency(used.toDouble(), 'EUR'),
                        style: TextStyle(color: theme.colorScheme.primary),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: 'Used from',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: ls.formatCurrency(total.toDouble(), 'BRL'),
                        style: TextStyle(color: theme.colorScheme.secondary),
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
                        text: ls.formatCurrency(available.toDouble(), 'ARS'),
                        style: TextStyle(
                          color:
                              available < 0
                                  ? theme.colorScheme.error
                                  : theme.customColors.success,
                        ),
                      ),
                      TextSpan(text: ' '),
                      TextSpan(
                        text: 'Available',
                        style: TextStyle(fontWeight: FontWeight.bold),
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
