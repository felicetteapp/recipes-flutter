import 'dart:developer';

import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:recipe_repository/recipe_repository.dart';

class IngredientsQuantityInput<T extends BasicIngredientQuantity>
    extends StatelessWidget {
  const IngredientsQuantityInput({
    required this.initialValue,
    required this.onChanged,
    required this.generateEmpty,
    this.createIngredient,
    super.key,
  });
  final List<T> initialValue;
  final T Function() generateEmpty;
  final ValueChanged<List<T>> onChanged;
  final Future<FRIngredient> Function({required String name})? createIngredient;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) {
        return IngredientsQuantityInputCubit<T>(
          createIngredient: createIngredient,
          initialState: IngredientQuantityInputState<T>(
            items: initialValue,
            generateEmpty: generateEmpty,
            onChanged: onChanged,
          ),
        );
      },
      child: _IngredientsQuantityInputContent<T>(),
    );
  }
}

class _IngredientsQuantityInputContent<T extends BasicIngredientQuantity>
    extends StatelessWidget {
  const _IngredientsQuantityInputContent();
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<IngredientsQuantityInputCubit<T>>();

    final items = cubit.state.items;
    final theme = Theme.of(context);
    final s = S.of(context);

    return Column(
      spacing: 16,
      children: [
        ...items.map(
          (iq) => _ItemWidget(
            key: ValueKey('ingredient_quantity_input_item_${iq.hashCode}'),
            item: iq,
          ),
        ),
        TextButton.icon(
          icon: const Icon(Icons.add),
          style: TextButton.styleFrom(
            backgroundColor: theme.customColors.onSuccess,
            foregroundColor: theme.customColors.success,
          ),
          onPressed: () {
            final newValue = [
              ...items,
              cubit.state.generateEmpty(),
            ];
            cubit.itemsChanged(newValue);
          },
          label: Text(s.add_ingredient),
        ),
      ],
    );
  }
}

class _ItemWidget<T extends BasicIngredientQuantity> extends StatelessWidget {
  const _ItemWidget({required this.item, super.key});
  final T item;
  @override
  Widget build(BuildContext context) {
    log('Building IngredientQuantityInputItemWidget...', name: '_ItemWidget');
    return BlocProvider(
      create: (context) {
        return IngredientQuantityInputItemCubit<T>(
          initialState: IngredientQuantityInputItemState<T>(
            item: item,
            ingredientQuantity: IngredientQuantity.dirty(item.quantity),
          ),
        );
      },
      child: _ItemWidgetContent<T>(),
    );
  }
}

class _ItemWidgetContent<T extends BasicIngredientQuantity>
    extends StatelessWidget {
  const _ItemWidgetContent({super.key});
  @override
  Widget build(BuildContext context) {
    final itemCubit = context.watch<IngredientQuantityInputItemCubit<T>>();
    final inputCubit = context.watch<IngredientsQuantityInputCubit<T>>();
    final item = itemCubit.state.item;
    final theme = Theme.of(context);
    final s = S.of(context);
    return Row(
      spacing: 8,
      crossAxisAlignment: .start,
      children: [
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(
              labelText: s.quantity.capitalize(),
            ),
            initialValue: item.quantity,
            onChanged: (newValue) {
              log(
                'Quantity changed to $newValue',
                name: '_ItemWidgetContent',
              );
            },
          ),
        ),
        Expanded(
          child: IngredientSelect(
            placeholder: s.ingredient(0).capitalize(),
            label: s.ingredient(1).capitalize(),
            key: ValueKey('ingredient_select_${item.hashCode}'),
            allowCreation: true,
            createIngredient: inputCubit.createIngredient,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () {
              final newItems = inputCubit.state.items
                  .where((i) => i != item)
                  .toList();
              inputCubit.itemsChanged(newItems);
            },
            icon: const Icon(Icons.delete),
          ),
        ),
      ],
    );
  }
}
