import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:recipes_flutter/app/data/models/group_models.dart';
import 'package:recipes_flutter/app/data/models/ingredient_models.dart';
import 'package:recipes_flutter/app/data/models/recipe_models.dart';
import 'package:recipes_flutter/app/modules/home/widgets/list/list_controller.dart';
import 'package:recipes_flutter/app/services/localization_service.dart';

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
    final groupService = Get.find<ListController>().groupsService;
    final currency = groupService.selectedGroup.value?.currency ?? 'USD';

    return CheckboxListTile(
      visualDensity: VisualDensity.compact,
      key: Key(item.ingredient.id),
      controlAffinity: ListTileControlAffinity.leading,
      value: item.isChecked,
      onChanged: (value) {
        // Handle checkbox state change
      },
      title: Text(item.ingredient.name),
      secondary: _buildIngredientItemSecondary(
        item.price,
        currency,
        item.isChecked,
      ),
      subtitle: _buildIngredientItemSubtitle(
        item.ingredient,
        item.recipes,
        quantity: item.quantity,
      ),
    );
  }

  RichText _buildIngredientItemSubtitleText(
    FRIngredient ingredient,
    FRRecipe? recipe, {
    bool isMainRecipe = false,
    String? quantity,
  }) {
    if (recipe == null && (quantity == null || quantity.isEmpty)) {
      return RichText(text: TextSpan());
    }

    if (recipe == null) {
      return RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 12,
            color: Get.context?.theme.colorScheme.onSurfaceVariant,
            height: 1,
          ),
          children: [
            TextSpan(
              text: quantity,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
      );
    }

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
    String? quantity,
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
        if (quantity != null && quantity.isNotEmpty)
          Container(
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
              null,
              quantity: quantity,
            ),
          ),
      ],
    );
  }

  Padding _buildFilters(ListController controller) {
    return Padding(
      key: const Key('list_filters'),
      padding: const EdgeInsets.only(bottom: 16),
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        children: [
          SegmentedButton<ListDisplayTypeEnum>(
            key: const Key('list_display_type_segmented_button'),
            segments: const [
              ButtonSegment<ListDisplayTypeEnum>(
                icon: Icon(Icons.kitchen),
                value: ListDisplayTypeEnum.ingredients,
                label: Text('Ingredients'),
                tooltip: 'Show list by ingredients',
              ),
              ButtonSegment<ListDisplayTypeEnum>(
                icon: Icon(Icons.book),
                value: ListDisplayTypeEnum.recipes,
                label: Text('Recipes'),
                tooltip: 'Show list by recipes',
              ),
            ],
            selected: {controller.displayType.value},
            onSelectionChanged: (newSelection) {
              if (newSelection.isNotEmpty) {
                controller.setDisplayType(newSelection.first);
              }
            },
          ),
          if (controller.displayType.value == ListDisplayTypeEnum.ingredients)
            ChoiceChip(
              label: const Text('Show checked first'),
              selected: controller.showCheckedFirst,
              onSelected: (selected) {
                controller.setShowCheckedFirst(selected);
              },
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
      secondary: _buildIngredientItemSecondary(
        prices,
        group?.currency ?? 'USD',
        isChecked,
      ),
      subtitle: _buildIngredientItemSubtitle(
        ingredient,
        recipes,
        mainRecipe: recipeItem.recipe,
      ),
    );
  }

  Widget? _buildIngredientItemSecondary(
    List<FRIngredientPrice> prices,
    String currency,
    bool isChecked,
  ) {
    final ls = Get.find<LocalizationService>();

    if (prices.isEmpty && !isChecked) {
      return null;
    } else if (prices.isEmpty && isChecked) {
      return IconButton(
        onPressed: () {},
        icon: Icon(Icons.edit),
        color: Get.context?.theme.colorScheme.secondary,
      );
    }

    final priceTotal = prices.fold<double>(
      0.0,
      (sum, price) => sum + (price.unitPrice * price.quantity),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          ls.formatCurrency(priceTotal, currency),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Get.context?.theme.colorScheme.error,
            fontSize: 14,
          ),
        ),
        Wrap(
          spacing: 4,
          children:
              prices.map((p) {
                return RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 10,
                      color: Get.context?.theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(
                        text: p.quantity.toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: ' x ',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: ls.formatCurrency(
                          p.unitPrice.toDouble(),
                          currency,
                        ),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Get.context?.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }
}
