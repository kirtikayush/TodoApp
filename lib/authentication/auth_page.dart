import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/LoginIn.dart';
import 'package:todo_app/ToDo_page.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          ///user is logged in
          if (snapshot.hasData) {
            return TodoPage();
          } else {
            return LoginIn();
          }

          /// user is not logged in
        },
      ),
    );
  }
}
