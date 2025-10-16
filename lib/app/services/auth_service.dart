import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/routes/app_routes.dart';

class AuthService extends GetxService {
  final RxBool isLoggedIn = false.obs;

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
    print('AuthService: Listening to Firebase auth changes');
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        isLoggedIn.value = false;
        Get.offAndToNamed(AppRoutes.login);
        print('User is currently signed out!');
      } else {
        isLoggedIn.value = true;
        Get.offAllNamed(AppRoutes.home);
        print('User is signed in!');
      }
    });
  }

  @override
  void onInit() {
    super.onInit();
    listenToFirebaseAuthChanges();
  }
}
