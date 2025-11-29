import 'package:cloud_firestore/cloud_firestore.dart';

class FRIngredient {
  FRIngredient({
    required this.id,
    required this.name,
    this.actualIngredient = true,
  });

  factory FRIngredient.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? _,
  ) {
    final data = doc.data()!;
    return FRIngredient(
      id: doc.id,
      name: data['name'] as String,
      actualIngredient: data['actualIngredient'] as bool? ?? true,
    );
  }
  String id;
  String name;
  bool actualIngredient;

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

class FRWearIngredient {
  FRWearIngredient({
    required this.id,
    required this.name,
    required this.description,
    this.checked = false,
  });

  factory FRWearIngredient.fromMap(Map<String, dynamic> map) {
    return FRWearIngredient(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      checked: map['isChecked'] as bool? ?? false,
    );
  }
  String id;
  String name;
  String description;
  bool checked;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isChecked': checked,
    };
  }

  @override
  String toString() {
    // ignore: lines_longer_than_80_chars
    return 'FRWearIngredient(id: $id, name: $name, description: $description, checked: $checked)';
  }
}
