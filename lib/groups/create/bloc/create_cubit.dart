import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/groups/groups.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:group_repository/group_repository.dart';

part 'create_state.dart';

class CreateGroupCubit extends Cubit<CreateGroupState> {
  CreateGroupCubit({
    required GroupRepository groupRepository,
    required this.currentUserId,
  }) : _groupRepository = groupRepository,
       super(const CreateGroupState());

  final GroupRepository _groupRepository;
  final String currentUserId;

  void groupNameChanged(String value) {
    final groupName = GroupName.dirty(value);
    emit(
      state.copyWith(
        groupName: groupName,
        isValid: Formz.validate([groupName]),
      ),
    );
  }

  Future<void> createGroup() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _groupRepository.createGroup(
        FRGroup.empty.copyWith(
          name: state.groupName.value,
          creatorUid: currentUserId,
        ),
      );

      //Add a delay to allow the backend to process the new group
      await Future<void>.delayed(const Duration(seconds: 5));

      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (e) {
      log(
        'Error creating group: $e',
        name: 'CreateGroupCubit.createGroup',
        level: 900,
      );
      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }
}
