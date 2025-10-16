import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/widgets/appbar/appbar.dart';
import 'package:recipes_flutter/app/common/widgets/drawer/drawer.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FRAppbar(title: Obx(() => Text(controller.currentItemTitle))),
      drawer: const FRDrawer(),
      body: const Center(child: Text('Welcome to the Home Page!')),
      bottomNavigationBar: Obx(
        () => NavigationBar(
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
      ),
    );
  }
}
