import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/authentication/models/username.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

part 'password_recovery_event.dart';
part 'password_recovery_state.dart';

class PasswordRecoveryBloc
    extends Bloc<PasswordRecoveryEvent, PasswordRecoveryState> {
  PasswordRecoveryBloc({
    required AuthenticationRepository authenticationRepository,
  }) : _authenticationRepository = authenticationRepository,
       super(const PasswordRecoveryState()) {
    on<PasswordRecoveryEmailChanged>(_onEmailChanged);
    on<PasswordRecoverySubmitted>(_onSubmitted);
  }

  final AuthenticationRepository _authenticationRepository;

  void _onEmailChanged(
    PasswordRecoveryEmailChanged event,
    Emitter<PasswordRecoveryState> emit,
  ) {
    final email = Username.dirty(event.email);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email]),
      ),
    );
  }

  void _onSubmitted(
    PasswordRecoverySubmitted event,
    Emitter<PasswordRecoveryState> emit,
  ) {
    // Implement password recovery submission logic here
  }
}
