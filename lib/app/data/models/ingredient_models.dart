import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felicette_recipes/app/common/common.dart';
import 'package:felicette_recipes/app/modules/home/widgets/list/list_controller.dart';
import 'package:get/utils.dart';

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

class FRWearIngredient {
  String id;
  String name;
  String description;
  bool checked;
  FRWearIngredient({
    required this.id,
    required this.name,
    required this.description,
    this.checked = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isChecked': checked,
    };
  }

  factory FRWearIngredient.fromMap(Map<String, dynamic> map) {
    return FRWearIngredient(
      id: map['id'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      checked: map['isChecked'] as bool? ?? false,
    );
  }

  factory FRWearIngredient.fromListIngredientItem(ListIngredientItem item) {
    final descriptionParts = <String>[];
    for (final recipe in item.recipes) {
      final quantityOfThisIngriedient = recipe.ingredients
          .firstWhere((ri) => ri.ingredientId == item.ingredient.id)
          .quantity;

      final thisRecipeParts = <String>[];
      if (quantityOfThisIngriedient.isNotEmpty) {
        thisRecipeParts.add('$quantityOfThisIngriedient ');
      }
      thisRecipeParts.add(TranslationKeys.for_.tr);
      thisRecipeParts.add(recipe.name);
      descriptionParts.add(thisRecipeParts.join(''));
    }

    if (item.quantity != null && item.quantity!.isNotEmpty) {
      descriptionParts.add(item.quantity!);
    }

    final description = descriptionParts.join(', ');

    log(
      'description for ingredient ${item.ingredient.name}: $description',
      name: 'FRWearIngredient',
    );

    return FRWearIngredient(
      id: item.ingredient.id,
      name: item.ingredient.name,
      description: description,
      checked: item.isChecked,
    );
  }
}
