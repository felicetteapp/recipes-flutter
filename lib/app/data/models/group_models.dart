import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:felicette_recipes/app/data/models/recipe_models.dart';

class FRGroupFilter {
  bool showCheckedsFirst;
  bool showBudget;

  FRGroupFilter({this.showCheckedsFirst = false, this.showBudget = false});

  factory FRGroupFilter.fromMap(Map<String, dynamic> data) {
    return FRGroupFilter(
      showCheckedsFirst: data['showCheckedsFirst'] as bool? ?? false,
      showBudget: data['showBudget'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {'showCheckedsFirst': showCheckedsFirst, 'showBudget': showBudget};
  }

  FRGroupFilter copyWith({bool? showCheckedsFirst, bool? showBudget}) {
    return FRGroupFilter(
      showCheckedsFirst: showCheckedsFirst ?? this.showCheckedsFirst,
      showBudget: showBudget ?? this.showBudget,
    );
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

  FRIngredientPrice copyWith({num? quantity, num? unitPrice}) {
    return FRIngredientPrice(
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }
}

class FRCurrentIngredients extends BasicIngredientQuantity {
  FRCurrentIngredients({required super.ingredientId, required super.quantity});

  factory FRCurrentIngredients.fromMap(Map<String, dynamic> data) {
    return FRCurrentIngredients(
      ingredientId: data['i'] as String,
      quantity: data['q'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {'i': ingredientId, 'q': quantity};
  }
}

class FRGroup {
  String id;
  String creatorUid;
  String name;
  List<String> currentRecipes;
  List<FRCurrentIngredients> currentIngredients;
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
              ?.map(
                (e) => FRCurrentIngredients.fromMap(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
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
    return {
      'creatorUid': group.creatorUid,
      'name': group.name,
      'currentRecipes': group.currentRecipes,
      'currentIngredients':
          group.currentIngredients.map((e) => e.toMap()).toList(),
      'checkedIngredients': group.checkedIngredients,
      'ingredientsPrices': group.ingredientsPrices.map(
        (key, value) =>
            MapEntry(key, value.map((price) => price.toMap()).toList()),
      ),
      'filters': group.filters.toMap(),
      'currency': group.currency,
      'budget': group.budget,
    };
  }

  FRGroup copyWith({
    String? id,
    String? creatorUid,
    String? name,
    List<String>? currentRecipes,
    List<FRCurrentIngredients>? currentIngredients,
    List<String>? checkedIngredients,
    Map<String, List<FRIngredientPrice>>? ingredientsPrices,
    FRGroupFilter? filters,
    String? currency,
    double? budget,
  }) {
    return FRGroup(
      id: id ?? this.id,
      creatorUid: creatorUid ?? this.creatorUid,
      name: name ?? this.name,
      currentRecipes: currentRecipes ?? this.currentRecipes,
      currentIngredients: currentIngredients ?? this.currentIngredients,
      checkedIngredients: checkedIngredients ?? this.checkedIngredients,
      ingredientsPrices: ingredientsPrices ?? this.ingredientsPrices,
      filters: filters ?? this.filters,
      currency: currency ?? this.currency,
      budget: budget ?? this.budget,
    );
  }
}
