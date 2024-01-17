import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/pages/SettingsPages/settings_styles.dart';
import 'package:flavorfile/render/auth_page.dart';
import 'package:flavorfile/services/user_services.dart';
import 'package:flutter/material.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  // final btnStyle = ButtonStyle(
  //     backgroundColor: MaterialStatePropertyAll(Colors.grey.shade100));

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
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const AuthPage(), // Replace with your landing page
                              ),
                            );
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
    final screenWidth = MediaQuery.of(context).size.width;
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
                        const SizedBox(height: 30),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/images/default_profile.jpg',
                            height: 200,
                            width: 200,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            width: screenWidth * 3 / 4,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    width: 3, color: Colors.grey.shade200)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("사용자 이름",
                                      style: dataIndicatorStyle),
                                  const SizedBox(height: 5),
                                  Text(username, style: dataTextStyle),
                                  const Divider(thickness: 1),
                                  const Text("이메일", style: dataIndicatorStyle),
                                  const SizedBox(height: 5),
                                  Text(email, style: dataTextStyle),
                                  const Divider(thickness: 1),
                                  const Text("레시피 개수",
                                      style: dataIndicatorStyle),
                                  const SizedBox(height: 5),
                                  Text(noRecipe.toString(),
                                      style: dataTextStyle)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ]);
                    } else {
                      return const Text('No user data found.');
                    }
                  }),
              TextButton(
                  style: btnStyle,
                  onPressed: () => _logoutDialogBuilder(context),
                  child: Text(
                    "로그아웃",
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.black),
                  )),
              // TextButton(
              //     style: btnStyle,
              //     onPressed: () {
              //       print("회원탈퇴");
              //     },
              //     child: Text(
              //       "회원탈퇴하기",
              //       style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              //           fontSize: 18,
              //           fontWeight: FontWeight.w400,
              //           color: Colors.black),
              //     )),
            ],
          ),
        ),
      )),
    );
  }
}
