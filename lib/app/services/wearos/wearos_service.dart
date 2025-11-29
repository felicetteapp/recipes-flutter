import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

part 'wearos_events.dart';

class WearOSService {
  WearOSService._();

  static final WearOSService instance = WearOSService._();

  static const MethodChannel _channel = MethodChannel(
    'app.felicette.recipes/wearos',
  );

  final ValueNotifier<bool> isSyncing = ValueNotifier(false);
  final ValueNotifier<bool> hasConnectedWatch = ValueNotifier(false);

  final _ingredientStatusUpdateController =
      StreamController<IngredientStatusUpdateEvent>.broadcast();

  final _ingredientsRequestController =
      StreamController<IngredientsRequestEvent>.broadcast();

  Stream<IngredientStatusUpdateEvent> get ingredientStatusUpdates =>
      _ingredientStatusUpdateController.stream;

  Stream<IngredientsRequestEvent> get ingredientsRequests =>
      _ingredientsRequestController.stream;

  bool _initialized = false;
  Timer? _debounceTimer;

  Future<void> initialize() async {
    if (_initialized || !Platform.isAndroid) {
      log(
        'WearOS service already initialized or not on Android platform',
        name: 'WearOSService',
      );
      return;
    }

    _initialized = true;
    log('Initializing WearOS service', name: 'WearOSService');

    await checkConnectedWatch();

    _channel.setMethodCallHandler((call) async {
      log(
        'Received method call from native: ${call.method}',
        name: 'WearOSService',
      );
      switch (call.method) {
        case 'updateIngredientStatus':
          final arguments = call.arguments as Map<Object?, Object?>;
          final ingredientId = arguments['ingredientId']! as String;
          final isChecked = arguments['isChecked']! as bool;
          log(
            'Updating status for ingredient $ingredientId to $isChecked',
            name: 'WearOSService',
          );

          _ingredientStatusUpdateController.add(
            IngredientStatusUpdateEvent(
              ingredientId: ingredientId,
              isChecked: isChecked,
            ),
          );
        case 'getIngredients':
          log(
            'Received request for current ingredients from watch',
            name: 'WearOSService',
          );

          _ingredientsRequestController.add(
            const IngredientsRequestEvent(),
          );

          return [];
      }
    });
  }

  Future<void> sendCurrentIngredients({
    required List<ListIngredientItem>? currentIngredients,
    required S s,
  }) async {
    _debounceTimer?.cancel();

    _debounceTimer = Timer(const Duration(seconds: 1), () async {
      try {
        if (!hasConnectedWatch.value) {
          return;
        }

        final wearIngredients = currentIngredients!
            .map(
              (item) =>
                  FRWearIngredientExtension.fromListIngredientItem(item, s),
            )
            .toList();

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
    });
  }

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

  void dispose() {
    _debounceTimer?.cancel();
    isSyncing.dispose();
    hasConnectedWatch.dispose();
    _ingredientStatusUpdateController.close();
    _ingredientsRequestController.close();
  }
}

extension FRWearIngredientExtension on FRWearIngredient {
  static String description(ListIngredientItem item, S s) {
    final parts = <String>[];

    if (item.quantity != null && item.quantity!.isNotEmpty) {
      parts.add(item.quantity!);
    }

    for (final recipe in item.associatedRecipes) {
      final thisIngredientAtRecipe = recipe.ingredients.firstWhereOrNull(
        (ing) => ing.ingredientId == item.ingredient.id,
      );

      if (thisIngredientAtRecipe == null) {
        continue;
      }

      final subParts = <String>[];
      if (thisIngredientAtRecipe.quantity.isNotEmpty) {
        subParts
          ..add(thisIngredientAtRecipe.quantity)
          ..add(' ');
      }
      subParts
        ..add(s.tfor)
        ..add(recipe.name);

      parts.add(subParts.join());
    }

    return parts.join(', ');
  }

  static FRWearIngredient fromListIngredientItem(
    ListIngredientItem item,
    S s,
  ) {
    return FRWearIngredient(
      id: item.ingredient.id,
      name: item.ingredient.name,
      description: description(item, s),
      checked: item.isChecked,
    );
  }
}
