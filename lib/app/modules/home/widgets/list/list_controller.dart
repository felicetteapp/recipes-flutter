import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/modules/home/home_controller.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/services/recipes_service.dart';
import 'package:recipes_flutter/app/utils/snackbar.dart';

enum ListDisplayTypeEnum { ingredients, recipes }

class ListIngredientItem {
  final FRIngredient ingredient;
  final List<FRIngredientPrice> price;
  final List<FRRecipe> recipes;
  final bool isChecked;

  ListIngredientItem({
    required this.ingredient,
    required this.price,
    required this.isChecked,
    required this.recipes,
  });
}

class ListRecipeItem {
  final FRRecipe recipe;
  final List<FRIngredient> ingredients;
  final bool isChecked;

  ListRecipeItem({
    required this.recipe,
    required this.ingredients,
    required this.isChecked,
  });
}

class ListController extends GetxController {
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final GroupsService groupsService = Get.find<GroupsService>();
  final HomeController homeController = Get.find<HomeController>();
  final RecipesService recipesService = Get.find<RecipesService>();
  final Rx<ListDisplayTypeEnum> displayType =
      ListDisplayTypeEnum.ingredients.obs;

  setDisplayType(ListDisplayTypeEnum type) {
    displayType.value = type;
  }

  bool get showCheckedFirst =>
      groupsService.selectedGroup.value?.filters.showCheckedsFirst ?? false;

  setShowCheckedFirst(bool value) {
    groupsService.updateCurrentGroupFilters(
      FRGroupFilter(showCheckedsFirst: value),
    );
  }

  List<ListIngredientItem> get sortedIngredientList {
    log('Building sortedIngredientList', name: 'ListController');
    final List<ListIngredientItem> list = <ListIngredientItem>[];

    final group = groupsService.selectedGroup.value;

    log('Selected group: ${group?.name}', name: 'ListController');
    if (group == null) {
      return list;
    }

    log(
      'Building sortedIngredientList for group: ${group.name}',
      name: 'ListController',
    );

    final currentListRecipes = recipesService.getCurrentGroupRecipes();

    final ingredientsIds = [
      ...group.currentIngredients.map(
        (ingredientMap) => ingredientMap.ingredientId,
      ),
    ];

    for (final recipe in currentListRecipes) {
      for (final ri in recipe.ingredients) {
        if (!ingredientsIds.contains(ri.ingredientId)) {
          ingredientsIds.add(ri.ingredientId);
        }
      }
    }

    for (final ingredientId in ingredientsIds) {
      log('Processing ingredient map: $ingredientId', name: 'ListController');

      final ingredient = ingredientsService.getIngredientById(ingredientId);
      if (ingredient == null) continue;

      final prices = group.ingredientsPrices[ingredientId];
      final isChecked = group.checkedIngredients.contains(ingredientId);
      final recipes = recipesService.getRecipesByIngredientId(
        ingredientId,
        currentListRecipes,
      );

      log(
        'Ingredient: ${ingredient.name}, Price: ${prices?.map((p) => '${p.quantity} ${p.unitPrice}').join(', ')}, Recipes: ${recipes.map((r) => r.name).join(', ')}, Checked: $isChecked',
        name: 'ListController',
      );

      list.add(
        ListIngredientItem(
          ingredient: ingredient,
          price: prices ?? [],
          isChecked: isChecked,
          recipes: recipes,
        ),
      );
    }

    if (showCheckedFirst) {
      list.sort((a, b) {
        if (a.isChecked && !b.isChecked) {
          return -1;
        } else if (!a.isChecked && b.isChecked) {
          return 1;
        } else {
          return 0;
        }
      });
    }

    return list;
  }

  List<ListRecipeItem> get sortedRecipeList {
    final List<ListRecipeItem> list = <ListRecipeItem>[];

    final group = groupsService.selectedGroup.value;

    if (group == null) {
      return list;
    }

    final currentListRecipes = recipesService.getCurrentGroupRecipes();

    for (final recipe in currentListRecipes) {
      final isChecked = group.currentRecipes.contains(recipe.id);
      final ingredients =
          recipe.ingredients
              .map(
                (ri) => ingredientsService.getIngredientById(ri.ingredientId),
              )
              .whereType<FRIngredient>()
              .toList();

      list.add(
        ListRecipeItem(
          recipe: recipe,
          ingredients: ingredients,
          isChecked: isChecked,
        ),
      );
    }

    list.sort((a, b) {
      return a.recipe.name.compareTo(b.recipe.name);
    });

    return list;
  }

  @override
  void onInit() {
    super.onInit();

    debounce(displayType, (type) {
      final itsStillAtList = homeController.bottomNavigationIndexIs(
        BottomNavigationItemEnum.list,
      );
      if (!itsStillAtList) {
        return;
      }

      final double bottomMargin = 80 + 8;
      final EdgeInsets margin = EdgeInsets.only(
        bottom: bottomMargin,
        left: 10,
        right: 10,
      );
      switch (type) {
        case ListDisplayTypeEnum.ingredients:
          FRSnackbar.info(
            'Info',
            'Showing list of ingredients',
            duration: Duration(seconds: 2),
            margin: margin,
          );
        case ListDisplayTypeEnum.recipes:
          FRSnackbar.info(
            'Info',
            'Showing list grouped by recipes',
            duration: Duration(seconds: 2),
            margin: margin,
          );
      }
      log('displayType changed to $type', name: 'ListController');
    }, time: Duration(seconds: 1));

    // Initialize any necessary data or listeners here
  }
}
