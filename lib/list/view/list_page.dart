import 'dart:developer';

import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/groups/bloc/groups_bloc.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:felicette_recipes/list/view/widgets/budget_display.dart';
import 'package:felicette_recipes/list/view/widgets/ingredient_modal/view/view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:group_repository/group_repository.dart';
import 'package:intl/intl.dart';
import 'package:recipe_repository/recipe_repository.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  static NavigationDestination navigationDestination(BuildContext context) {
    final s = S.of(context);
    return NavigationDestination(
      icon: const Icon(Icons.list),
      label: s.list(1).capitalize(),
    );
  }

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.list,
      builder: (context, state) => const ListPage(),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      title: Text(s.list(1).capitalize()),
      actions: [
        TextButton(
          onPressed: () {
            context.push(AppRoutes.editList);
          },
          child: Text(s.edit),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return const ListPageContent();
  }
}

class ListPageContent extends StatelessWidget {
  const ListPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final groupsBloc = context.watch<GroupsBloc>();
    final listBloc = context.watch<ListBloc>();
    final currentSelectedGroup = groupsBloc.state.selectedGroup;

    final items = listBloc.state.listItems;

    final listItemsCount = items.length + 2;

    return Scaffold(
      extendBody: true,
      body: ListView.builder(
        padding: .only(
          bottom: BudgetDisplay.safeHeightToAvoidBudgetDisplay(context),
        ),
        itemCount: listItemsCount,
        itemBuilder: (context, index) {
          log(
            'render index $index of $listItemsCount',
            name: 'ListPageContent',
          );
          if (index == 0) {
            return const _ListFilters();
          }

          if (index == listItemsCount - 1) {
            return const _ListQuickActionButtons();
          }

          final item = items[index - 1];

          if (item.type == ListPageListItemTypeEnum.recipe) {
            return _ListRecipeTile(
              key: Key('list_recipe_tile_${item.recipeItem!.recipeId}'),
              item: item.recipeItem!,
              first:
                  index - 1 == 0 ||
                  items[index - 2].type == ListPageListItemTypeEnum.ingredient,
              last:
                  index - 1 == items.length - 1 ||
                  items[index].type == ListPageListItemTypeEnum.ingredient,
            );
          }
          return _ListIngredientTile(
            key: Key(
              // ignore: lines_longer_than_80_chars
              'list_ingredient_tile_${item.ingredientItem!.ingredientId}_${item.recipeItem?.recipeId ?? 'no_recipe'}',
            ),
            item: item.ingredientItem!,
            displayType: listBloc.state.displayType,
            recipe: item.recipeItem?.recipe,
            first:
                index - 1 == 0 ||
                items[index - 2].type == ListPageListItemTypeEnum.recipe,
            last:
                index - 1 == items.length - 1 ||
                items[index].type == ListPageListItemTypeEnum.recipe,
          );
        },
      ),
      bottomNavigationBar: BudgetDisplay(
        used: listBloc.state.currentListSpentBudget.toDouble(),
        total: listBloc.state.currentListBudget.toDouble(),
        currency: currentSelectedGroup?.currency ?? '',
        showBudget: listBloc.state.showBudget,
      ),
    );
  }
}

final List<ListDisplayTypeEnum> typesList = [
  .ingredients,
  .recipes,
];

class _ListRecipeTile extends StatelessWidget {
  const _ListRecipeTile({
    required this.item,
    required this.first,
    required this.last,
    super.key,
  });
  final ListRecipeItem item;
  final bool first;
  final bool last;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return Padding(
      padding: const .symmetric(vertical: 16, horizontal: 8),
      child: ListTile(
        title: Text(
          item.withoutRecipeFlag ? s.other_ingredients : item.recipe.name,
        ),
        contentPadding: const .only(
          left: 4,
          right: 4,
        ),
        leading: Padding(
          padding: const .only(left: 12, right: 4),
          child: Icon(
            item.withoutRecipeFlag ? Icons.kitchen : Icons.book,
          ),
        ),
        visualDensity: .compact,
      ),
    );
  }
}

class _ListIngredientTile extends StatelessWidget {
  const _ListIngredientTile({
    required this.item,
    required this.first,
    required this.last,
    required this.displayType,
    required this.recipe,
    super.key,
  });
  final ListIngredientItem item;
  final bool first;
  final bool last;
  final ListDisplayTypeEnum displayType;
  final FRRecipe? recipe;

  RoundedRectangleBorder getShape() {
    const double biggestRadius = 16;
    const double smallestRadius = 4;
    return RoundedRectangleBorder(
      borderRadius: .only(
        topLeft: .circular(
          first || item.isChecked ? biggestRadius : smallestRadius,
        ),
        topRight: .circular(
          first || item.isChecked ? biggestRadius : smallestRadius,
        ),
        bottomLeft: .circular(
          last || item.isChecked ? biggestRadius : smallestRadius,
        ),
        bottomRight: .circular(
          last || item.isChecked ? biggestRadius : smallestRadius,
        ),
      ),
    );
  }

  Future<void> handleCheckedDialog(BuildContext context) async {
    final prices = await showDialog<List<FRIngredientPrice>>(
      context: context,
      useSafeArea: false,
      builder: (_) => ListIngredientModal(item: item),
    );

    log(
      'Returned prices from modal: $prices',
      name: '_ListIngredientTile',
    );

    if (!context.mounted || prices == null) return;
    context.read<ListBloc>().add(
      UpdateIngredientPrices(
        item.ingredient.id,
        prices,
      ),
    );
  }

  Widget getTrailingWidget(BuildContext context) {
    if (!item.isChecked) {
      return const SizedBox(width: 16);
    }

    if (item.prices.isEmpty) {
      return IconButton(
        visualDensity: .compact,
        onPressed: () => handleCheckedDialog(context),
        icon: const Icon(Icons.edit),
      );
    }

    final currentLocale = context.read<AppBloc>().state.locale;
    final currency =
        context.read<GroupsBloc>().state.selectedGroup?.currency ?? 'USD';

    final currencyFormatter = NumberFormat.simpleCurrency(
      locale: currentLocale.toLanguageTag(),
      name: currency,
    );

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    final totalPrice = item.prices.fold<double>(
      0,
      (previousValue, element) =>
          previousValue + element.unitPrice * element.quantity,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: .circular(8),
            onTap: () => handleCheckedDialog(context),
            child: Container(
              padding: const .symmetric(horizontal: 4),
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.25,
              ),
              child: Column(
                crossAxisAlignment: .end,
                children: [
                  Text(
                    currencyFormatter.format(totalPrice),
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: .bold,
                      color: colorScheme.primary,
                    ),
                  ),

                  RichText(
                    overflow: .ellipsis,
                    maxLines: 2,
                    textAlign: .right,
                    text: TextSpan(
                      style: textTheme.labelSmall?.copyWith(height: 1),
                      children: item.prices.map((price) {
                        return TextSpan(
                          children: [
                            if (item.prices.indexOf(price) > 0)
                              const TextSpan(
                                text: ' ',
                              ),
                            TextSpan(
                              text: price.quantity.toString(),
                              style: TextStyle(
                                color: colorScheme.onSurface,
                              ),
                            ),
                            TextSpan(
                              text: 'x',
                              style: TextStyle(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: .w400,
                              ),
                            ),
                            TextSpan(
                              text: currencyFormatter.format(price.unitPrice),
                              style: TextStyle(
                                fontWeight: .bold,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget getSubtitleWidget(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final parts = <TextSpan>[];

    final otherAssociatedRecipes = item.associatedRecipes
        .where((r) => r.id != recipe?.id)
        .toList();

    if (displayType == ListDisplayTypeEnum.recipes) {
      if (recipe != null) {
        final ingredientInThisRecipe = recipe!.ingredients.firstWhereOrNull(
          (ing) => ing.ingredientId == item.ingredient.id,
        );
        if (ingredientInThisRecipe != null &&
            ingredientInThisRecipe.quantity.isNotEmpty) {
          parts.add(
            TextSpan(
              children: [
                TextSpan(
                  text: ingredientInThisRecipe.quantity,
                  style: const TextStyle(
                    fontWeight: .bold,
                  ),
                ),
                const TextSpan(
                  text: ' - ',
                ),
              ],
            ),
          );
        }
      }
    }

    if (((item.quantity != null && item.quantity!.isNotEmpty) ||
            otherAssociatedRecipes.isNotEmpty) &&
        displayType == ListDisplayTypeEnum.recipes) {
      parts.add(
        TextSpan(
          children: [
            TextSpan(text: s.also.capitalize()),
            const TextSpan(
              text: ': ',
            ),
          ],
        ),
      );
    }

    if (otherAssociatedRecipes.isNotEmpty) {
      otherAssociatedRecipes.asMap().forEach((index, recipe) {
        final thisIngredientInRecipe = recipe.ingredients.firstWhereOrNull(
          (ing) => ing.ingredientId == item.ingredient.id,
        );
        if (thisIngredientInRecipe == null) {
          return;
        }
        parts.add(
          TextSpan(
            children: [
              if (index > 0) const TextSpan(text: ', '),
              if (thisIngredientInRecipe.quantity.isNotEmpty)
                TextSpan(
                  style: const TextStyle(
                    fontWeight: .bold,
                  ),
                  children: [
                    TextSpan(text: thisIngredientInRecipe.quantity),
                    const TextSpan(text: ' '),
                  ],
                ),
              TextSpan(text: s.tfor),
              TextSpan(
                text: recipe.name,
                style: const TextStyle(
                  fontWeight: .bold,
                ),
              ),
            ],
          ),
        );
      });
    }

    if (otherAssociatedRecipes.isNotEmpty &&
        item.quantity != null &&
        item.quantity!.isNotEmpty) {
      parts.add(
        const TextSpan(text: ', '),
      );
    }

    if (item.quantity != null && item.quantity!.isNotEmpty) {
      parts.add(
        TextSpan(
          children: [
            TextSpan(
              text: item.quantity,
            ),
          ],
        ),
      );
    }

    if (parts.isEmpty) {
      parts.add(
        const TextSpan(
          text: '',
        ),
      );
    }

    return RichText(
      text: TextSpan(
        children: parts,
        style: theme.textTheme.bodySmall?.copyWith(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final subtitleWidget = getSubtitleWidget(context);
    return Padding(
      padding: const .symmetric(vertical: 1, horizontal: 8),
      child: ListTile(
        isThreeLine: true,
        title: Text(item.ingredient.name),
        shape: getShape(),
        tileColor: item.isChecked
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surfaceContainer,
        contentPadding: const .only(
          left: 4,
          right: 4,
        ),
        leading: Padding(
          padding: const .only(left: 8),
          child: Checkbox(
            visualDensity: .compact,
            materialTapTargetSize: .shrinkWrap,
            value: item.isChecked,
            onChanged: (checked) async {
              log(
                'Checkbox changed to $checked for ingredient ${item.ingredient.id}',
                name: '_ListIngredientTile',
              );
              context.read<ListBloc>().add(
                ToggleIngredientCheckedStatus(
                  item.ingredient.id,
                ),
              );

              if (checked != true) return;

              await handleCheckedDialog(context);
            },
            activeColor: colorScheme.secondary,
          ),
        ),
        trailing: getTrailingWidget(context),
        visualDensity: .compact,
        subtitle: subtitleWidget,
      ),
    );
  }
}

class _ListFilters extends StatelessWidget {
  const _ListFilters();

  @override
  Widget build(BuildContext context) {
    final listBloc = context.watch<ListBloc>();
    final displayType = listBloc.state.displayType;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = S.of(context);

    return Padding(
      key: const Key('list_filters'),
      padding: const .only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: .center,
            spacing: 2,
            children: [
              ...typesList.map((t) {
                final index = typesList.indexOf(t);

                final isFirst = index == 0;
                final isLast = index == typesList.length - 1;
                final isSelected = displayType == t;

                return FilledButton.icon(
                  key: Key('list_display_type_button_${t.name}'),
                  onPressed: () {
                    listBloc.add(ListDisplayTypeChanged(t));
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: isSelected
                        ? colorScheme.primary
                        : colorScheme.primaryContainer,
                    foregroundColor: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onPrimaryContainer,
                    shape: RoundedRectangleBorder(
                      borderRadius: isSelected
                          ? const .all(.circular(24))
                          : .horizontal(
                              left: isFirst
                                  ? const .circular(24)
                                  : const .circular(8),
                              right: isLast
                                  ? const .circular(24)
                                  : const .circular(8),
                            ),
                    ),
                  ),
                  icon: Icon(
                    isSelected
                        ? Icons.check
                        : (t == ListDisplayTypeEnum.ingredients
                              ? Icons.kitchen
                              : Icons.book),
                  ),
                  label: Text(
                    t == ListDisplayTypeEnum.ingredients
                        ? s.ingredient(0).capitalize()
                        : s.recipe(0).capitalize(),
                  ),
                );
              }),
            ],
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: SingleChildScrollView(
                  scrollDirection: .horizontal,
                  padding: const .symmetric(horizontal: 16),
                  child: Row(
                    mainAxisSize: .min,
                    spacing: 4,
                    children: [
                      if (displayType == .ingredients)
                        ChoiceChip(
                          selected: listBloc.state.showCheckedsFirst,
                          label: Text(s.show_checked_first),
                          onSelected: (selected) {
                            listBloc.add(const ToggleShowCheckedsFirst());
                          },
                        ),
                      ChoiceChip(
                        selected: listBloc.state.showBudget,
                        label: Text(s.show_budget),
                        onSelected: (selected) {
                          listBloc.add(
                            ListShowBudgetChanged(showBudget: selected),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ListQuickActionButtons extends StatelessWidget {
  const _ListQuickActionButtons();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);
    final colorScheme = theme.colorScheme;
    return Padding(
      padding: const .only(top: 8),
      child: Wrap(
        alignment: .center,
        runAlignment: .center,
        spacing: 16,
        children: [
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.primary,
            ),
            key: const Key('add_item_button'),
            icon: const Icon(Icons.add),
            label: Text(s.add_ingredient),
            onPressed: () {
              /*
              Get.dialog(
                Scaffold(
                  body: IngredientSelect(
                    startOpened: true,
                    onModalClosed: () {
                      log('IngredientSelect modal closed', name: 'ListWidget');
                      Get.back();
                    },
                    items: controller.ingredientsService.ingredients,
                    value: [
                      ...controller
                              .groupsService
                              .selectedGroup
                              .value
                              ?.currentIngredients ??
                          [],
                      BasicIngredientQuantity(ingredientId: '', quantity: ''),
                    ],
                    itemLabelBuilder: (item) {
                      return controller.ingredientsService
                              .getIngredientById(item.ingredientId)
                              ?.name ??
                          '';
                    },
                    onChanged: (val) => {
                      log(val.toString(), name: 'IngredientSelect onChanged'),
                    },
                    isMulti: true,
                    label: TranslationKeys.selectIngredients.tr,
                    isRecipe: false,
                  ),
                ),
              ); */
              //   controller.openAddItemModal();
            },
          ),
          TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            key: const Key('clear_all_checks_button'),
            icon: const Icon(Icons.clear_all),
            label: Text(s.clear_all_checks),
            onPressed: () async {
              final confirm =
                  await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(s.clear_all_checks),
                      content: Text(
                        s.clear_all_checks_confirmation,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(s.cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text(s.confirm),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (!confirm) return;
              if (!context.mounted) return;
              context.read<ListBloc>().add(const ClearAllChecked());
            },
          ),
        ],
      ),
    );
  }
}
