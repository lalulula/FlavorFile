import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/pages/LoginRegisterPages/forgot_pwd_page.dart';
import 'package:flavorfile/pages/LoginRegisterPages/register_page.dart';
import 'package:flavorfile/widgets/custom_buttons.dart';
import 'package:flavorfile/widgets/square_tile.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  late bool _passwordObscure;

  @override
  void initState() {
    super.initState();
    _passwordObscure = true;
  }

  Future<void> login() async {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Lottie.network(
                  "https://assets1.lottiefiles.com/packages/lf20_ubewyam5.json"));
        });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _pwdController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("user not found");
      } else if (e.code == 'wrong-password') {
        print('wrong password');
      }
    }
    Navigator.pop(context);
  }

  Future<void> showRegisterDialog(BuildContext context) async {
    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Register",
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          contentPadding: EdgeInsets.zero,
          content: const RegisterPage(),
        );
      },
    );
  }

  @override
  void dispose() {
    _pwdController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        const RiveAnimation.asset('assets/rive/foodloading.riv'),
        Positioned.fill(
          child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: const SizedBox()),
        ),
        SafeArea(
            child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Flavor File",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 60)),
                Text(
                  "모든 레시피를 한 곳에",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontSize: 20),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: screenWidth * 3 / 4,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        fillColor: Colors.grey.shade200,
                        filled: false,
                        labelText: '이메일',
                        labelStyle: const TextStyle(color: Colors.grey)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: screenWidth * 3 / 4,
                  child: TextField(
                    controller: _pwdController,
                    obscureText: _passwordObscure,
                    decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: false,
                      labelStyle: const TextStyle(color: Colors.grey),
                      labelText: '비밀번호',
                      suffixIcon: IconButton(
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              _passwordObscure = !_passwordObscure;
                            });
                          },
                          icon: _passwordObscure
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const ForgotPasswordPage();
                            },
                          );
                        },
                        child: Text(
                          "비밀번호를 잊으셨나요?",
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15,
                                  decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                CustomButtons(onTap: login, buttonName: "로그인"),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade400,
                          thickness: 1,
                        ),
                      ),
                      const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text("다른 방법으로 로그인")),
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade400,
                          thickness: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(imagePath: 'assets/images/kakaotalk.png'),
                    SizedBox(width: 10),
                    SquareTile(imagePath: 'assets/images/google.png'),
                    SizedBox(width: 10),
                    SquareTile(imagePath: 'assets/images/applelogo.png'),
                  ],
                ),
                const SizedBox(height: 10),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    showRegisterDialog(context);
                  },
                  child: Text(
                    "회원가입하기",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ),
        )),
      ]),
    );
  }
}
