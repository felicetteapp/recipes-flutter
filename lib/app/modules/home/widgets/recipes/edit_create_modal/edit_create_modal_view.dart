import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/common/widgets/select/select.dart';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/data/models/recipe_models.dart';
import 'package:felicette_recipes/app/modules/home/widgets/recipes/edit_create_modal/edit_create_modal_controller.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';
import 'package:felicette_recipes/theme.dart';

class EditCreateRecipeModal extends StatelessWidget {
  final String groupId;
  final FRRecipe? recipe;
  const EditCreateRecipeModal({
    super.key,
    required this.groupId,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      EditCreateRecipeModalController(groupId: groupId, recipe: recipe),
    );
    final ingredientsService = Get.find<IngredientsService>();
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        title:
            recipe != null
                ? Text(TranslationKeys.editRecipe.tr)
                : Text(TranslationKeys.createRecipe.tr),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
                child: Column(
                  spacing: 16,
                  children: [
                    TextField(
                      controller: controller.nameController,
                      decoration: InputDecoration(
                        labelText: TranslationKeys.recipeName.tr,
                      ),
                    ),
                    Text(
                      TranslationKeys.chooseIngredientsText.tr,
                      style: Get.theme.textTheme.bodyMedium,
                    ),
                    Obx(
                      () => FRSelect<FRIngredient>(
                        label: TranslationKeys.selectIngredients.tr,
                        items:
                            ingredientsService.ingredients
                                .where((i) => i.actualIngredient)
                                .toList(),
                        value:
                            controller.ingredients
                                .map(
                                  (ri) => ingredientsService.getIngredientById(
                                    ri.ingredientId,
                                  ),
                                )
                                .whereType<FRIngredient>()
                                .toList(),
                        itemLabelBuilder: (ingredient) {
                          return ingredient.name;
                        },
                        isMulti: true,
                        createItem: (name) async {
                          final tempIngredient = FRIngredient(
                            id: '',
                            name: name,
                            actualIngredient: true,
                          );
                          final newIngredient = await ingredientsService
                              .createIngredient(
                                groupId: groupId,
                                ingredient: tempIngredient,
                              );

                          log(
                            'Created new ingredient: ${newIngredient.id} - ${newIngredient.name}',
                          );
                          return newIngredient;
                        },
                        onChanged: (selected) {
                          log('Selected ingredients: $selected');
                          final currentSelected =
                              controller.ingredients
                                  .where(
                                    (ri) => selected.any(
                                      (ing) => ing.id == ri.ingredientId,
                                    ),
                                  )
                                  .toList();

                          final newRecipeIngredients =
                              selected.map((ing) {
                                final existing = currentSelected
                                    .firstWhereOrNull(
                                      (ri) => ri.ingredientId == ing.id,
                                    );
                                if (existing != null) {
                                  return existing;
                                } else {
                                  return FRRecipeIngredient(
                                    ingredientId: ing.id,
                                    quantity: '',
                                  );
                                }
                              }).toList();
                          controller.ingredients.assignAll(
                            newRecipeIngredients,
                          );
                        },
                      ),
                    ),
                    Divider(),
                    Text(
                      TranslationKeys.optionalQuantitiesText.tr,
                      style: Get.theme.textTheme.bodyMedium,
                    ),
                    Text(
                      TranslationKeys.quantitiesShoppingListText.tr,
                      style: Get.theme.textTheme.bodySmall,
                    ),

                    Obx(
                      () => Column(
                        spacing: 16,
                        children:
                            controller.ingredients.map((ri) {
                              final ingredient = ingredientsService
                                  .getIngredientById(ri.ingredientId);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: TranslationKeys.quantityFor
                                        .trParams({
                                          'ingredient':
                                              ingredient?.name ?? 'Unknown',
                                        }),
                                  ),
                                  onChanged: (value) {
                                    ri.quantity = value;
                                  },
                                  controller: TextEditingController(
                                    text: ri.quantity,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
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
                                controller.recipe == null
                                    ? controller.createRecipe()
                                    : controller.updateRecipe();
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
                if (recipe != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        // add a confirmation dialog before deleting
                        Get.defaultDialog(
                          title: TranslationKeys.confirmDeletion.tr,
                          middleText: TranslationKeys.confirmDeletionMessage.tr,
                          textCancel: TranslationKeys.cancel.tr,
                          textConfirm: TranslationKeys.delete.tr,
                          onConfirm: () {
                            log('Recipe deleted: ${recipe!.id}');
                            controller.deleteRecipe();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Get.theme.colorScheme.error,
                      ),
                      label: Text(
                        TranslationKeys.delete.tr,
                        style: TextStyle(color: Get.theme.colorScheme.error),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
