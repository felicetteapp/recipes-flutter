import 'dart:async';
import 'dart:developer';

import 'package:felicette_recipes/app/common/common.dart';
import 'package:felicette_recipes/app/data/models/group_models.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';
import 'package:felicette_recipes/app/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GroupDetailController extends GetxController {
  final String id = Get.parameters['id'] ?? '';
  final GroupsService groupServices = Get.find<GroupsService>();
  final TextEditingController groupNameController = TextEditingController();
  final RxBool isLoading = false.obs;

  FRGroup? get group {
    try {
      return groupServices.availableGroups.firstWhere((g) => g.id == id);
    } catch (e) {
      log('Group with id $id not found', name: 'GroupDetailController');
      return null;
    }
  }

  Future<void> deleteGroup() async {
    final currentGroup = group;
    if (currentGroup == null) {
      return;
    }

    final confirm = await Get.dialog<bool>(
      AlertDialog(
        title: Text(TranslationKeys.deleteGroup.tr),
        content: Text(TranslationKeys.deleteGroupMessage.tr),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: Text(TranslationKeys.cancel.tr),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: Text(TranslationKeys.delete.tr),
          ),
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    isLoading.value = true;
    try {
      await groupServices.deleteGroup(currentGroup);
      log('Group ${currentGroup.name} deleted', name: 'GroupDetailController');
      FRSnackbar.success(
        TranslationKeys.success.tr,
        TranslationKeys.groupDeleted.tr,
      );
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      log('Error deleting group: $e', name: 'GroupDetailController');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveGroupName() async {
    isLoading.value = true;
    try {
      await groupServices.updateGroupName(group!, groupNameController.text);
      log(
        'Group name updated to ${groupNameController.text}',
        name: 'GroupDetailController',
      );
      FRSnackbar.success(
        TranslationKeys.success.tr,
        TranslationKeys.groupUpdated.tr,
      );
    } catch (e) {
      log('Error updating group name: $e', name: 'GroupDetailController');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();

    log('init', name: 'GroupDetailController');

    log('Group ID: $id', name: 'GroupDetailController');

    if (id.isEmpty) {
      Get.to(AppRoutes.home);
      return;
    }
    isLoading.value = true;

    if (group == null) {
      final awaitingTimer = Timer.periodic(Duration(seconds: 1), (t) {
        final currentGroup = group;
        if (currentGroup != null) {
          log(
            'Group found after waiting: ${currentGroup.name}',
            name: 'GroupDetailController',
          );
          t.cancel();
          handleInit();
        }
      });

      Future.delayed(Duration(seconds: 10), () {
        if (awaitingTimer.isActive) {
          awaitingTimer.cancel();
          handleInit();
        }
      });
    } else {
      handleInit();
    }
  }

  void handleInit() {
    final currentGroup = group;
    if (currentGroup == null) {
      Get.to(AppRoutes.home);

      return;
    }
    groupNameController.text = currentGroup.name;
    isLoading.value = false;
  }
}
