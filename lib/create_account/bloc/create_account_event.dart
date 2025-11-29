part of 'create_account_bloc.dart';

sealed class CreateAccountEvent extends Equatable {
  const CreateAccountEvent();

  @override
  List<Object> get props => [];
}

final class CreateAccountUsernameChanged extends CreateAccountEvent {
  const CreateAccountUsernameChanged(this.username);

  final String username;

  @override
  List<Object> get props => [username];
}

final class CreateAccountPasswordChanged extends CreateAccountEvent {
  const CreateAccountPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

final class CreateAccountPasswordConfirmationChanged
    extends CreateAccountEvent {
  const CreateAccountPasswordConfirmationChanged(this.passwordConfirmation);

  final String passwordConfirmation;

  @override
  List<Object> get props => [passwordConfirmation];
}

final class CreateAccountPasswordVisibilityToggled extends CreateAccountEvent {
  const CreateAccountPasswordVisibilityToggled();
}

final class CreateAccountPasswordConfirmationVisibilityToggled
    extends CreateAccountEvent {
  const CreateAccountPasswordConfirmationVisibilityToggled();
}

final class CreateAccountSubmitted extends CreateAccountEvent {
  const CreateAccountSubmitted();
}
