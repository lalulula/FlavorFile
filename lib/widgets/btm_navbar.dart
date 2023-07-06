import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BtmNavBar extends StatefulWidget {
  const BtmNavBar({super.key, required this.onTabSelected});
  final Function(int) onTabSelected;

  @override
  State<BtmNavBar> createState() => _BtmNavBarState();
}

Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

class _BtmNavBarState extends State<BtmNavBar> {
  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        color: Theme.of(context).canvasColor,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (int index) {
          widget.onTabSelected(index);
        },
        items: const [
          // Icon(
          //   Icons.bookmark_border_rounded,
          //   color: Colors.black54,
          // ),
          Icon(
            CupertinoIcons.book,
            color: Colors.black54,
          ),
          Icon(
            CupertinoIcons.search,
            color: Colors.black54,
          ),
          Icon(
            Icons.settings,
            color: Colors.black54,
          ),
        ]);
  }
}
