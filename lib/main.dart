import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/contact_screen.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hoi ContactBook',
      theme: ThemeData(
        textTheme: GoogleFonts.ralewayTextTheme(),
        primaryColor: const Color.fromARGB(255, 50, 186, 165),
        useMaterial3: true,
      ),
      home: ContactScreen(
        users: const [],
      ),
    );
  }
}
