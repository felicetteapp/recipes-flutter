import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/modules/home/widgets/list/list_controller.dart';
import 'package:recipes_flutter/app/modules/home/widgets/list/widgets/edit_ingredient_price_modal/edit_ingredient_price_controller.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import 'package:recipes_flutter/theme.dart';

class EditIngredientPriceModal extends StatelessWidget {
  final FRGroup group;
  final ListIngredientItem item;
  const EditIngredientPriceModal({
    super.key,
    required this.group,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      EditIngredientPriceModalController(group: group, item: item),
    );

    final ls = Get.find<LocalizationService>();
    return Scaffold(
      appBar: AppBar(title: Text(controller.item.ingredient.name)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 4,
                  right: 4,
                  bottom: 32,
                ),
                child: Obx(
                  () => Column(
                    spacing: 16,
                    children: [
                      ...controller.ingredientPrices.toList().map(
                        (price) => _buildPriceSection(
                          context,
                          controller,
                          controller.ingredientPrices.toList().indexOf(price),
                        ),
                      ),
                      Text(
                        ls.formatCurrency(
                          controller.ingredientPrices.fold(
                            0.0,
                            (previousValue, element) =>
                                previousValue +
                                (element.quantity.toDouble() *
                                    element.unitPrice.toDouble()),
                          ),
                          group.currency,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Get.context?.theme.colorScheme.secondary,
                        ),
                      ),
                      TextButton.icon(
                        style: TextButton.styleFrom(
                          foregroundColor:
                              Get.context?.theme.customColors.success,
                        ),
                        onPressed: () {
                          controller.ingredientPrices.add(
                            FRIngredientPrice(quantity: 1, unitPrice: 0),
                          );
                        },
                        icon: const Icon(Icons.add),
                        label: Text(TranslationKeys.addPrice.tr),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              bottom: Get.mediaQuery.padding.bottom,
              left: 16,
              right: 16,
              top: 8,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: [
                Expanded(
                  child: Obx(() {
                    return TextButton.icon(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () {
                                controller.handleSaveWithoutPrice();
                              },
                      icon: const Icon(Icons.save_outlined),
                      label: Text(
                        TranslationKeys.saveWithoutPrice.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }),
                ),
                Expanded(
                  child: Obx(
                    () => FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: Get.theme.customColors.success,
                        foregroundColor: Get.theme.customColors.onSuccess,
                      ),
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () {
                                controller.handleSave();
                              },
                      icon: const Icon(Icons.save),
                      label: Text(
                        TranslationKeys.save.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(
    BuildContext context,
    EditIngredientPriceModalController controller,
    int index,
  ) {
    final ls = Get.find<LocalizationService>();

    return Obx(() {
      final price = controller.ingredientPrices[index];
      final pricesLength = controller.ingredientPrices.length;

      final fixedQuantities = [1, 2, 3, 4];
      final buttons = [...fixedQuantities, 5];
      return Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            spacing: 8,
            children: [
              SizedBox(height: 4),
              TextFormField(
                autofocus: index == 0 && pricesLength == 1,
                decoration: InputDecoration(
                  labelText: TranslationKeys.unitPrice.tr,
                  suffixText: ls.formatCurrency(
                    price.unitPrice.toDouble(),
                    controller.group.currency,
                  ),
                ),
                initialValue:
                    price.unitPrice == 0.0 ? null : price.unitPrice.toString(),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final unitPrice = double.tryParse(value) ?? 0.0;
                  controller.ingredientPrices[index] = price.copyWith(
                    unitPrice: unitPrice,
                  );

                  log(
                    'EditIngredientPriceModal - onChanged: unitPrice=$unitPrice',
                    name: 'EditIngredientPriceModal',
                  );
                },
              ),
              LayoutBuilder(
                builder: (context, constraints) {
                  return Row(
                    spacing: 4,
                    children: [
                      SizedBox(
                        width: constraints.maxWidth,
                        child: Row(
                          spacing: 2,
                          children: [
                            ...buttons.map((i) {
                              log(
                                'EditIngredientPriceModal - building quantity button: i=${price.quantity}',
                                name: 'EditIngredientPriceModal',
                              );
                              var shape = RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              );

                              if (i == price.quantity) {
                                shape = RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                );
                              } else if (i == 1) {
                                shape = const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(24),
                                    right: Radius.circular(8),
                                  ),
                                );
                              } else if (i == 5) {
                                shape = const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(8),
                                    right: Radius.circular(24),
                                  ),
                                );
                              }

                              if (i == 5) {
                                final isSelected =
                                    !fixedQuantities.contains(price.quantity);
                                return Expanded(
                                  child: FilledButton.icon(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      controller.ingredientPrices[index] = price
                                          .copyWith(quantity: i);

                                      final newQuantity = await Get.dialog(
                                        ObxValue<RxNum>((context) {
                                          return Container(
                                            color: Colors.black54,
                                            child: Center(
                                              child: Card(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    16.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Text(
                                                        TranslationKeys
                                                            .enterQuantity
                                                            .tr,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      SizedBox(height: 16),
                                                      TextFormField(
                                                        initialValue:
                                                            context.value
                                                                .toString(),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        autofocus: true,
                                                        onChanged: (v) {
                                                          final qty =
                                                              double.tryParse(
                                                                v,
                                                              ) ??
                                                              price.quantity;
                                                          context.value = qty;
                                                        },
                                                        onFieldSubmitted: (
                                                          value,
                                                        ) {
                                                          final qty =
                                                              double.tryParse(
                                                                value,
                                                              ) ??
                                                              price.quantity;
                                                          Get.back(result: qty);
                                                        },
                                                      ),

                                                      SizedBox(height: 16),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          final qty =
                                                              double.tryParse(
                                                                context.value
                                                                    .toString(),
                                                              ) ??
                                                              price.quantity;
                                                          Get.back(result: qty);
                                                        },
                                                        child: Text(
                                                          TranslationKeys.ok.tr,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }, RxNum(price.quantity)),
                                      );

                                      log(
                                        'EditIngredientPriceModal - dialog returned: newQuantity=$newQuantity',
                                        name: 'EditIngredientPriceModal',
                                      );

                                      if (newQuantity != null) {
                                        controller
                                            .ingredientPrices[index] = price
                                            .copyWith(quantity: newQuantity);
                                      }
                                    },
                                    style: ButtonStyle(
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: WidgetStatePropertyAll(
                                        EdgeInsets.symmetric(
                                          horizontal: isSelected ? 16 : 0,
                                          vertical: 8,
                                        ),
                                      ),
                                      shape: WidgetStatePropertyAll(shape),
                                      foregroundColor: WidgetStatePropertyAll(
                                        isSelected
                                            ? Get.theme.colorScheme.onPrimary
                                            : Get
                                                .theme
                                                .colorScheme
                                                .onPrimaryContainer,
                                      ),
                                      backgroundColor: WidgetStatePropertyAll(
                                        isSelected
                                            ? Get.theme.colorScheme.primary
                                            : Get
                                                .theme
                                                .colorScheme
                                                .primaryContainer,
                                      ),
                                    ),
                                    label: Text(
                                      !fixedQuantities.contains(price.quantity)
                                          ? price.quantity.toString()
                                          : TranslationKeys.more.tr,
                                    ),
                                  ),
                                );
                              }

                              return FilledButton(
                                onPressed: () {
                                  controller.ingredientPrices[index] = price
                                      .copyWith(quantity: i);

                                  log(
                                    'EditIngredientPriceModal - onPressed: quantity=$i',
                                    name: 'EditIngredientPriceModal',
                                  );
                                },
                                style: ButtonStyle(
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                      horizontal: i == price.quantity ? 16 : 0,
                                      vertical: 8,
                                    ),
                                  ),
                                  shape: WidgetStatePropertyAll(shape),
                                  foregroundColor: WidgetStatePropertyAll(
                                    i == price.quantity
                                        ? Get.theme.colorScheme.onPrimary
                                        : Get
                                            .theme
                                            .colorScheme
                                            .onPrimaryContainer,
                                  ),
                                  backgroundColor: WidgetStatePropertyAll(
                                    i == price.quantity
                                        ? Get.theme.colorScheme.primary
                                        : Get
                                            .theme
                                            .colorScheme
                                            .primaryContainer,
                                  ),
                                ),
                                child: Text(i.toString()),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              if (controller.ingredientPrices.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      ls.formatCurrency(
                        price.quantity.toDouble() * price.unitPrice.toDouble(),
                        controller.group.currency,
                      ),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Get.context?.theme.colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        controller.ingredientPrices.removeAt(index);
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Get.context?.theme.colorScheme.error,
                      ),
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
            ],
          ),
        ),
      );
    });
  }
}
