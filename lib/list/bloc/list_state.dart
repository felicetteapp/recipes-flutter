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
    this.listItems = const [],
    this.currentIngredientPrices = const {},
    this.currentCheckedIngredients = const [],
    this.showBudget = false,
    this.showCheckedsFirst = false,
    this.selectedGroup,
    this.currentListSpentBudget = 0,
    this.currentListBudget = 0,
  });

  final ListDisplayTypeEnum displayType;
  final List<FRCurrentIngredients> currentIngredientIds;
  final List<ListIngredientItem> currentIngredients;
  final List<String> currentRecipesIds;
  final List<FRRecipe> currentRecipes;
  final List<FRRecipe> groupRecipes;
  final List<FRIngredient> groupIngredients;
  final List<ListPageListItem> listItems;
  final Map<String, List<FRIngredientPrice>> currentIngredientPrices;
  final List<String> currentCheckedIngredients;
  final bool showBudget;
  final bool showCheckedsFirst;
  final FRGroup? selectedGroup;
  final num currentListSpentBudget;
  final num currentListBudget;

  ListState copyWith({
    ListDisplayTypeEnum? displayType,
    List<FRCurrentIngredients>? currentIngredientIds,
    List<FRRecipe>? groupRecipes,
    List<FRIngredient>? groupIngredients,
    List<ListIngredientItem>? currentIngredients,
    List<String>? currentRecipesIds,
    List<FRRecipe>? currentRecipes,
    List<ListPageListItem>? listItems,
    Map<String, List<FRIngredientPrice>>? currentIngredientPrices,
    List<String>? currentCheckedIngredients,
    bool? showBudget,
    bool? showCheckedsFirst,
    FRGroup? selectedGroup,
    num? currentListSpentBudget,
    num? currentListBudget,
  }) {
    return ListState(
      displayType: displayType ?? this.displayType,
      currentIngredientIds: currentIngredientIds ?? this.currentIngredientIds,
      groupRecipes: groupRecipes ?? this.groupRecipes,
      groupIngredients: groupIngredients ?? this.groupIngredients,
      currentIngredients: currentIngredients ?? this.currentIngredients,
      currentRecipesIds: currentRecipesIds ?? this.currentRecipesIds,
      currentRecipes: currentRecipes ?? this.currentRecipes,
      listItems: listItems ?? this.listItems,
      currentIngredientPrices:
          currentIngredientPrices ?? this.currentIngredientPrices,
      currentCheckedIngredients:
          currentCheckedIngredients ?? this.currentCheckedIngredients,
      showBudget: showBudget ?? this.showBudget,
      showCheckedsFirst: showCheckedsFirst ?? this.showCheckedsFirst,
      selectedGroup: selectedGroup ?? this.selectedGroup,
      currentListSpentBudget:
          currentListSpentBudget ?? this.currentListSpentBudget,
      currentListBudget: currentListBudget ?? this.currentListBudget,
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
    listItems,
    currentIngredientPrices,
    currentCheckedIngredients,
    showBudget,
    showCheckedsFirst,
    selectedGroup,
    currentListSpentBudget,
    currentListBudget,
  ];
}
