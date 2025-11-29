part of 'ingredients_bloc.dart';

class IngredientsState extends Equatable {
  const IngredientsState({
    this.ingredients = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedGroupId,
    this.selectedGroupCurrentListIngredients = const [],
  });
  final List<FRIngredient> ingredients;
  final bool isLoading;
  final String? errorMessage;
  final String? selectedGroupId;
  final List<FRCurrentIngredients> selectedGroupCurrentListIngredients;

  IngredientsState copyWith({
    List<FRIngredient>? ingredients,
    bool? isLoading,
    String? errorMessage,
    String? selectedGroupId,
    List<FRCurrentIngredients>? selectedGroupCurrentListIngredients,
  }) {
    return IngredientsState(
      ingredients: ingredients ?? this.ingredients,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedGroupCurrentListIngredients:
          selectedGroupCurrentListIngredients ??
          this.selectedGroupCurrentListIngredients,
    );
  }

  @override
  List<Object?> get props => [
    ingredients,
    isLoading,
    errorMessage,
    selectedGroupId,
  ];
}
