import '../../models/user_model.dart';

abstract class UserEvent {}

class FetchUsers extends UserEvent {
  final int page;

  FetchUsers({required this.page});
}

class FetchAllUsers extends UserEvent {}

class ToggleUserFavorite extends UserEvent {
  final int userId;

  ToggleUserFavorite({required this.userId});
}

class SearchUsers extends UserEvent {
  final String searchTerm;

  SearchUsers({required this.searchTerm});
}

class CreateUser extends UserEvent {
  final User user;

  CreateUser({required this.user});
}

class DeleteUserEvent extends UserEvent {
  final int userId;

  DeleteUserEvent(this.userId);
}

class UpdateUserEvent extends UserEvent {
  final int userId;
  final String firstName;
  final String lastName;
  final String email;
  UpdateUserEvent(
      {required this.userId,
      required this.firstName,
      required this.lastName,
      required this.email});
}
