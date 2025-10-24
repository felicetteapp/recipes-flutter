import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/modules/home/widgets/list/list_controller.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ListController());
    return Obx(key: Key('list_obx'), () {
      var itemCount = 0;
      final staticItemsAtTop = 1;
      final ingredients = controller.sortedIngredientList;
      final recipes = controller.sortedRecipeList;
      if (controller.displayType.value == ListDisplayTypeEnum.ingredients) {
        itemCount = staticItemsAtTop + ingredients.length;
      } else {
        final totalIngredients = recipes.fold<int>(
          0,
          (sum, recipeItem) => sum + recipeItem.recipe.ingredients.length,
        );
        itemCount = staticItemsAtTop + recipes.length + totalIngredients;
      }

      return ListView.builder(
        key: const Key('list_view'),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildFilters(controller);
          }

          if (controller.displayType.value == ListDisplayTypeEnum.ingredients) {
            final item = ingredients[index - staticItemsAtTop];
            return _buildIngredientListTile(item);
          }

          final adjustedIndex = index - staticItemsAtTop;

          var currentIndex = 0;
          for (final recipeItem in recipes) {
            if (adjustedIndex == currentIndex) {
              return _buildRecipeTitle(recipeItem, controller);
            }
            currentIndex++;

            for (final ingredient in recipeItem.ingredients) {
              if (adjustedIndex == currentIndex) {
                final recipeIngredient = recipeItem.recipe.ingredients
                    .firstWhere((ri) => ri.ingredientId == ingredient.id);
                return _buildRecipeIngredientItem(
                  ingredient,
                  recipeIngredient,
                  recipeItem,
                  controller,
                );
              }
              currentIndex++;
            }
          }

          return const SizedBox.shrink();
        },
      );
    });
  }

  CheckboxListTile _buildIngredientListTile(ListIngredientItem item) {
    return CheckboxListTile(
      visualDensity: VisualDensity.compact,
      key: Key(item.ingredient.id),
      controlAffinity: ListTileControlAffinity.leading,
      value: item.isChecked,
      onChanged: (value) {
        // Handle checkbox state change
      },
      title: Text(item.ingredient.name),
      secondary: Text(
        item.price.isNotEmpty
            ? item.price
                .map(
                  (p) => '${p.quantity} x \$${p.unitPrice.toStringAsFixed(2)}',
                )
                .join(', ')
            : 'No price available',
      ),
      subtitle: _buildIngredientItemSubtitle(item.ingredient, item.recipes),
    );
  }

  RichText _buildIngredientItemSubtitleText(
    FRIngredient ingredient,
    FRRecipe recipe, {
    bool isMainRecipe = false,
  }) {
    final quantityOfThisIngriedient =
        recipe.ingredients
            .firstWhere((ri) => ri.ingredientId == ingredient.id)
            .quantity;

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 12,
          color:
              isMainRecipe
                  ? Get.context?.theme.colorScheme.secondary
                  : Get.context?.theme.colorScheme.onSurfaceVariant,
          height: 1,
        ),
        children: [
          ...[
            if (quantityOfThisIngriedient.isNotEmpty)
              TextSpan(
                text:
                    isMainRecipe
                        ? quantityOfThisIngriedient
                        : '$quantityOfThisIngriedient ',
                style: TextStyle(
                  fontWeight: isMainRecipe ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            if (!isMainRecipe)
              TextSpan(
                text: 'for ',
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
          ],
          if (!isMainRecipe)
            TextSpan(
              text: recipe.name,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
        ],
      ),
    );
  }

  Wrap _buildIngredientItemSubtitle(
    FRIngredient ingredient,
    List<FRRecipe> recipes, {
    FRRecipe? mainRecipe,
  }) {
    final localRecipes = [...recipes];

    if (mainRecipe != null) {
      localRecipes.removeWhere((r) => r.id == mainRecipe.id);

      if (mainRecipe.ingredients
          .where((ri) => ri.ingredientId == ingredient.id)
          .first
          .quantity
          .isNotEmpty) {
        localRecipes.insert(0, mainRecipe);
      }
    }

    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        ...localRecipes.map((recipe) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(
                color:
                    Get.context?.theme.colorScheme.outlineVariant ??
                    Colors.grey,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: _buildIngredientItemSubtitleText(
              ingredient,
              recipe,
              isMainRecipe: recipe.id == mainRecipe?.id,
            ),
          );
        }),
      ],
    );
  }

  Padding _buildFilters(ListController controller) {
    return Padding(
      key: const Key('list_filters'),
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        children: [
          SegmentedButton<ListDisplayTypeEnum>(
            key: const Key('list_display_type_segmented_button'),
            segments: const [
              ButtonSegment<ListDisplayTypeEnum>(
                value: ListDisplayTypeEnum.ingredients,
                label: Text('Ingredients'),
              ),
              ButtonSegment<ListDisplayTypeEnum>(
                value: ListDisplayTypeEnum.recipes,
                label: Text('Recipes'),
              ),
            ],
            selected: {controller.displayType.value},
            onSelectionChanged: (newSelection) {
              if (newSelection.isNotEmpty) {
                controller.setDisplayType(newSelection.first);
              }
            },
          ),

          Visibility(
            visible:
                controller.displayType.value == ListDisplayTypeEnum.ingredients,
            child: ChoiceChip(
              label: const Text('Show checked first'),
              selected: controller.showCheckedFirst,
              onSelected: (selected) {
                controller.setShowCheckedFirst(selected);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeTitle(
    ListRecipeItem recipeItem,
    ListController controller,
  ) {
    return ListTile(
      textColor: Get.theme.colorScheme.primaryFixedDim,
      key: Key('recipe_title_${recipeItem.recipe.id}'),
      title: Text(recipeItem.recipe.name),
    );
  }

  Widget _buildRecipeIngredientItem(
    FRIngredient ingredient,
    FRRecipeIngredient recipeIngredient,
    ListRecipeItem recipeItem,
    ListController controller,
  ) {
    final group = controller.groupsService.selectedGroup.value;
    final isChecked =
        group?.checkedIngredients.contains(ingredient.id) ?? false;
    final prices = group?.ingredientsPrices[ingredient.id] ?? [];

    final recipes = controller.recipesService.getRecipesByIngredientId(
      ingredient.id,
      controller.recipesService.getCurrentGroupRecipes(),
    );

    return CheckboxListTile(
      visualDensity: VisualDensity.compact,
      key: Key('ingredient_${ingredient.id}_in_recipe_${recipeItem.recipe.id}'),
      controlAffinity: ListTileControlAffinity.leading,
      value: isChecked,
      onChanged: (value) {
        // Handle checkbox state change
      },
      title: Text(ingredient.name),
      secondary: Text(
        prices.isNotEmpty
            ? prices
                .map(
                  (p) => '${p.quantity} x \$${p.unitPrice.toStringAsFixed(2)}',
                )
                .join(', ')
            : 'No price available',
      ),
      subtitle: _buildIngredientItemSubtitle(
        ingredient,
        recipes,
        mainRecipe: recipeItem.recipe,
      ),
    );
  }
}
