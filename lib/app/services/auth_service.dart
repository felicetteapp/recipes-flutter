import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/routes/app_routes.dart';
import 'package:recipes_flutter/app/services/groups_service.dart';

class AuthService extends GetxService {
  final RxBool _isLoggedIn = false.obs;
  final RxList<String> _userGroups = <String>[].obs;

  bool get isLoggedIn => _isLoggedIn.value;
  List<String> get userGroups => _userGroups;

  Future<UserCredential> login(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
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
    _isLoggedIn.value = false;
    Get.offAllNamed(AppRoutes.login);
  }

  handleUserLoggedIn() async {
    log('User logged in', name: 'AuthService');
    final groups = await getUserGroups();
    log('User groups: $groups', name: 'AuthService');
    _userGroups.assignAll(groups);
    _isLoggedIn.value = true;
    Get.offAllNamed(AppRoutes.home);
  }

  listenToGroupsChanges() {
    _userGroups.listen((List<String> groups) {
      log('User groups updated: $groups', name: 'AuthService');

      final groupsService = Get.find<GroupsService>();
      groupsService.getUserGroups();
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenToFirebaseAuthChanges();
    listenToGroupsChanges();
  }
}
