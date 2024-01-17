import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavorfile/render/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  Future<void> addUserDetails(
      BuildContext context, String username, String email, String uid) async {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .set({'username': username, 'email': email, 'recipes': []});
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  Future<UserCredential?> signInWithGoogle(BuildContext context) async {
    try {
      // Begin interactive sign-in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      print('Current User is $gUser');
      if (gUser == null) {
        // User canceled the sign-in flow
        print('User canceled the sign-in flow');
        return null;
      }
      // Obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser.authentication;
      // Create a new credential for user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      // Sign in
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get the user details
      final User? user = userCredential.user;

      if (user != null) {
        // User is signed in, add details to Firestore
        await addUserDetails(
            context, user.displayName ?? '', user.email ?? '', user.uid);
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuthException (e.g., sign-in error, account disabled)
      print('Firebase Auth error: ${e.message}');
      return null;
    } catch (e) {
      // Handle other exceptions or errors
      print('Error occurred: $e');
      return null;
    }
  }
}
