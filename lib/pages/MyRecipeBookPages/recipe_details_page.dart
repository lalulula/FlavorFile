import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/functions/recipe_detail_function.dart';
import 'package:flavorfile/pages/MyRecipeBookPages/edit_recipe_page.dart';
import 'package:flavorfile/render/home_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class RecipeDetailPage extends StatefulWidget {
  RecipeDetailPage({
    Key? key,
    required this.recipeData,
    required this.recipeId,
  }) : super(key: key);

  late Map<String, dynamic> recipeData;
  final String? recipeId;

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    _pageController =
        PageController(initialPage: _currentPage, viewportFraction: 0.8);
    super.initState();
  }

  Future<void> _deleteRecipe() async {
    final recipeId = widget.recipeId;
    final user = FirebaseAuth.instance.currentUser!;
    showDialog(
        context: context,
        builder: (context) {
          return Center(
              child: Lottie.network(
                  "https://assets10.lottiefiles.com/packages/lf20_R2MChv.json"));
        });
    try {
      await FirebaseFirestore.instance
          .collection('recipes')
          .doc(recipeId)
          .delete();
      final userRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userRef.get();
      final recipeIds = List<String>.from(userDoc.data()!['recipes']);
      recipeIds.remove(recipeId);

      await userRef.update({'recipes': recipeIds});
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
        (route) => false,
      );
      print('Recipe deleted successfully');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipeImages = widget.recipeData['recipeImage'] as List<dynamic>;
    print(widget.recipeData["order"].isEmpty);
    print(widget.recipeData["recipeName"]);
    print(widget.recipeData["ingredients"]);
    print(recipeImages.isEmpty);
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              //APP BAR
              Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.symmetric(horizontal: 18),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  color: Colors.indigo.shade200,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_back, color: Colors.black),
                            const SizedBox(width: 10),
                            Text(
                              "레시피 홈",
                              style: Theme.of(context).textTheme.bodyLarge,
                            )
                          ],
                        ),
                        onTap: () async {
                          final updatedRecipeData =
                              await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const HomePage()),
                            (route) => false,
                          );
                          if (updatedRecipeData != null) {
                            setState(() {
                              widget.recipeData = updatedRecipeData;
                            });
                            Navigator.pop(context, updatedRecipeData);
                          }
                        }),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const SizedBox(width: 20),
                        GestureDetector(
                            onTap: () async {
                              final updatedRecipeData = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditRecipePage(
                                    initialRecipeData: widget.recipeData,
                                    recipeId: widget.recipeId,
                                  ),
                                ),
                              );

                              if (updatedRecipeData != null) {
                                // Update page with the new recipe data
                                setState(() {
                                  widget.recipeData = updatedRecipeData;
                                });
                              }
                            },
                            child: const Icon(Icons.mode_edit_outline_rounded)),
                        const SizedBox(width: 20),
                        GestureDetector(
                            onTap: _deleteRecipe,
                            child: const Icon(Icons.delete_forever_outlined))
                      ],
                    )
                  ],
                ),
              ),
              //RECIPE CONTENTS
              Column(
                children: [
                  const SizedBox(height: 15),
                  widget.recipeData['recipeName'] == ""
                      ? const Text("레시피 이름을 입력하세요")
                      : Text(
                          widget.recipeData['recipeName'],
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                  const SizedBox(height: 10),
                  recipeImages.isEmpty
                      ? const Text("레시피 수정하기로 완성된 음식사진을 올려보세요!")
                      : SizedBox(
                          height: 300,
                          child: PageView.builder(
                            itemCount: recipeImages.length,
                            pageSnapping: true,
                            controller: _pageController,
                            onPageChanged: (index) {
                              setState(() {
                                _currentPage = index;
                              });
                            },
                            itemBuilder: (context, index) {
                              final image = recipeImages[index];
                              bool active = index == _currentPage;
                              return imageSlider(image, _currentPage, active,
                                  index, widget.recipeId);
                            },
                          ),
                        ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:
                        imageIndicators(recipeImages.length, _currentPage),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: () => dialogBuilder(context, widget.recipeData),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        child: const Text("재료 확인하기",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 15)),
                      )),
                  const SizedBox(height: 20),
                  widget.recipeData["order"].isEmpty
                      ? const Text("레시피 순서를 추가해보세요!")
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final recipe
                                in widget.recipeData['order'].asMap().entries)
                              Text(
                                '${recipe.key + 1}. ${recipe.value}\n',
                                style: const TextStyle(fontSize: 20),
                                textAlign: TextAlign.left,
                              ),
                          ],
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
