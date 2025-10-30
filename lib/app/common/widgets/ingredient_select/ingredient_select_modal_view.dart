import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/common.dart';
import 'package:felicette_recipes/app/common/widgets/ingredient_select/ingredient_select_controller.dart';
import 'package:felicette_recipes/app/common/widgets/select/select.dart';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/data/models/recipe_models.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';
import 'package:felicette_recipes/theme.dart';

class IngredientSelectModalView extends StatelessWidget {
  final IngredientSelectController controller;
  final bool isRecipe;
  const IngredientSelectModalView({
    super.key,
    required this.controller,
    this.isRecipe = false,
  });

  @override
  Widget build(BuildContext context) {
    final IngredientsService ingredientsService =
        Get.find<IngredientsService>();
    final GroupsService groupsService = Get.find<GroupsService>();
    return Scaffold(
      appBar: AppBar(title: Text(controller.label)),
      extendBodyBehindAppBar: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Obx(
                      () => ListView(
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ...controller.selectedItems.map((item) {
                            final index = controller.selectedItems.indexOf(
                              item,
                            );
                            final ingredientValue =
                                controller.items
                                    .where((ing) => ing.id == item.ingredientId)
                                    .toList();

                            final availableIngredients =
                                controller.items.toList();

                            log(
                              'Rendering item at index $index: ingredientId=${item.ingredientId}, quantity=${item.quantity}, ingredientName=${ingredientValue.map((e) => e.name).join(', ')}',
                            );
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                spacing: 8,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: item.quantity.toString(),
                                      decoration: InputDecoration(
                                        labelText: TranslationKeys.quantity.tr,
                                      ),
                                      onChanged: (value) {
                                        log(
                                          'Quantity changed for item at index $index: new value = $value',
                                        );
                                        final newValue = List.of(
                                          controller.selectedItems,
                                        );
                                        newValue[index] = item.copyWith(
                                          quantity: value,
                                        );
                                        controller.selectedItems.value =
                                            newValue;
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    child: FRSelect<FRIngredient>(
                                      key: ValueKey(
                                        'ingredient_select_${index}_${item.ingredientId}',
                                      ),
                                      items: availableIngredients,
                                      value: ingredientValue,
                                      itemLabelBuilder: (item) => item.name,
                                      onChanged: (selected) {
                                        log(
                                          'Ingredient changed for item at index $index: selected = ${selected.map((e) => e.name).join(', ')}',
                                        );
                                        if (selected.isEmpty) return;
                                        final newValue = List.of(
                                          controller.selectedItems,
                                        );
                                        newValue[index] = item.copyWith(
                                          ingredientId: selected.first.id,
                                        );
                                        controller.selectedItems.value =
                                            newValue;
                                      },
                                      isMulti: false,
                                      label: TranslationKeys.ingredient.tr,
                                      createItem: (name) async {
                                        final newIngredient = FRIngredient(
                                          id: '',
                                          name: name,
                                        );

                                        if (isRecipe) {
                                          newIngredient.actualIngredient = true;
                                        } else {
                                          newIngredient.actualIngredient =
                                              await Get.dialog<bool>(
                                                AlertDialog(
                                                  title: Text(
                                                    TranslationKeys
                                                        .actualIngredientTitle
                                                        .tr,
                                                  ),
                                                  content: Text(
                                                    TranslationKeys
                                                        .actualIngredientContent
                                                        .tr,
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back(result: false);
                                                      },
                                                      child: Text(
                                                        TranslationKeys.no.tr,
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Get.back(result: true);
                                                      },
                                                      child: Text(
                                                        TranslationKeys.yes.tr,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ) ??
                                              false;
                                        }

                                        log(
                                          'Creating new ingredient: id=${newIngredient.id}, name=${newIngredient.name}',
                                        );

                                        final createdIngredient =
                                            await ingredientsService
                                                .createIngredient(
                                                  groupId:
                                                      groupsService
                                                          .selectedGroup
                                                          .value!
                                                          .id,
                                                  ingredient: newIngredient,
                                                );

                                        return createdIngredient;
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Get.theme.colorScheme.error,
                                    onPressed: () {
                                      final newValue = List.of(
                                        controller.selectedItems,
                                      );
                                      newValue.remove(item);
                                      controller.selectedItems.value = newValue;
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 16),
                            child: TextButton.icon(
                              style: TextButton.styleFrom(
                                foregroundColor:
                                    Get.context?.theme.customColors.success,
                              ),
                              icon: Icon(Icons.add),
                              onPressed: () {
                                final newValue = List.of(
                                  controller.selectedItems,
                                );
                                newValue.add(
                                  BasicIngredientQuantity(
                                    ingredientId:
                                        controller.items.isNotEmpty
                                            ? controller.items.first.id
                                            : '',
                                    quantity: '',
                                  ),
                                );
                                controller.selectedItems.value = newValue;
                              },
                              label: Text(TranslationKeys.addIngredient.tr),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: Get.mediaQuery.padding.bottom,
                      top: 8,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(TranslationKeys.done.tr),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
