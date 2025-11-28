import 'dart:async';
import 'dart:developer';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  AuthenticationBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository,
       super(const AuthenticationState.unknown()) {
    on<AuthenticationSubscriptionRequested>(_onSubscriptionRequested);
    on<AuthenticationLogoutPressed>(_onLogoutPressed);
    on<AuthenticationStatusRefreshRequested>(
      _onAuthenticationStatusRefreshRequested,
    );
    on<AuthenticationUserChanged>(_onUserChanged);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  StreamSubscription<FRUser?>? _userStreamSubscription;

  Future<void> _onAuthenticationStatusRefreshRequested(
    AuthenticationStatusRefreshRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    log(
      'Refreshing authentication status',
      name: 'AuthenticationBloc',
    );
    await _authenticationRepository.refreshToken();
  }

  Future<void> _onSubscriptionRequested(
    AuthenticationSubscriptionRequested event,
    Emitter<AuthenticationState> emit,
  ) {
    log('Authentication subscription requested', name: 'AuthenticationBloc');
    return emit.onEach(
      _authenticationRepository.status,
      onData: (status) async {
        log(
          'Authentication status changed: $status',
          name: 'AuthenticationBloc',
        );
        switch (status) {
          case AuthenticationStatus.unauthenticated:
            _clearCurrentUserData();
            return emit(const AuthenticationState.unauthenticated());
          case AuthenticationStatus.authenticated:
            final user = await _tryGetUser();
            log(
              'User authenticated: $user',
              name: 'AuthenticationBloc',
            );

            if (user != null) {
              _startListeningToUser(user.uid);
              return emit(AuthenticationState.authenticated(user));
            } else {
              return emit(const AuthenticationState.unauthenticated());
            }
          case AuthenticationStatus.unknown:
            return emit(const AuthenticationState.unknown());
        }
      },
      onError: addError,
    );
  }

  void _onLogoutPressed(
    AuthenticationLogoutPressed event,
    Emitter<AuthenticationState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  void _onUserChanged(
    AuthenticationUserChanged event,
    Emitter<AuthenticationState> emit,
  ) {
    log(
      'User data changed: ${event.user}',
      name: 'AuthenticationBloc',
    );
    if (event.user != null) {
      emit(AuthenticationState.authenticated(event.user!));
    }
  }

  void _startListeningToUser(String userId) {
    log(
      'Starting to listen to user stream for userId: $userId',
      name: 'AuthenticationBloc',
    );
    _userStreamSubscription?.cancel();
    _userStreamSubscription = _userRepository
        .getUserStream(userId)
        .listen(
          (user) {
            add(AuthenticationUserChanged(user));
          },
          onError: (dynamic error) {
            log(
              'Error in user stream: $error',
              name: 'AuthenticationBloc',
              error: error,
            );
          },
        );
  }

  Future<FRUser?> _tryGetUser() async {
    try {
      final user = await _userRepository.getUserFromAuthenticatedUser(
        _authenticationRepository.currentUser!,
      );
      return user;
    } catch (_) {
      return null;
    }
  }

  void _clearCurrentUserData() {
    _userStreamSubscription?.cancel();
    _userStreamSubscription = null;
    _userRepository.clearCurrentUser();
  }

  @override
  Future<void> close() {
    _userStreamSubscription?.cancel();
    return super.close();
  }
}
