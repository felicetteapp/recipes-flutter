import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/data/models/group_models.dart';
import 'package:felicette_recipes/app/services/api/group_api_service.dart';
import 'package:felicette_recipes/app/services/auth_service.dart';
import 'package:felicette_recipes/app/utils/secure_storage.dart';

class GroupsService extends GetxService {
  final GroupApiService groupApiService = Get.put<GroupApiService>(
    GroupApiService(),
    permanent: true,
  );
  final RxList<FRGroup> availableGroups = <FRGroup>[].obs;
  final Rx<FRGroup?> selectedGroup = Rx<FRGroup?>(null);
  final Rxn<String> selectedGroupId = Rxn<String>();
  StreamSubscription<DocumentSnapshot<FRGroup>>?
  _currentGroupListenerSubscription;

  void selectGroup(FRGroup? group) {
    selectedGroupId.value = group?.id;
    log('Selected group: ${group?.name}', name: 'GroupsService');
    if (group != null) {
      saveSelectedGroupToStorage(group.id);
    }
  }

  void getUserGroups() async {
    final authService = Get.find<AuthService>();
    final userGroupIds = authService.userGroups;

    availableGroups.clear();

    for (final groupId in userGroupIds) {
      await handleGetGroup(groupId);
    }

    if (selectedGroup.value == null && availableGroups.isNotEmpty) {
      final storedGroupId = await RFSecureStorage.read(
        key: GroupsService.selectedGroupKey,
      );
      if (storedGroupId != null) {
        try {
          final group = availableGroups.firstWhere(
            (group) => group.id == storedGroupId,
          );
          selectGroup(group);
          return;
        } catch (e) {
          selectGroup(availableGroups.first);
        }
      }
    }

    final names = availableGroups.map((group) => group.name).toList();
    log('Available group names: $names', name: 'GroupsService');
  }

  Future<void> handleGetGroup(String groupId) async {
    final groupSnapshot = await groupApiService.getGroup(groupId);
    if (groupSnapshot.exists) {
      final group = groupSnapshot.data()!;
      availableGroups.add(group);
    }
  }

  Future<void> updateCurrentGroupRecipes(List<String> recipeIds) {
    final group = selectedGroup.value;
    log(
      'Updating current recipes for group ${group?.name} to $recipeIds',
      name: 'GroupsService',
    );
    if (group == null) {
      throw Exception('No selected group to update recipes for');
    }
    final newGroup = group.copyWith(currentRecipes: recipeIds);
    log(
      'New group current recipes: ${newGroup.currentRecipes}',
      name: 'GroupsService',
    );
    return groupApiService.updateGroupRecipes(group: newGroup);
  }

  Future<void> updateCurrentGroupFilters(FRGroupFilter filters) {
    final group = selectedGroup.value;
    log(
      'Updating current filters for group ${group?.name} to $filters',
      name: 'GroupsService',
    );
    if (group == null) {
      throw Exception('No selected group to update filters for');
    }
    final newGroup = group.copyWith(filters: filters);
    log('New group filters: ${newGroup.filters}', name: 'GroupsService');
    return groupApiService.updateGroupFilters(group: newGroup);
  }

  Future<void> updateGroupListDetails(FRGroup group) {
    log('Updating list details for group ${group.name}', name: 'GroupsService');
    return groupApiService.updateGroupListDetails(group: group);
  }

  Future<void> updateIngredientPrices({
    required String ingredientId,
    required List<FRIngredientPrice> prices,
  }) {
    final group = selectedGroup.value;
    log(
      'Updating ingredient prices for ingredient $ingredientId in group ${group?.name} to $prices',
      name: 'GroupsService',
    );
    if (group == null) {
      throw Exception('No selected group to update ingredient prices for');
    }
    return groupApiService.updateIngredientPrices(
      group: group,
      ingredientId: ingredientId,
      prices: prices,
    );
  }

  Future<void> removeIngredientPrice({required String ingredientId}) {
    final group = selectedGroup.value;
    log(
      'Removing ingredient price for ingredient $ingredientId in group ${group?.name}',
      name: 'GroupsService',
    );
    if (group == null) {
      throw Exception('No selected group to remove ingredient price for');
    }
    return groupApiService.removeIngredientPrice(
      group: group,
      ingredientId: ingredientId,
    );
  }

  Future<void> checkIngredient({
    required String ingredientId,
    required bool isChecked,
  }) {
    final group = selectedGroup.value;
    log(
      '${isChecked ? 'Checking' : 'Unchecking'} ingredient $ingredientId in group ${group?.name}',
      name: 'GroupsService',
    );
    if (group == null) {
      throw Exception('No selected group to check/uncheck ingredient for');
    }
    return groupApiService.checkIngredient(
      group: group,
      ingredientId: ingredientId,
      isChecked: isChecked,
    );
  }

  static const selectedGroupKey = 'selected_group';

  fetchSelectedGroupFromStorage() async {
    final storedGroupId = await RFSecureStorage.read(key: selectedGroupKey);
    try {
      final group = availableGroups.firstWhere(
        (group) => group.id == storedGroupId,
      );
      selectGroup(group);
    } catch (e) {
      return null;
    }
  }

  saveSelectedGroupToStorage(String groupId) async {
    await RFSecureStorage.write(key: selectedGroupKey, value: groupId);
  }

  @override
  void onInit() {
    super.onInit();

    final authService = Get.find<AuthService>();
    authService.userGroups.listen((_) {
      getUserGroups();
    });

    authService.isLoggedIn.listen((isLoggedIn) {
      if (!isLoggedIn) {
        availableGroups.clear();
        selectedGroup.value = null;
        selectedGroupId.value = null;
        _currentGroupListenerSubscription?.cancel();
        _currentGroupListenerSubscription = null;

        selectedGroup(null);
      }
    });

    selectedGroupId.listen((gId) {
      _currentGroupListenerSubscription?.cancel();
      if (gId != null) {
        _currentGroupListenerSubscription = groupApiService
            .listenGroup(gId)
            .listen((groupSnapshot) {
              if (groupSnapshot.exists) {
                final group = groupSnapshot.data()!;
                selectedGroup.value = group;
                log(
                  'Selected group updated: ${group.name}',
                  name: 'GroupsService',
                );
              }
            });
      } else {
        selectedGroup.value = null;
      }
    });
  }
}
