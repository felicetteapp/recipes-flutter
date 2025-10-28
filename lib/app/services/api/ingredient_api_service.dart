import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felicette_recipes/app/data/models/ingredient_models.dart';
import 'package:felicette_recipes/app/services/api/api_service.dart';
import 'package:felicette_recipes/app/services/api/group_api_service.dart';

class IngredientApiService extends ApiService {
  CollectionReference<FRIngredient> collection(String groupId) {
    final groupDoc = GroupApiService().doc(groupId);
    return groupDoc
        .collection('ingredients')
        .withConverter<FRIngredient>(
          fromFirestore: FRIngredient.fromFirestore,
          toFirestore: FRIngredient.toFirestore,
        );
  }

  DocumentReference<FRIngredient> doc({
    required String groupId,
    required String ingredientId,
  }) {
    return collection(groupId).doc(ingredientId);
  }

  Future<DocumentSnapshot<FRIngredient>> getIngredient({
    required String groupId,
    required String ingredientId,
  }) {
    return doc(groupId: groupId, ingredientId: ingredientId).get();
  }

  Future<QuerySnapshot<FRIngredient>> getIngredients({
    required String groupId,
  }) {
    return collection(groupId).orderBy('name').get();
  }

  Future<void> updateIngredient({
    required String groupId,
    required FRIngredient ingredient,
  }) {
    return doc(groupId: groupId, ingredientId: ingredient.id).set(ingredient);
  }

  Future<void> deleteIngredient({
    required String groupId,
    required String ingredientId,
  }) {
    return doc(groupId: groupId, ingredientId: ingredientId).delete();
  }

  Future<DocumentReference<FRIngredient>> addIngredient({
    required String groupId,
    required FRIngredient ingredient,
  }) {
    return collection(groupId).add(ingredient);
  }
}
