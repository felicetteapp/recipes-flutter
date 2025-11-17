part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

final class AppUserSubscriptionRequested extends AppEvent {
  const AppUserSubscriptionRequested();
}

final class AppLogoutPressed extends AppEvent {
  const AppLogoutPressed();
}

final class AppToggleDarkMode extends AppEvent {
  const AppToggleDarkMode();
}

final class AppSetDarkMode extends AppEvent {
  const AppSetDarkMode({required this.isDarkMode});

  final bool isDarkMode;
}
