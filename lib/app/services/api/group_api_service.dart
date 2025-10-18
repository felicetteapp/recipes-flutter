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

  Future<DocumentSnapshot<FRGroup>> getGroup(String groupId) {
    return collection().doc(groupId).get();
  }
}
