import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditRecipeBook extends StatefulWidget {
  const EditRecipeBook({Key? key}) : super(key: key);

  @override
  State<EditRecipeBook> createState() => _EditRecipeBookState();
}

class _EditRecipeBookState extends State<EditRecipeBook> {
  List<String> recipes = [];

  @override
  void initState() {
    super.initState();
    fetchUserRecipes();
  }

  Future<void> fetchUserRecipes() async {
    final user = FirebaseAuth.instance.currentUser!;
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    final snapshot = await userCollection.doc(user.uid).get();
    final userData = snapshot.data() as Map<String, dynamic>?;

    if (userData == null || !userData.containsKey('recipes')) {
      return;
    }

    final recipeIds = userData['recipes'] as List<dynamic>;

    final List<Future<Map<String, dynamic>>> recipeFutures =
        recipeIds.map((recipeId) => fetchRecipeData(recipeId)).toList();

    final List<Map<String, dynamic>> fetchedRecipes =
        await Future.wait(recipeFutures);

    setState(() {
      recipes = fetchedRecipes
          .map((recipe) => recipe['recipeName'] as String)
          .toList();
    });
  }

  Future<Map<String, dynamic>> fetchRecipeData(String recipeId) async {
    final CollectionReference recipeCollection =
        FirebaseFirestore.instance.collection('recipes');

    final snapshot = await recipeCollection.doc(recipeId).get();
    final recipeData = snapshot.data() as Map<String, dynamic>?;

    return recipeData ?? {};
  }

  Future<void> updateRecipeOrderInFirestore() async {
    final user = FirebaseAuth.instance.currentUser!;
    final CollectionReference userCollection =
        FirebaseFirestore.instance.collection('users');

    final snapshot = await userCollection.doc(user.uid).get();
    final userData = snapshot.data() as Map<String, dynamic>?;

    if (userData == null || !userData.containsKey('recipes')) {
      return;
    }

    final recipeIds = List<String>.from(userData['recipes']);

    final updatedRecipeIds = recipes
        .asMap()
        .map((index, recipe) {
          final recipeId = recipeIds[index];
          return MapEntry(recipe, recipeId);
        })
        .values
        .toList();

    await userCollection.doc(user.uid).update({
      'recipes': updatedRecipeIds,
    });

    print('Recipe order updated in Firestore!');
    setState(() {
      recipes = recipes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        key: const Key('edit_recipe_book_container'),
        child: Column(
          children: [
            Expanded(
              child: ReorderableListView(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                children: recipes
                    .asMap()
                    .map((index, recipe) => MapEntry(
                          index,
                          ListTile(
                            key: Key('$index'),
                            leading: const Icon(Icons.menu),
                            title: Text(recipe),
                          ),
                        ))
                    .values
                    .toList(),
                onReorder: (oldIndex, newIndex) {
                  setState(() {
                    if (newIndex > oldIndex) {
                      newIndex -= 1;
                    }
                    final recipe = recipes.removeAt(oldIndex);
                    recipes.insert(newIndex, recipe);
                  });
                },
              ),
            ),
            TextButton(
              onPressed: updateRecipeOrderInFirestore,
              child: const Text("레시피 순서 변경"),
            ),
          ],
        ),
      ),
    );
  }
}
