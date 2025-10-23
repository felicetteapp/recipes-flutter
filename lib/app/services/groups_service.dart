import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/services/api/group_api_service.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';

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
  }

  void getUserGroups() async {
    final authService = Get.find<AuthService>();
    final userGroupIds = authService.userGroups;

    availableGroups.clear();

    for (final groupId in userGroupIds) {
      await handleGetGroup(groupId);
    }

    if (selectedGroup.value == null && availableGroups.isNotEmpty) {
      selectGroup(availableGroups.first);
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
