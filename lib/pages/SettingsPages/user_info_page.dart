import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/services/user_services.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  const UserInfo({super.key});
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _logoutDialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "로그아웃",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 25, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            content: SizedBox(
              height: 100,
              child: Column(
                children: [
                  Text(
                    "로그아웃 하시겠습니까?",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontSize: 18, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "아니요",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () async {
                            await logout();
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "로그아웃",
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.red),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: fetchUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      final userData = snapshot.data as Map<String, dynamic>;
                      final username = userData['username'];
                      final email = userData['email'];
                      final noRecipe = userData['recipes'].length;
                      return Column(children: [
                        const Text("This is where the image is going to be"),
                        Text(username),
                        Text(email),
                        Text(noRecipe.toString())
                      ]);
                    } else {
                      return const Text('No user data found.');
                    }
                  }),
              TextButton(
                  onPressed: () => _logoutDialogBuilder(context),
                  child: Text(
                    "로그아웃",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  )),
              TextButton(
                  onPressed: () {
                    print("회원탈퇴");
                  },
                  child: Text(
                    "회원탈퇴하기",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  )),
            ],
          ),
        ),
      )),
    );
  }
}
