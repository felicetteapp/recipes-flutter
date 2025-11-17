import 'dart:developer';
import 'dart:ui';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secure_storage/secure_storage.dart';
import 'package:user_repository/user_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

const isDarkModeKey = 'isDarkMode';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    SecureStorageClient? secureStorageClient,
  }) : _authenticationRepository = authenticationRepository,
       _userRepository = userRepository,
       _secureStorageClient = secureStorageClient ?? SecureStorageClient(),
       super(AppState(user: userRepository.user, darkMode: false)) {
    on<AppUserSubscriptionRequested>(_onUserSubscriptionRequested);
    on<AppLogoutPressed>(_onLogoutPressed);
    on<AppToggleDarkMode>(_onToggleDarkMode);
    on<AppSetDarkMode>(_onSetDarkMode);
  }

  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final SecureStorageClient _secureStorageClient;

  Future<void> _onUserSubscriptionRequested(
    AppUserSubscriptionRequested event,
    Emitter<AppState> emit,
  ) {
    return emit.onEach(
      _authenticationRepository.user,
      onData: (user) => emit(
        state.copyWith(
          user: _userRepository.user,
          status: user == null
              ? AppStatus.unauthenticated
              : AppStatus.authenticated,
        ),
      ),
      onError: addError,
    );
  }

  void _onToggleDarkMode(
    AppToggleDarkMode event,
    Emitter<AppState> emit,
  ) {
    log(
      'Toggling dark mode from ${state.darkMode} to ${!state.darkMode}',
      name: 'AppBloc',
    );
    final newDarkModeSetting = !state.darkMode;
    _onSetDarkMode(
      AppSetDarkMode(isDarkMode: newDarkModeSetting),
      emit,
    );
  }

  void _onLogoutPressed(
    AppLogoutPressed event,
    Emitter<AppState> emit,
  ) {
    _authenticationRepository.logOut();
  }

  void _onSetDarkMode(
    AppSetDarkMode event,
    Emitter<AppState> emit,
  ) {
    log(
      'Setting dark mode to ${event.isDarkMode}',
      name: 'AppBloc',
    );
    _secureStorageClient.write(
      key: isDarkModeKey,
      value: event.isDarkMode.toString(),
    );
    emit(state.copyWith(darkMode: event.isDarkMode));
  }

  Future<String?> getStoredDarkModeSetting() async {
    final storedDarkModeSetting = await _secureStorageClient.read(
      key: isDarkModeKey,
    );
    return storedDarkModeSetting ?? 'false';
  }

  Future<bool> getInitialDarkModeSetting() async {
    final userHasDarkModeSettingEnabled =
        PlatformDispatcher.instance.platformBrightness == Brightness.dark;

    final storedDarkModeSetting = await getStoredDarkModeSetting();
    var initialThemeIsDark = userHasDarkModeSettingEnabled;

    if (storedDarkModeSetting == 'true') {
      initialThemeIsDark = true;
    } else if (storedDarkModeSetting == 'false') {
      initialThemeIsDark = false;
    }

    log(
      'Initial dark mode setting: $initialThemeIsDark (Stored: $storedDarkModeSetting, System: $userHasDarkModeSettingEnabled)',
      name: 'AppBloc',
    );

    return initialThemeIsDark;
  }
}
