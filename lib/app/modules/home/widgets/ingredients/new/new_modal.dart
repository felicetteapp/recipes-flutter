import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/modules/home/widgets/ingredients/new/new_modal_controller.dart';
import 'package:recipes_flutter/theme.dart';

class NewIngredientModal extends StatelessWidget {
  final String groupId;
  const NewIngredientModal({super.key, required this.groupId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NewIngredientModalController(groupId: groupId));
    return Scaffold(
      extendBody: false,
      appBar: AppBar(title: const Text('New Ingredient')),
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
                        labelText: 'Ingredient Name',
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        title: const Text('Is Actual Ingredient'),
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
                                // Save logic here
                                controller.createIngredient();
                              },
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
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
