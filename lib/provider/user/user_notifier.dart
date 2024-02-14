// user_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/user_model.dart';
import '../../repository/user_repository.dart';
import 'user_state.dart';

final userNotifierProvider =
    NotifierProvider.autoDispose<UserNotifier, UserState>(UserNotifier.new);

class UserNotifier extends AutoDisposeAsyncNotifier<UserState> {
  List<User>? userList = [];
  // UserRepository? userRepository;
  UserRepository get userRepoProvider => ref.read(userRepoProvider);

  @override
  UserState build() {
    fetchAllUsers();

    return UsersLoading();
  }

  Future<void> fetchAllUsers() async {
    state = const AsyncValue.loading();
    try {
      final users = await userRepository?.fetchAllUsers();
      state = AsyncValue.data(UsersLoaded(users: users));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> toggleUserFavorite(int userId) async {
    state.whenData((data) {
      if (data is UsersLoaded) {
        final updatedUsers = data.users?.map((user) {
          return user.id == userId
              ? user.copyWith(favourite: !user.favourite)
              : user;
        }).toList();
        state = AsyncValue.data(UsersLoaded(users: updatedUsers));
      }
    });
  }

  Future<void> searchUsers(String searchTerm) async {
    state = const AsyncValue.loading();
    try {
      final filteredUsers = userList?.where((user) {
        return user.firstName!
                .toLowerCase()
                .contains(searchTerm.toLowerCase()) ||
            user.lastName!.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
      state = AsyncValue.data(UsersLoaded(users: filteredUsers));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> createUser(User newUser) async {
    state = const AsyncValue.loading();
    try {
      final createdUser = await userRepository?.createUser(newUser.toJson());
      // Ensure we do not proceed if createdUser is null.
      if (createdUser == null) {
        throw Exception("User creation failed.");
      }
      final currentUsers = (state.value as UsersLoaded?)?.users ?? [];
      final updatedUsers = List<User>.from(currentUsers)..add(createdUser);
      state = AsyncValue.data(UsersLoaded(users: updatedUsers));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> deleteUser(int userId) async {
    state = const AsyncValue.loading();
    try {
      await userRepository?.deleteUser(userId);
      final currentUsers = (state.value as UsersLoaded?)?.users ?? [];
      final updatedUsers =
          currentUsers.where((user) => user.id != userId).toList();
      state = AsyncValue.data(UsersLoaded(users: updatedUsers));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }

  Future<void> updateUser(
      int userId, Map<String, dynamic> updatedUserData) async {
    state = const AsyncValue.loading();
    try {
      await userRepository?.updateUser(userId, updatedUserData);
      final currentUsers = (state.value as UsersLoaded?)?.users ?? [];
      final updatedUsers = currentUsers.map((user) {
        if (user.id == userId) {
          return user.copyWith(
            firstName: updatedUserData['firstName'],
            lastName: updatedUserData['lastName'],
            email: updatedUserData['email'],
          );
        }
        return user;
      }).toList();
      state = AsyncValue.data(UsersLoaded(users: updatedUsers));
    } catch (error) {
      state = AsyncValue.error(error, StackTrace.current);
    }
  }
}
