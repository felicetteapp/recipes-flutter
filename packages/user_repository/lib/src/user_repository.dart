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

  void clearCurrentUser() {
    _user = null;
  }
}
