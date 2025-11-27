import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class FRUser extends Equatable {
  const FRUser({
    required this.uid,
    required this.groups,
    required this.metadataUpdatedAt,
    required this.email,
  });
  factory FRUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? _,
  ) {
    final data = snapshot.data()!;
    final user = FRUser(
      uid: snapshot.id,
      groups: data['groups'] != null
          ? List<String>.from(data['groups'] as List<dynamic>? ?? [])
          : <String>[],
      metadataUpdatedAt: (data['metadataUpdated'] as Timestamp).toDate(),
      email: data['email'] as String? ?? '',
    );
    return user;
  }
  final String uid;
  final String email;
  final List<String> groups;
  final DateTime metadataUpdatedAt;

  static Map<String, dynamic> toFirestore(FRUser user, SetOptions? options) {
    return {
      'uid': user.uid,
      'groups': user.groups,
      'metadataUpdated': user.metadataUpdatedAt,
      'email': user.email,
    };
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
    // ignore: lines_longer_than_80_chars
    return 'FRUser{uid: $uid, email: $email, groups: $groups, metadataUpdatedAt: $metadataUpdatedAt}';
  }

  @override
  List<Object?> get props => [uid, email, groups, metadataUpdatedAt];
}
