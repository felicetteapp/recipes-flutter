import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
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

    return ListTile(
      title: Text(recipe.name),
      subtitle: Text(ingredients.map((i) => i.name).join(', ')),
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      trailing: Row(
        spacing: 4,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isInList)
            Chip(
              label: Text('on list'),
              avatar: isInList ? Icon(Icons.list) : null,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.all(9),
              //            labelPadding: EdgeInsets.all(2),
            ),
          IconButton(
            onPressed: () {
              log('Edit Recipe: ${recipe.name}');
            },
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
    );
  }
}
