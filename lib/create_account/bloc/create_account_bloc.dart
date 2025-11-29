import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/authentication/models/models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'create_account_event.dart';
part 'create_account_state.dart';

class CreateAccountBloc extends Bloc<CreateAccountEvent, CreateAccountState> {
  CreateAccountBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const CreateAccountState()) {
    on<CreateAccountUsernameChanged>(_onUsernameChanged);
    on<CreateAccountPasswordChanged>(_onPasswordChanged);
    on<CreateAccountPasswordConfirmationChanged>(
      _onPasswordConfirmationChanged,
    );
    on<CreateAccountPasswordVisibilityToggled>(_onPasswordVisibilityToggled);
    on<CreateAccountPasswordConfirmationVisibilityToggled>(
      _onPasswordConfirmationVisibilityToggled,
    );
    on<CreateAccountSubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onUsernameChanged(
    CreateAccountUsernameChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    final username = Username.dirty(event.username);
    emit(
      state.copyWith(
        username: username,
        isValid: Formz.validate([
          state.password,
          state.passwordConfirmation,
          username,
        ]),
      ),
    );
  }

  void _onPasswordChanged(
    CreateAccountPasswordChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    final password = Password.dirty(event.password);
    final passwordConfirmation = ConfirmedPassword.dirty(
      password: event.password,
      value: state.passwordConfirmation.value,
    );

    emit(
      state.copyWith(
        password: password,
        passwordConfirmation: passwordConfirmation,
        isValid: Formz.validate([
          password,
          passwordConfirmation,
          state.username,
        ]),
      ),
    );
  }

  void _onPasswordConfirmationChanged(
    CreateAccountPasswordConfirmationChanged event,
    Emitter<CreateAccountState> emit,
  ) {
    final passwordConfirmation = ConfirmedPassword.dirty(
      password: state.password.value,
      value: event.passwordConfirmation,
    );
    emit(
      state.copyWith(
        passwordConfirmation: passwordConfirmation,
        isValid: Formz.validate([
          state.password,
          passwordConfirmation,
          state.username,
        ]),
      ),
    );
  }

  void _onPasswordVisibilityToggled(
    CreateAccountPasswordVisibilityToggled event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordHidden: !state.isPasswordHidden,
      ),
    );
  }

  void _onPasswordConfirmationVisibilityToggled(
    CreateAccountPasswordConfirmationVisibilityToggled event,
    Emitter<CreateAccountState> emit,
  ) {
    emit(
      state.copyWith(
        isPasswordConfirmationHidden: !state.isPasswordConfirmationHidden,
      ),
    );
  }

  Future<void> _onSubmitted(
    CreateAccountSubmitted event,
    Emitter<CreateAccountState> emit,
  ) async {
    if (state.isValid) {
      emit(state.copyWith(submissionStatus: .inProgress));
      try {
        await _authenticationRepository.createAccount(
          username: state.username.value,
          password: state.password.value,
        );
        emit(state.copyWith(submissionStatus: .success));
      } catch (_) {
        emit(state.copyWith(submissionStatus: .failure));
      }
    }
  }
}
