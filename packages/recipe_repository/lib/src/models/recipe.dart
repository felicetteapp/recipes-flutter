import 'package:cloud_firestore/cloud_firestore.dart';

class BasicIngredientQuantity {
  BasicIngredientQuantity({required this.ingredientId, required this.quantity});
  String ingredientId;
  String quantity;

  BasicIngredientQuantity copyWith({String? ingredientId, String? quantity}) {
    return BasicIngredientQuantity(
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
    );
  }
}

class FRRecipeIngredient extends BasicIngredientQuantity {
  FRRecipeIngredient({required super.ingredientId, required super.quantity});

  factory FRRecipeIngredient.fromMap(Map<String, dynamic> data) {
    return FRRecipeIngredient(
      ingredientId: data['ingredient'] as String,
      quantity: data['quantity'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'ingredient': ingredientId, 'quantity': quantity};
  }
}

class FRRecipe {
  FRRecipe({required this.id, required this.name, required this.ingredients});

  factory FRRecipe.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? _,
  ) {
    final data = doc.data()!;
    return FRRecipe(
      id: doc.id,
      name: data['name'] as String,
      ingredients: (data['ingredients'] as List<dynamic>)
          .map(
            (e) => FRRecipeIngredient.fromMap(
              Map<String, dynamic>.from(e as Map),
            ),
          )
          .toList(),
    );
  }
  String id;
  String name;
  List<FRRecipeIngredient> ingredients;

  static Map<String, dynamic> toFirestore(
    FRRecipe recipe,
    SetOptions? options,
  ) {
    return {
      'name': recipe.name,
      'ingredients': recipe.ingredients.map((e) => e.toMap()).toList(),
    };
  }

  FRRecipe copyWith({
    String? name,
    List<FRRecipeIngredient>? ingredients,
    String? id,
  }) {
    return FRRecipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
    );
  }
}
