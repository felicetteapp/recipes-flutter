// ignore_for_file: do_not_use_environment

final class Environment {
  static const firebaseAppCheckAndroidDebugToken = String.fromEnvironment(
    'FIREBASE_APP_CHECK_ANDROID_DT',
  );
  static const firebaseAppCheckIosDebugToken = String.fromEnvironment(
    'FIREBASE_APP_CHECK_IOS_DT',
  );
  static const androidDeepLinkUrl = String.fromEnvironment(
    'ANDROID_DEEP_LINK_URL',
    defaultValue: 'app.recipes.felicette.app',
  );
}
