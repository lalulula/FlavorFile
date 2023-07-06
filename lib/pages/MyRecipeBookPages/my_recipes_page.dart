import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/pages/MyRecipeBookPages/add_recipe_page.dart';
import 'package:flavorfile/services/user_services.dart';
import 'package:flavorfile/widgets/recipe_cover.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyRecipePage extends StatefulWidget {
  const MyRecipePage({super.key});

  @override
  State<MyRecipePage> createState() => _MyRecipePageState();
}

class _MyRecipePageState extends State<MyRecipePage> {
  final user = FirebaseAuth.instance.currentUser!;
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FutureBuilder<List<dynamic>>(
              future: fetchUserRecipes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Lottie.network(
                      "https://assets6.lottiefiles.com/packages/lf20_6yhhrbk6.json",
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Text(
                    "레시피를 불러오는데 오류가 발생했습니다, 잠시후에 다시 사용해주세요",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 15),
                  );
                }
                final recipeRef = snapshot.data ?? [];

                return recipeRef.isEmpty
                    ? const Text("아래 버튼을 눌러 나만의 레시피북을 만들어 보세요!")
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 100,
                            ),
                            Row(
                              children: recipeRef.map((recipeId) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder<
                                      DocumentSnapshot<Map<String, dynamic>>>(
                                    future: fetchRecipeData(recipeId),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: Lottie.network(
                                            "https://assets6.lottiefiles.com/packages/lf20_6yhhrbk6.json",
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Text(
                                          "레시피를 불러오는데 오류가 발생했습니다, 잠시후에 다시 사용해주세요",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                              ),
                                        );
                                      }
                                      final recipeData = snapshot.data?.data();
                                      final recipeId = snapshot.data?.id;

                                      return RecipeCover(
                                        recipeData: recipeData ?? {},
                                        recipeId: recipeId ?? '',
                                      );
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
              },
            ),
            FloatingActionButton(
              backgroundColor: Colors.indigo.shade100.withOpacity(0.8),
              onPressed: navigateToRecipeUploadPage,
              child: Icon(
                CupertinoIcons.add,
                size: 40,
                color: Colors.black87.withOpacity(0.7),
              ),
            )
          ],
        ),
      ),
    );
  }
}
