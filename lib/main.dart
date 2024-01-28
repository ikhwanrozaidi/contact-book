import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import 'bloc/tab/tab_bloc.dart';
import 'bloc/user/user_bloc.dart';
import 'repository/user_repository.dart';
import 'screens/contact_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(userRepository: userRepository),
        ),
        BlocProvider<TabBloc>(
          create: (context) => TabBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Contact List',
        theme: ThemeData(
          textTheme: GoogleFonts.ralewayTextTheme(),
          primaryColor: const Color.fromARGB(255, 50, 186, 165),
        ),
        home: ContactScreen(users: []),
      ),
    );
  }
}
