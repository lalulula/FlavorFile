import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/pages/LoginRegisterPages/login_page.dart';
import 'package:flavorfile/render/home_page.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('Snapshot: ${snapshot.connectionState}');
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}
