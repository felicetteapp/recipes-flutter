part of 'edit_cubit.dart';

class EditRecipeState extends Equatable {
  const EditRecipeState({
    this.isLoading = false,
    this.errorMessage,
    this.status = FormzSubmissionStatus.initial,
    this.recipeName = const RecipeName.pure(),
    this.isValid = false,
    this.isActualIngredient = true,
    this.groupId = '',
    this.recipeId = '',
    this.recipeIngredients = const RecipeIngredients.pure(),
    this.removeStatus = FormzSubmissionStatus.initial,
  });

  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? errorMessage;
  final RecipeName recipeName;
  final RecipeIngredients recipeIngredients;
  final bool isValid;
  final bool isActualIngredient;
  final String groupId;
  final String recipeId;
  final FormzSubmissionStatus removeStatus;

  EditRecipeState copyWith({
    bool? isLoading,
    String? errorMessage,
    FormzSubmissionStatus? status,
    RecipeName? recipeName,
    bool? isValid,
    bool? isActualIngredient,
    String? groupId,
    RecipeIngredients? recipeIngredients,
    String? recipeId,
    FormzSubmissionStatus? removeStatus,
  }) {
    log(
      'EditRecipeState.copyWith called with isActualIngredient: $isActualIngredient',
      name: 'EditRecipeState',
    );
    return EditRecipeState(
      recipeName: recipeName ?? this.recipeName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      isActualIngredient: isActualIngredient ?? this.isActualIngredient,
      groupId: groupId ?? this.groupId,
      recipeIngredients: recipeIngredients ?? this.recipeIngredients,
      recipeId: recipeId ?? this.recipeId,
      removeStatus: removeStatus ?? this.removeStatus,
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
    recipeId,
    removeStatus,
  ];
}
