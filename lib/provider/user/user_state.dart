import '../../models/user_model.dart';

abstract class UserState {
  const UserState();
}

class UsersInitial extends UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User>? users;
  const UsersLoaded({required this.users});
}

class UsersError extends UserState {}
