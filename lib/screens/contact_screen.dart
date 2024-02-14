// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../provider/tab/tab_notifier.dart';
import '../provider/user/user_notifier.dart';
import '../widget/addcontact_bottomsheet.dart';
import 'editprofile_screen.dart';
import 'profile_screen.dart';

class ContactScreen extends ConsumerStatefulWidget {
  ContactScreen({Key? key}) : super(key: key);

  @override
  _ContactScreenState createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    ref.read(userNotifierProvider.notifier).searchUsers(_searchController.text);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userNotifierProvider);
    // double h = MediaQuery.of(context).size.height;
    // Color hoidefault = const Color.fromARGB(255, 50, 186, 165);

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
              ref.read(userNotifierProvider.notifier).fetchAllUsers();
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
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(tabNotifierProvider);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildTabButton(
                        context, ref, 'All', 0, state.selectedTabIndex),
                    const SizedBox(width: 15),
                    _buildTabButton(
                        context, ref, 'Favourite', 1, state.selectedTabIndex),
                  ],
                );
              },
            ),
          ),
          Consumer(builder: (context, ref, child) {
            final tabState = ref.watch(tabNotifierProvider);
            final userState = ref.watch(userNotifierProvider);

            if (tabState.selectedTabIndex == 0) {
              if (userState.users?.isNotEmpty ?? false) {
                return _contactListtile(userState, ref);
              } else {
                return Column(
                  children: const [
                    SizedBox(height: 50),
                    Text('Sync all your contacts to start'),
                  ],
                );
              }
            } else if (tabState.selectedTabIndex == 1) {
              var favoriteUsers =
                  userState.users?.where((user) => user.favourite).toList() ??
                      [];
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

                                      ref
                                          .read(userNotifierProvider.notifier)
                                          .toggleUserFavorite(user.id!);
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

            return Text('Page 404');
          }),
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
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
        ref.read(tabNotifierProvider.notifier).updateTab(index);
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
                    ref
                        .read(userNotifierProvider.notifier)
                        .deleteUser(user.id!);
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
                          // BlocProvider.of<UserBloc>(context)
                          //     .add(ToggleUserFavorite(userId: user.id!));
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
