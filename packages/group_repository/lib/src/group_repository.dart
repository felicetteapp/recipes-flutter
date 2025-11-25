import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_repository/group_repository.dart';

class GroupRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference<FRGroup> collection() {
    return db
        .collection('groups')
        .withConverter<FRGroup>(
          fromFirestore: FRGroup.fromFirestore,
          toFirestore: FRGroup.toFirestore,
        );
  }

  Stream<DocumentSnapshot<FRGroup>> listenToGroup(String groupId) {
    return collection().doc(groupId).snapshots();
  }

  Stream<List<FRGroup>> listenToGroups(List<String> groupIds) {
    return collection()
        .where(
          FieldPath.documentId,
          whereIn: groupIds.isEmpty ? [''] : groupIds,
        )
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> updateSelectedGroupFilters(
    String groupId, {
    required FRGroupFilter filters,
  }) async {
    final groupDocRef = collection().doc(groupId);

    await groupDocRef.update({
      'filters': filters.toMap(),
    });
  }

  Future<void> removeCheckedIngredientFromGroup(
    String groupId,
    String ingredientId,
  ) async {
    final groupDocRef = collection().doc(groupId);

    await groupDocRef.update({
      'checkedIngredients': FieldValue.arrayRemove([ingredientId]),
      'ingredientsPrices.$ingredientId': FieldValue.delete(),
    });
  }

  Future<void> addCheckedIngredientToGroup(
    String groupId,
    String ingredientId,
  ) async {
    final groupDocRef = collection().doc(groupId);

    await groupDocRef.update({
      'checkedIngredients': FieldValue.arrayUnion([ingredientId]),
    });
  }
}
