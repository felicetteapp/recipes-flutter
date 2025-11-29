import 'dart:developer';

import 'package:felicette_recipes/app/common/widgets/appbar/appbar.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/app/view/view.dart';
import 'package:felicette_recipes/extensions/extensions.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/groups/groups.dart';
import 'package:felicette_recipes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:group_repository/group_repository.dart';

class EditGroupPage extends StatelessWidget {
  const EditGroupPage({required this.groupId, super.key});

  final String groupId;

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.editGroup,
      builder: (context, state) => EditGroupPage(
        groupId: state.pathParameters['groupId']!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditGroupCubit(
            groupRepository: context.read<GroupRepository>(),
          )..loadGroup(
            groupId,
            context.read<GroupsBloc>().state.groups.firstWhereOrNull(
              (grp) => grp.id == groupId,
            ),
          ),
      child: const _EditGroupPageContent(),
    );
  }
}

class _EditGroupPageContent extends StatelessWidget {
  const _EditGroupPageContent();

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    return BlocListener<EditGroupCubit, EditGroupState>(
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

        if (state.removeStatus.isSuccess) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(s.success),
              ),
            );
        } else if (state.removeStatus.isFailure) {
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
          title: Text(s.edit_group.capitalize()),
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
    final editCubit = context.watch<EditGroupCubit>();
    final isSending = editCubit.state.removeStatus.isInProgressOrSuccess;

    return TextButton.icon(
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.error,
      ),
      onPressed: isSending
          ? null
          : () async {
              log('Deleting group...', name: 'EditGroupPage');

              final confirmedExclusion = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(s.confirm_group_deletion),
                  content: Text(s.confirm_group_deletion_message),
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
                await editCubit.deleteGroup();
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
    final editCubit = context.watch<EditGroupCubit>();
    final isSending = editCubit.state.status.isInProgressOrSuccess;

    return FilledButton.icon(
      style: FilledButton.styleFrom(
        backgroundColor: theme.customColors.success,
        foregroundColor: theme.customColors.onSuccess,
      ),
      onPressed: editCubit.state.isValid && !isSending
          ? () {
              log('Saving group...', name: 'EditGroupPage');
              // Save logic here
              editCubit.saveGroup();
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
    final editCubit = context.watch<EditGroupCubit>();
    return Padding(
      padding: const .symmetric(horizontal: 16),
      child: TextFormField(
        initialValue: editCubit.state.groupName.value,
        key: const Key('editGroupPage_name_textFormField'),
        decoration: InputDecoration(
          labelText: s.group_name.capitalize(),
          errorText: editCubit.state.groupName.displayError != null
              ? s.input_required_error
              : null,
        ),
        autovalidateMode: .onUserInteraction,
        onChanged: editCubit.groupNameChanged,
      ),
    );
  }
}
