import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';
import 'package:recipes_flutter/app/utils/snackbar.dart';

class NewIngredientModalController extends GetxController {
  final String groupId;
  final IngredientsService ingredientsService = Get.find<IngredientsService>();
  final RxBool isLoading = false.obs;

  final TextEditingController nameController = TextEditingController();
  final RxBool isActualIngredient = false.obs;

  NewIngredientModalController({required this.groupId});

  @override
  void onInit() {
    super.onInit();
    nameController.text = '';
    isActualIngredient.value = false;
  }

  Future<void> createIngredient() async {
    isLoading.value = true;
    final newIngredient = FRIngredient(
      id: '',
      name: nameController.text,
      actualIngredient: isActualIngredient.value,
    );
    await ingredientsService.createIngredient(
      groupId: groupId,
      ingredient: newIngredient,
    );
    isLoading.value = false;
    Get.back();
    FRSnackbar.success('Success', 'Ingredient created successfully');
  }
}
