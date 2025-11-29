import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_repository/recipe_repository.dart';

class RecipeRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference<FRRecipe> collection(String groupId) {
    return db
        .collection('groups')
        .doc(groupId)
        .collection('recipes')
        .withConverter<FRRecipe>(
          fromFirestore: FRRecipe.fromFirestore,
          toFirestore: FRRecipe.toFirestore,
        );
  }

  Stream<List<FRRecipe>> listenToRecipes(String groupId) {
    return collection(groupId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> updateRecipe(String groupId, FRRecipe recipe) async {
    final docRef = collection(groupId).doc(recipe.id);
    await docRef.set(recipe);
  }

  Future<void> deleteRecipe(String groupId, FRRecipe recipe) async {
    final docRef = collection(groupId).doc(recipe.id);
    await docRef.delete();
  }

  Future<void> createRecipe(String groupId, FRRecipe recipe) async {
    log(
      'Creating new recipe: $recipe, groupId: $groupId',
      name: 'RecipeRepository.createRecipe',
    );
    final docRef = collection(groupId).doc();
    final newRecipe = recipe.copyWith(id: docRef.id);
    log(
      'Creating new recipe: $newRecipe',
      name: 'RecipeRepository.createRecipe',
    );
    await docRef.set(newRecipe);
  }
}
