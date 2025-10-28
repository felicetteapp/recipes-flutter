import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';

class AuthService extends GetxService {
  final RxBool isLoggedIn = false.obs;
  final RxList<String> userGroups = <String>[].obs;

  Future<UserCredential> login(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    return FirebaseAuth.instance.signOut();
  }

  listenToFirebaseAuthChanges() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        handleUserLoggedOut();
      } else {
        handleUserLoggedIn();
      }
    });
  }

  Future<List<String>> getUserGroups() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return [];
    }

    final tokenResult =
        await FirebaseAuth.instance.currentUser!.getIdTokenResult();

    return tokenResult.claims?['groups']?.cast<String>() ?? [];
  }

  handleUserLoggedOut() {
    log('User logged out', name: 'AuthService');
    isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  handleUserLoggedIn() async {
    log('User logged in', name: 'AuthService');
    final groups = await getUserGroups();
    log('User groups: $groups', name: 'AuthService');
    userGroups.assignAll(groups);
    isLoggedIn.value = true;
    Get.offAllNamed(AppRoutes.home);
  }

  listenToGroupsChanges() {
    userGroups.listen((List<String> groups) {
      log('User groups updated: $groups', name: 'AuthService');
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenToFirebaseAuthChanges();
    listenToGroupsChanges();
  }
}
