import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(

        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // If there's an error, show an error message
          else if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }
          // If the snapshot has data, it means the user is logged in
          else if (snapshot.hasData) {
            return const HomeScreen(); // Show the Home Screen
          }
          // Otherwise, the user is logged out
          else {
            return const LoginScreen(); // Show the Login Screen
          }
        },
      ),
    );
  }
}