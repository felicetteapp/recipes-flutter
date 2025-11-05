import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_helper.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';
import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/common/widgets/drawer/drawer.dart';
import 'package:felicette_recipes/app/modules/home/widgets/budget_display/budget_display.dart';
import 'package:felicette_recipes/app/modules/home/widgets/ingredients/ingredients.dart';
import 'package:felicette_recipes/app/modules/home/widgets/ingredients/new/new_fab.dart';
import 'package:felicette_recipes/app/modules/home/widgets/list/list.dart';
import 'package:felicette_recipes/app/modules/home/widgets/list/widgets/edit_list_modal/edit_list_modal_view.dart';
import 'package:felicette_recipes/app/modules/home/widgets/recipes/edit_create_modal/edit_create_modal_view.dart';
import 'package:felicette_recipes/app/modules/home/widgets/recipes/recipes.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';

import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  _buildBodyWithNoGroups() {
    final isLoading = false.obs;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
              maxWidth: constraints.maxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 16,
              children: [
                Text(
                  TranslationKeys.noGroupsCreated.tr,
                  style: Get.textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Obx(() {
                  return FilledButton(
                    onPressed:
                        isLoading.value
                            ? null
                            : () async {
                              isLoading.value = true;
                              await controller.handleCreateFirstGroup();
                              isLoading.value = false;
                            },
                    child: Text(
                      isLoading.value
                          ? TranslationKeys.loading.tr
                          : TranslationKeys.createGroup.tr,
                    ),
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildBody() {
    return Obx(() {
      if (controller.userHasAnyGroup == false) {
        return _buildBodyWithNoGroups();
      }

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
    return Obx(() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Visibility(
            visible:
                controller.bottomNavigationIndexIs(
                  BottomNavigationItemEnum.list,
                ) &&
                controller.userHasAnyGroup,
            child: BudgetDisplay(
              used: controller.usedBudget,
              total: controller.budget,
              currency: controller.currency,
              showBudget: controller.showBudget,
            ),
          ),
          NavigationBar(
            height: 80,
            selectedIndex: controller.bottomNavigationIndex.value,
            onDestinationSelected: controller.setBottomNavigationIndex,
            destinations: [
              NavigationDestination(
                enabled: controller.userHasAnyGroup,
                icon: Badge(
                  isLabelVisible:
                      !controller.groupHasRecipes && controller.userHasAnyGroup,
                  child: Icon(Icons.book),
                ),
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
                enabled: controller.userHasAnyGroup,
                icon: Badge(
                  isLabelVisible:
                      !controller.groupHasIngredients &&
                      controller.userHasAnyGroup,
                  child: Icon(Icons.kitchen),
                ),
                label:
                    TranslationHelper.plural(
                      TranslationKeys.ingredient,
                      0,
                    ).capitalizeFirst!,
              ),
            ],
          ),
        ],
      );
    });
  }

  _buildFloatingActionButton() {
    final groupsService = Get.find<GroupsService>();

    return Obx(() {
      if (controller.userHasAnyGroup == false) {
        return SizedBox.shrink();
      }

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
    final GroupsService groupsService = Get.find<GroupsService>();

    return [
      Obx(
        () => Visibility(
          visible:
              controller.bottomNavigationIndexIs(
                BottomNavigationItemEnum.recipes,
              ) &&
              controller.userHasAnyGroup,
          child: TextButton(
            onPressed: () {
              controller.enableRecipesSelectionMode();
            },
            child: Text(TranslationKeys.selectRecipes.tr),
          ),
        ),
      ),

      Obx(
        () => Visibility(
          visible:
              controller.bottomNavigationIndexIs(
                BottomNavigationItemEnum.list,
              ) &&
              groupsService.selectedGroup.value != null &&
              controller.userHasAnyGroup,
          child: TextButton(
            onPressed: () {
              Get.dialog(
                EditListModal(groupId: groupsService.selectedGroup.value!.id),
                useSafeArea: false,
              );
            },
            child: Text(TranslationKeys.editList.tr),
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
        drawer: FRDrawer(),
        floatingActionButton: _buildFloatingActionButton(),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }
}
