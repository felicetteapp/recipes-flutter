import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/view/widgets/ingredients_quantity_input/bloc/input_cubit.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_repository/recipe_repository.dart';

class IngredientsQuantityInput<T extends BasicIngredientQuantity>
    extends StatelessWidget {
  const IngredientsQuantityInput({
    required this.initialValue,
    required this.onChanged,
    required this.generateEmpty,
    super.key,
  });
  final List<T> initialValue;
  final T Function() generateEmpty;
  final ValueChanged<List<T>> onChanged;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) {
        return IngredientsQuantityInputCubit<T>(
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

    return Container(
      child: Column(
        children: [
          Text('Ingredients Quantity Input'),

          // Here you would implement the actual input logic
          ...items.map(
            (iq) => Text('${iq.ingredientId}: ${iq.quantity}'),
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
              ]; // Add logic to get new values

              cubit.itemsChanged(newValue);
            },
            label: Text(s.add_ingredient),
          ),
        ],
      ),
    );
  }
}
