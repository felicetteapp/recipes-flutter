import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/services/api/recipe_api_service.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';

class RecipesService extends GetxService {
  final RecipeApiService recipeApiService = Get.put<RecipeApiService>(
    RecipeApiService(),
    permanent: true,
  );
  final RxList<FRRecipe> recipes = RxList.empty();

  StreamSubscription<QuerySnapshot<FRRecipe>>? _recipesSubscription;

  listenToGroupRecipes(String groupId) {
    _recipesSubscription?.cancel();

    _recipesSubscription = recipeApiService
        .collection(groupId)
        .orderBy('name')
        .snapshots()
        .listen((querySnapshot) {
          final List<FRRecipe> updatedRecipes = [];
          for (final doc in querySnapshot.docs) {
            final recipe = doc.data();
            updatedRecipes.add(recipe);
          }
          recipes.assignAll(updatedRecipes);
          log(
            'Real-time update: ${updatedRecipes.length} recipes for group $groupId',
            name: 'RecipesService',
          );
        });
  }

  getSelectedGroupRecipes() async {
    final groupsService = Get.find<GroupsService>();
    final selectedGroup = groupsService.selectedGroup.value;
    recipes.clear();
    if (selectedGroup != null) {
      listenToGroupRecipes(selectedGroup.id);
    } else {
      _recipesSubscription?.cancel();
      log('No selected group to load recipes for', name: 'RecipesService');
    }
  }

  bool isRecipeInSelectedGroupList(String recipeId) {
    final groupsService = Get.find<GroupsService>();
    final selectedGroup = groupsService.selectedGroup.value;
    if (selectedGroup == null) {
      return false;
    }
    return selectedGroup.currentRecipes.contains(recipeId);
  }

  Future<void> updateRecipe({
    required String groupId,
    required FRRecipe recipe,
  }) {
    return recipeApiService.updateRecipe(groupId: groupId, recipe: recipe);
  }

  Future<FRRecipe> createRecipe({
    required String groupId,
    required FRRecipe recipe,
  }) async {
    final docRef = await recipeApiService.addRecipe(
      groupId: groupId,
      recipe: recipe,
    );
    log(
      'Created recipe with ID: ${docRef.id} in group $groupId',
      name: 'RecipesService',
    );
    return recipe.copyWith(id: docRef.id);
  }

  Future<void> deleteRecipe({
    required String groupId,
    required String recipeId,
  }) {
    return recipeApiService.deleteRecipe(groupId: groupId, recipeId: recipeId);
  }

  List<FRRecipe> getCurrentGroupRecipes() {
    final groupsService = Get.find<GroupsService>();
    final selectedGroup = groupsService.selectedGroup.value;
    if (selectedGroup == null) {
      return [];
    }
    return recipes
        .where((recipe) => selectedGroup.currentRecipes.contains(recipe.id))
        .toList();
  }

  List<FRRecipe> getRecipesByIngredientId(
    String ingredientId,
    List<FRRecipe>? source,
  ) {
    final actualSource = source ?? recipes;
    return actualSource.where((recipe) {
      return recipe.ingredients.any((ri) => ri.ingredientId == ingredientId);
    }).toList();
  }

  FRRecipe? getRecipeById(String recipeId) {
    try {
      return recipes.firstWhere((recipe) => recipe.id == recipeId);
    } catch (e) {
      log('Recipe with ID $recipeId not found', name: 'RecipesService');
      return null;
    }
  }

  @override
  void onClose() {
    _recipesSubscription?.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    super.onInit();

    final AuthService authService = Get.find<AuthService>();
    authService.isLoggedIn.listen((isLoggedIn) {
      if (!isLoggedIn) {
        recipes.clear();
        _recipesSubscription?.cancel();
      }
    });

    final GroupsService groupsService = Get.find<GroupsService>();
    groupsService.selectedGroup.listen((FRGroup? group) {
      getSelectedGroupRecipes();
    });
  }
}
