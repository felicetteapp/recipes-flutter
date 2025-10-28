import 'dart:developer';

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
    return doc(group.id).update({
      'currentRecipes': FRGroup.toFirestore(group, null)['currentRecipes'],
    });
  }

  Future<void> updateGroupFilters({required FRGroup group}) {
    log(
      'Updating filters for group ${group.name} to ${group.filters}',
      name: 'GroupApiService',
    );

    log(
      'filter showCheckedsFirst: ${group.filters.showCheckedsFirst}',
      name: 'GroupApiService',
    );

    log(FRGroup.toFirestore(group, null).toString(), name: 'GroupApiService');
    return doc(
      group.id,
    ).update({'filters': FRGroup.toFirestore(group, null)['filters']});
  }

  Future<void> updateGroupListDetails({required FRGroup group}) {
    final data = FRGroup.toFirestore(group, null);
    return doc(group.id).update({
      'budget': data['budget'],
      'currency': data['currency'],
      'filters': data['filters'],
      'currentRecipes': data['currentRecipes'],
    });
  }

  Future<void> removeIngredientPrice({
    required FRGroup group,
    required String ingredientId,
  }) {
    return doc(
      group.id,
    ).update({'ingredientsPrices.$ingredientId': FieldValue.delete()});
  }

  Future<void> updateIngredientPrices({
    required FRGroup group,
    required String ingredientId,
    required List<FRIngredientPrice> prices,
  }) {
    return doc(group.id).update({
      'ingredientsPrices.$ingredientId':
          prices.map((price) => price.toMap()).toList(),
    });
  }

  Future<void> checkIngredient({
    required FRGroup group,
    required String ingredientId,
    required bool isChecked,
  }) {
    return doc(group.id).update({
      'checkedIngredients':
          isChecked
              ? FieldValue.arrayUnion([ingredientId])
              : FieldValue.arrayRemove([ingredientId]),
    });
  }
}
