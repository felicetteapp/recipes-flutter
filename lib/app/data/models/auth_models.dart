import 'package:cloud_firestore/cloud_firestore.dart';

class FRUser {
  final String uid;
  final List<String> groups;
  final DateTime metadataUpdatedAt;

  FRUser({
    required this.uid,
    required this.groups,
    required this.metadataUpdatedAt,
  });

  static Map<String, dynamic> toFirestore(FRUser user, SetOptions? options) {
    return {
      'uid': user.uid,
      'groups': user.groups,
      'metadataUpdated': user.metadataUpdatedAt,
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
    );
    user.groups.addAll((data['groups'] as List<dynamic>).cast<String>());
    return user;
  }
}
