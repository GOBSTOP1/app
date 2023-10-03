import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_auth/screens/account_screen.dart';
import 'package:flutter_firebase_auth/screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Главная страница'),
        leading: IconButton(
          onPressed: () {
            if (user == null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AccountScreen()),
              );
            }
          },
          icon: const Icon(
            Icons.person,
          ),
        ),
      ),
      body: const SafeArea(
        child: Center(
          child: Column(
            children: [
              Text("Общий контент для всех пользователей"),
            ],
          ),
        ),
      ),
    );
  }
}
