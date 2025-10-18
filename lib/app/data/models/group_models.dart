import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class FRGroupFilter {
  bool showCheckedsFirst;

  FRGroupFilter({this.showCheckedsFirst = false});

  factory FRGroupFilter.fromMap(Map<String, dynamic> data) {
    return FRGroupFilter(
      showCheckedsFirst: data['showCheckedsFirst'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'showCheckedsFirst': showCheckedsFirst};
  }
}

class FRIngredientPrice {
  num quantity;
  num unitPrice;

  FRIngredientPrice({required this.quantity, required this.unitPrice});

  factory FRIngredientPrice.fromMap(Map<String, dynamic> data) {
    return FRIngredientPrice(
      quantity: data['q'] as num,
      unitPrice: data['u'] as num,
    );
  }

  Map<String, dynamic> toMap() {
    return {'q': quantity, 'u': unitPrice};
  }
}

class FRGroup {
  String id;
  String creatorUid;
  String name;
  List<String> currentRecipes;
  List<Map<String, String>> currentIngredients;
  List<String> checkedIngredients;
  Map<String, List<FRIngredientPrice>> ingredientsPrices;
  FRGroupFilter filters;
  String currency;
  double budget;

  FRGroup({
    required this.id,
    required this.creatorUid,
    required this.name,
    required this.currentRecipes,
    required this.currentIngredients,
    required this.checkedIngredients,
    required this.ingredientsPrices,
    required this.filters,
    required this.currency,
    required this.budget,
  });

  factory FRGroup.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
    SnapshotOptions? options,
  ) {
    final data = doc.data()!;
    log(data.toString());
    return FRGroup(
      id: doc.id,
      creatorUid: data['creatorUid'] as String,
      name: data['name'] as String,
      currentRecipes:
          (data['currentRecipes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      currentIngredients:
          (data['currentIngredients'] as List<dynamic>?)
              ?.map((e) => Map<String, String>.from(e as Map))
              .toList() ??
          [],
      checkedIngredients:
          (data['checkedIngredients'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      ingredientsPrices:
          (data['ingredientsPrices'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(
              key,
              (value as List<dynamic>)
                  .map(
                    (e) => FRIngredientPrice.fromMap(
                      Map<String, dynamic>.from(e as Map),
                    ),
                  )
                  .toList(),
            ),
          ) ??
          {},
      filters:
          data['filters'] != null
              ? FRGroupFilter.fromMap(
                Map<String, dynamic>.from(data['filters'] as Map),
              )
              : FRGroupFilter(),
      currency: data['currency'] as String? ?? 'USD',
      budget: (data['budget'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static Map<String, dynamic> toFirestore(FRGroup group, SetOptions? options) {
    return {'creatorUid': group.creatorUid, 'name': group.name};
  }
}
