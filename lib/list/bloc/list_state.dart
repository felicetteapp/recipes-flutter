part of 'list_bloc.dart';

class ListState extends Equatable {
  const ListState({
    this.displayType = ListDisplayTypeEnum.ingredients,
    this.currentIngredientIds = const [],
    this.groupRecipes = const [],
    this.groupIngredients = const [],
    this.currentIngredients = const [],
    this.currentRecipesIds = const [],
    this.currentRecipes = const [],
  });

  final ListDisplayTypeEnum displayType;
  final List<FRCurrentIngredients> currentIngredientIds;
  final List<ListIngredientItem> currentIngredients;
  final List<String> currentRecipesIds;
  final List<FRRecipe> currentRecipes;
  final List<FRRecipe> groupRecipes;
  final List<FRIngredient> groupIngredients;

  ListState copyWith({
    ListDisplayTypeEnum? displayType,
    List<FRCurrentIngredients>? currentIngredientIds,
    List<FRRecipe>? groupRecipes,
    List<FRIngredient>? groupIngredients,
    List<ListIngredientItem>? currentIngredients,
    List<String>? currentRecipesIds,
    List<FRRecipe>? currentRecipes,
  }) {
    return ListState(
      displayType: displayType ?? this.displayType,
      currentIngredientIds: currentIngredientIds ?? this.currentIngredientIds,
      groupRecipes: groupRecipes ?? this.groupRecipes,
      groupIngredients: groupIngredients ?? this.groupIngredients,
      currentIngredients: currentIngredients ?? this.currentIngredients,
      currentRecipesIds: currentRecipesIds ?? this.currentRecipesIds,
      currentRecipes: currentRecipes ?? this.currentRecipes,
    );
  }

  @override
  List<Object?> get props => [
    displayType,
    currentIngredientIds,
    groupRecipes,
    groupIngredients,
    currentIngredients,
    currentRecipesIds,
    currentRecipes,
  ];
}
