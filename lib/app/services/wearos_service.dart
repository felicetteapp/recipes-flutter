import 'dart:developer';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/modules/home/widgets/list/list_controller.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';
import 'package:felicette_recipes/app/services/ingredients_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// Service to communicate with WearOS devices through the native Android layer.
/// This service provides methods to manually trigger data synchronization with paired watches.
class WearOSService extends GetxService {
  static const MethodChannel _channel = MethodChannel(
    'app.felicette.recipes/wearos',
  );

  final RxBool isSyncing = false.obs;
  final RxBool hasConnectedWatch = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkConnectedWatch();

    _channel.setMethodCallHandler((call) async {
      log(
        'Received method call from native: ${call.method}',
        name: 'WearOSService',
      );
      switch (call.method) {
        case 'updateIngredientStatus':
          final String ingredientId = call.arguments['ingredientId'];
          final bool isChecked = call.arguments['isChecked'];
          log(
            'Updating status for ingredient $ingredientId to $isChecked',
            name: 'WearOSService',
          );

          final GroupsService groupsService = Get.find<GroupsService>();
          await groupsService.checkIngredient(
            ingredientId: ingredientId,
            isChecked: isChecked,
          );

          log(
            'Ingredient $ingredientId status updated successfully',
            name: 'WearOSService',
          );
          break;
        case 'getIngredients':
          log(
            'Received request for current ingredients from watch',
            name: 'WearOSService',
          );
          return getCurrentIngredients().map((ing) => ing.toMap()).toList();
      }
    });
  }

  List<FRWearIngredient> getCurrentIngredients() {
    final IngredientsService ingredientsService =
        Get.find<IngredientsService>();

    final List<ListIngredientItem> currentIngredientsItems = ingredientsService
        .getListIngredientsItems(showCheckedFirst: false);

    final List<FRWearIngredient> wearIngredients = currentIngredientsItems
        .map((ing) => FRWearIngredient.fromListIngredientItem(ing))
        .toList();

    return wearIngredients;
  }

  Future<void> sendCurrentIngredients() async {
    final List<FRWearIngredient> wearIngredients = getCurrentIngredients();

    try {
      if (hasConnectedWatch.value == false) {
        return;
      }

      isSyncing.value = true;
      log('Sending current ingredients to watch...', name: 'WearOSService');
      final result = await _channel.invokeMethod('sendCurrentIngredients', {
        'ingredients': wearIngredients.map((ing) => ing.toMap()).toList(),
      });
      log('Result: $result', name: 'WearOSService');
    } on PlatformException catch (e) {
      log('Error sending to watch: ${e.message}', name: 'WearOSService');
      Get.snackbar(
        'WearOS Sync Error',
        e.message ?? 'Failed to send data to watch',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      log('Unexpected error: $e', name: 'WearOSService');
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isSyncing.value = false;
    }
  }

  /// Check if any WearOS devices are connected.
  Future<void> checkConnectedWatch() async {
    try {
      final bool? connected = await _channel.invokeMethod<bool>(
        'hasConnectedWatch',
      );
      hasConnectedWatch.value = connected ?? false;
      log('Connected watch: ${hasConnectedWatch.value}', name: 'WearOSService');
    } on PlatformException catch (e) {
      log(
        'Error checking connected watch: ${e.message}',
        name: 'WearOSService',
      );
      hasConnectedWatch.value = false;
    } catch (e) {
      log('Unexpected error checking watch: $e', name: 'WearOSService');
      hasConnectedWatch.value = false;
    }
  }
}
