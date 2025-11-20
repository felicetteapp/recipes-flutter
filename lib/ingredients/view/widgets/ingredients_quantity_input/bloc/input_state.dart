part of 'input_cubit.dart';

class IngredientQuantityInputState<T extends BasicIngredientQuantity> {
  IngredientQuantityInputState({
    required this.items,
    required this.generateEmpty,
    required this.onChanged,
  });

  final List<T> items;

  final T Function() generateEmpty;
  final ValueChanged<List<T>> onChanged;

  IngredientQuantityInputState<T> copyWith({
    List<T>? items,
    T Function()? generateEmpty,
    ValueChanged<List<T>>? onChanged,
  }) {
    return IngredientQuantityInputState<T>(
      items: items ?? this.items,
      generateEmpty: generateEmpty ?? this.generateEmpty,
      onChanged: onChanged ?? this.onChanged,
    );
  }
}
