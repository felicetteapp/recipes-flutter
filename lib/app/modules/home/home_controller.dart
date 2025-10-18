import 'package:get/get.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';

class HomeController extends GetxController {
  final RxInt bottomNavigationIndex = 1.obs;
  final GroupsService groupsService = Get.find<GroupsService>();

  double get budget => groupsService.selectedGroup.value?.budget ?? 0.0;
  String get currency => groupsService.selectedGroup.value?.currency ?? '';

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
}

enum BottomNavigationItemEnum { recipes, list, ingredients }
