part of 'new_cubit.dart';

class NewIngredientState extends Equatable {
  const NewIngredientState({
    this.isLoading = false,
    this.errorMessage,
    this.status = FormzSubmissionStatus.initial,
    this.ingredientName = const IngredientName.pure(),
    this.isValid = false,
    this.isActualIngredient = true,
    this.groupId = '',
  });

  final FormzSubmissionStatus status;
  final bool isLoading;
  final String? errorMessage;
  final IngredientName ingredientName;
  final bool isValid;
  final bool isActualIngredient;
  final String groupId;

  NewIngredientState copyWith({
    bool? isLoading,
    String? errorMessage,
    FormzSubmissionStatus? status,
    IngredientName? ingredientName,
    bool? isValid,
    bool? isActualIngredient,
    String? groupId,
  }) {
    log(
      'EditIngredientState.copyWith called with isActualIngredient: $isActualIngredient',
      name: 'NewIngredientState',
    );
    return NewIngredientState(
      ingredientName: ingredientName ?? this.ingredientName,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      isActualIngredient: isActualIngredient ?? this.isActualIngredient,
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
    groupId,
  ];
}
