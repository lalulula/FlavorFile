import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      print(gUser);
      if (gUser == null) {
        // User canceled the sign-in flow
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
      return await FirebaseAuth.instance.signInWithCredential(credential);
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
