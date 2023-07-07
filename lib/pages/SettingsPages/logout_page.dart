import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});
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
          child: Column(
        children: [
          Text(
            "설정",
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
          ),
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
              onPressed: () => _logoutDialogBuilder(context),
              child: Text(
                "레시피북 정리하기",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              )),
          TextButton(
              onPressed: () => _logoutDialogBuilder(context),
              child: Text(
                "사용자 정보",
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black),
              ))
        ],
      )),
    );
  }
}
