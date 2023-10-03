import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_auth/screens/home_screen.dart';

class FioScreen extends StatefulWidget {
  const FioScreen({Key? key}) : super(key: key);

  @override
  _FioScreenState createState() => _FioScreenState();
}

class _FioScreenState extends State<FioScreen> {
  TextEditingController lastNameController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Метод для отправки инициалов в Firestore
  Future<void> sendFioToFirestore() async {
    if (_formKey.currentState!.validate()) {
      final lastName = lastNameController.text.trim();
      final firstName = firstNameController.text.trim();
      final middleName = middleNameController.text.trim();

      // Получите доступ к Firestore
      final firestore = FirebaseFirestore.instance; // Создайте объект firestore

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String userUid = user.uid;
        // Теперь вы можете использовать userUid для отправки данных в Firestore
        final userDocRef = firestore.collection('users').doc(userUid);

        // Создайте Map с данными о пользователе
        final userData = {
          'lastName': lastName,
          'firstName': firstName,
          'middleName': middleName,
        };

        // Запишите данные в Firestore
        await userDocRef.set(userData);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // Обработайте ситуацию, когда пользователь не аутентифицирован или его данные недоступны
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Введите инициалы'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: lastNameController,
                decoration: InputDecoration(labelText: 'Фамилия'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите фамилию';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: firstNameController,
                decoration: InputDecoration(labelText: 'Имя'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Пожалуйста, введите имя';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: middleNameController,
                decoration: InputDecoration(labelText: 'Отчество (необязательно)'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Вызовите метод для отправки данных в Firestore при нажатии кнопки
                  sendFioToFirestore();
                },
                child: Text('Сохранить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
