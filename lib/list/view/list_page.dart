import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/groups/bloc/groups_bloc.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:felicette_recipes/list/view/widgets/budget_display.dart';
import 'package:felicette_recipes/list/view/widgets/ingredient_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    final ingredientsBloc = context.watch<IngredientsBloc>();
    final currentSelectedGroup = groupsBloc.state.selectedGroup;

    final currentIngredients = context
        .watch<ListBloc>()
        .state
        .currentIngredients;

    log(
      'Current ingredients in ListPageContent: $currentIngredients',
      name: 'ListPageContent',
    );

    final listItemsCount = currentIngredients.length + 2;

    return Scaffold(
      extendBody: true,
      body: ListView.builder(
        padding: .only(
          bottom: BudgetDisplay.safeHeightToAvoidBudgetDisplay(context),
        ),
        itemCount: listItemsCount,
        itemBuilder: (context, index) {
          if (index == 0) {
            return const _ListFilters();
          }

          if (index == listItemsCount - 1) {
            return const _ListQuickActionButtons();
          }

          return _ListIngredientTile(
            item: currentIngredients[index - 1],
            first: index - 1 == 0,
            last: index - 1 == listItemsCount - 3,
          );
        },
      ),
      bottomNavigationBar: BudgetDisplay(
        used: 0,
        total: 0,
        currency: currentSelectedGroup?.currency ?? '',
        showBudget: currentSelectedGroup?.filters.showBudget ?? false,
      ),
    );
  }
}

final List<ListDisplayTypeEnum> typesList = [
  .ingredients,
  .recipes,
];

class _ListIngredientTile extends StatelessWidget {
  const _ListIngredientTile({
    required this.item,
    required this.first,
    required this.last,
  });
  final ListIngredientItem item;
  final bool first;
  final bool last;

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

  Widget? getTrailingWidget() {
    if (!item.isChecked) {
      return null;
    }

    if (item.prices.isEmpty) {
      return IconButton(
        visualDensity: .compact,
        onPressed: () {},
        icon: const Icon(Icons.edit),
      );
    }

    return const Text('preco'); // TODO: implement price display
  }

  Widget? getSubtitleWidget(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final parts = <TextSpan>[];
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
    if (item.associatedRecipes.isNotEmpty) {
      item.associatedRecipes.asMap().forEach((index, recipe) {
        final thisIngredientInRecipe = recipe.ingredients.firstWhereOrNull(
          (ing) => ing.ingredientId == item.ingredient.id,
        );
        if (thisIngredientInRecipe == null) {
          return;
        }
        parts.add(
          TextSpan(
            children: [
              if (parts.isNotEmpty) const TextSpan(text: ', '),
              if (thisIngredientInRecipe.quantity.isNotEmpty)
                TextSpan(
                  text: '${thisIngredientInRecipe.quantity} ',
                  style: const TextStyle(
                    fontWeight: .bold,
                  ),
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

    if (parts.isEmpty) {
      return null;
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
        isThreeLine: subtitleWidget != null,
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
              if (checked != true) return;
              await showDialog<void>(
                context: context,
                useSafeArea: false,
                builder: (_) => ListIngredientModal(item: item),
              );
              //recipesBloc.add(RecipesToggleRecipeSelection(id));
            },
            activeColor: colorScheme.secondary,
          ),
        ),
        trailing: getTrailingWidget(),
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
    final groupsBloc = context.watch<GroupsBloc>();
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
                          selected:
                              groupsBloc
                                  .state
                                  .selectedGroup
                                  ?.filters
                                  .showCheckedsFirst ??
                              false,
                          label: Text(s.show_checked_first),
                          onSelected: (selected) {
                            //                          controller.setShowCheckedFirst(selected);
                          },
                        ),
                      ChoiceChip(
                        selected:
                            groupsBloc
                                .state
                                .selectedGroup
                                ?.filters
                                .showBudget ??
                            false,
                        label: Text(s.show_budget),
                        onSelected: (selected) {
                          /*     final currentFilters =
                              controller
                                  .groupsService
                                  .selectedGroup
                                  .value
                                  ?.filters ??
                              FRGroupFilter();
                          controller.groupsService.updateCurrentGroupFilters(
                            FRGroupFilter(
                              showCheckedsFirst:
                                  currentFilters.showCheckedsFirst,
                              showBudget: selected,
                            ),
                          ); */
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
    return Wrap(
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
          onPressed: () {
            //            controller.clearAllChecks();
          },
        ),
      ],
    );
  }
}
