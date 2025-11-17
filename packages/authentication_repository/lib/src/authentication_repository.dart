import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _controller = StreamController<AuthenticationStatus>();

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

  void dispose() => _controller.close();
}
