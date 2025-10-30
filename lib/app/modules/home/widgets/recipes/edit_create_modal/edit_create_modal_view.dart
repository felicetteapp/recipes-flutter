import 'dart:developer';

import 'package:felicette_recipes/app/common/translation_helper.dart';
import 'package:felicette_recipes/app/common/widgets/ingredient_select/ingredient_select_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
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
                    Obx(
                      () => IngredientSelect(
                        isRecipe: true,
                        items: ingredientsService.ingredients.toList(),
                        value: controller.ingredients.toList(),
                        isMulti: true,
                        label: TranslationHelper.plural(
                          TranslationKeys.ingredient,
                          controller.ingredients.length,
                        ),
                        itemLabelBuilder: (item) {
                          final ingredient = ingredientsService
                              .getIngredientById(item.ingredientId);
                          final ingredientName =
                              ingredient?.name ?? 'Unknown Ingredient';
                          return ingredientName;
                        },
                        onChanged: (selectedIngredients) {
                          log(
                            'EditCreateRecipeModal - onChanged: selectedIngredients=${selectedIngredients.length}, selected=${selectedIngredients.map((e) => e.ingredientId).join(', ')}',
                            name: 'EditCreateRecipeModal',
                          );
                          controller.ingredients.assignAll(
                            selectedIngredients
                                .map(
                                  (i) => FRRecipeIngredient(
                                    ingredientId: i.ingredientId,
                                    quantity: i.quantity,
                                  ),
                                )
                                .toList(),
                          );
                        },
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
