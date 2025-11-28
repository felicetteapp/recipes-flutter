part of 'create_cubit.dart';

class CreateGroupState extends Equatable {
  const CreateGroupState({
    this.status = FormzSubmissionStatus.initial,
    this.groupName = const GroupName.pure(),
    this.isValid = false,
  });

  final FormzSubmissionStatus status;
  final GroupName groupName;
  final bool isValid;

  CreateGroupState copyWith({
    FormzSubmissionStatus? status,
    GroupName? groupName,
    bool? isValid,
  }) {
    return CreateGroupState(
      groupName: groupName ?? this.groupName,
      status: status ?? this.status,
      isValid: isValid ?? this.isValid,
    );
  }

  @override
  List<Object?> get props => [
    status,
    groupName,
    isValid,
  ];
}
