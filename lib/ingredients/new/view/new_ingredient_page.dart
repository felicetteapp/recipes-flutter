import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/view/widgets/crud_bottom_navigation.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ingredient_repository/ingredient_repository.dart';

class NewIngredientPage extends StatelessWidget {
  const NewIngredientPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.newIngredient,
      builder: (context, state) => const NewIngredientPage(),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      showBackButton: true,
      title: Text(s.new_ingredient.capitalize()),
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
    return BlocProvider(
      create: (context) =>
          NewIngredientCubit(
            ingredientRepository: context.read<IngredientRepository>(),
          )..defineGroupId(
            context.read<IngredientsBloc>().state.selectedGroupId!,
          ),
      child: const _NewIngredientPageContent(),
    );
  }
}

class _NewIngredientPageContent extends StatelessWidget {
  const _NewIngredientPageContent();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);

    return BlocListener<NewIngredientCubit, NewIngredientState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          GoRouter.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.ingredient_created_successfully),
              ),
            );
        } else if (state.status.isFailure) {
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
        appBar: NewIngredientPage.appbar(context),
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
              child: _CreateButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CreateButton extends StatelessWidget {
  const _CreateButton();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    final newCubit = context.watch<NewIngredientCubit>();
    final isSending = newCubit.state.status.isInProgressOrSuccess;

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: newCubit.state.isValid && !isSending
          ? () {
              log('Creating ingredient...', name: 'NewIngredientPage');
              // Save logic here
              newCubit.createIngredient();
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
          : const Icon(Icons.add),
      label: Text(
        s.create,
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
    final newCubit = context.watch<NewIngredientCubit>();
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: TextFormField(
        initialValue: context
            .read<NewIngredientCubit>()
            .state
            .ingredientName
            .value,
        key: const Key('newIngredientPage_name_textFormField'),
        decoration: InputDecoration(
          labelText: s.ingredient_name.capitalize(),
          errorText: newCubit.state.ingredientName.displayError != null
              ? s.input_required_error
              : null,
        ),
        autovalidateMode: .onUserInteraction,
        onChanged: (name) {
          context.read<NewIngredientCubit>().ingredientNameChanged(name);
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
    final newIngredientCubit = context.watch<NewIngredientCubit>();
    return CheckboxListTile(
      title: Text(s.is_actual_ingredient.capitalize()),
      subtitle: Text(s.actual_ingredients_subtitle),
      value: newIngredientCubit.state.isActualIngredient,
      onChanged: (value) {
        log(
          'Is actual ingredient changed: $value',
          name: 'NewIngredientPage',
        );
        newIngredientCubit.ingredientIsActualIngredientChanged(
          isActualIngredient: value ?? false,
        );
      },
    );
  }
}
