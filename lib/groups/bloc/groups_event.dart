part of 'groups_bloc.dart';

sealed class GroupsEvent {
  const GroupsEvent();
}

final class GroupsSubscriptionRequested extends GroupsEvent {}

final class GroupSelected extends GroupsEvent {
  const GroupSelected(this.group);

  final FRGroup group;
}

final class GroupAuthUserChanged extends GroupsEvent {
  const GroupAuthUserChanged(this.authUser);

  final FRUser? authUser;
}
