import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/modules/home/widgets/ingredients/edit_modal/edit_modal_controller.dart';
import 'package:recipes_flutter/theme.dart';

class EditIngredientModal extends StatelessWidget {
  final String groupId;
  final FRIngredient ingredient;
  const EditIngredientModal({
    super.key,
    required this.groupId,
    required this.ingredient,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      EditIngredientModalController(groupId: groupId, ingredient: ingredient),
    );
    return Scaffold(
      extendBody: false,
      appBar: AppBar(title: Text(TranslationKeys.editIngredient.tr)),
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
                        labelText: TranslationKeys.ingredientName.tr,
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        title: Text(TranslationKeys.isActualIngredient.tr),
                        value: controller.isActualIngredient.value,
                        onChanged: (value) {
                          controller.isActualIngredient.value = value ?? false;
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
                    label: Text(TranslationKeys.cancel.tr),
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
                                controller.updateIngredient();
                              },
                      icon: const Icon(Icons.save),
                      label: Text(TranslationKeys.save.tr),
                    ),
                  ),
                ),
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
                          log('Ingredient deleted: ${ingredient.id}');
                          controller.deleteIngredient();
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
