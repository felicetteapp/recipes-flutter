import 'dart:developer';

import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';

class HomeController extends GetxController {
  final RxInt bottomNavigationIndex = 1.obs;
  final GroupsService groupsService = Get.find<GroupsService>();
  final RxBool itsSelectionMode = false.obs;
  final RxList<String> selectedIds = RxList<String>();

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
        return 'Recipes';
      case BottomNavigationItemEnum.list:
        return 'List';
      case BottomNavigationItemEnum.ingredients:
        return 'Ingredients';
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
