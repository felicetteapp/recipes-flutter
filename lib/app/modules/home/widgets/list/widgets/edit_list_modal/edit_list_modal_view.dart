import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/common.dart';
import 'package:recipes_flutter/app/common/widgets/ingredient_select/ingredient_select_view.dart';
import 'package:recipes_flutter/app/common/widgets/select/select.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/modules/home/widgets/list/widgets/edit_list_modal/edit_list_modal_controller.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/theme.dart';

class EditListModal extends StatelessWidget {
  final String groupId;
  const EditListModal({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(EditListModalController(groupId: groupId));
    final ingredientsService = Get.find<IngredientsService>();
    return Scaffold(
      appBar: AppBar(title: Text(TranslationKeys.editList.tr)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Column(
                  spacing: 16,
                  children: [
                    Obx(
                      () => FRSelect<FRRecipe>(
                        items: controller.availableRecipes,
                        value: controller.selectedRecipes.toList(),
                        itemLabelBuilder: (item) => item.name,
                        onChanged: controller.handleRecipesOnChange,
                        isMulti: true,
                        label: TranslationKeys.selectRecipes.tr,
                      ),
                    ),
                    Obx(
                      () => IngredientSelect(
                        items: controller.availableIngredients,
                        value:
                            controller.selectedIngredientsWithQuantities
                                .toList(),
                        itemLabelBuilder: (item) {
                          final ingredient = ingredientsService
                              .getIngredientById(item.ingredientId);
                          final ingredientName =
                              ingredient?.name ?? 'Unknown Ingredient';
                          return ingredientName;
                        },
                        onChanged: (ingredients) {
                          log(
                            'EditListModal - onChanged: ingredients=${ingredients.length}, selected=${ingredients.map((e) => e.ingredientId).join(', ')}',
                            name: 'EditListModal',
                          );
                          controller.selectedIngredientsWithQuantities
                              .assignAll(
                                ingredients
                                    .map(
                                      (e) => FRCurrentIngredients(
                                        ingredientId: e.ingredientId,
                                        quantity: e.quantity,
                                      ),
                                    )
                                    .toList(),
                              );
                        },
                        isMulti: true,
                        label: TranslationKeys.selectIngredients.tr,
                      ),
                    ),
                    Obx(
                      () => FRSelect<String>(
                        items: controller.availableCurrencies,
                        value: controller.selectedCurrency.toList(),
                        itemLabelBuilder:
                            (item) => TranslationHelper.currencyLabel(item),
                        onChanged: controller.handleCurrencyOnChange,
                        isMulti: false,
                        label: TranslationKeys.selectCurrency.tr,
                      ),
                    ),
                    TextFormField(
                      controller: controller.budgetController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*$'),
                        ),
                      ],
                      decoration: InputDecoration(
                        labelText: TranslationKeys.budget.tr,
                      ),
                      onChanged: (value) {
                        Get.log('EditListModal - onChanged: budget=$value');
                        controller.updateBudgetValidation(value);
                      },
                      validator: controller.validateBudget,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                  ],
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
                  child: TextButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.chevron_left),
                    label: Text(
                      TranslationKeys.cancel.tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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
                                controller.handleOnSave();
                                //TODO: Save action
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
}
