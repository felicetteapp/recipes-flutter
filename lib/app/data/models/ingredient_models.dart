import 'package:cloud_firestore/cloud_firestore.dart';

class FRIngredient {
  String id;
  String name;
  bool actualIngredient;

  FRIngredient({
    required this.id,
    required this.name,
    this.actualIngredient = true,
  });

  factory FRIngredient.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data()!;
    return FRIngredient(
      id: doc.id,
      name: data['name'] as String,
      actualIngredient: data['actualIngredient'] as bool? ?? true,
    );
  }

  static Map<String, dynamic> toFirestore(
    FRIngredient ingredient,
    SetOptions? options,
  ) {
    return {
      'name': ingredient.name,
      'actualIngredient': ingredient.actualIngredient,
    };
  }

  FRIngredient copyWith({String? id, String? name, bool? actualIngredient}) {
    return FRIngredient(
      id: id ?? this.id,
      name: name ?? this.name,
      actualIngredient: actualIngredient ?? this.actualIngredient,
    );
  }
}
