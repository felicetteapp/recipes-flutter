part of 'login_bloc.dart';

final class LoginState extends Equatable {
  const LoginState({
    this.status = FormzSubmissionStatus.initial,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
    this.isValid = false,
    this.isPasswordHidden = true,
    this.isUsernameValid = false,
  });

  final FormzSubmissionStatus status;
  final Username username;
  final Password password;
  final bool isValid;
  final bool isPasswordHidden;
  final bool isUsernameValid;

  LoginState copyWith({
    FormzSubmissionStatus? status,
    Username? username,
    Password? password,
    bool? isValid,
    bool? isPasswordHidden,
    bool? isUsernameValid,
  }) {
    return LoginState(
      status: status ?? this.status,
      username: username ?? this.username,
      password: password ?? this.password,
      isValid: isValid ?? this.isValid,
      isPasswordHidden: isPasswordHidden ?? this.isPasswordHidden,
      isUsernameValid: isUsernameValid ?? this.isUsernameValid,
    );
  }

  @override
  List<Object> get props => [
    status,
    username,
    password,
    isPasswordHidden,
    isUsernameValid,
  ];
}
