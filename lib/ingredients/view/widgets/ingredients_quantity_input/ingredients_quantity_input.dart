import 'dart:developer';

import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/ingredients/view/widgets/ingredients_quantity_input/models/models.dart';
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
    this.errorMessage,
    this.createIngredient,
    super.key,
  });
  final String? errorMessage;
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
          onChanged: onChanged,
          generateEmpty: generateEmpty,
          initialState: IngredientQuantityInputState<T>(
            items: initialValue,
          ),
        );
      },
      child: _IngredientsQuantityInputContent<T>(
        errorMessage: errorMessage,
      ),
    );
  }
}

class _IngredientsQuantityInputContent<T extends BasicIngredientQuantity>
    extends StatelessWidget {
  const _IngredientsQuantityInputContent({this.errorMessage});

  final String? errorMessage;
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<IngredientsQuantityInputCubit<T>>();

    final items = cubit.state.items;
    final theme = Theme.of(context);
    final s = S.of(context);

    final atLeastOneIngredientIsEmpty = items.any(
      (iq) => iq.ingredientId.isEmpty,
    );

    return Column(
      spacing: 16,
      children: [
        ...items.map(
          (iq) => _ItemWidget(
            key: ValueKey(
              'ingredient_quantity_input_item_${iq.uuid}',
            ),
            item: iq,
          ),
        ),
        if (errorMessage != null)
          Align(
            alignment: .centerLeft,
            child: Text(
              errorMessage!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
        TextButton.icon(
          icon: const Icon(Icons.add),
          style: TextButton.styleFrom(
            backgroundColor: theme.customColors.onSuccess,
            foregroundColor: theme.customColors.success,
          ),
          onPressed: atLeastOneIngredientIsEmpty
              ? null
              : () {
                  final newValue = [
                    ...items,
                    cubit.generateEmpty(),
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
    log(
      'Building IngredientQuantityInputItemWidget... ${item.uuid} -> quantity: ${item.quantity}, ingredientId: ${item.ingredientId}',
      name: '_ItemWidget',
    );
    return BlocProvider(
      create: (context) {
        return IngredientQuantityInputItemCubit<T>(
          initialState: IngredientQuantityInputItemState<T>(
            item: item,
            ingredientQuantity: item.quantity.isEmpty
                ? const .pure()
                : .dirty(item.quantity),
            ingredient: item.ingredientId.isEmpty
                ? const .pure()
                : .dirty(item.ingredientId),
          ),
        );
      },
      child:
          BlocListener<
            IngredientQuantityInputItemCubit<T>,
            IngredientQuantityInputItemState<T>
          >(
            listener: (itemCubit, state) {
              log(
                'Item widget listener called...',
                name: '_ItemWidget.listener',
              );

              final inputCubit = context
                  .read<IngredientsQuantityInputCubit<T>>();

              final newItem = item.copyWith(
                quantity: state.ingredientQuantity.value,
                ingredientId: state.ingredient.value,
              );
              log(
                'Notifying input cubit of item change... ${newItem.uuid} -> quantity: ${newItem.quantity}, ingredientId: ${newItem.ingredientId}',
                name: '_ItemWidget.listener',
              );
              inputCubit.itemChanged(
                inputCubit.state.items.indexOf(item),
                newItem as T,
              );
            },
            child: _ItemWidgetContent<T>(),
          ),
    );
  }
}

class _ItemWidgetContent<T extends BasicIngredientQuantity>
    extends StatelessWidget {
  const _ItemWidgetContent({super.key});

  String? getErrorMessage(
    IngredientQuantityInputIngredient fieldState,
    S s,
  ) {
    if (fieldState.displayError != null) {
      switch (fieldState.displayError!) {
        case IngredientQuantityInputIngredientError.empty:
          return s.input_required_error;
      }
    }
    return null;
  }

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
              itemCubit.ingredientQuantityChanged(
                newValue,
              );
            },
          ),
        ),
        Expanded(
          child: IngredientSelect(
            initialValue: item.ingredientId.isEmpty ? [] : [item.ingredientId],
            placeholder: s.ingredient(0).capitalize(),
            label: s.ingredient(1).capitalize(),
            key: ValueKey('ingredient_select_${item.uuid}'),
            allowCreation: true,
            createIngredient: inputCubit.createIngredient,
            errorMessage: getErrorMessage(itemCubit.state.ingredient, s),
            onOpened: () {
              log(
                'IngredientSelect opened for item ${item.uuid}',
                name: '_ItemWidgetContent',
              );
              itemCubit.ingredientTouched();
            },
            onChanged: (newValue) {
              log(
                'Ingredient changed to $newValue',
                name: '_ItemWidgetContent',
              );

              log(
                'Notifying item cubit of ingredient change $newValue',
                name: '_ItemWidgetContent',
              );
              itemCubit.ingredientChanged(
                newValue.isEmpty ? '' : newValue.first,
              );
            },
          ),
        ),
        Align(
          alignment: .centerRight,
          child: IconButton(
            style: IconButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: () {
              final newItems = inputCubit.state.items
                  .where((i) => i.uuid != item.uuid)
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
