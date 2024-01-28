// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../bloc/tab/tab_bloc.dart';
import '../bloc/tab/tab_event.dart';
import '../bloc/tab/tab_state.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../bloc/user/user_state.dart';
import '../models/user_model.dart';
import '../repository/user_repository.dart';
import '../widget/addcontact_bottomsheet.dart';
import 'editprofile_screen.dart';
import 'profile_screen.dart';

class ContactScreen extends StatefulWidget {
  final List<User> users;

  ContactScreen({required this.users});

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    context
        .read<UserBloc>()
        .add(SearchUsers(searchTerm: _searchController.text));
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    Color hoidefault = const Color.fromARGB(255, 50, 186, 165);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 50, 186, 165),
        title: Text(
          'My Contacts',
          style: GoogleFonts.raleway(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.sync,
              color: Colors.white,
            ),
            onPressed: () {
              BlocProvider.of<UserBloc>(context).add(FetchAllUsers());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey.shade300,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              margin:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search Contact',
                  suffixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: BlocBuilder<TabBloc, TabState>(
              builder: (context, state) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildTabButton(context, 'All', 0, state.selectedTabIndex),
                    const SizedBox(width: 15),
                    _buildTabButton(
                        context, 'Favourite', 1, state.selectedTabIndex),
                  ],
                );
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<TabBloc, TabState>(
              builder: (context, state) {
                if (state.selectedTabIndex == 0) {
                  return BlocBuilder<UserBloc, UserState>(
                    builder: (context, userState) {
                      if (userState is UsersLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (userState is UsersLoaded) {
                        return _contactListtile(userState);
                      } else {
                        return Column(
                          children: [
                            SizedBox(height: 50),
                            Lottie.asset('assets/contact_list.json',
                                height: h / 5),
                            const Text('Sync all your contact to start'),
                          ],
                        );
                      }
                    },
                  );
                } else if (state.selectedTabIndex == 1) {
                  return BlocBuilder<UserBloc, UserState>(
                    builder: (context, userState) {
                      if (userState is UsersLoaded) {
                        var favoriteUsers = userState.users
                            .where((user) => user.favourite)
                            .toList();
                        if (favoriteUsers.isNotEmpty) {
                          return ListView.builder(
                            itemCount: favoriteUsers.length,
                            itemBuilder: (context, index) {
                              var user = favoriteUsers[index];
                              return Slidable(
                                endActionPane: ActionPane(
                                  motion: const DrawerMotion(),
                                  children: [
                                    SlidableAction(
                                      onPressed: (BuildContext context) {},
                                      backgroundColor: Colors.teal.shade300,
                                      foregroundColor: Colors.white,
                                      icon: Icons.edit,
                                      label: 'Edit',
                                    ),
                                    SlidableAction(
                                      onPressed: (BuildContext context) {},
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                      icon: Icons.delete,
                                      label: 'Delete',
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user.avatar ?? ''),
                                  ),
                                  title: Row(
                                    children: [
                                      Text(user.firstName ?? ''),
                                      const SizedBox(width: 5),
                                      Icon(
                                        Icons.star,
                                        color: user.favourite
                                            ? Colors.yellow.shade600
                                            : Colors.transparent,
                                        size: 12,
                                      ),
                                    ],
                                  ),
                                  subtitle: Text(user.email ?? ''),
                                  trailing: const Icon(
                                    Icons.telegram,
                                    color: Color.fromARGB(255, 50, 186, 165),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                          userId: user.id ?? 0,
                                          firstname: user.firstName ?? '',
                                          lastname: user.lastName ?? '',
                                          email: user.email ?? '',
                                          imageUrl: user.avatar ?? '',
                                        ),
                                      ),
                                    );
                                  },
                                  onLongPress: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(user.favourite
                                              ? 'Remove as Favourite'
                                              : 'Add as Favourite'),
                                          content: Text(user.favourite
                                              ? 'Do you want to remove ${user.firstName} as your favourite contact?'
                                              : 'Do you want to add ${user.firstName} as your favourite contact?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);

                                                BlocProvider.of<UserBloc>(
                                                        context)
                                                    .add(ToggleUserFavorite(
                                                        userId: user.id!));
                                              },
                                              child: const Text('Yes'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return Column(
                            children: [
                              SizedBox(height: 50),
                              Lottie.asset('assets/contact_list.json',
                                  height: h / 5),
                              const Text(
                                  'Add to Favourite by long press the contact'),
                            ],
                          );
                        }
                      } else {
                        return Column(
                          children: [
                            SizedBox(height: 50),
                            Lottie.asset('assets/contact_list.json',
                                height: h / 5),
                            const Text(
                                'Add to Favourite by long press the contact'),
                          ],
                        );
                      }
                    },
                  );
                } else {
                  return Column(
                    children: [
                      SizedBox(height: 50),
                      Lottie.asset('assets/contact_list.json', height: h / 5),
                      const Text('Sync all your contact for start'),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 9, 145, 124),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return ContactInputSheet();
            },
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
      ),
    );
  }

  _buildTabButton(
      BuildContext context, String title, int index, int selectedIndex) {
    final bool isActive = index == selectedIndex;
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: isActive ? Colors.teal : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        side: const BorderSide(color: Colors.teal),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.teal,
          // fontSize: 15,
        ),
      ),
      onPressed: () {
        BlocProvider.of<TabBloc>(context).add(TabUpdated(index));
      },
    );
  }

  _contactListtile(userState) {
    return ListView.builder(
      itemCount: userState.users.length,
      itemBuilder: (context, index) {
        var user = userState.users[index];
        return Slidable(
          endActionPane: ActionPane(
            motion: const DrawerMotion(),
            children: [
              SlidableAction(
                onPressed: (BuildContext context) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        userId: user.id ?? 0,
                        firstname: user.firstName ?? '',
                        lastname: user.lastName ?? '',
                        email: user.email ?? '',
                        imageUrl: user.avatar ?? '',
                      ),
                    ),
                  );
                },
                backgroundColor: Colors.teal.shade300,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Edit',
              ),
              SlidableAction(
                onPressed: (BuildContext context) {
                  if (user.id != null) {
                    final userBloc = BlocProvider.of<UserBloc>(context);
                    userBloc.add(DeleteUserEvent(user.id!));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Unable to delete user without an ID.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.avatar ?? ''),
            ),
            title: Row(
              children: [
                Text(user.firstName ?? ''),
                const SizedBox(width: 5),
                Icon(
                  Icons.star,
                  color: user.favourite
                      ? Colors.yellow.shade600
                      : Colors.transparent,
                  size: 12,
                ),
              ],
            ),
            subtitle: Text(user.email ?? ''),
            trailing: const Icon(
              Icons.telegram,
              color: Color.fromARGB(255, 50, 186, 165),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    userId: user.id ?? 0,
                    firstname: user.firstName ?? '',
                    lastname: user.lastName ?? '',
                    email: user.email ?? '',
                    imageUrl: user.avatar ?? '',
                  ),
                ),
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(user.favourite
                        ? 'Remove as Favourite'
                        : 'Add as Favourite'),
                    content: Text(user.favourite
                        ? 'Do you want to remove ${user.firstName} as your favourite contact?'
                        : 'Do you want to add ${user.firstName} as your favourite contact?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);

                          BlocProvider.of<UserBloc>(context)
                              .add(ToggleUserFavorite(userId: user.id!));
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
