import 'dart:developer';

import 'package:felicette_recipes/app/bloc/app_bloc.dart';
import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:felicette_recipes/list/view/widgets/ingredient_modal/bloc/ingredient_modal_cubit.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:group_repository/group_repository.dart';
import 'package:intl/intl.dart';

class ListIngredientModal extends StatelessWidget {
  const ListIngredientModal({
    required this.item,
    super.key,
  });
  final ListIngredientItem item;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IngredientModalCubit()..loadItem(item),
      child: const _ModalContent(),
    );
  }
}

class _ModalContent extends StatelessWidget {
  const _ModalContent();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final item = context.watch<IngredientModalCubit>().state.item!;

    final currentLocale = context.read<AppBloc>().state.locale;
    final currency =
        context.read<ListBloc>().state.selectedGroup?.currency ?? 'USD';

    final currencyFormatter = NumberFormat.simpleCurrency(
      locale: currentLocale.toLanguageTag(),
      name: currency,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(item.ingredient.name),
      ),
      bottomNavigationBar: const CrudBottomNavigation(
        actions: [
          Expanded(child: _SaveWithoutPriceButton()),
          Expanded(
            child: _SavePricesButton(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            ...item.prices.map(
              (price) => _PriceCard(
                price: price,
                key: ValueKey(price.uuid),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    textAlign: .center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondary,
                    ),
                    currencyFormatter.format(
                      item.prices.fold<double>(
                        0,
                        (previousValue, element) =>
                            previousValue +
                            (element.quantity * element.unitPrice),
                      ),
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    log(
                      'Adding new price row',
                      name: 'IngredientModal',
                    );
                    context.read<IngredientModalCubit>().addPrice();
                  },
                  icon: const Icon(Icons.add),
                  label: Text(
                    S.of(context).add_price,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.price, super.key});
  final FRIngredientPrice price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    final currentLocale = context.read<AppBloc>().state.locale;
    final currency =
        context.read<ListBloc>().state.selectedGroup?.currency ?? 'USD';

    final currencyFormatter = NumberFormat.simpleCurrency(
      locale: currentLocale.toLanguageTag(),
      name: currency,
    );

    return Card(
      child: Padding(
        padding: const .symmetric(
          horizontal: 16,
          vertical: 24,
        ),

        child: Row(
          crossAxisAlignment: .start,
          spacing: 8,
          children: [
            Expanded(
              child: Column(
                spacing: 8,
                children: [
                  Row(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: price.unitPrice == 0
                              ? ''
                              : price.unitPrice.toString(),
                          decoration: InputDecoration(
                            labelText: s.unit_price,
                          ),
                          keyboardType: const .numberWithOptions(
                            decimal: true,
                          ),
                          onChanged: (value) {
                            final newUnitPrice =
                                num.tryParse(value.replaceAll(',', '.')) ?? 0;
                            final newPrice = price.copyWith(
                              unitPrice: newUnitPrice,
                            );
                            context.read<IngredientModalCubit>().updatePrice(
                              price,
                              newPrice,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  _PriceCardQuantityButtons(price: price),
                  if (context
                          .watch<IngredientModalCubit>()
                          .state
                          .item!
                          .prices
                          .length >
                      1)
                    Text(
                      currencyFormatter.format(
                        price.quantity * price.unitPrice,
                      ),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            if (context
                    .watch<IngredientModalCubit>()
                    .state
                    .item!
                    .prices
                    .length >
                1)
              IconButton(
                onPressed: () {
                  log(
                    'Removing price row',
                    name: 'IngredientModal',
                  );
                  context.read<IngredientModalCubit>().removePrice(price);
                },
                icon: Icon(
                  Icons.delete,
                  color: theme.colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PriceCardQuantityButtons extends StatelessWidget {
  const _PriceCardQuantityButtons({required this.price});
  final FRIngredientPrice price;

  List<int> get defaultQuantities => [1, 2, 3, 4];
  double get biggestRadius => 16;
  double get smallRadius => 4;

  OutlinedBorder getShape(int? defaultQuantity) {
    if (defaultQuantity == price.quantity) {
      return RoundedRectangleBorder(
        borderRadius: .circular(biggestRadius),
      );
    }

    if (defaultQuantity == null) {
      return RoundedRectangleBorder(
        borderRadius: .only(
          topLeft: .circular(smallRadius),
          bottomLeft: .circular(smallRadius),
          topRight: .circular(biggestRadius),
          bottomRight: .circular(biggestRadius),
        ),
      );
    } else if (defaultQuantity == 1) {
      return RoundedRectangleBorder(
        borderRadius: .only(
          topLeft: .circular(biggestRadius),
          bottomLeft: .circular(biggestRadius),
        ),
      );
    } else {
      return RoundedRectangleBorder(
        borderRadius: .circular(smallRadius),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = S.of(context);

    final quantityItsNotInDefaults = !defaultQuantities.contains(
      price.quantity,
    );

    return Row(
      spacing: 1,
      children: [
        ...[...defaultQuantities, null].map((defaultQuantity) {
          if (defaultQuantity != null) {
            return FilledButton(
              style: TextButton.styleFrom(
                visualDensity: .compact,
                tapTargetSize: .shrinkWrap,
                backgroundColor: defaultQuantity == price.quantity
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.primaryContainer,
                foregroundColor: defaultQuantity == price.quantity
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.onPrimaryContainer,
                padding: .symmetric(vertical: biggestRadius, horizontal: 2),
                shape: getShape(defaultQuantity),
              ),
              onPressed: () {
                final newPrice = price.copyWith(
                  quantity: defaultQuantity,
                );
                context.read<IngredientModalCubit>().updatePrice(
                  price,
                  newPrice,
                );
              },
              child: Text(defaultQuantity.toString()),
            );
          }
          return Expanded(
            child: FilledButton.icon(
              style: TextButton.styleFrom(
                visualDensity: .compact,
                tapTargetSize: .shrinkWrap,
                backgroundColor: quantityItsNotInDefaults
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.primaryContainer,
                foregroundColor: quantityItsNotInDefaults
                    ? theme.colorScheme.primaryContainer
                    : theme.colorScheme.onPrimaryContainer,
                shape: getShape(defaultQuantity),
                padding: .symmetric(vertical: biggestRadius, horizontal: 2),
              ),
              onPressed: () {
                showDialog<double>(
                  context: context,
                  builder: (context) {
                    final quantityController = TextEditingController();
                    return AlertDialog(
                      title: Text(s.enter_quantity),
                      content: TextField(
                        autofocus: true,
                        controller: quantityController,
                        keyboardType: const .numberWithOptions(decimal: true),
                        decoration: InputDecoration(
                          hintText: s.quantity,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(s.cancel),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final enteredQuantity =
                                double.tryParse(
                                  quantityController.text.replaceAll(',', '.'),
                                ) ??
                                0;
                            Navigator.of(context).pop(enteredQuantity);
                          },
                          child: Text(s.save),
                        ),
                      ],
                    );
                  },
                ).then((enteredQuantity) {
                  if (enteredQuantity != null) {
                    final newPrice = price.copyWith(
                      quantity: enteredQuantity,
                    );
                    if (!context.mounted) return;
                    context.read<IngredientModalCubit>().updatePrice(
                      price,
                      newPrice,
                    );
                  }
                });
              },
              label: Text(
                quantityItsNotInDefaults ? price.quantity.toString() : s.more,
              ),
              icon: const Icon(Icons.edit),
            ),
          );
        }),
      ],
    );
  }
}

class _SavePricesButton extends StatelessWidget {
  const _SavePricesButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final modalCubit = context.watch<IngredientModalCubit>();

    return FilledButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: () {
        log(
          'Saving ingredient prices...',
          name: 'IngredientModal',
        );
        log(
          'Current prices to save: ${modalCubit.state.item?.prices}',
          name: 'IngredientModal',
        );

        GoRouter.of(context).pop(modalCubit.state.item?.prices);
      },
      icon: const Icon(Icons.save),
      label: Text(
        s.save,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _SaveWithoutPriceButton extends StatelessWidget {
  const _SaveWithoutPriceButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.secondary,
      ),
      onPressed: () {
        log(
          'Saving ingredient without price...',
          name: 'IngredientModal',
        );
        GoRouter.of(context).pop(<FRIngredientPrice>[]);
      },
      icon: const Icon(Icons.save),
      label: Text(
        s.save_without_price,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
