import 'dart:developer';

import 'package:get/get.dart';
import 'package:felicette_recipes/app/data/models/group_models.dart';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/data/models/recipe_models.dart';
import 'package:felicette_recipes/app/modules/home/home_controller.dart';
import 'package:felicette_recipes/app/modules/home/widgets/list/widgets/edit_ingredient_price_modal/edit_ingredient_price_view.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';
import 'package:felicette_recipes/app/services/recipes_service.dart';
import 'package:felicette_recipes/app/utils/secure_storage.dart';

enum ListDisplayTypeEnum { ingredients, recipes }

class ListIngredientItem {
  final FRIngredient ingredient;
  final List<FRIngredientPrice> price;
  final List<FRRecipe> recipes;
  final bool isChecked;
  final String? quantity;

  ListIngredientItem({
    required this.ingredient,
    required this.price,
    required this.isChecked,
    required this.recipes,
    required this.quantity,
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

const String displayTypeKey = 'list_display_type';

class ListController extends GetxController {
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final GroupsService groupsService = Get.find<GroupsService>();
  final HomeController homeController = Get.find<HomeController>();
  final RecipesService recipesService = Get.find<RecipesService>();
  final Rx<ListDisplayTypeEnum> displayType =
      ListDisplayTypeEnum.ingredients.obs;

  saveDisplayTypeToStorage(ListDisplayTypeEnum type) async {
    await RFSecureStorage.write(key: displayTypeKey, value: type.toString());
  }

  fetchDisplayTypeFromStorage() async {
    final storedType = await RFSecureStorage.read(key: displayTypeKey);
    if (storedType != null) {
      if (storedType == ListDisplayTypeEnum.ingredients.toString()) {
        displayType.value = ListDisplayTypeEnum.ingredients;
      } else if (storedType == ListDisplayTypeEnum.recipes.toString()) {
        displayType.value = ListDisplayTypeEnum.recipes;
      }
    }
  }

  setDisplayType(ListDisplayTypeEnum type) {
    displayType.value = type;
    saveDisplayTypeToStorage(type);
  }

  bool get showCheckedFirst =>
      groupsService.selectedGroup.value?.filters.showCheckedsFirst ?? false;

  setShowCheckedFirst(bool value) {
    groupsService.updateCurrentGroupFilters(
      groupsService.selectedGroup.value!.filters.copyWith(
        showCheckedsFirst: value,
      ),
    );
  }

  setShowBudget(bool value) {
    groupsService.updateCurrentGroupFilters(
      groupsService.selectedGroup.value!.filters.copyWith(showBudget: value),
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
      final ingredient = ingredientsService.getIngredientById(ingredientId);
      if (ingredient == null) continue;

      final prices = group.ingredientsPrices[ingredientId];
      final isChecked = group.checkedIngredients.contains(ingredientId);
      final recipes = recipesService.getRecipesByIngredientId(
        ingredientId,
        currentListRecipes,
      );

      String? quantity;

      if (group.currentIngredients.any(
        (ingMap) => ingMap.ingredientId == ingredientId,
      )) {
        quantity =
            group.currentIngredients
                .firstWhere((ingMap) => ingMap.ingredientId == ingredientId)
                .quantity;
      }

      list.add(
        ListIngredientItem(
          ingredient: ingredient,
          price: prices ?? [],
          isChecked: isChecked,
          recipes: recipes,
          quantity: quantity,
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

  List<ListIngredientItem> get ingredientsWithoutRecipes {
    final allIngredients = sortedIngredientList;
    return allIngredients.where((item) => item.recipes.isEmpty).toList();
  }

  openEditIngredientPriceModal(FRGroup group, ListIngredientItem item) {
    Get.dialog(
      useSafeArea: false,
      EditIngredientPriceModal(group: group, item: item),
    );
  }

  handleCheckIngredient(ListIngredientItem item, bool isChecked) async {
    groupsService.checkIngredient(
      ingredientId: item.ingredient.id,
      isChecked: isChecked,
    );
    if (isChecked) {
      openEditIngredientPriceModal(groupsService.selectedGroup.value!, item);
    } else {
      groupsService.removeIngredientPrice(ingredientId: item.ingredient.id);
    }
  }

  @override
  void onInit() {
    log('ListController: onInit called', name: 'ListController');
    fetchDisplayTypeFromStorage();
    super.onInit();
  }
}
