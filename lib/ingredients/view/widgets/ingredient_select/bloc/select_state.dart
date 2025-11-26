part of 'select_cubit.dart';

class IngredientSelectState extends Equatable {
  const IngredientSelectState({
    this.selectedIngredientIds = const [],
    this.filteredIngredients = const [],
    this.textFilter = '',
  });

  final List<String> selectedIngredientIds;
  final String textFilter;
  final List<FRIngredient> filteredIngredients;

  IngredientSelectState copyWith({
    List<String>? selectedIngredientIds,
    String? textFilter,
    List<FRIngredient>? filteredIngredients,
  }) {
    return IngredientSelectState(
      selectedIngredientIds:
          selectedIngredientIds ?? this.selectedIngredientIds,
      textFilter: textFilter ?? this.textFilter,
      filteredIngredients: filteredIngredients ?? this.filteredIngredients,
    );
  }

  IngredientSelectState clearSelection() {
    return const IngredientSelectState();
  }

  @override
  List<Object?> get props => [
    selectedIngredientIds,
    textFilter,
    filteredIngredients,
  ];
}
