import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/widgets/select/select.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/modules/home/widgets/recipes/edit_create_modal/edit_create_modal_controller.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/theme.dart';

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
        title: recipe != null ? Text('Edit Recipe') : Text('Create Recipe'),
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
                      decoration: const InputDecoration(
                        labelText: 'Recipe Name',
                      ),
                    ),
                    Text(
                      'Choose the ingredients needed for the recipe. Quantities can be entered below.',
                      style: Get.theme.textTheme.bodyMedium,
                    ),
                    Obx(
                      () => FRSelect<FRIngredient>(
                        label: 'Select Ingredients',
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
                      'Optionally, enter the quantities of the ingredients below.',
                      style: Get.theme.textTheme.bodyMedium,
                    ),
                    Text(
                      'The quantities will appear in the shopping list when the recipe is selected.',
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
                                    labelText:
                                        'Quantity for ${ingredient?.name ?? 'Unknown'}',
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
                    label: const Text('Cancel'),
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
                      label: const Text('Save'),
                    ),
                  ),
                ),
                if (recipe != null)
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        // add a confirmation dialog before deleting
                        Get.defaultDialog(
                          title: 'Confirm Deletion',
                          middleText:
                              'Are you sure you want to delete this ingredient?',
                          textCancel: 'Cancel',
                          textConfirm: 'Delete',
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
                        'Delete',
                        style: TextStyle(color: Get.theme.colorScheme.error),
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
