import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/utils/snackbar.dart';

class EditIngredientModalController extends GetxController {
  final String groupId;
  final FRIngredient ingredient;
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final RxBool isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final RxBool isActualIngredient = false.obs;

  EditIngredientModalController({
    required this.groupId,
    required this.ingredient,
  });

  @override
  void onInit() {
    super.onInit();
    nameController.text = ingredient.name;
    isActualIngredient.value = ingredient.actualIngredient;
  }

  Future<void> updateIngredient() async {
    isLoading.value = true;
    final updatedIngredient = ingredient.copyWith(
      name: nameController.text,
      actualIngredient: isActualIngredient.value,
    );
    await ingredientsService.updateIngredient(
      groupId: groupId,
      ingredient: updatedIngredient,
    );
    isLoading.value = false;
    Get.back();
    FRSnackbar.success(
      'Success',
      TranslationKeys.ingredientUpdatedSuccessfully.tr,
    );
  }

  Future<void> deleteIngredient() async {
    isLoading.value = true;
    await ingredientsService.deleteIngredient(
      groupId: groupId,
      ingredientId: ingredient.id,
    );
    isLoading.value = false;
    Get.back();
    Get.back();
    FRSnackbar.success(
      'Success',
      TranslationKeys.ingredientDeletedSuccessfully.tr,
    );
  }
}
