import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/groups/groups.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:group_repository/group_repository.dart';

part 'edit_state.dart';

class EditGroupCubit extends Cubit<EditGroupState> {
  EditGroupCubit({required GroupRepository groupRepository})
    : _groupRepository = groupRepository,
      super(const EditGroupState());

  final GroupRepository _groupRepository;

  void groupNameChanged(String value) {
    final groupName = GroupName.dirty(value);
    emit(
      state.copyWith(
        groupName: groupName,
        isValid: Formz.validate([groupName]),
      ),
    );
  }

  void loadGroup(String groupId, FRGroup? group) {
    final groupName = GroupName.dirty(group?.name ?? '');
    emit(
      state.copyWith(
        group: group,
        groupName: groupName,
        isValid: Formz.validate([groupName]),
        groupId: groupId,
      ),
    );
  }

  Future<void> saveGroup() async {
    if (!state.isValid) return;
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _groupRepository.updateGroup(
        state.groupId,
        state.group!.copyWith(
          name: state.groupName.value,
        ),
      );

      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (_) {
      if (isClosed) {
        return;
      }
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
    }
  }

  Future<void> deleteGroup() async {
    emit(state.copyWith(removeStatus: FormzSubmissionStatus.inProgress));
    try {
      await _groupRepository.deleteGroup(state.groupId);

      //Add a delay to allow the backend to process the new group
      await Future<void>.delayed(const Duration(seconds: 5));

      if (isClosed) {
        return;
      }
      emit(state.copyWith(removeStatus: FormzSubmissionStatus.success));
    } catch (_) {
      if (isClosed) {
        return;
      }
      emit(state.copyWith(removeStatus: FormzSubmissionStatus.failure));
    }
  }
}
