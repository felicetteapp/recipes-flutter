import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/ingredients/ingredients.dart';
import 'package:felicette_recipes/list/bloc/list_bloc.dart';
import 'package:felicette_recipes/list/edit/bloc/edit_cubit.dart';
import 'package:felicette_recipes/recipes/recipes.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:group_repository/group_repository.dart';
import 'package:ingredient_repository/ingredient_repository.dart';
import 'package:uuid/uuid.dart';

class EditListPage extends StatelessWidget {
  const EditListPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.editList,
      builder: (context, state) => const EditListPage(),
    );
  }

  static FRAppbar appbar(BuildContext context) {
    final s = S.of(context);

    return FRAppbar(
      showBackButton: true,
      title: Text(s.edit_list.capitalize()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final listBloc = context.watch<ListBloc>();

    return BlocProvider(
      lazy: false,
      create: (context) =>
          EditListCubit(
              groupRepository: context.read<GroupRepository>(),
            )
            ..handleGroupChanged(listBloc.state.selectedGroup)
            ..handleIngredientsChanged(listBloc.state.groupIngredients)
            ..handleRecipesChanged(listBloc.state.groupRecipes),
      child: BlocListener<ListBloc, ListState>(
        listener: (context, state) {
          context.read<EditListCubit>().handleGroupChanged(state.selectedGroup);
          context.read<EditListCubit>().handleIngredientsChanged(
            state.groupIngredients,
          );
          context.read<EditListCubit>().handleRecipesChanged(
            state.groupRecipes,
          );
        },
        child: const _EditListPageContent(),
      ),
    );
  }
}

class _EditListPageContent extends StatelessWidget {
  const _EditListPageContent();

  @override
  Widget build(BuildContext context) {
    final editCubit = context.watch<EditListCubit>();
    final s = S.of(context);

    return Scaffold(
      appBar: EditListPage.appbar(context),
      bottomNavigationBar: CrudBottomNavigation(
        actions: [
          Expanded(
            child: TextButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.chevron_left),
              label: Text(s.cancel.capitalize()),
            ),
          ),
          const Expanded(child: _SaveButton()),
        ],
      ),
      body: SingleChildScrollView(
        padding: const .symmetric(horizontal: 16),
        child: Column(
          spacing: 16,
          children: [
            Text(
              'Budget: ${editCubit.state.budget} ${editCubit.state.currency}',
            ),
            RecipeSelect(
              placeholder: s.select_recipes,
              label: s.recipe(0).capitalize(),
              isMulti: true,
              initialValue: editCubit.state.currentRecipes,
              onChanged: editCubit.handleCurrentRecipesChanged,
            ),
            TextFormField(
              initialValue: editCubit.state.budget.toString(),
              decoration: InputDecoration(
                labelText: s.budget.capitalize(),
              ),
              keyboardType: const .numberWithOptions(
                decimal: true,
              ),
              onChanged: (value) {
                final budget =
                    double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
                editCubit.handleBudgetChanged(budget);
              },
            ),
            Padding(
              padding: const .symmetric(vertical: 8),
              child: Text(
                s.ingredient(0).capitalize(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IngredientsQuantityInput<FRCurrentIngredients>(
              initialValue: editCubit.state.currentIngredients,
              generateEmpty: () => FRCurrentIngredients(
                uuid: const Uuid().v4(),
                ingredientId: '',
                quantity: '',
              ),
              onChanged: editCubit.handleCurrentIngredientsChanged,
              createIngredient:
                  ({
                    required String name,
                  }) async {
                    final ingredientRepository = context
                        .read<IngredientRepository>();

                    final isActualIngredient =
                        await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(s.confirm),
                            content: Text(
                              s.confirm_actual_ingredient_description(name),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text(s.no),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text(s.yes),
                              ),
                            ],
                          ),
                        ) ??
                        false;

                    if (!context.mounted) {
                      throw Exception('Context is not mounted');
                    }
                    return ingredientRepository.createIngredient(
                      context.read<ListBloc>().state.selectedGroup!.id,
                      FRIngredient(
                        id: '',
                        name: name,
                        actualIngredient: isActualIngredient,
                      ),
                    );
                  },
            ),
          ],
        ),
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
    final editCubit = context.watch<EditListCubit>();

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: () async {
        log('Saving ingredient...', name: 'EditIngredientPage');
        // Save logic here
        //              editCubit.saveIngredient();

        await editCubit.saveChanges();
        if (context.mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(s.list_details_updated_successfully),
            ),
          );
        }
      },
      icon: const Icon(Icons.save),
      label: Text(
        s.save,
        maxLines: 1,
        overflow: .ellipsis,
      ),
    );
  }
}
