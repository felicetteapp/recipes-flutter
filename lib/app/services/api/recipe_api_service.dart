import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/services/api/api_service.dart';
import 'package:recipes_flutter/app/services/api/group_api_service.dart';

class RecipeApiService extends ApiService {
  CollectionReference<FRRecipe> collection(String groupId) {
    final groupDoc = GroupApiService().doc(groupId);
    return groupDoc
        .collection('recipes')
        .withConverter<FRRecipe>(
          fromFirestore: FRRecipe.fromFirestore,
          toFirestore: FRRecipe.toFirestore,
        );
  }

  DocumentReference<FRRecipe> doc({
    required String groupId,
    required String recipeId,
  }) {
    return collection(groupId).doc(recipeId);
  }

  Future<DocumentSnapshot<FRRecipe>> getRecipe({
    required String groupId,
    required String recipeId,
  }) {
    return doc(groupId: groupId, recipeId: recipeId).get();
  }

  Future<QuerySnapshot<FRRecipe>> getRecipes({required String groupId}) {
    return collection(groupId).orderBy('name').get();
  }

  Future<void> updateRecipe({
    required String groupId,
    required FRRecipe recipe,
  }) {
    return doc(groupId: groupId, recipeId: recipe.id).set(recipe);
  }

  Future<void> deleteRecipe({
    required String groupId,
    required String recipeId,
  }) {
    return doc(groupId: groupId, recipeId: recipeId).delete();
  }

  Future<DocumentReference<FRRecipe>> addRecipe({
    required String groupId,
    required FRRecipe recipe,
  }) {
    return collection(groupId).add(recipe);
  }
}
