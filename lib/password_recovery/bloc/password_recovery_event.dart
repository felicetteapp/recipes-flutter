part of 'password_recovery_bloc.dart';

sealed class PasswordRecoveryEvent extends Equatable {
  const PasswordRecoveryEvent();

  @override
  List<Object> get props => [];
}

final class PasswordRecoveryEmailChanged extends PasswordRecoveryEvent {
  const PasswordRecoveryEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

final class PasswordRecoverySubmitted extends PasswordRecoveryEvent {
  const PasswordRecoverySubmitted();
}
