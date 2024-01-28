import '../../models/user_model.dart';

abstract class UserState {}

class UsersInitial extends UserState {}

class UsersLoading extends UserState {}

class UsersLoaded extends UserState {
  final List<User> users;

  UsersLoaded({required this.users});

  UsersLoaded copyWith({List<User>? users}) {
    return UsersLoaded(users: users ?? this.users);
  }
}

class UsersError extends UserState {}
