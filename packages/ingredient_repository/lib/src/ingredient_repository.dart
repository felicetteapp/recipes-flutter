import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

class IngredientRepository {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  CollectionReference<FRIngredient> collection(String groupId) {
    return db
        .collection('groups')
        .doc(groupId)
        .collection('ingredients')
        .withConverter<FRIngredient>(
          fromFirestore: FRIngredient.fromFirestore,
          toFirestore: FRIngredient.toFirestore,
        );
  }

  Stream<List<FRIngredient>> listenToIngredients(String groupId) {
    return collection(groupId)
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
