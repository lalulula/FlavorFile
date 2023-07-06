import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/pages/MyRecipeBookPages/add_recipe_page.dart';
// import 'package:flavorfile/pages/bookmark_page.dart';
import 'package:flavorfile/pages/MyRecipeBookPages/my_recipes_page.dart';
import 'package:flavorfile/pages/setting_page.dart';
import 'package:flavorfile/pages/ShareRecipePages/share_recipe_page.dart';
import 'package:flavorfile/widgets/btm_navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static List<Widget> pages = [
    // const BookMarkPage(),
    const MyRecipePage(),
    const ShareRecipePage(),
    const SettingPage(),
  ];
  final user = FirebaseAuth.instance.currentUser!;

  Future<void> refreshData() async {
    setState(() {});
  }

  void navigateToRecipeUploadPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddRecipePage()),
    ).then((_) {
      refreshData();
    });
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> fetchRecipeData(
      String recipeId) async {
    final CollectionReference<Map<String, dynamic>> recipeCollection =
        FirebaseFirestore.instance.collection('recipes');
    return await recipeCollection.doc(recipeId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar: BtmNavBar(
          onTabSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
