final class Environment {
  static const firebaseAppCheckAndroidDebugToken = String.fromEnvironment(
    'FIREBASE_APP_CHECK_ANDROID_DT',
    defaultValue: '',
  );
  static const firebaseAppCheckIosDebugToken = String.fromEnvironment(
    'FIREBASE_APP_CHECK_IOS_DT',
    defaultValue: '',
  );
}
