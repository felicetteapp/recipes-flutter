import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference<FRUser> collection() {
    return db
        .collection('users')
        .withConverter<FRUser>(
          fromFirestore: FRUser.fromFirestore,
          toFirestore: FRUser.toFirestore,
        );
  }

  FRUser? _user;
  StreamSubscription<DocumentSnapshot<FRUser>>? _userSubscription;

  FRUser? get user => _user;

  Future<FRUser?> getUserFromAuthenticatedUser(User authUser) async {
    if (_user != null) return _user;

    final snapshot = await collection().doc(authUser.uid).get();

    log(
      'Fetched user data for userId $authUser: ${snapshot.data()}',
      name: 'UserRepository',
    );
    return _user = snapshot.data()?.copyWith(
      email: authUser.email ?? '',
    );
  }

  Stream<FRUser?> getUserStream(String userId) {
    log(
      'Starting user stream for userId: $userId',
      name: 'UserRepository',
    );
    return collection().doc(userId).snapshots().map((snapshot) {
      final user = snapshot.data();
      log(
        'User stream update for userId $userId: $user',
        name: 'UserRepository',
      );
      if (user != null) {
        _user = user;
      }
      return user;
    });
  }

  void clearCurrentUser() {
    _user = null;
    _userSubscription?.cancel();
    _userSubscription = null;
  }
}
