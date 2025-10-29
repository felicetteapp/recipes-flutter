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

  final AuthService authService = Get.find<AuthService>();
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

  void getUserGroups(List<String> userGroupIds) async {
    final newGroups = <FRGroup>[];

    log('Fetching user groups for IDs: $userGroupIds', name: 'GroupsService');

    for (final groupId in userGroupIds) {
      final group = await handleGetGroup(groupId);
      if (group != null) {
        newGroups.add(group);
      }
    }

    availableGroups.assignAll(newGroups);

    log(
      'Fetched ${availableGroups.length} groups for user',
      name: 'GroupsService',
    );

    log(
      'Current selected group before check: ${selectedGroup.value?.name}',
      name: 'GroupsService',
    );

    if (selectedGroup.value == null && availableGroups.isNotEmpty) {
      final storedGroupId = await RFSecureStorage.read(
        key: GroupsService.selectedGroupKey,
      );

      log('Stored group ID: $storedGroupId', name: 'GroupsService');

      if (storedGroupId != null) {
        try {
          final group = availableGroups.firstWhere(
            (group) => group.id == storedGroupId,
          );
          selectGroup(group);
          return;
        } catch (e) {
          log(
            'Stored group ID not found in available groups: $storedGroupId',
            name: 'GroupsService',
          );
        }
      }
    }
    if (availableGroups.isNotEmpty) {
      selectGroup(availableGroups.first);
    }

    final names = availableGroups.map((group) => group.name).toList();
    log('Available group names: $names', name: 'GroupsService');
  }

  Future<FRGroup?> handleGetGroup(String groupId) async {
    try {
      final groupSnapshot = await groupApiService.getGroup(groupId);
      if (groupSnapshot.exists) {
        final group = groupSnapshot.data()!;
        return group;
      }
    } catch (_) {}
    return null;
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

  Future<void> updateGroupName(FRGroup group, String newName) async {
    log(
      'Updating group name for group ${group.name} to $newName',
      name: 'GroupsService',
    );
    final response = await groupApiService.updateGroupName(
      group: group,
      newName: newName,
    );

    refreshGroupData(group);

    return response;
  }

  Future<FRGroup> createGroup(String groupName) async {
    log('Creating new group with name $groupName', name: 'GroupsService');

    final group = FRGroup(
      id: '',
      creatorUid: authService.currentUser.value!.uid,
      name: groupName,
      currentRecipes: [],
      currentIngredients: [],
      checkedIngredients: [],
      ingredientsPrices: {},
      filters: FRGroupFilter(),
      currency: 'USD',
      budget: 0.0,
    );
    return groupApiService.createGroup(group);
  }

  Future<void> deleteGroup(FRGroup group) async {
    log('Deleting group ${group.name}', name: 'GroupsService');

    await groupApiService.deleteGroup(group.id);

    log('Group ${group.name} deleted successfully', name: 'GroupsService');

    return;
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

  refreshGroupData(FRGroup group) async {
    final index = availableGroups.indexWhere((g) => g.id == group.id);

    final updatedGroup = await groupApiService.getGroup(group.id);

    if (updatedGroup.exists) {
      availableGroups[index] = updatedGroup.data()!;
    }
    availableGroups.refresh();
  }

  saveSelectedGroupToStorage(String groupId) async {
    await RFSecureStorage.write(key: selectedGroupKey, value: groupId);
  }

  @override
  void onInit() {
    super.onInit();

    authService.isLoggedIn.listen((isLoggedIn) {
      log('User login status changed: $isLoggedIn', name: 'GroupsService');
      if (!isLoggedIn) {
        availableGroups.clear();
        selectedGroup.value = null;
        selectedGroupId.value = null;
        _currentGroupListenerSubscription?.cancel();
        _currentGroupListenerSubscription = null;

        selectedGroup(null);
      }
    });

    authService.userGroups.listen((ids) {
      log(
        'User groups changed, fetching user groups: $ids',
        name: 'GroupsService',
      );
      getUserGroups(ids);
    });

    selectedGroupId.listen((gId) {
      log('Selected group ID changed: $gId', name: 'GroupsService');
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
