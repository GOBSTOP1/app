import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return _AccountScreenContent();
  }
}

class _AccountScreenContent extends StatefulWidget {
  @override
  State<_AccountScreenContent> createState() => _AccountScreenContentState();
}

class _AccountScreenContentState extends State<_AccountScreenContent> {
  final user = FirebaseAuth.instance.currentUser;
  String userEmail = "";
  String firstName = "";
  String lastName = "";
  String? middleName; 

  @override
  void initState() {
    super.initState();
    if (user != null) {
      fetchUserDataFromFirestore();
    }
  }

  void fetchUserDataFromFirestore() async {
    final firestore = FirebaseFirestore.instance;
    final userDoc = firestore.collection('users').doc(user!.uid); // Добавили ! после user
    final userData = await userDoc.get();

    if (userData.exists) {
      setState(() {
        firstName = userData['firstName'] ?? "";
        lastName = userData['lastName'] ?? "";
        middleName = userData['middleName'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Аккаунт'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Ваш Email: ${user?.email}'),
            Text('Имя: $firstName'),
            Text('Фамилия: $lastName'),
            if (middleName != null) Text('Отчество: $middleName'),
            TextButton(
              onPressed: () => signOut(context),
              child: const Text('Выйти'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(context, '/home', (Route<dynamic> route) => false);
  }
}
