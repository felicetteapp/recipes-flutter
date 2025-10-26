import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import 'package:recipes_flutter/app/services/recipes_service.dart';

class EditListModalController extends GetxController {
  final String groupId;
  final RxBool isLoading = false.obs;
  final TextEditingController budgetController = TextEditingController();

  final GroupsService groupsService = Get.find<GroupsService>();
  final RecipesService recipesService = Get.find<RecipesService>();
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final LocalizationService localizationService =
      Get.find<LocalizationService>();

  List<FRRecipe> get recipes => recipesService.getCurrentGroupRecipes();
  List<FRRecipe> get availableRecipes => recipesService.recipes;

  List<FRIngredient> get availableIngredients => ingredientsService.ingredients;
  List<FRIngredient> get currentIngredients =>
      ingredientsService.getCurrentGroupIngredients();

  List<String> get listCurrency => [
    groupsService.selectedGroup.value?.currency ?? '',
  ];

  List<String> get availableCurrencies =>
      localizationService.availableCurrencies;

  num get budget => groupsService.selectedGroup.value?.budget ?? 0;

  EditListModalController({required this.groupId});

  /// Validates if the budget text is a valid number
  bool isBudgetValid() {
    final budgetText = budgetController.text.trim();
    if (budgetText.isEmpty) return true; // Allow empty budget

    final budgetValue = double.tryParse(budgetText);
    return budgetValue != null && budgetValue >= 0;
  }

  double getBudgetValue() {
    final budgetText = budgetController.text.trim();
    if (budgetText.isEmpty) return 0.0;

    return double.tryParse(budgetText) ?? 0.0;
  }

  String? validateBudget(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    final budgetValue = double.tryParse(value.trim());
    if (budgetValue == null) {
      return 'Please enter a valid number';
    }

    if (budgetValue < 0) {
      return 'Budget must be a positive number';
    }

    return null;
  }

  void updateBudgetValidation(String value) {
    validateBudget(value);
  }

  handleOnChange(List<FRRecipe> selectedRecipes) {
    isLoading.value = true;
    Get.log(
      'EditListModalController - handleOnChange: selectedRecipes=${selectedRecipes.map((e) => e.name).toList()}',
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();

    final currentBudget = budget;
    Get.log(
      'EditListModalController initialized for group $groupId with ${recipes.length} recipes, '
      '${currentIngredients.length} ingredients, budget: $currentBudget, '
      'currency: ${listCurrency.isNotEmpty ? listCurrency[0] : 'N/A'}',
    );
    budgetController.text = currentBudget.toString();
  }

  @override
  void onClose() {
    budgetController.dispose();
    super.onClose();
  }
}
