part of 'create_account_bloc.dart';

final class CreateAccountState extends Equatable {
  const CreateAccountState({
    this.submissionStatus = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.passwordConfirmation = const ConfirmedPassword.pure(),
    this.isPasswordHidden = true,
    this.isPasswordConfirmationHidden = true,
    this.isValid = false,
  });

  final FormzSubmissionStatus submissionStatus;
  final Username username;
  final Password password;
  final ConfirmedPassword passwordConfirmation;
  final bool isPasswordHidden;
  final bool isPasswordConfirmationHidden;
  final bool isValid;

  CreateAccountState copyWith({
    FormzSubmissionStatus? submissionStatus,
    Username? username,
    Password? password,
    ConfirmedPassword? passwordConfirmation,
    bool? isPasswordHidden,
    bool? isPasswordConfirmationHidden,
    bool? isValid,
  }) {
    return CreateAccountState(
      submissionStatus: submissionStatus ?? this.submissionStatus,
      username: username ?? this.username,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isPasswordConfirmationHidden:
          isPasswordConfirmationHidden ?? this.isPasswordConfirmationHidden,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
    submissionStatus,
    username,
    password,
    passwordConfirmation,
    isPasswordHidden,
    isPasswordConfirmationHidden,
    isValid,
  ];
}
