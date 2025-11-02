import 'package:cloud_firestore/cloud_firestore.dart';

class FRUser {
  final String uid;
  final String email;
  final List<String> groups;
  final DateTime metadataUpdatedAt;

  FRUser({
    required this.uid,
    required this.groups,
    required this.metadataUpdatedAt,
    required this.email,
  });

  static Map<String, dynamic> toFirestore(FRUser user, SetOptions? options) {
    return {
      'uid': user.uid,
      'groups': user.groups,
      'metadataUpdated': user.metadataUpdatedAt,
      'email': user.email,
    };
  }

  factory FRUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data()!;
    final user = FRUser(
      uid: snapshot.id,
      groups: <String>[],
      metadataUpdatedAt: (data['metadataUpdated'] as Timestamp).toDate(),
      email: data['email'] ?? '',
    );
    user.groups.addAll((data['groups'] ?? []).cast<String>());
    return user;
  }

  FRUser copyWith({
    String? uid,
    String? email,
    List<String>? groups,
    DateTime? metadataUpdatedAt,
  }) {
    return FRUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      groups: groups ?? this.groups,
      metadataUpdatedAt: metadataUpdatedAt ?? this.metadataUpdatedAt,
    );
  }

  @override
  String toString() {
    return 'FRUser{uid: $uid, email: $email, groups: $groups, metadataUpdatedAt: $metadataUpdatedAt}';
  }
}
