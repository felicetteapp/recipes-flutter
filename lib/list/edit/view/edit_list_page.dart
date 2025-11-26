import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/list/bloc/list_bloc.dart';
import 'package:felicette_recipes/list/edit/bloc/edit_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
      create: (context) => EditListCubit()
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

    return Scaffold(
      appBar: EditListPage.appbar(context),
      body: Center(
        child: Text(
          'teste - budget ${editCubit.state.budget} - currency ${editCubit.state.currency}',
        ),
      ),
    );
  }
}
