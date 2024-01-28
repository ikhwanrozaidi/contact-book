import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ikhwanrozaidi_hoisystem/screens/editprofile_screen.dart';

class ProfileScreen extends StatelessWidget {
  final String firstname;
  final String lastname;
  final String email;
  final String imageUrl;
  final int userId;

  ProfileScreen({
    Key? key,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.imageUrl,
    required this.userId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color hoidefault = const Color.fromARGB(255, 50, 186, 165);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.raleway(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        backgroundColor: hoidefault,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(
                          userId: userId,
                          firstname: firstname,
                          lastname: lastname,
                          email: email,
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'Edit',
                    style: GoogleFonts.raleway(
                      color: hoidefault,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 120.0,
            height: 120.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
              border: Border.all(
                color: hoidefault,
                width: 3.0,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '$firstname $lastname',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: Center(
              child: Column(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                    size: 50.0,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 15),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: hoidefault,
                shape: const StadiumBorder(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                'Send Email',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
