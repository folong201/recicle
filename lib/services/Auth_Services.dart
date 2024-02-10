import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:recicle/services/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  //  shp = HelperFunction;
  // Future<UserCredential> RegisterWithEmailAndPassword(
  Future RegisterWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      //petite mis a our du user
      await credential.user!.sendEmailVerification();
      await credential.user!.updateDisplayName(emailAddress.split('@')[0]);
      // creation du user dans le firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'email': credential.user!.email,
        'displayName': credential.user!.displayName,
        'photoURL': credential.user!.photoURL,
        'uid': credential.user!.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print("registration successfully executer");
      print(credential.toString());
      return signInWithEmailAndPassword(emailAddress, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  // Future<UserCredential> signInWithEmailAndPassword(
  Future signInWithEmailAndPassword(
      String emailAddress, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: emailAddress, password: password);
      print("signin okay");
      print(credential);
      //set shared preference
      print("saving user logged in");
      await HelperFunction.saveUserLoggedInSharedPreference(true);
      print(credential.user!.email!);
      await HelperFunction.saveUserEmailSharedPreference(
          credential.user!.email!);
      //set userid in shared preference
      await HelperFunction.saveUserUIDSharedPreference(credential.user!.uid);
      print(credential.user!.uid!);
      if (credential.user!.displayName != null) {
        print(credential.user!.displayName!);
        // Check if displayName is not null before saving
        await HelperFunction.saveUserNameSharedPreference(
            credential.user!.displayName!);
      }

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
    await HelperFunction.saveUserLoggedInSharedPreference(false);
    await HelperFunction.saveUserEmailSharedPreference("");
    await HelperFunction.saveUserNameSharedPreference("");
    await HelperFunction.saveUserUIDSharedPreference("");
  }

  Future<void> resetPassword(String email) async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> sendEmailVerification() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.sendEmailVerification();
  }

  Future<void> reloadUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
  }

  Future<void> deleteUser() async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.delete();
  }

  Future<void> updatePassword(String password) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.updatePassword(password);
  }
}
