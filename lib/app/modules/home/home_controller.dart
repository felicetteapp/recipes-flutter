import 'dart:developer';

import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';
import 'package:felicette_recipes/app/services/recipes_service.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/common.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';

class HomeController extends GetxController {
  final RxInt bottomNavigationIndex = 1.obs;
  final GroupsService groupsService = Get.find<GroupsService>();
  final RecipesService recipesService = Get.find<RecipesService>();
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final RxBool itsSelectionMode = false.obs;
  final RxList<String> selectedIds = RxList<String>();

  bool get userHasAnyGroup => groupsService.userHasAnyGroup;
  bool get groupHasRecipes => recipesService.recipes.isNotEmpty;
  bool get groupHasIngredients => ingredientsService.ingredients.isNotEmpty;

  bool get showBudget =>
      groupsService.selectedGroup.value?.filters.showBudget ?? false;
  double get budget => groupsService.selectedGroup.value?.budget ?? 0.0;
  String get currency => groupsService.selectedGroup.value?.currency ?? '';
  double get usedBudget =>
      groupsService.selectedGroup.value?.ingredientsPrices.values
          .expand((prices) => prices)
          .fold(
            0.0,
            (sum, price) => (sum ?? 0) + price.unitPrice * price.quantity,
          ) ??
      0.0;

  final List<BottomNavigationItemEnum> bottomNavigationItems = [
    BottomNavigationItemEnum.recipes,
    BottomNavigationItemEnum.list,
    BottomNavigationItemEnum.ingredients,
  ];

  void setBottomNavigationIndex(int index) {
    bottomNavigationIndex.value = index;
  }

  Future<void> handleCreateFirstGroup() async {
    final name = TranslationKeys.myFirstGroup.tr;
    final createdGroup = await groupsService.createGroup(name);
    await Future.delayed(const Duration(seconds: 1));
    Get.toNamed(AppRoutes.groupDetails(createdGroup.id));
  }

  void bottomNavigationGoTo(BottomNavigationItemEnum item) {
    final int index = bottomNavigationItems.indexOf(item);
    if (index != -1) {
      bottomNavigationIndex.value = index;
    }
  }

  bool bottomNavigationIndexIs(BottomNavigationItemEnum item) {
    return bottomNavigationItems[bottomNavigationIndex.value] == item;
  }

  String get currentItemTitle {
    switch (bottomNavigationItems[bottomNavigationIndex.value]) {
      case BottomNavigationItemEnum.recipes:
        return TranslationHelper.plural(
          TranslationKeys.recipe,
          0,
        ).capitalizeFirst!;
      case BottomNavigationItemEnum.list:
        return TranslationHelper.plural(
          TranslationKeys.list,
          1,
        ).capitalizeFirst!;
      case BottomNavigationItemEnum.ingredients:
        return TranslationHelper.plural(
          TranslationKeys.ingredient,
          0,
        ).capitalizeFirst!;
    }
  }

  enableRecipesSelectionMode() {
    itsSelectionMode.value = true;
    selectedIds.clear();
    selectedIds.addAll(groupsService.selectedGroup.value?.currentRecipes ?? []);
  }

  saveRecipesSelection() {
    final selectedGroup = groupsService.selectedGroup.value;
    if (selectedGroup != null) {
      groupsService.updateCurrentGroupRecipes(selectedIds.toList());
    }
    itsSelectionMode.value = false;
    selectedIds.clear();
  }

  @override
  void onInit() {
    super.onInit();

    bottomNavigationIndex.listen((index) {
      log('Bottom Navigation Index changed to $index', name: 'HomeController');
      itsSelectionMode.value = false;
      selectedIds.clear();
    });
  }
}

enum BottomNavigationItemEnum { recipes, list, ingredients }
