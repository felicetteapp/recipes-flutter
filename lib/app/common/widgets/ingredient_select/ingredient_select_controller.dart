import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/data/models/recipe_models.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';

class IngredientSelectController extends GetxController {
  final RxList<BasicIngredientQuantity> selectedItems = RxList.empty();
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final List<BasicIngredientQuantity> value;
  final String Function(BasicIngredientQuantity) itemLabelBuilder;
  final String label;
  final List<GlobalKey> itemKeys = [];

  final RxList<FRIngredient> items = RxList.empty();

  StreamSubscription<List<FRIngredient>>? _itemsSubscription;
  StreamSubscription<List<BasicIngredientQuantity>>? _selectedSubscription;

  final void Function(List<BasicIngredientQuantity>) onChanged;

  IngredientSelectController({
    required this.itemLabelBuilder,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  void onInit() {
    super.onInit();
    selectedItems.assignAll(value);

    items.assignAll(ingredientsService.ingredients);

    _itemsSubscription = ingredientsService.ingredients.listen((
      ingredientList,
    ) {
      log(
        'IngredientSelectController: Received ${ingredientList.length} ingredients',
        name: 'IngredientSelectController',
      );
      items.assignAll(ingredientList);
    });

    _selectedSubscription = selectedItems.listen((selectedList) {
      log(
        'IngredientSelectController: selectedItems changed, count=${selectedList.length}',
        name: 'IngredientSelectController',
      );
      onChanged(selectedList);
    });
  }

  @override
  void onClose() {
    _itemsSubscription?.cancel();
    _selectedSubscription?.cancel();
    super.onClose();
  }
}
