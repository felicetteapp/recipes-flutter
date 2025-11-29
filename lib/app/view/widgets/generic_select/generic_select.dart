import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A generic select widget that can be reused for any type of selectable item.
///
/// Type parameter [T] represents the type of items that can be selected.
/// Type parameter [B] represents a Bloc that provides the list of items.
class GenericSelect<T, B extends StateStreamableSource<Object?>>
    extends StatelessWidget {
  const GenericSelect({
    required this.placeholder,
    required this.label,
    required this.getId,
    required this.getName,
    required this.getItems,
    required this.filterPredicate,
    super.key,
    this.allowCreation = false,
    this.createItem,
    this.onChanged,
    this.errorMessage,
    this.onOpened,
    this.initialValue,
    this.isMulti = false,
    this.itemExists,
  }) : assert(
         !allowCreation || createItem != null,
         'createItem must be provided if allowCreation is true',
       );

  final String? errorMessage;
  final String placeholder;
  final String label;
  final bool allowCreation;
  final bool isMulti;
  final List<String>? initialValue;

  /// Function to extract ID from an item
  final String Function(T item) getId;

  /// Function to extract display name from an item
  final String Function(T item) getName;

  /// Function to get items from the bloc state
  final List<T> Function(B bloc) getItems;

  /// Function to filter items based on search text
  final bool Function(T item, String filter) filterPredicate;

  /// Function to create a new item (required if allowCreation is true)
  final Future<T> Function({required String name})? createItem;

  /// Callback when selection changes
  final ValueChanged<List<String>>? onChanged;

  /// Callback when modal is opened
  final VoidCallback? onOpened;

  /// Function to check if an item with a given name already exists
  final bool Function(List<T> items, String name)? itemExists;

  @override
  Widget build(BuildContext context) {
    final items = context.select(getItems);

    return BlocProvider(
      create: (context) {
        return GenericSelectCubit<T>(
          allowCreation: allowCreation,
          createItem: createItem,
          isMulti: isMulti,
          onChanged: onChanged,
          getId: getId,
          filterPredicate: filterPredicate,
          initialValue: GenericSelectState<T>(
            selectedItemIds: initialValue == null || initialValue!.isEmpty
                ? []
                : initialValue!,
          ),
        )..initItems(items);
      },
      child: BlocListener<B, Object?>(
        listener: (context, state) {
          context.read<GenericSelectCubit<T>>().initItems(
            getItems(context.read<B>()),
          );
        },
        child: _GenericSelectContent<T>(
          placeholder: placeholder,
          label: label,
          errorMessage: errorMessage,
          onOpened: onOpened,
          getName: getName,
          getId: getId,
          allowCreation: allowCreation,
          createItem: createItem,
          itemExists: itemExists,
        ),
      ),
    );
  }
}

class _GenericSelectContent<T> extends StatelessWidget {
  const _GenericSelectContent({
    required this.placeholder,
    required this.label,
    required this.getName,
    required this.getId,
    required this.allowCreation,
    this.errorMessage,
    this.onOpened,
    this.createItem,
    this.itemExists,
  });

  final String placeholder;
  final String label;
  final String? errorMessage;
  final VoidCallback? onOpened;
  final String Function(T item) getName;
  final String Function(T item) getId;
  final bool allowCreation;
  final Future<T> Function({required String name})? createItem;
  final bool Function(List<T> items, String name)? itemExists;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GenericSelectCubit<T>>();
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final inputDecorationTheme = theme.inputDecorationTheme;
    final contentPadding = inputDecorationTheme.contentPadding;
    final border = errorMessage != null
        ? theme.inputDecorationTheme.errorBorder!
        : inputDecorationTheme.border!;
    final labelShouldFloat = cubit.state.selectedItemIds.isNotEmpty;

    return LayoutBuilder(
      builder: (context, constraints) {
        const decorationRadius = 8.0;
        const topOffset = 4.0;

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

        return Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: constraints.maxWidth,
                  padding: contentPadding,
                  height: 48,
                  decoration: BoxDecoration(
                    color: inputDecorationTheme.fillColor,
                    borderRadius: BorderRadius.circular(decorationRadius),
                    border: Border.fromBorderSide(border.borderSide),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: floatingLabelHorizontalPadding,
                    ),
                    child: Text(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      cubit.selectedItems.isNotEmpty
                          ? cubit.selectedItems.map(getName).join(', ')
                          : '',
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
                    padding: EdgeInsets.only(
                      left: floatingLabelHorizontalPadding,
                      bottom: labelShouldFloat ? 4 : 0,
                      right: floatingLabelHorizontalPadding,
                    ),
                    color: labelShouldFloat
                        ? theme.scaffoldBackgroundColor
                        : null,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        labelShouldFloat ? label : placeholder,
                        style: labelShouldFloat
                            ? textTheme.labelSmall?.copyWith(
                                height: 1,
                                color: errorMessage != null
                                    ? colorScheme.error
                                    : colorScheme.onSurfaceVariant,
                              )
                            : textTheme.bodyLarge?.copyWith(
                                height: 1,
                                color: errorMessage != null
                                    ? colorScheme.error
                                    : colorScheme.onSurfaceVariant,
                              ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(decorationRadius),
                    onTap: () async {
                      await showDialog<void>(
                        useSafeArea: false,
                        context: context,
                        builder: (_) {
                          return BlocProvider.value(
                            value: cubit,
                            child: _GenericSelectModal<T>(
                              getName: getName,
                              getId: getId,
                              allowCreation: allowCreation,
                              createItem: createItem,
                              itemExists: itemExists,
                            ),
                          );
                        },
                      );
                      onOpened?.call();
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
            ),
            if (errorMessage != null)
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 4,
                    left: contentPadding!.horizontal / 2,
                    right: contentPadding.horizontal / 2,
                  ),
                  child: Text(
                    errorMessage!,
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _GenericSelectModal<T> extends StatelessWidget {
  const _GenericSelectModal({
    required this.getName,
    required this.getId,
    required this.allowCreation,
    this.createItem,
    this.itemExists,
  });

  final String Function(T item) getName;
  final String Function(T item) getId;
  final bool allowCreation;
  final Future<T> Function({required String name})? createItem;
  final bool Function(List<T> items, String name)? itemExists;

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<GenericSelectCubit<T>>();
    final currentFilteredItems = cubit.state.filteredItems;
    final s = S.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final shouldShowCreateOption =
        allowCreation &&
        createItem != null &&
        cubit.state.textFilter.isNotEmpty &&
        (itemExists == null ||
            !itemExists!(cubit.items, cubit.state.textFilter));

    return Scaffold(
      bottomNavigationBar: CrudBottomNavigation(
        actions: [
          Expanded(
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(s.done),
            ),
          ),
        ],
      ),
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
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
                        if (currentFilteredItems.isNotEmpty) {
                          final item = currentFilteredItems.first;
                          cubit.selectItem(getId(item));
                          if (!cubit.isMulti) {
                            Navigator.of(context).pop();
                          }
                          return;
                        }

                        if (createItem != null) {
                          final newItem = await createItem!(
                            name: cubit.state.textFilter,
                          );
                          cubit.selectItem(getId(newItem));
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
                      onChanged: cubit.filterChange,
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
                          index == currentFilteredItems.length) {
                        return ListTile(
                          leading: const Icon(Icons.add),
                          title: Text(
                            cubit.state.textFilter,
                          ),
                          onTap: () async {
                            if (createItem != null) {
                              final newItem = await createItem!(
                                name: cubit.state.textFilter,
                              );
                              cubit.selectItem(getId(newItem));
                              if (context.mounted) {
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        );
                      }

                      final item = currentFilteredItems[index];
                      if (cubit.isMulti) {
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          value: cubit.state.selectedItemIds.contains(
                            getId(item),
                          ),
                          title: Text(getName(item)),
                          onChanged: (isSelected) {
                            cubit.selectItem(getId(item));
                          },
                        );
                      }
                      return ListTile(
                        selected: cubit.state.selectedItemIds.contains(
                          getId(item),
                        ),
                        title: Text(getName(item)),
                        onTap: () {
                          cubit.selectItem(getId(item));
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    childCount:
                        currentFilteredItems.length +
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
