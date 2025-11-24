import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/edit/bloc/edit_cubit.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

class EditIngredientPage extends StatelessWidget {
  const EditIngredientPage({required this.ingredientId, super.key});
  final String ingredientId;

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.editIngredient,
      builder: (context, state) => EditIngredientPage(
        ingredientId: state.pathParameters['ingredientId']!,
      ),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      showBackButton: true,
      title: Text(s.edit_ingredient.capitalize()),
    );
  }

  static NavigationDestination navigationDestination(BuildContext context) {
    final s = S.of(context);
    return NavigationDestination(
      icon: const Icon(Icons.kitchen),
      label: s.ingredient(1).capitalize(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsBloc = context.watch<IngredientsBloc>();

    final ingredient = ingredientsBloc.state.ingredients.firstWhereOrNull(
      (ing) => ing.id == ingredientId,
    );
    return BlocProvider(
      create: (context) => EditIngredientCubit(
        ingredientRepository: context.read<IngredientRepository>(),
      )..loadIngredient(ingredientsBloc.state.selectedGroupId!, ingredient),
      child: _EditIngredientPageContent(
        ingredientId: ingredientId,
      ),
    );
  }
}

class _EditIngredientPageContent extends StatelessWidget {
  const _EditIngredientPageContent({required this.ingredientId});
  final String ingredientId;

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocListener<EditIngredientCubit, EditIngredientState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          log(
            'Ingredient edited successfully: $ingredientId',
            name: 'EditIngredientPage',
          );
          GoRouter.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.ingredient_updated_successfully),
              ),
            );
        } else if (state.removeStatus.isSuccess) {
          log(
            'Ingredient removed successfully: $ingredientId',
            name: 'EditIngredientPage',
          );
          GoRouter.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.ingredient_deleted_successfully),
              ),
            );
        } else if (state.status.isFailure || state.removeStatus.isFailure) {
          final snackBar = SnackBar(
            content: Text(s.error),
            backgroundColor: theme.colorScheme.error,
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Scaffold(
        appBar: EditIngredientPage.appbar(context),
        body: const SingleChildScrollView(
          padding: .symmetric(vertical: 16),
          child: Column(
            spacing: 8,
            children: [
              _NameInput(),
              _IsActualIngredientCheckbox(),
            ],
          ),
        ),
        bottomNavigationBar: CrudBottomNavigation(
          actions: [
            Expanded(
              child: TextButton.icon(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(Icons.chevron_left),
                label: Text(
                  s.cancel,
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
              ),
            ),
            const Expanded(
              child: _SaveButton(),
            ),
            const Expanded(
              child: _ExcludeButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExcludeButton extends StatelessWidget {
  const _ExcludeButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final editCubit = context.watch<EditIngredientCubit>();
    final isSending = editCubit.state.removeStatus.isInProgressOrSuccess;

    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
      ),
      onPressed: isSending
          ? null
          : () async {
              log('Deleting ingredient...', name: 'EditIngredientPage');

              final confirmedExclusion = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(s.confirm_ingredient_deletion),
                  content: Text(s.confirm_ingredient_deletion_message),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(s.cancel),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(s.delete),
                    ),
                  ],
                ),
              );

              if (confirmedExclusion != null && confirmedExclusion) {
                await editCubit.excludeIngredient();
              }
            },
      icon: isSending
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(
              Icons.delete,
            ),
      label: Text(
        s.delete,
        maxLines: 1,
        overflow: .ellipsis,
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final editCubit = context.watch<EditIngredientCubit>();
    final isSending = editCubit.state.status.isInProgressOrSuccess;

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: editCubit.state.isValid && !isSending
          ? () {
              log('Saving ingredient...', name: 'EditIngredientPage');
              // Save logic here
              editCubit.saveIngredient();
            }
          : null,
      icon: isSending
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.save),
      label: Text(
        s.save,
        maxLines: 1,
        overflow: .ellipsis,
      ),
    );
  }
}

class _NameInput extends StatelessWidget {
  const _NameInput();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final editCubit = context.watch<EditIngredientCubit>();
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: TextFormField(
        initialValue: context
            .read<EditIngredientCubit>()
            .state
            .ingredientName
            .value,
        key: const Key('editIngredientPage_name_textFormField'),
        decoration: InputDecoration(
          labelText: s.ingredient_name.capitalize(),
          errorText: editCubit.state.ingredientName.displayError != null
              ? s.input_required_error
              : null,
        ),
        autovalidateMode: .onUserInteraction,
        onChanged: (name) {
          context.read<EditIngredientCubit>().ingredientNameChanged(name);
        },
      ),
    );
  }
}

class _IsActualIngredientCheckbox extends StatelessWidget {
  const _IsActualIngredientCheckbox();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final editIngredientCubit = context.watch<EditIngredientCubit>();
    return CheckboxListTile(
      title: Text(s.is_actual_ingredient.capitalize()),
      subtitle: Text(s.actual_ingredients_subtitle),
      value: editIngredientCubit.state.isActualIngredient,
      onChanged: (value) {
        log(
          'Is actual ingredient changed: $value',
          name: 'EditIngredientPage',
        );
        editIngredientCubit.ingredientIsActualIngredientChanged(
          isActualIngredient: value ?? false,
        );
      },
    );
  }
}
