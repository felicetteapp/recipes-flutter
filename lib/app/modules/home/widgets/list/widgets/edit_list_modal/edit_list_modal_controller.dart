import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';
import 'package:recipes_flutter/app/services/recipes_service.dart';
import 'package:recipes_flutter/app/utils/snackbar.dart';

class EditListModalController extends GetxController {
  final String groupId;
  final RxBool isLoading = false.obs;
  final TextEditingController budgetController = TextEditingController();

  final GroupsService groupsService = Get.find<GroupsService>();
  final RecipesService recipesService = Get.find<RecipesService>();
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final LocalizationService localizationService =
      Get.find<LocalizationService>();

  final RxList<FRRecipe> selectedRecipes = RxList<FRRecipe>([]);
  final RxList<String> selectedCurrency = RxList<String>([]);

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

  handleRecipesOnChange(List<FRRecipe> selectedRecipes) {
    this.selectedRecipes.assignAll(selectedRecipes);
    Get.log(
      'EditListModalController - handleOnChange: selectedRecipes=${selectedRecipes.map((e) => e.name).toList()}',
    );
  }

  handleCurrencyOnChange(List<String> selectedCurrency) {
    this.selectedCurrency.assignAll(selectedCurrency);
    Get.log(
      'EditListModalController - handleOnChange: selectedCurrency=$selectedCurrency',
    );
  }

  handleOnSave() async {
    isLoading.value = true;
    final selectedGroup = groupsService.selectedGroup.value;
    if (selectedGroup == null) {
      Get.snackbar('Error', 'No group selected');
      isLoading.value = false;
      return;
    }

    final updatedGroup = selectedGroup.copyWith(
      budget: getBudgetValue(),
      currency:
          selectedCurrency.isNotEmpty
              ? selectedCurrency[0]
              : selectedGroup.currency,
      currentRecipes: selectedRecipes.map((r) => r.id).toList(),
    );

    try {
      await groupsService.updateGroupListDetails(updatedGroup);
      Get.back();
      FRSnackbar.success('Success', 'List details updated successfully');
    } catch (e) {
      FRSnackbar.error('Error', 'Failed to update list details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    final currentBudget = budget;
    Get.log(
      'EditListModalController initialized for group $groupId with ${recipes.length} recipes, '
      '${currentIngredients.length} ingredients, budget: $currentBudget, '
      'currency: ${listCurrency.isNotEmpty ? listCurrency[0] : 'N/A'}',
    );
    budgetController.text = currentBudget.toString();

    final currentRecipes = recipes;
    selectedRecipes.assignAll(currentRecipes);
    final currentCurrency = listCurrency;
    selectedCurrency.assignAll(currentCurrency);
  }

  @override
  void onClose() {
    budgetController.dispose();
    super.onClose();
  }
}
