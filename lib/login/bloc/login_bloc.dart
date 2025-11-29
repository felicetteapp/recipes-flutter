import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/app/common/environment.dart';
import 'package:felicette_recipes/authentication/models/password.dart';
import 'package:felicette_recipes/authentication/models/username.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'login_state.dart';
part 'login_event.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const LoginState()) {
    on<LoginUsernameChanged>(_onUsernameChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LoginPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<LoginSubmitted>(_onSubmitted);
    on<LoginPasswordlessRequested>(_onPasswordlessRequested);
    on<LoginEmailLinkReceived>(_onEmailLinkReceived);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onUsernameChanged(
    LoginUsernameChanged event,
    Emitter<LoginState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([state.password, username]),
        isUsernameValid: Formz.validate([username]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPasswordChanged(
    LoginPasswordChanged event,
    Emitter<LoginState> emit,
  ) {
    final password = Password.dirty(event.password);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.username]),
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  void _onPasswordVisibilityToggled(
    LoginPasswordVisibilityToggled event,
    Emitter<LoginState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
        status: FormzSubmissionStatus.initial,
      ),
    );
  }

  Future<void> _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
      try {
        await _authenticationRepository.logIn(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(status: FormzSubmissionStatus.success));
      } catch (_) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
      }
    }
  }

  Future<void> _onPasswordlessRequested(
    LoginPasswordlessRequested event,
    Emitter<LoginState> emit,
  ) async {
    if (state.isUsernameValid) {
      emit(
        state.copyWith(
          passwordlessStatus: FormzSubmissionStatus.inProgress,
        ),
      );
      try {
        await _authenticationRepository.sendSignInLinkToEmail(
          email: state.username.value,
          continueUrl:
              'https://${Environment.androidDeepLinkUrl}/__/auth/links?email=${state.username.value}',
          linkDomain: Environment.androidDeepLinkUrl,
        );
        emit(
          state.copyWith(
            passwordlessStatus: FormzSubmissionStatus.success,
          ),
        );
      } catch (_) {
        emit(
          state.copyWith(
            passwordlessStatus: FormzSubmissionStatus.failure,
          ),
        );
      }
    }
  }

  Future<void> _onEmailLinkReceived(
    LoginEmailLinkReceived event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      if (!_authenticationRepository.isSignInWithEmailLink(event.emailLink)) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        return;
      }

      final email = await _authenticationRepository.getEmailForSignIn();

      if (email == null) {
        emit(state.copyWith(status: FormzSubmissionStatus.failure));
        return;
      }

      await _authenticationRepository.signInWithEmailLink(
        email: email,
        emailLink: event.emailLink,
      );

      await _authenticationRepository.clearEmailForSignIn();

      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
