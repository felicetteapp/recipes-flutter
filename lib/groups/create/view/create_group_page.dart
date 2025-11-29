import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/authentication/bloc/authentication_bloc.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/groups/groups.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:group_repository/group_repository.dart';

class CreateGroupPage extends StatelessWidget {
  const CreateGroupPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.newGroup,
      builder: (context, state) => const CreateGroupPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserUuid = context.read<AuthenticationBloc>().state.user?.uid;
    return BlocProvider(
      create: (context) => CreateGroupCubit(
        groupRepository: context.read<GroupRepository>(),
        currentUserId: currentUserUuid!,
      ),
      child: const _CreateGroupPageContent(),
    );
  }
}

class _CreateGroupPageContent extends StatelessWidget {
  const _CreateGroupPageContent();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<CreateGroupCubit, CreateGroupState>(
      listener: (context, state) {
        if (state.status.isSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.success),
              ),
            );
        } else if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.error),
              ),
            );
        }
      },
      child: Scaffold(
        appBar: FRAppbar(
          showBackButton: true,
          title: Text(s.create_group.capitalize()),
        ),
        body: const SingleChildScrollView(
          padding: .symmetric(vertical: 16),
          child: Column(
            spacing: 8,
            children: [
              _NameInput(),
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
    final createCubit = context.watch<CreateGroupCubit>();
    final isSending = createCubit.state.status.isInProgressOrSuccess;

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: createCubit.state.isValid && !isSending
          ? () {
              log('Creating group...', name: 'CreateGroupPage');
              createCubit.createGroup();
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
    final createCubit = context.watch<CreateGroupCubit>();
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: TextFormField(
        initialValue: createCubit.state.groupName.value,
        key: const Key('createGroupPage_name_textFormField'),
        decoration: InputDecoration(
          labelText: s.group_name.capitalize(),
          errorText: createCubit.state.groupName.displayError != null
              ? s.input_required_error
              : null,
        ),
        autovalidateMode: .onUserInteraction,
        onChanged: createCubit.groupNameChanged,
      ),
    );
  }
}
