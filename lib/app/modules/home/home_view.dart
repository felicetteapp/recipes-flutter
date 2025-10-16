import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/widgets/appbar/appbar.dart';
import 'package:recipes_flutter/app/common/widgets/drawer/drawer.dart';
import 'package:recipes_flutter/app/modules/home/widgets/budget_display/budget_display.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FRAppbar(title: Obx(() => Text(controller.currentItemTitle))),
      drawer: const FRDrawer(),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return ListTile(title: Text('Item $index'));
        },
        itemCount: 20,
      ),
      bottomNavigationBar: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Visibility(
              visible: controller.bottomNavigationIndexIs(
                BottomNavigationItemEnum.list,
              ),
              child: BudgetDisplay(used: 123, total: 456),
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
