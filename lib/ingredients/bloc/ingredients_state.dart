part of 'ingredients_bloc.dart';

class IngredientsState extends Equatable {
  const IngredientsState({
    this.ingredients = const [],
    this.isLoading = false,
    this.errorMessage,
    this.selectedGroupId,
    this.selectedGroupCurrentListIngredient = const [],
  });
  final List<FRIngredient> ingredients;
  final bool isLoading;
  final String? errorMessage;
  final String? selectedGroupId;
  final List<FRCurrentIngredients> selectedGroupCurrentListIngredient;

  IngredientsState copyWith({
    List<FRIngredient>? ingredients,
    bool? isLoading,
    String? errorMessage,
    String? selectedGroupId,
    List<FRCurrentIngredients>? selectedGroupCurrentListIngredient,
  }) {
    return IngredientsState(
      ingredients: ingredients ?? this.ingredients,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedGroupCurrentListIngredient:
          selectedGroupCurrentListIngredient ??
          this.selectedGroupCurrentListIngredient,
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
