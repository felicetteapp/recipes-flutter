part of 'edit_cubit.dart';

class EditGroupState extends Equatable {
  const EditGroupState({
    this.status = FormzSubmissionStatus.initial,
    this.removeStatus = FormzSubmissionStatus.initial,
    this.groupName = const GroupName.pure(),
    this.isValid = false,
    this.group,
    this.groupId = '',
  });

  final FormzSubmissionStatus status;
  final FormzSubmissionStatus removeStatus;
  final GroupName groupName;
  final bool isValid;
  final FRGroup? group;
  final String groupId;

  EditGroupState copyWith({
    FormzSubmissionStatus? status,
    GroupName? groupName,
    bool? isValid,
    FRGroup? group,
    String? groupId,
    FormzSubmissionStatus? removeStatus,
  }) {
    return EditGroupState(
      groupName: groupName ?? this.groupName,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
      group: group ?? this.group,
      groupId: groupId ?? this.groupId,
      removeStatus: removeStatus ?? this.removeStatus,
    );
  }

  @override
  List<Object?> get props => [
    status,
    groupName,
    isValid,
    group,
    groupId,
    removeStatus,
  ];
}
