part of 'groups_bloc.dart';

class GroupsState extends Equatable {
  const GroupsState({
    this.groups = const [],
    String? selectedGroupId,
  }) : _selectedGroupId = selectedGroupId;

  GroupsState copyWith({
    List<FRGroup>? groups,
    String? selectedGroupId,
  }) {
    return GroupsState(
      groups: groups ?? this.groups,
      selectedGroupId: selectedGroupId ?? _selectedGroupId,
    );
  }

  final List<FRGroup> groups;

  FRGroup? get selectedGroup {
    log(
      'Getting selected group with ID: $_selectedGroupId from groups: $groups',
      name: 'GroupsState',
    );
    if (groups.isEmpty) {
      return null;
    }
    try {
      return groups.firstWhere(
        (group) => group.id == _selectedGroupId,
      );
    } catch (_) {
      log(
        'No group found with ID: $_selectedGroupId',
        name: 'GroupsState',
      );
      return null;
    }
  }

  final String? _selectedGroupId;

  @override
  List<Object?> get props => [groups, _selectedGroupId];
}
