import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/modules/home/widgets/ingredients/edit_modal/edit_modal_view.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';

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

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 72),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const ListTile(
              title: Text(
                'Actual Ingredients',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.kitchen_outlined),
              subtitle: Text(
                'These items can be used in recipes and added to the shopping list',
              ),
            );
          }

          if (index == actualIngredients.length + 1) {
            return const ListTile(
              title: Text(
                'Non-Actual Ingredients',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.shopping_cart_outlined),
              subtitle: Text(
                'This items can be added to the sopping list but can\'t be used in recipes',
              ),
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

  Widget _ingredientItemBuilder({
    required BuildContext context,
    required FRIngredient ingredient,
    required GroupsService groupsService,
  }) {
    return ListTile(
      title: Text(ingredient.name),
      leading: Icon(
        ingredient.actualIngredient ? Icons.kitchen : Icons.shopping_cart,
        color:
            ingredient.actualIngredient
                ? Get.theme.colorScheme.primary
                : Get.theme.colorScheme.secondary,
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
