import 'package:flavorfile/render/intro_page.dart';
import 'package:flavorfile/render/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'Noto Sans KR'),
          bodySmall: TextStyle(
              fontFamily: 'SanFrancisco', fontWeight: FontWeight.normal),
        ),
        // scaffoldBackgroundColor: const Color.fromARGB(255, 165, 193, 240),
        scaffoldBackgroundColor: Colors.white,
        // scaffoldBackgroundColor: const Color.fromARGB(244, 244, 244, 255),
        canvasColor: Colors.indigo.shade200,
      ),
      home: const IntroPage(),
      routes: {
        '/intro': (context) => const IntroPage(),
        '/auth': (context) => const AuthPage(),
      },
    );
  }
}
