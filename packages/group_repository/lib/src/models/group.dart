import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_repository/recipe_repository.dart';
import 'package:uuid/uuid.dart';

class FRGroupFilter {
  FRGroupFilter({this.showCheckedsFirst = false, this.showBudget = false});

  factory FRGroupFilter.fromMap(Map<String, dynamic> data) {
    return FRGroupFilter(
      showCheckedsFirst: data['showCheckedsFirst'] as bool? ?? false,
      showBudget: data['showBudget'] as bool? ?? false,
    );
  }
  bool showCheckedsFirst;
  bool showBudget;

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
  FRIngredientPrice({
    required this.quantity,
    required this.unitPrice,
    required this.uuid,
  });

  factory FRIngredientPrice.fromMap(Map<String, dynamic> data) {
    final mapUuid = data['uuid'] as String?;
    final uuid = const Uuid().v4();
    return FRIngredientPrice(
      quantity: data['q'] as num,
      unitPrice: data['u'] as num,
      uuid: mapUuid ?? uuid,
    );
  }
  num quantity;
  num unitPrice;
  String uuid;

  Map<String, dynamic> toMap() {
    return {'q': quantity, 'u': unitPrice, 'uuid': uuid};
  }

  FRIngredientPrice copyWith({num? quantity, num? unitPrice}) {
    return FRIngredientPrice(
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      uuid: uuid,
    );
  }

  @override
  String toString() {
    return 'FRIngredientPrice(quantity: $quantity, unitPrice: $unitPrice, uuid: $uuid)';
  }
}

class FRCurrentIngredients extends BasicIngredientQuantity {
  FRCurrentIngredients({
    required super.ingredientId,
    required super.quantity,
    required super.uuid,
  });

  factory FRCurrentIngredients.fromMap(Map<String, dynamic> data) {
    final mapUuid = data['uuid'] as String?;
    final uuid = const Uuid().v4();
    return FRCurrentIngredients(
      ingredientId: data['i'] as String,
      quantity: data['q'] as String,
      uuid: mapUuid ?? uuid,
    );
  }

  @override
  BasicIngredientQuantity copyWith({
    String? ingredientId,
    String? quantity,
    String? uuid,
  }) {
    return FRCurrentIngredients(
      ingredientId: ingredientId ?? this.ingredientId,
      quantity: quantity ?? this.quantity,
      uuid: uuid ?? this.uuid,
    );
  }

  Map<String, dynamic> toMap() {
    return {'i': ingredientId, 'q': quantity, 'uuid': uuid};
  }
}

class FRGroup {
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
    SnapshotOptions? _,
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
      filters: data['filters'] != null
          ? FRGroupFilter.fromMap(
              Map<String, dynamic>.from(data['filters'] as Map),
            )
          : FRGroupFilter(),
      currency: data['currency'] as String? ?? 'USD',
      budget: (data['budget'] as num?)?.toDouble() ?? 0.0,
    );
  }
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

  static Map<String, dynamic> toFirestore(FRGroup group, SetOptions? options) {
    return {
      'creatorUid': group.creatorUid,
      'name': group.name,
      'currentRecipes': group.currentRecipes,
      'currentIngredients': group.currentIngredients
          .map((e) => e.toMap())
          .toList(),
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
