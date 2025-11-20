part of 'recipes_bloc.dart';

class RecipesState extends Equatable {
  const RecipesState({
    this.isSelecting = false,
    this.selectedGroupId,
    this.selectedGroupCurrentListRecipeIds = const [],
    this.recipes = const [],
    this.selectedRecipeIds = const [],
  });
  final bool isSelecting;
  final String? selectedGroupId;
  final List<String> selectedGroupCurrentListRecipeIds;
  final List<String> selectedRecipeIds;
  final List<FRRecipe> recipes;

  RecipesState copyWith({
    bool? isSelecting,
    String? selectedGroupId,
    List<String>? selectedGroupCurrentListRecipeIds,
    List<String>? selectedRecipeIds,
    List<FRRecipe>? recipes,
  }) {
    return RecipesState(
      isSelecting: isSelecting ?? this.isSelecting,
      selectedGroupId: selectedGroupId ?? this.selectedGroupId,
      selectedGroupCurrentListRecipeIds:
          selectedGroupCurrentListRecipeIds ??
          this.selectedGroupCurrentListRecipeIds,
      selectedRecipeIds: selectedRecipeIds ?? this.selectedRecipeIds,
      recipes: recipes ?? this.recipes,
    );
  }

  @override
  List<Object?> get props => [
    isSelecting,
    selectedGroupId,
    selectedGroupCurrentListRecipeIds,
    recipes,
    selectedRecipeIds,
  ];
}
