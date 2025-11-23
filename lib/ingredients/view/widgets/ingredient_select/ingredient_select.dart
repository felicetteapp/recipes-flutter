import 'dart:developer';

import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

class IngredientSelect extends StatelessWidget {
  const IngredientSelect({
    required this.placeholder,
    required this.label,
    super.key,
    this.allowCreation = false,
    this.createIngredient,
  });

  final String placeholder;
  final String label;
  final bool allowCreation;
  final Future<FRIngredient> Function({required String name})? createIngredient;

  @override
  Widget build(BuildContext context) {
    final ingredients = context.select(
      (IngredientsBloc bloc) => bloc.state.ingredients,
    );

    return BlocProvider(
      create: (context) {
        return IngredientSelectCubit(
          allowCreation: allowCreation,
          createIngredient: createIngredient,
        )..initIngredients(ingredients);
      },
      child: BlocListener<IngredientsBloc, IngredientsState>(
        listener: (context, state) {
          context.read<IngredientSelectCubit>().initIngredients(
            state.ingredients,
          );
        },
        child: _IngredientSelectContent(
          placeholder: placeholder,
          label: label,
        ),
      ),
    );
  }
}

class _IngredientSelectContent extends StatelessWidget {
  const _IngredientSelectContent({
    required this.placeholder,
    required this.label,
  });

  final String placeholder;
  final String label;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<IngredientSelectCubit>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final inputDecorationTheme = theme.inputDecorationTheme;
    final contentPadding = inputDecorationTheme.contentPadding;
    final border = inputDecorationTheme.border!;
    final labelShouldFloat = cubit.state.selectedIngredientId != null;

    return LayoutBuilder(
      builder: (context, constraints) {
        const decorationRadius = 8.0;
        const topOffset = 4.0;

        log(
          'labelDecoration build with fillColor: ${inputDecorationTheme.labelStyle}',
        );

        final floatingLabelHorizontalPadding = labelShouldFloat
            ? 4.0
            : contentPadding!.horizontal / 2 + 4.0;

        final labelPositionedTop = labelShouldFloat
            ? -1 * topOffset
            : border.borderSide.width;
        final labelPositionedLeft = labelShouldFloat
            ? contentPadding!.horizontal / 2
            : border.borderSide.width;
        final labelPositionedBottom = labelShouldFloat
            ? null
            : border.borderSide.width;
        final labelPositionedRight = labelShouldFloat
            ? null
            : border.borderSide.width;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: constraints.maxWidth,
              padding: contentPadding,
              height: 48,
              decoration: BoxDecoration(
                color: inputDecorationTheme.fillColor,
                borderRadius: .circular(decorationRadius),
                border: Border.fromBorderSide(
                  border.borderSide,
                ),
              ),
              child: Padding(
                padding: .only(left: floatingLabelHorizontalPadding),
                child: Text(
                  maxLines: 1,
                  overflow: .ellipsis,
                  cubit.selectedIngredient?.name ?? '',
                  style: textTheme.bodyLarge,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: labelPositionedLeft,
              right: labelPositionedRight,
              top: labelPositionedTop,
              bottom: labelPositionedBottom,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: .only(
                  left: floatingLabelHorizontalPadding,
                  bottom: labelShouldFloat ? 4 : 0,
                  right: floatingLabelHorizontalPadding,
                ),
                color: labelShouldFloat ? theme.scaffoldBackgroundColor : null,
                child: Align(
                  alignment: .centerLeft,
                  child: Text(
                    labelShouldFloat ? label : placeholder,
                    style: labelShouldFloat
                        ? textTheme.labelSmall?.copyWith(
                            height: 1,
                            color: colorScheme.onSurfaceVariant,
                          )
                        : textTheme.bodyLarge?.copyWith(
                            height: 1,
                            color: colorScheme.onSurfaceVariant,
                          ),
                  ),
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: .circular(decorationRadius),
                onTap: () async {
                  log('Tapped IngredientSelect', name: 'IngredientSelect');
                  // Open ingredient selection logic here
                  await showDialog<void>(
                    useSafeArea: false,
                    context: context,
                    builder: (_) {
                      return BlocProvider.value(
                        value: cubit,
                        child: const _IngredientSelectModal(),
                      );
                    },
                  );
                  cubit.filterChange('');
                },
                child: Container(
                  width: constraints.maxWidth,
                  height: 48,
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _IngredientSelectModal extends StatelessWidget {
  const _IngredientSelectModal();

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<IngredientSelectCubit>();
    final currentFilteredIngredients = cubit.state.filteredIngredients;
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final shouldShowCreateOption =
        cubit.allowCreation &&
        cubit.createIngredient != null &&
        cubit.state.textFilter.isNotEmpty &&
        !cubit.ingredients.any(
          (ingredient) =>
              ingredient.name.toLowerCase() ==
              cubit.state.textFilter.toLowerCase(),
        );
    log('Building _IngredientSelectModal', name: '_IngredientSelectModal');

    log(
      'current filtered ingredients: ${currentFilteredIngredients.length}',
      name: '_IngredientSelectModal',
    );
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          log(
            'innerBoxIsScrolled: $innerBoxIsScrolled',
            name: '_IngredientSelectModal',
          );
          return [
            SliverOverlapAbsorber(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                context,
              ),
              sliver: SliverAppBar(
                backgroundColor: innerBoxIsScrolled
                    ? colorScheme.surfaceContainer
                    : colorScheme.surface,
                elevation: 0,
                scrolledUnderElevation: 0,
                floating: true,
                snap: true,
                title: LayoutBuilder(
                  builder: (_, constraints) {
                    return SearchBar(
                      constraints: const BoxConstraints(
                        minHeight: 48,
                      ),
                      autoFocus: true,
                      onSubmitted: (value) async {
                        log(
                          'Search submitted with value: $value',
                          name: '_IngredientSelectModal',
                        );

                        if (currentFilteredIngredients.isNotEmpty) {
                          final ingredient = currentFilteredIngredients.first;
                          log(
                            'Selected ingredient ${ingredient.name} from search submission',
                            name: '_IngredientSelectModal',
                          );
                          cubit.selectIngredient(ingredient.id);
                          Navigator.of(context).pop();
                          return;
                        }

                        if (cubit.createIngredient != null) {
                          final newIngredient = await cubit.createIngredient!(
                            name: cubit.state.textFilter,
                          );
                          cubit.selectIngredient(newIngredient.id);
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        }
                      },
                      trailing: [
                        if (cubit.state.textFilter.isNotEmpty)
                          IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            onPressed: () {
                              log(
                                'Clearing search',
                                name: '_IngredientSelectModal',
                              );
                              cubit.filterChange('');
                            },
                          ),
                      ],
                      elevation: const WidgetStatePropertyAll(0),
                      backgroundColor: innerBoxIsScrolled
                          ? WidgetStatePropertyAll(
                              colorScheme.surfaceContainerHighest,
                            )
                          : WidgetStatePropertyAll(
                              colorScheme.surfaceContainer,
                            ),
                      hintText: s.search,
                      onChanged: (value) {
                        log(
                          'Search changed to $value',
                          name: '_IngredientSelectModal',
                        );
                        cubit.filterChange(value);
                      },
                    );
                  },
                ),
              ),
            ),
          ];
        },
        body: Builder(
          builder: (context) {
            return CustomScrollView(
              slivers: [
                SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                    context,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, index) {
                      if (shouldShowCreateOption &&
                          index == currentFilteredIngredients.length) {
                        return ListTile(
                          leading: const Icon(Icons.add),
                          title: Text(
                            cubit.state.textFilter,
                          ),
                          onTap: () async {
                            log(
                              'Creating new ingredient with name: ${cubit.state.textFilter}',
                              name: '_IngredientSelectModal',
                            );
                            if (cubit.createIngredient != null) {
                              final newIngredient =
                                  await cubit.createIngredient!(
                                    name: cubit.state.textFilter,
                                  );
                              cubit.selectIngredient(newIngredient.id);
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        );
                      }

                      final ingredient = currentFilteredIngredients[index];
                      return ListTile(
                        selected:
                            cubit.state.selectedIngredientId == ingredient.id,
                        title: Text(ingredient.name),
                        onTap: () {
                          log(
                            'Selected ingredient ${ingredient.name}',
                            name: '_IngredientSelectModal',
                          );
                          cubit.selectIngredient(ingredient.id);
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    childCount:
                        currentFilteredIngredients.length +
                        (shouldShowCreateOption ? 1 : 0),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
