import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<List<dynamic>> fetchUserRecipes() async {
  final user = FirebaseAuth.instance.currentUser!;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final snapshot = await userCollection.doc(user.uid).get();
  final userData = snapshot.data() as Map<String, dynamic>?;

  if (userData == null || !userData.containsKey('recipes')) {
    return [];
  }

  final recipeIds = userData['recipes'] as List<dynamic>;

  final List<Future<Map<String, dynamic>>> recipeFutures =
      recipeIds.map((recipeId) => fetchRecipeData(recipeId)).toList();

  final List<Map<String, dynamic>> recipes = await Future.wait(recipeFutures);

  return recipes;
}

Future<Map<String, dynamic>> fetchRecipeData(String recipeId) async {
  final CollectionReference recipeCollection =
      FirebaseFirestore.instance.collection('recipes');

  final snapshot = await recipeCollection.doc(recipeId).get();
  final recipeData = snapshot.data() as Map<String, dynamic>?;

  return recipeData ?? {};
}
