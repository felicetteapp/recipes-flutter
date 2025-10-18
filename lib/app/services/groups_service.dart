import 'dart:developer';

import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/services/api/group_api_service.dart';
import 'package:recipes_flutter/app/services/auth_service.dart';
import 'package:recipes_flutter/app/services/ingredients_service.dart';

class GroupsService extends GetxService {
  final GroupApiService groupApiService = Get.put<GroupApiService>(
    GroupApiService(),
    permanent: true,
  );
  final RxList<FRGroup> availableGroups = <FRGroup>[].obs;
  final Rx<FRGroup?> selectedGroup = Rx<FRGroup?>(null);

  void selectGroup(FRGroup? group) {
    selectedGroup.value = group;
    log('Selected group: ${group?.name}', name: 'GroupsService');
    IngredientsService ingredientsService = Get.find<IngredientsService>();
    ingredientsService.getSelectedGroupIngredients();
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
}
