part of 'edit_cubit.dart';

class EditIngredientState extends Equatable {
  const EditIngredientState({
    this.isLoading = false,
    this.errorMessage,
    this.status = FormzSubmissionStatus.initial,
    this.ingredientName = const IngredientName.pure(),
    this.isValid = false,
    this.isActualIngredient = false,
    this.removeStatus = FormzSubmissionStatus.initial,
    this.ingredient,
    this.groupId = '',
  });

  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? errorMessage;
  final IngredientName ingredientName;
  final bool isValid;
  final bool isActualIngredient;
  final FormzSubmissionStatus removeStatus;
  final FRIngredient? ingredient;
  final String groupId;

  EditIngredientState copyWith({
    bool? isLoading,
    String? errorMessage,
    FormzSubmissionStatus? status,
    IngredientName? ingredientName,
    bool? isValid,
    bool? isActualIngredient,
    FormzSubmissionStatus? removeStatus,
    FRIngredient? ingredient,
    String? groupId,
  }) {
    log(
      'copyWith called with isActualIngredient: $isActualIngredient',
      name: 'EditIngredientState',
    );
    return EditIngredientState(
      ingredientName: ingredientName ?? this.ingredientName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      isActualIngredient: isActualIngredient ?? this.isActualIngredient,
      removeStatus: removeStatus ?? this.removeStatus,
      ingredient: ingredient ?? this.ingredient,
      groupId: groupId ?? this.groupId,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    errorMessage,
    status,
    ingredientName,
    isValid,
    isActualIngredient,
    removeStatus,
    ingredient,
    groupId,
  ];
}
