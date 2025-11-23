part of 'select_cubit.dart';

class IngredientSelectState extends Equatable {
  const IngredientSelectState({
    this.selectedIngredientId,
    this.filteredIngredients = const [],
    this.textFilter = '',
  });

  final String? selectedIngredientId;
  final String textFilter;
  final List<FRIngredient> filteredIngredients;

  IngredientSelectState copyWith({
    String? selectedIngredientId,
    String? textFilter,
    List<FRIngredient>? filteredIngredients,
  }) {
    return IngredientSelectState(
      selectedIngredientId: selectedIngredientId ?? this.selectedIngredientId,
      textFilter: textFilter ?? this.textFilter,
      filteredIngredients: filteredIngredients ?? this.filteredIngredients,
    );
  }

  IngredientSelectState clearSelection() {
    return const IngredientSelectState();
  }

  @override
  List<Object?> get props => [
    selectedIngredientId,
    textFilter,
    filteredIngredients,
  ];
}
