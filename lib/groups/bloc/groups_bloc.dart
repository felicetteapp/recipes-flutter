import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:user_repository/user_repository.dart';

part 'groups_state.dart';
part 'groups_event.dart';

class GroupsBloc extends Bloc<GroupsEvent, GroupsState> {
  GroupsBloc({
    required GroupRepository groupRepository,
    required UserRepository userRepository,
  }) : _groupRepository = groupRepository,
       _userRepository = userRepository,
       super(const GroupsState()) {
    on<GroupsSubscriptionRequested>(_onSubscriptionRequested);
    on<GroupSelected>(_onGroupSelected);
  }

  final GroupRepository _groupRepository;
  final UserRepository _userRepository;

  Future<void> _onSubscriptionRequested(
    GroupsSubscriptionRequested event,
    Emitter<GroupsState> emit,
  ) async {
    log('Groups subscription requested', name: 'GroupsBloc');

    final user = _userRepository.user;
    if (user == null) return;
    return emit.onEach<List<FRGroup>>(
      _groupRepository.listenToGroups(user.groups),
      onData: (groups) {
        log('Received groups update: $groups', name: 'GroupsBloc');

        emit(state.copyWith(groups: groups));
        if (state.selectedGroup == null && groups.isNotEmpty) {
          log(
            'No group selected, selecting first group: ${groups.first}',
            name: 'GroupsBloc',
          );
          add(GroupSelected(groups.first));
        }
      },
      onError: addError,
    );
  }

  void _onGroupSelected(
    GroupSelected event,
    Emitter<GroupsState> emit,
  ) {
    log('Group selected: ${event.group}', name: 'GroupsBloc');
    emit(state.copyWith(selectedGroupId: event.group.id));
  }
}
