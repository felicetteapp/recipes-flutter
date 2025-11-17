import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<FRUser?> getUser(String userId) async {
    if (_user != null) return _user;

    final snapshot = await collection().doc(userId).get();
    return _user = snapshot.data();
  }

  void clearCurrentUser() {
    _user = null;
  }
}
