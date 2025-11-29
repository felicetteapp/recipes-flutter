part of 'authentication_bloc.dart';

sealed class AuthenticationEvent {
  const AuthenticationEvent();
}

final class AuthenticationSubscriptionRequested extends AuthenticationEvent {}

final class AuthenticationLogoutPressed extends AuthenticationEvent {}

final class AuthenticationStatusRefreshRequested extends AuthenticationEvent {}

final class AuthenticationUserChanged extends AuthenticationEvent {
  const AuthenticationUserChanged(this.user);

  final FRUser? user;
}
