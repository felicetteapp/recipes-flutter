import 'dart:developer';

// import 'package:felicette_recipes/ingredients/models/ingredient.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

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
          final String ingredientId = call.arguments['ingredientId'] as String;
          final bool isChecked = call.arguments['isChecked'] as bool;
          log(
            'Updating status for ingredient $ingredientId to $isChecked',
            name: 'WearOSService',
          );
          /*
          final groupsService = Get.find<GroupsService>();
          await groupsService.checkIngredient(
            ingredientId: ingredientId,
            isChecked: isChecked,
          ); */

          await Future.delayed(const Duration(seconds: 1));

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
          return getCurrentIngredients(
            null,
          ).map((ing) => ing.toMap()).toList();
      }
    });
  }

  List<FRWearIngredient> getCurrentIngredients(BuildContext? context) {
    /*    final ingredientsService = Get.find<IngredientsService>();

    final currentIngredientsItems = ingredientsService.getListIngredientsItems(
      showCheckedFirst: false,
    );

    final wearIngredients = currentIngredientsItems
        .map((ing) => FRWearIngredient.fromListIngredientItem(ing, context!))
        .toList(); 

    return wearIngredients;
     */
    return [];
  }

  Future<void> sendCurrentIngredients() async {
    final wearIngredients = getCurrentIngredients(null);

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
    } catch (e) {
      log('Unexpected error: $e', name: 'WearOSService');
    } finally {
      isSyncing.value = false;
    }
  }

  /// Check if any WearOS devices are connected.
  Future<void> checkConnectedWatch() async {
    try {
      final connected = await _channel.invokeMethod<bool>(
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
