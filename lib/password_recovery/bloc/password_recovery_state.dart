part of 'password_recovery_bloc.dart';

final class PasswordRecoveryState extends Equatable {
  const PasswordRecoveryState({
    this.email = const Username.pure(),
    this.isValid = false,
    this.status = FormzSubmissionStatus.initial,
  });

  final Username email;
  final bool isValid;
  final FormzSubmissionStatus status;

  PasswordRecoveryState copyWith({
    Username? email,
    bool? isValid,
    FormzSubmissionStatus? status,
  }) {
    return PasswordRecoveryState(
      email: email ?? this.email,
      isValid: isValid ?? this.isValid,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [email, isValid, status];
}
