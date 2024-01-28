import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_event.dart';
import '../models/user_model.dart';

class ContactInputSheet extends StatefulWidget {
  @override
  _ContactInputSheetState createState() => _ContactInputSheetState();
}

class _ContactInputSheetState extends State<ContactInputSheet> {
  TextEditingController emailController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Color hoidefault = const Color.fromARGB(255, 50, 186, 165);

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'Add Contact',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: hoidefault,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: ElevatedButton(
                onPressed: () {
                  User newUser = User(
                    email: emailController.text,
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    favourite: false,
                  );

                  BlocProvider.of<UserBloc>(context)
                      .add(CreateUser(user: newUser));

                  emailController.clear();
                  firstNameController.clear();
                  lastNameController.clear();
                  Navigator.of(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hoidefault,
                  shape: const StadiumBorder(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Add Contact',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
