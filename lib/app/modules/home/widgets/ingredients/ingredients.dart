import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/modules/home/widgets/ingredients/edit_modal/edit_modal_view.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';

class IngredientsWidget extends StatelessWidget {
  const IngredientsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ingredientsService = Get.find<IngredientsService>();
    final groupsService = Get.find<GroupsService>();
    return Obx(() {
      final ingredients = ingredientsService.ingredients;
      final actualIngredients =
          ingredients.where((ing) => ing.actualIngredient).toList();
      final nonActualIngredients =
          ingredients.where((ing) => !ing.actualIngredient).toList();

      final itemCount = ingredients.length + 2;

      log('IngredientsWidget rebuild: itemCount=$itemCount');

      if (ingredients.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 72),
        itemBuilder: (context, index) {
          if (index == 0) {
            return ListTile(
              title: Text(
                TranslationKeys.actualIngredients.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.kitchen_outlined),
              subtitle: Text(TranslationKeys.actualIngredientsSubtitle.tr),
            );
          }

          if (index == actualIngredients.length + 1) {
            return ListTile(
              title: Text(
                TranslationKeys.nonActualIngredients.tr,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.shopping_cart_outlined),
              subtitle: Text(TranslationKeys.nonActualIngredientsSubtitle.tr),
            );
          }

          if (index <= actualIngredients.length) {
            final ingredient = actualIngredients[index - 1];
            return _ingredientItemBuilder(
              context: context,
              ingredient: ingredient,
              groupsService: groupsService,
            );
          } else {
            final ingredient =
                nonActualIngredients[index - actualIngredients.length - 2];
            return _ingredientItemBuilder(
              context: context,
              ingredient: ingredient,
              groupsService: groupsService,
            );
          }
        },
        itemCount: itemCount,
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    TranslationKeys.noIngredientsCreated.tr,
                    style: Get.textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    TranslationKeys.noIngredientsCreatedDescription.tr,
                    style: Get.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _ingredientItemBuilder({
    required BuildContext context,
    required FRIngredient ingredient,
    required GroupsService groupsService,
  }) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      contentPadding: EdgeInsets.only(left: 4, right: 4),
      title: Text(ingredient.name),
      leading: Padding(
        padding: const EdgeInsets.only(left: 12, right: 6),
        child: Icon(
          ingredient.actualIngredient ? Icons.kitchen : Icons.shopping_cart,
          color:
              ingredient.actualIngredient
                  ? Get.theme.colorScheme.primary
                  : Get.theme.colorScheme.secondary,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          Get.dialog(
            EditIngredientModal(
              groupId: groupsService.selectedGroup.value!.id,
              ingredient: ingredient,
            ),
            useSafeArea: false,
          );
        },
        icon: const Icon(Icons.edit),
      ),
    );
  }
}
