import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/user_model.dart';
import 'user_event.dart';
import 'user_state.dart';
import '../../repository/user_repository.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  List<User> userList = [];

  UserBloc({required this.userRepository}) : super(UsersInitial()) {
    // on<FetchUsers>(_onFetchUsers);
    on<FetchAllUsers>(_onFetchAllUsers);
    on<ToggleUserFavorite>(_onToggleUserFavorite);
    on<SearchUsers>(_onSearchUsers);
    on<CreateUser>(_onCreateUser);
    on<DeleteUserEvent>(_onDeleteUser);
    on<UpdateUserEvent>(_onUpdateUser);
  }

  // Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
  //   emit(UsersLoading());
  //   try {
  //     final users = await userRepository.fetchUsers(event.page);
  //     emit(UsersLoaded(users: users));
  //   } catch (error) {
  //     emit(UsersError());
  //   }
  // }

  Future<void> _onFetchAllUsers(
      FetchAllUsers event, Emitter<UserState> emit) async {
    emit(UsersLoading());
    try {
      final users = await userRepository.fetchAllUsers();
      userList = users;
      emit(UsersLoaded(users: users));
    } catch (error) {
      emit(UsersError());
    }
  }

  Future<void> _onToggleUserFavorite(
      ToggleUserFavorite event, Emitter<UserState> emit) async {
    if (state is UsersLoaded) {
      final users = (state as UsersLoaded).users;
      final updatedUsers = users.map((user) {
        if (user.id == event.userId) {
          return user.copyWith(favourite: !user.favourite);
        }
        return user;
      }).toList();

      emit(UsersLoaded(users: updatedUsers));
    }
  }

  Future<void> _onSearchUsers(
      SearchUsers event, Emitter<UserState> emit) async {
    if (state is UsersLoaded ||
        state is UsersInitial ||
        state is UsersLoading) {
      final filteredUsers = userList.where((user) {
        return user.firstName!
                .toLowerCase()
                .contains(event.searchTerm.toLowerCase()) ||
            user.lastName!
                .toLowerCase()
                .contains(event.searchTerm.toLowerCase());
      }).toList();

      emit(UsersLoaded(users: filteredUsers));
    }
  }

  Future<void> _onCreateUser(CreateUser event, Emitter<UserState> emit) async {
    try {
      final newUser = await userRepository.createUser(event.user.toJson());
      userList.add(newUser);

      emit(UsersLoaded(users: userList));
    } catch (error) {
      emit(UsersError());
    }
  }

  void _onDeleteUser(DeleteUserEvent event, Emitter<UserState> emit) async {
    try {
      await userRepository.deleteUser(event.userId);
      userList.removeWhere((user) => user.id == event.userId);
      emit(UsersLoaded(users: userList));
    } catch (e) {
      emit(UsersError());
    }
  }

  void _onUpdateUser(UpdateUserEvent event, Emitter<UserState> emit) async {
    try {
      Map<String, dynamic> updatedUserData = {
        'firstName': event.firstName,
        'lastName': event.lastName,
        'email': event.email,
      };
      await userRepository.updateUser(event.userId, updatedUserData);
      int userIndex = userList.indexWhere((user) => user.id == event.userId);
      if (userIndex != -1) {
        User updatedUser = userList[userIndex].copyWith(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
        );
        userList[userIndex] = updatedUser;

        emit(UsersLoaded(users: List.from(userList)));
      }
    } catch (e) {
      emit(UsersError());
    }
  }
}
