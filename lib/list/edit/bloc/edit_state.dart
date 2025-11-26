part of 'edit_cubit.dart';

class EditListState extends Equatable {
  const EditListState({
    this.currentIngredients = const [],
    this.budget = 0.0,
    this.currentRecipes = const [],
    this.currency = '',
    this.groupIngredients = const [],
    this.groupRecipes = const [],
  });
  final List<FRCurrentIngredients> currentIngredients;
  final double budget;
  final List<String> currentRecipes;
  final String currency;

  final List<FRIngredient> groupIngredients;
  final List<FRRecipe> groupRecipes;

  EditListState copyWith({
    List<FRCurrentIngredients>? currentIngredients,
    double? budget,
    List<String>? currentRecipes,
    String? currency,
    List<FRIngredient>? groupIngredients,
    List<FRRecipe>? groupRecipes,
  }) {
    return EditListState(
      currentIngredients: currentIngredients ?? this.currentIngredients,
      budget: budget ?? this.budget,
      currentRecipes: currentRecipes ?? this.currentRecipes,
      currency: currency ?? this.currency,
      groupIngredients: groupIngredients ?? this.groupIngredients,
      groupRecipes: groupRecipes ?? this.groupRecipes,
    );
  }

  @override
  List<Object?> get props => [
    currentIngredients,
    budget,
    currentRecipes,
    currency,
    groupIngredients,
    groupRecipes,
  ];
}
