part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

final class AppState extends Equatable {
  const AppState({required bool darkMode, FRUser? user})
    : this._(
        status: user == null
            ? AppStatus.unauthenticated
            : AppStatus.authenticated,
        user: user,
        darkMode: darkMode,
      );

  const AppState._({
    required this.status,
    required this.darkMode,
    this.user,
    this.locale = const Locale.fromSubtags(languageCode: 'en'),
  });

  final AppStatus status;
  final FRUser? user;
  final bool darkMode;
  final Locale locale;

  AppState copyWith({
    AppStatus? status,
    FRUser? user,
    bool? darkMode,
    Locale? locale,
  }) {
    return AppState._(
      status: status ?? this.status,
      user: user ?? this.user,
      darkMode: darkMode ?? this.darkMode,
      locale: locale ?? this.locale,
    );
  }

  @override
  List<Object> get props => [status, darkMode, ?user, locale];
}
