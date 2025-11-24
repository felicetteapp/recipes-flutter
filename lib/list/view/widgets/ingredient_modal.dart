import 'package:felicette_recipes/list/list.dart';
import 'package:flutter/material.dart';

class ListIngredientModal extends StatelessWidget {
  const ListIngredientModal({
    required this.item,
    super.key,
  });
  final ListIngredientItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(item.ingredient.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quantity: ${item.quantity ?? 'N/A'}',
              style: theme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            Text(
              'Associated Recipes:',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...item.associatedRecipes.map(
              (recipe) => Text(
                '- ${recipe.name}',
                style: theme.textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Prices:',
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}
