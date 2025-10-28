import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/data/models/recipe_models.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';
import 'package:felicette_recipes/app/services/recipes_service.dart';
import 'package:felicette_recipes/app/utils/snackbar.dart';

class EditCreateRecipeModalController extends GetxController {
  final String groupId;
  final FRRecipe? recipe;
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final RecipesService recipesService = Get.find<RecipesService>();
  final RxBool isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final RxList<FRRecipeIngredient> ingredients = <FRRecipeIngredient>[].obs;

  EditCreateRecipeModalController({
    required this.groupId,
    required this.recipe,
  });

  @override
  void onInit() {
    super.onInit();
    nameController.text = recipe?.name ?? '';
    ingredients.addAll(recipe?.ingredients ?? []);
  }

  Future<void> createRecipe() async {
    isLoading.value = true;
    final newRecipe = FRRecipe(
      id: '',
      name: nameController.text,
      ingredients: ingredients.toList(),
    );
    await recipesService.createRecipe(groupId: groupId, recipe: newRecipe);
    isLoading.value = false;
    Get.back();
    FRSnackbar.success('Success', 'Recipe created successfully');
  }

  Future<void> updateRecipe() async {
    if (recipe == null) {
      throw Exception('No recipe to update');
    }
    isLoading.value = true;
    final updatedRecipe = recipe!.copyWith(
      name: nameController.text,
      ingredients: ingredients.toList(),
    );
    await recipesService.updateRecipe(groupId: groupId, recipe: updatedRecipe);
    isLoading.value = false;
    Get.back();
    FRSnackbar.success('Success', 'Recipe updated successfully');
  }

  Future<void> deleteRecipe() async {
    if (recipe == null) {
      throw Exception('No recipe to delete');
    }
    isLoading.value = true;
    await recipesService.deleteRecipe(groupId: groupId, recipeId: recipe!.id);
    isLoading.value = false;
    Get.back();
    Get.back();
    FRSnackbar.success('Success', 'Recipe deleted successfully');
  }
}
