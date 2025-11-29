part of 'wearos_service.dart';

class IngredientStatusUpdateEvent {
  const IngredientStatusUpdateEvent({
    required this.ingredientId,
    required this.isChecked,
  });

  final String ingredientId;
  final bool isChecked;
}

class IngredientsRequestEvent {
  const IngredientsRequestEvent();
}
