import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felicette_recipes/app/common/environment.dart';
import 'package:felicette_recipes/app/data/models/auth_models.dart';
import 'package:felicette_recipes/app/services/api/auth_api_service.dart';
import 'package:felicette_recipes/app/services/localization_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AuthService extends GetxService {
  final AuthApiService authApiService = Get.put<AuthApiService>(
    AuthApiService(),
    permanent: true,
  );
  final RxBool isLoggedIn = false.obs;
  final RxList<String> userGroups = RxList.empty();
  final Rxn<FRUser> currentUser = Rxn<FRUser>();

  StreamSubscription<DocumentSnapshot<FRUser>>? userListenerStream;

  Future<UserCredential> login(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount(String email, String password) async {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  loginWithEmailLink(String email, String emailLink) async {
    log(
      'Logging in with email link for email: $email',
      name: 'AuthService.loginWithEmailLink',
    );
    final isLink = FirebaseAuth.instance.isSignInWithEmailLink(emailLink);
    if (!isLink) {
      throw Exception('Invalid email link');
    }
    return FirebaseAuth.instance.signInWithEmailLink(
      email: email,
      emailLink: emailLink,
    );
  }

  Future<void> loginWithoutPassword(String email) async {
    final ls = Get.find<LocalizationService>();
    final packageInfo = await PackageInfo.fromPlatform();
    final androidPackageName = packageInfo.packageName;

    final isAndroid = GetPlatform.isAndroid;

    if (!isAndroid) {
      // TODO: implement for iOS
      throw Exception('loginWithoutPassword is only supported on Android');
    }

    final ActionCodeSettings acs = ActionCodeSettings(
      url:
          'https://${Environment.androidDeepLinkUrl}/__/auth/links?email=$email',
      handleCodeInApp: true,
      androidPackageName: androidPackageName,
      androidInstallApp: true,
      androidMinimumVersion: '12',
      linkDomain: Environment.androidDeepLinkUrl,
    );

    await FirebaseAuth.instance.setLanguageCode(ls.currentLocale.languageCode);

    await FirebaseAuth.instance.sendSignInLinkToEmail(
      email: email,
      actionCodeSettings: acs,
    );
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    return FirebaseAuth.instance.signOut();
  }

  listenToFirebaseAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      log(
        'Firebase auth state changed: user is ${user == null ? 'logged out' : 'logged in'}',
        name: 'AuthService',
      );
      if (user == null) {
        handleUserLoggedOut();
      } else {
        handleUserLoggedIn();
      }
    });
  }

  Future<List<String>> getUserGroups({bool forceRefresh = false}) async {
    log(
      'Fetching user groups from ID token claims - force $forceRefresh',
      name: 'AuthService',
    );
    if (FirebaseAuth.instance.currentUser == null) {
      return [];
    }

    final tokenResult = await FirebaseAuth.instance.currentUser!
        .getIdTokenResult(forceRefresh);

    final List<String> groups =
        tokenResult.claims?['groups']?.cast<String>() ?? [];

    log('User groups from claims: $groups', name: 'AuthService');
    return groups;
  }

  handleUserLoggedOut() {
    log('User logged out', name: 'AuthService');
    isLoggedIn.value = false;
    currentUser.value = null;
    Get.offAllNamed(AppRoutes.login);
    userListenerStream?.cancel();
  }

  handleUserLoggedIn() async {
    log('User logged in', name: 'AuthService');
    //    currentUser.value = FRUser(uid: FirebaseAuth.instance.currentUser!.uid, );
    userListenerStream?.cancel();
    userListenerStream = authApiService
        .listenUser(userId: FirebaseAuth.instance.currentUser!.uid)
        .listen((snapshot) async {
          final groups = snapshot.data()?.groups ?? [];

          var claimsGroups = await getUserGroups();

          final bool shouldForceRefresh =
              groups.toSet().difference(claimsGroups.toSet()).isNotEmpty ||
              claimsGroups.toSet().difference(groups.toSet()).isNotEmpty;

          if (shouldForceRefresh) {
            claimsGroups = await getUserGroups(forceRefresh: true);
          }

          final needsToUpdateUserGroups =
              groups.toSet().difference(claimsGroups.toSet()).isNotEmpty ||
              claimsGroups.toSet().difference(groups.toSet()).isNotEmpty ||
              userGroups.toSet().difference(claimsGroups.toSet()).isNotEmpty ||
              claimsGroups.toSet().difference(userGroups.toSet()).isNotEmpty;

          var partialUserData = snapshot.data();
          log(
            'Fetched user data from Firestore: ${partialUserData.toString()}',
            name: 'AuthService',
          );
          if (partialUserData == null) {
            log(
              'No user data found in Firestore for user ${FirebaseAuth.instance.currentUser!.uid}',
              name: 'AuthService',
            );
            return;
          }
          partialUserData = partialUserData.copyWith(
            email: FirebaseAuth.instance.currentUser!.email ?? '',
          );

          log(
            'auth email: ${FirebaseAuth.instance.currentUser!.email}',
            name: 'AuthService',
          );
          log(
            'email for current user set to ${partialUserData.email}',
            name: 'AuthService',
          );
          currentUser.value = partialUserData;
          isLoggedIn.value = true;
          if (needsToUpdateUserGroups) {
            userGroups.assignAll(claimsGroups);
          }
        });

    Get.offAllNamed(AppRoutes.home);
  }

  handlePasswordRecovery(String email) async {
    final ls = Get.find<LocalizationService>();
    final languageCode = ls.currentLocale.languageCode;
    await FirebaseAuth.instance.setLanguageCode(languageCode);

    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  void onInit() {
    super.onInit();
    listenToFirebaseAuthChanges();
  }
}
