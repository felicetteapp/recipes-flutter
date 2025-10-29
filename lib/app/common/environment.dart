final class Environment {
  static const firebaseAppCheckAndroidDebugToken = String.fromEnvironment(
    'FIREBASE_APP_CHECK_ANDROID_DT',
    defaultValue: '',
  );
}
