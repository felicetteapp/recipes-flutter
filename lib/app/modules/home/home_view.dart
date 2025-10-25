import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_helper.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/common/widgets/appbar/appbar.dart';
import 'package:recipes_flutter/app/common/widgets/drawer/drawer.dart';
import 'package:recipes_flutter/app/modules/home/widgets/budget_display/budget_display.dart';
import 'package:recipes_flutter/app/modules/home/widgets/ingredients/ingredients.dart';
import 'package:recipes_flutter/app/modules/home/widgets/ingredients/new/new_fab.dart';
import 'package:recipes_flutter/app/modules/home/widgets/list/list.dart';
import 'package:recipes_flutter/app/modules/home/widgets/recipes/edit_create_modal/edit_create_modal_view.dart';
import 'package:recipes_flutter/app/modules/home/widgets/recipes/recipes.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  _buildBody() {
    return Obx(() {
      if (controller.bottomNavigationIndexIs(
        BottomNavigationItemEnum.recipes,
      )) {
        return const RecipesWidget();
      }
      if (controller.bottomNavigationIndexIs(BottomNavigationItemEnum.list)) {
        return const ListWidget();
      }
      if (controller.bottomNavigationIndexIs(
        BottomNavigationItemEnum.ingredients,
      )) {
        return IngredientsWidget();
      }
      return Center(child: Text(TranslationKeys.unknownView.tr));
    });
  }

  _buildBottomNavigationBar() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible: controller.bottomNavigationIndexIs(
              BottomNavigationItemEnum.list,
            ),
            child: BudgetDisplay(
              used: controller.usedBudget,
              total: controller.budget,
              currency: controller.currency,
            ),
          ),
          NavigationBar(
            height: 80,
            selectedIndex: controller.bottomNavigationIndex.value,
            onDestinationSelected: controller.setBottomNavigationIndex,
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.book),
                label:
                    TranslationHelper.plural(
                      TranslationKeys.recipe,
                      0,
                    ).capitalizeFirst!,
              ),
              NavigationDestination(
                icon: Icon(Icons.list),
                label:
                    TranslationHelper.plural(
                      TranslationKeys.list,
                      1,
                    ).capitalizeFirst!,
              ),
              NavigationDestination(
                icon: Icon(Icons.kitchen),
                label:
                    TranslationHelper.plural(
                      TranslationKeys.ingredient,
                      0,
                    ).capitalizeFirst!,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildFloatingActionButton() {
    final groupsService = Get.find<GroupsService>();

    return Obx(() {
      if (controller.bottomNavigationIndexIs(
        BottomNavigationItemEnum.ingredients,
      )) {
        return NewIngredientFab();
      }
      if (controller.bottomNavigationIndexIs(
        BottomNavigationItemEnum.recipes,
      )) {
        if (controller.itsSelectionMode.value) {
          return FloatingActionButton.large(
            backgroundColor: Get.theme.colorScheme.secondary,
            foregroundColor: Get.theme.colorScheme.onSecondary,
            child: const Icon(Icons.save),
            onPressed: () {
              controller.saveRecipesSelection();
            },
          );
        }

        return FloatingActionButton.extended(
          onPressed: () {
            Get.dialog(
              EditCreateRecipeModal(
                groupId: groupsService.selectedGroup.value!.id,
                recipe: null,
              ),
              useSafeArea: false,
            );
          },
          icon: const Icon(Icons.add),
          label: Text(TranslationKeys.addRecipe.tr),
        );
      }
      return SizedBox.shrink();
    });
  }

  _buildAppBarTitle() {
    return Obx(() {
      return Text(controller.currentItemTitle);
    });
  }

  List<Widget>? _buildAppBarActions() {
    return [
      Obx(
        () => Visibility(
          visible: controller.bottomNavigationIndexIs(
            BottomNavigationItemEnum.recipes,
          ),
          child: TextButton(
            onPressed: () {
              controller.enableRecipesSelectionMode();
            },
            child: Text(TranslationKeys.selectRecipes.tr),
          ),
        ),
      ),
    ];
  }

  _buildAppBar() {
    if (controller.itsSelectionMode.value) {
      return FRAppbar(
        title: Text(
          TranslationHelper.plural(
            TranslationKeys.itemsSelected,
            controller.selectedIds.length,
          ),
        ),
        showBackButton: false,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            controller.itsSelectionMode.value = false;
            controller.selectedIds.clear();
          },
        ),
        selectingMode: true,
      );
    }
    return FRAppbar(title: _buildAppBarTitle(), actions: _buildAppBarActions());
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: _buildAppBar(),
        drawer: const FRDrawer(),
        floatingActionButton: _buildFloatingActionButton(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}
