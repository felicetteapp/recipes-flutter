part of 'new_cubit.dart';

class NewRecipeState extends Equatable {
  const NewRecipeState({
    this.isLoading = false,
    this.errorMessage,
    this.status = FormzSubmissionStatus.initial,
    this.recipeName = const RecipeName.pure(),
    this.isValid = false,
    this.isActualIngredient = true,
    this.groupId = '',
    this.recipeIngredients = const RecipeIngredients.pure(),
  });

  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? errorMessage;
  final RecipeName recipeName;
  final RecipeIngredients recipeIngredients;
  final bool isValid;
  final bool isActualIngredient;
  final String groupId;

  NewRecipeState copyWith({
    bool? isLoading,
    String? errorMessage,
    FormzSubmissionStatus? status,
    RecipeName? recipeName,
    bool? isValid,
    bool? isActualIngredient,
    String? groupId,
    RecipeIngredients? recipeIngredients,
  }) {
    log(
      'called with isActualIngredient: $isActualIngredient',
      name: 'NewRecipeState',
    );
    return NewRecipeState(
      recipeName: recipeName ?? this.recipeName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      isActualIngredient: isActualIngredient ?? this.isActualIngredient,
      groupId: groupId ?? this.groupId,
      recipeIngredients: recipeIngredients ?? this.recipeIngredients,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    status,
    recipeName,
    isValid,
    isActualIngredient,
    groupId,
    recipeIngredients,
  ];
}
