import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/widgets/appbar/appbar.dart';
import 'package:recipes_flutter/app/common/widgets/drawer/drawer.dart';
import 'package:recipes_flutter/app/modules/home/widgets/budget_display/budget_display.dart';
import 'package:recipes_flutter/app/modules/home/widgets/ingredients/ingredients.dart';
import 'package:recipes_flutter/app/modules/home/widgets/ingredients/new/new_fab.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FRAppbar(title: Obx(() => Text(controller.currentItemTitle))),
      drawer: const FRDrawer(),
      floatingActionButton: Obx(() {
        if (controller.bottomNavigationIndexIs(
          BottomNavigationItemEnum.ingredients,
        )) {
          return NewIngredientFab();
        }
        return SizedBox.shrink();
      }),
      body: Obx(() {
        if (controller.bottomNavigationIndexIs(
          BottomNavigationItemEnum.recipes,
        )) {
          return const Center(child: Text('Recipes View'));
        }
        if (controller.bottomNavigationIndexIs(BottomNavigationItemEnum.list)) {
          return const Center(child: Text('List View'));
        }
        if (controller.bottomNavigationIndexIs(
          BottomNavigationItemEnum.ingredients,
        )) {
          return IngredientsWidget();
        }
        return const Center(child: Text('Unknown View'));
      }),
      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: controller.bottomNavigationIndexIs(
                BottomNavigationItemEnum.list,
              ),
              child: BudgetDisplay(
                used: 123,
                total: controller.budget,
                currency: controller.currency,
              ),
            ),
            NavigationBar(
              selectedIndex: controller.bottomNavigationIndex.value,
              onDestinationSelected: controller.setBottomNavigationIndex,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.book), label: 'Recipes'),
                NavigationDestination(icon: Icon(Icons.list), label: 'List'),
                NavigationDestination(
                  icon: Icon(Icons.kitchen),
                  label: 'Ingredients',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
