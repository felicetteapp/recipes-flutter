import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/common.dart';
import 'package:recipes_flutter/app/common/widgets/select/select.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
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
                      () => FRSelect<FRIngredient>(
                        items: controller.availableIngredients,
                        value: controller.currentIngredients,
                        itemLabelBuilder: (item) => item.name,
                        onChanged: (selectedIngredients) {
                          Get.log(
                            'EditListModal - handleOnChange: selectedIngredients=${selectedIngredients.map((e) => e.name).toList()}',
                          );
                        },
                        isMulti: true,
                        label: TranslationKeys.selectIngredients.tr,
                        createItem: (name) async {
                          final actualIngredient =
                              await Get.dialog<bool>(
                                AlertDialog(
                                  title: Text(
                                    TranslationKeys.confirmActualIngredient.tr,
                                  ),
                                  content: Text(
                                    TranslationKeys
                                        .confirmActualIngredientDescription
                                        .trParams({'ingredientName': name}),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Get.back(result: false);
                                      },
                                      child: Text(TranslationKeys.no.tr),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.back(result: true);
                                      },
                                      child: Text(TranslationKeys.yes.tr),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;

                          final tempIngredient = FRIngredient(
                            id: '',
                            name: name,
                            actualIngredient: actualIngredient,
                          );
                          final newIngredient = await ingredientsService
                              .createIngredient(
                                groupId: groupId,
                                ingredient: tempIngredient,
                              );

                          return newIngredient;
                        },
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
