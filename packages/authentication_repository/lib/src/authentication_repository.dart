import 'dart:async';
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:secure_storage/secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  AuthenticationRepository({SecureStorageClient? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorageClient();

  final _controller = StreamController<AuthenticationStatus>();
  final SecureStorageClient _secureStorage;
  static const _emailForSignInKey = 'emailForSignIn';

  Stream<AuthenticationStatus> get status {
    return FirebaseAuth.instance.authStateChanges().map(
      (user) => user != null
          ? AuthenticationStatus.authenticated
          : AuthenticationStatus.unauthenticated,
    );
  }

  Stream<User?> get user {
    return FirebaseAuth.instance.authStateChanges();
  }

  User? get currentUser => FirebaseAuth.instance.currentUser;

  void setLocale(Locale locale) {
    FirebaseAuth.instance.setLanguageCode(locale.languageCode);
  }

  Future<void> logIn({
    required String username,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: username,
      password: password,
    );
  }

  void logOut() {
    FirebaseAuth.instance.signOut();
  }

  Future<void> sendPasswordRecoveryEmail({required String email}) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> createAccount({
    required String username,
    required String password,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: username,
      password: password,
    );
  }

  Future<void> refreshToken() async {
    await currentUser?.getIdToken(true);
  }

  Future<void> sendSignInLinkToEmail({
    required String email,
    required String continueUrl,
    required String linkDomain,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final androidPackageName = packageInfo.packageName;
    final iosBundleId = packageInfo.packageName;

    final actionCodeSettings = ActionCodeSettings(
      url: continueUrl,
      handleCodeInApp: true,
      androidPackageName: androidPackageName,
      iOSBundleId: iosBundleId,
      androidInstallApp: true,
      androidMinimumVersion: '12',
      linkDomain: linkDomain,
    );

    await FirebaseAuth.instance.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: actionCodeSettings,
    );

    await _secureStorage.write(key: _emailForSignInKey, value: email);
  }

  Future<String?> getEmailForSignIn() async {
    return _secureStorage.read(key: _emailForSignInKey);
  }

  Future<void> clearEmailForSignIn() async {
    await _secureStorage.delete(key: _emailForSignInKey);
  }

  bool isSignInWithEmailLink(String link) {
    return FirebaseAuth.instance.isSignInWithEmailLink(link);
  }

  Future<void> signInWithEmailLink({
    required String email,
    required String emailLink,
  }) async {
    await FirebaseAuth.instance.signInWithEmailLink(
      email: email,
      emailLink: emailLink,
    );
  }

  void dispose() => _controller.close();
}
