import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:group_repository/group_repository.dart';

class GroupRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference collectionWithoutConverter() {
    return db.collection('groups');
  }

  CollectionReference<FRGroup> collection() {
    return collectionWithoutConverter().withConverter<FRGroup>(
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

  Future<void> updateIngredientPrices(
    String groupId,
    String ingredientId,
    List<FRIngredientPrice> prices,
  ) async {
    final groupDocRef = collection().doc(groupId);

    final pricesMapList = prices.map((price) => price.toMap()).toList();

    await groupDocRef.update({
      'ingredientsPrices.$ingredientId': pricesMapList,
    });
  }

  Future<void> clearAllCheckedIngredientsFromGroup(
    String groupId,
  ) async {
    final groupDocRef = collection().doc(groupId);

    await groupDocRef.update({
      'checkedIngredients': [],
      'ingredientsPrices': {},
    });
  }

  Future<void> updateList(
    String groupId,
    FRGroup updatedGroup, {
    List<String>? mergeFields = const [
      'currentIngredients',
      'currentRecipes',
      'budget',
      'currency',
    ],
  }) async {
    final groupDocRef = collection().doc(groupId);

    await groupDocRef.set(
      updatedGroup,
      SetOptions(
        mergeFields: mergeFields,
      ),
    );
  }

  Future<void> addIngredientsToGroup(
    String groupId,
    List<FRCurrentIngredients> ingredients,
  ) async {
    final groupDocRef = collection().doc(groupId);

    final ingredientIds = ingredients.map((e) => e.ingredientId).toList();

    await groupDocRef.update({
      'currentIngredients': FieldValue.arrayUnion(
        ingredients.map((e) => e.toMap()).toList(),
      ),
      'checkedIngredients': FieldValue.arrayRemove(ingredientIds),
    });
  }

  Future<void> updateGroup(
    String groupId,
    FRGroup updatedGroup,
  ) async {
    final groupDocRef = collection().doc(groupId);

    await groupDocRef.update(
      FRGroup.toFirestore(updatedGroup, SetOptions(mergeFields: ['name'])),
    );
  }

  Future<void> deleteGroup(String groupId) async {
    final groupDocRef = collection().doc(groupId);

    await groupDocRef.delete();
  }

  Future<void> createGroup(FRGroup newGroup) async {
    final data = newGroup.toCreationMap();
    await collectionWithoutConverter().add(data);
  }
}
