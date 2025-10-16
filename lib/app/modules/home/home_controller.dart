import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxInt bottomNavigationIndex = 0.obs;

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
