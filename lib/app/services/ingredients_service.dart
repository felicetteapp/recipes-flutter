import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felicette_recipes/app/modules/home/widgets/list/list_controller.dart';
import 'package:felicette_recipes/app/services/recipes_service.dart';
import 'package:felicette_recipes/ingredients/models/ingredient.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/data/models/group_models.dart';
import 'package:felicette_recipes/app/services/api/ingredient_api_service.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';

class IngredientsService extends GetxService {
  final IngredientApiService ingredientApiService =
      Get.put<IngredientApiService>(IngredientApiService(), permanent: true);
  final RxList<FRIngredient> ingredients = RxList.empty();

  StreamSubscription<QuerySnapshot<FRIngredient>>? _ingredientsSubscription;

  List<FRIngredient> getCurrentGroupIngredients() {
    final groupsService = Get.find<GroupsService>();
    final selectedGroup = groupsService.selectedGroup.value;
    if (selectedGroup == null) {
      return [];
    }
    return ingredients
        .where(
          (ingredient) => selectedGroup.currentIngredients.any(
            (ing) => ing.ingredientId == ingredient.id,
          ),
        )
        .toList();
  }

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

  Future<FRIngredient> createIngredient({
    required String groupId,
    required FRIngredient ingredient,
  }) async {
    final docRef = await ingredientApiService.addIngredient(
      groupId: groupId,
      ingredient: ingredient,
    );

    return ingredient.copyWith(id: docRef.id);
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

  FRIngredient? getIngredientById(String ingredientId) {
    try {
      return ingredients.firstWhere((ing) => ing.id == ingredientId);
    } catch (e) {
      log(
        'Ingredient with ID $ingredientId not found',
        name: 'IngredientsService',
      );
      return null;
    }
  }

  List<ListIngredientItem> getListIngredientsItems({
    required bool showCheckedFirst,
  }) {
    log('Building sortedIngredientList', name: 'IngredientsService');

    final GroupsService groupsService = Get.find<GroupsService>();
    final RecipesService recipesService = Get.find<RecipesService>();

    final List<ListIngredientItem> list = <ListIngredientItem>[];

    final group = groupsService.selectedGroup.value;

    log('Selected group: ${group?.name}', name: 'IngredientsService');
    if (group == null) {
      return list;
    }

    log(
      'Building sortedIngredientList for group: ${group.name}',
      name: 'IngredientsService',
    );

    final currentListRecipes = recipesService.getCurrentGroupRecipes();

    final ingredientsIds = [
      ...group.currentIngredients.map(
        (ingredientMap) => ingredientMap.ingredientId,
      ),
    ];

    for (final recipe in currentListRecipes) {
      for (final ri in recipe.ingredients) {
        if (!ingredientsIds.contains(ri.ingredientId)) {
          ingredientsIds.add(ri.ingredientId);
        }
      }
    }

    for (final ingredientId in ingredientsIds) {
      final ingredient = getIngredientById(ingredientId);
      if (ingredient == null) continue;

      final prices = group.ingredientsPrices[ingredientId];
      final isChecked = group.checkedIngredients.contains(ingredientId);
      final recipes = recipesService.getRecipesByIngredientId(
        ingredientId,
        currentListRecipes,
      );

      String? quantity;

      if (group.currentIngredients.any(
        (ingMap) => ingMap.ingredientId == ingredientId,
      )) {
        quantity = group.currentIngredients
            .firstWhere((ingMap) => ingMap.ingredientId == ingredientId)
            .quantity;
      }

      list.add(
        ListIngredientItem(
          ingredient: ingredient,
          price: prices ?? [],
          isChecked: isChecked,
          recipes: recipes,
          quantity: quantity,
        ),
      );
    }

    if (showCheckedFirst) {
      list.sort((a, b) {
        if (a.isChecked && !b.isChecked) {
          return -1;
        } else if (!a.isChecked && b.isChecked) {
          return 1;
        } else {
          return 0;
        }
      });
    }

    return list;
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
      if (!isLoggedIn) {
        ingredients.clear();
        _ingredientsSubscription?.cancel();
      }
    });

    final GroupsService groupsService = Get.find<GroupsService>();
    groupsService.selectedGroup.listen((FRGroup? group) {
      getSelectedGroupIngredients();
    });
  }
}
