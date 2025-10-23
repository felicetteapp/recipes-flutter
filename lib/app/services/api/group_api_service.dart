import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/services/api/api_service.dart';

class GroupApiService extends ApiService {
  CollectionReference<FRGroup> collection() {
    return db
        .collection('groups')
        .withConverter<FRGroup>(
          fromFirestore: FRGroup.fromFirestore,
          toFirestore: FRGroup.toFirestore,
        );
  }

  DocumentReference<FRGroup> doc(String groupId) {
    return collection().doc(groupId);
  }

  Future<DocumentSnapshot<FRGroup>> getGroup(String groupId) {
    return doc(groupId).get();
  }

  Stream<DocumentSnapshot<FRGroup>> listenGroup(String groupId) {
    return doc(groupId).snapshots();
  }

  Future<void> updateGroupRecipes({required FRGroup group}) {
    return doc(
      group.id,
    ).set(group, SetOptions(mergeFields: ['currentRecipes']));
  }

  Future<void> updateGroupFilters({required FRGroup group}) {
    return doc(group.id).set(group, SetOptions(mergeFields: ['filters']));
  }
}
