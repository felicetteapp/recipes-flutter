import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/modules/home/home_controller.dart';
import 'package:recipes_flutter/app/modules/home/widgets/recipes/edit_create_modal/edit_create_modal_view.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/services/recipes_service.dart';

class RecipesWidget extends StatelessWidget {
  const RecipesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final recipesService = Get.find<RecipesService>();
    final groupsService = Get.find<GroupsService>();
    final ingredientsService = Get.find<IngredientsService>();
    final homeViewController = Get.find<HomeController>();
    return Obx(() {
      final recipes = recipesService.recipes;

      final itemCount = recipes.length;

      log('RecipesWidget rebuild: itemCount=$itemCount');

      return ListView.builder(
        padding: EdgeInsets.only(bottom: 72),
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return _recipeItemBuilder(
            context: context,
            recipe: recipe,
            groupsService: groupsService,
            ingredientsService: ingredientsService,
            recipesService: recipesService,
            homeViewController: homeViewController,
          );
        },
        itemCount: itemCount,
      );
    });
  }

  Widget _recipeItemBuilder({
    required BuildContext context,
    required FRRecipe recipe,
    required GroupsService groupsService,
    required IngredientsService ingredientsService,
    required RecipesService recipesService,
    required HomeController homeViewController,
  }) {
    final isInList = recipesService.isRecipeInSelectedGroupList(recipe.id);
    final ingredients =
        recipe.ingredients
            .map((ri) {
              final ingredient = ingredientsService.getIngredientById(
                ri.ingredientId,
              );
              return ingredient;
            })
            .whereType<FRIngredient>()
            .toList();

    ingredients.sort((a, b) => a.name.compareTo(b.name));

    return Obx(
      () => ListTile(
        leading:
            homeViewController.itsSelectionMode.value
                ? Checkbox(
                  value: homeViewController.selectedIds.contains(recipe.id),
                  onChanged: (checked) {
                    if (checked == true) {
                      homeViewController.selectedIds.add(recipe.id);
                    } else {
                      homeViewController.selectedIds.remove(recipe.id);
                    }
                  },
                  activeColor: Theme.of(context).colorScheme.secondary,
                )
                : null,
        title: Wrap(
          spacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text(recipe.name),
            if (isInList && !homeViewController.itsSelectionMode.value)
              Container(
                decoration: BoxDecoration(
                  color: Get.theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 2,
                  children: [
                    Icon(
                      Icons.list,
                      size: 14,
                      color: Get.theme.colorScheme.onPrimaryContainer,
                    ),
                    Text(
                      TranslationKeys.onList.tr.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        height: 0.8,
                        color: Get.theme.colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        onTap:
            homeViewController.itsSelectionMode.value
                ? () {
                  if (homeViewController.selectedIds.contains(recipe.id)) {
                    homeViewController.selectedIds.remove(recipe.id);
                  } else {
                    homeViewController.selectedIds.add(recipe.id);
                  }
                }
                : null,
        onLongPress:
            homeViewController.itsSelectionMode.value
                ? null
                : () {
                  homeViewController.enableRecipesSelectionMode();
                },
        subtitle: Text(ingredients.map((i) => i.name).join(', ')),
        contentPadding: EdgeInsets.symmetric(horizontal: 16),
        trailing:
            !homeViewController.itsSelectionMode.value
                ? Row(
                  spacing: 4,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.dialog(
                          EditCreateRecipeModal(
                            groupId: groupsService.selectedGroup.value!.id,
                            recipe: recipe,
                          ),
                          useSafeArea: false,
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                  ],
                )
                : null,
      ),
    );
  }
}
