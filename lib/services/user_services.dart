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

  return userData['recipes'];
}
