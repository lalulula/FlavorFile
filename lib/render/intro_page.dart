import 'dart:async';
import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/auth');
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: RiveAnimation.asset('assets/rive/foodloading.riv'))
        // body: Center(
        //   child: Lottie.network(
        //       "https://assets4.lottiefiles.com/packages/lf20_szviypry.json"),
        // ),
        );
  }
}
