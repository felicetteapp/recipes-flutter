import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/modules/home/home_controller.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/utils/snackbar.dart';

enum ListDisplayTypeEnum { ingredients, recipes }

class ListController extends GetxController {
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final GroupsService groupsService = Get.find<GroupsService>();
  final HomeController homeController = Get.find<HomeController>();
  final Rx<ListDisplayTypeEnum> displayType =
      ListDisplayTypeEnum.ingredients.obs;

  setDisplayType(ListDisplayTypeEnum type) {
    displayType.value = type;
  }

  bool get showCheckedFirst =>
      groupsService.selectedGroup.value?.filters.showCheckedsFirst ?? false;

  setShowCheckedFirst(bool value) {
    groupsService.updateCurrentGroupFilters(
      FRGroupFilter(showCheckedsFirst: value),
    );
  }

  @override
  void onInit() {
    super.onInit();

    debounce(displayType, (type) {
      final itsStillAtList = homeController.bottomNavigationIndexIs(
        BottomNavigationItemEnum.list,
      );
      if (!itsStillAtList) {
        return;
      }

      final double bottomMargin = 80 + 8;
      final EdgeInsets margin = EdgeInsets.only(
        bottom: bottomMargin,
        left: 10,
        right: 10,
      );
      switch (type) {
        case ListDisplayTypeEnum.ingredients:
          FRSnackbar.info(
            'Info',
            'Showing list of ingredients',
            duration: Duration(seconds: 2),
            margin: margin,
          );
        case ListDisplayTypeEnum.recipes:
          FRSnackbar.info(
            'Info',
            'Showing list grouped by recipes',
            duration: Duration(seconds: 2),
            margin: margin,
          );
      }
      log('displayType changed to $type', name: 'ListController');
    }, time: Duration(seconds: 1));

    // Initialize any necessary data or listeners here
  }
}
