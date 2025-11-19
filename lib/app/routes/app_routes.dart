class AppRoutes {
  static const String splash = '/';
  static const String home = list;
  static const String login = '/login';
  static const String passwordRecovery = '/password-recovery';
  static const String groups = '/groups';
  static const String detailsPart = '/details';
  static const String createAccount = '/create-account';
  static const String recipes = '/recipes';
  static const String list = '/list';
  static const String ingredients = '/ingredients';

  static String groupDetails(String groupId) =>
      [groups, detailsPart, groupId].join('/').replaceAll('//', '/');
}
