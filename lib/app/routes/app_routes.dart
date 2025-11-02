class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String passwordRecovery = '/password-recovery';
  static const String groups = '/groups';
  static const String detailsPart = '/details';
  static const String createAccount = '/create-account';

  static String groupDetails(String groupId) =>
      [groups, detailsPart, groupId].join('/').replaceAll('//', '/');
}
