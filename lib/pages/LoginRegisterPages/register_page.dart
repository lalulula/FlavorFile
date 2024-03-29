import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/pages/LoginRegisterPages/login_page.dart';
import 'package:flavorfile/render/auth_page.dart';
import 'package:flavorfile/services/auth_service.dart';
import 'package:flavorfile/widgets/custom_buttons.dart';
import 'package:flavorfile/widgets/other_auth_btn.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _pwdConfirmController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  late bool _passwordNotMatch = false;
  @override
  void initState() {
    super.initState();
    _passwordNotMatch = false;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _pwdController.dispose();
    _pwdConfirmController.dispose();
    super.dispose();
  }

  bool passwordConfirmed() {
    if (_pwdConfirmController.text.trim() == _pwdController.text.trim()) {
      return true;
    } else {
      print("비밀번호 오류");
      setState(() {
        _passwordNotMatch = true;
      });
      return false;
    }
  }

  Future<void> register() async {
    if (_usernameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('사용자 이름과 이메일을 입력해주세요.'),
        ),
      );
      return;
    }

    if (passwordConfirmed()) {
      showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Lottie.network(
              "https://assets1.lottiefiles.com/packages/lf20_ubewyam5.json",
            ),
          );
        },
      );
      try {
        final userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _pwdController.text.trim(),
        );
        final uid = userCredential.user!.uid;
        await addUserDetails(
          _usernameController.text.trim(),
          _emailController.text.trim(),
          uid,
        );
        Navigator.pop(context);
        setState(() {});
        // _navigateToLoginPage();
      } catch (e) {
        print('Registration error: $e');
      } finally {
        Navigator.pop(context);
      }
    }
  }

  Future<void> addUserDetails(String username, String email, String uid) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'username': username, 'email': email, 'recipes': []});
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: 500,
      height: 700,
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
          child: Column(
            children: [
              Text(
                "이메일로 회원가입하기",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenWidth * 3 / 4,
                child: TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: false,
                      prefixIcon: const Icon(CupertinoIcons.textformat_abc),
                      labelText: '사용자이름',
                      labelStyle: const TextStyle(color: Colors.grey)),
                ),
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
                      prefixIcon: const Icon(CupertinoIcons.mail),
                      labelText: '이메일',
                      labelStyle: const TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenWidth * 3 / 4,
                child: TextField(
                  controller: _pwdController,
                  obscureText: true,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: false,
                      prefixIcon: const Icon(CupertinoIcons.padlock),
                      labelText: '비밀번호',
                      labelStyle: const TextStyle(color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: screenWidth * 3 / 4,
                child: TextField(
                  controller: _pwdConfirmController,
                  obscureText: true,
                  decoration: InputDecoration(
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      fillColor: Colors.grey.shade200,
                      filled: false,
                      prefixIcon: const Icon(CupertinoIcons.padlock),
                      labelText: '비밀번호 확인',
                      labelStyle: const TextStyle(color: Colors.grey)),
                ),
              ),
              if (_passwordNotMatch)
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 50, 0),
                    child: Text(
                      "이메일 또는 비밀번호가 일치하지 않습니다",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
              CustomButtons(onTap: register, buttonName: "회원가입"),
              const SizedBox(height: 30),
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
                        child: Text("다른 방법으로 회원가입")),
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
              OtherAuthentication(
                  screenWidth: screenWidth,
                  imagePath: 'assets/images/google.png',
                  btnText: "Gmail로 로그인하기",
                  authFunction: () =>
                      GoogleAuthService().signInWithGoogle(context)),
              const SizedBox(height: 10),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "이미 회원이신가요?",
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
    );
  }
}
