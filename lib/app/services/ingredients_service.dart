import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/services/api/ingredient_api_service.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';

class IngredientsService extends GetxService {
  final IngredientApiService ingredientApiService =
      Get.put<IngredientApiService>(IngredientApiService(), permanent: true);
  final RxList<FRIngredient> ingredients = RxList.empty();

  StreamSubscription<QuerySnapshot<FRIngredient>>? _ingredientsSubscription;

  listenToGroupIngredients(String groupId) {
    _ingredientsSubscription?.cancel();

    _ingredientsSubscription = ingredientApiService
        .collection(groupId)
        .orderBy('name')
        .snapshots()
        .listen((querySnapshot) {
          final List<FRIngredient> updatedIngredients = [];
          for (final doc in querySnapshot.docs) {
            final ingredient = doc.data();
            updatedIngredients.add(ingredient);
          }
          ingredients.assignAll(updatedIngredients);
          log(
            'Real-time update: ${updatedIngredients.length} ingredients for group $groupId',
            name: 'IngredientsService',
          );
        });
  }

  getSelectedGroupIngredients() async {
    final groupsService = Get.find<GroupsService>();
    final selectedGroup = groupsService.selectedGroup.value;
    ingredients.clear();
    if (selectedGroup != null) {
      listenToGroupIngredients(selectedGroup.id);
    } else {
      _ingredientsSubscription?.cancel();
      log(
        'No selected group to load ingredients for',
        name: 'IngredientsService',
      );
    }
  }

  Future<void> updateIngredient({
    required String groupId,
    required FRIngredient ingredient,
  }) {
    return ingredientApiService.updateIngredient(
      groupId: groupId,
      ingredient: ingredient,
    );
  }

  Future<void> createIngredient({
    required String groupId,
    required FRIngredient ingredient,
  }) async {
    final docRef = await ingredientApiService.addIngredient(
      groupId: groupId,
      ingredient: ingredient,
    );
    log(
      'Created ingredient with ID: ${docRef.id} in group $groupId',
      name: 'IngredientsService',
    );
  }

  Future<void> deleteIngredient({
    required String groupId,
    required String ingredientId,
  }) {
    return ingredientApiService.deleteIngredient(
      groupId: groupId,
      ingredientId: ingredientId,
    );
  }

  @override
  void onClose() {
    _ingredientsSubscription?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    final AuthService authService = Get.find<AuthService>();
    authService.isLoggedIn.listen((isLoggedIn) {
      if (isLoggedIn) {
        getSelectedGroupIngredients();
      } else {
        ingredients.clear();
        _ingredientsSubscription?.cancel();
      }
    });
  }
}
