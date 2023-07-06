import 'package:chat_application/models/user.dart';
import 'package:chat_application/utils/router/routesName.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'firebaseUser.dart';

class Auth {
  static User? get currentUser => FirebaseAuth.instance.currentUser;

  static Stream<User?> get authStateChanges =>
      FirebaseAuth.instance.authStateChanges();

  static Future createUserWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await value.user?.updateDisplayName(displayName);
        UserModel userM = UserModel(
            email: email,
            name: displayName,
            photoUrl: value.user?.photoURL,
            id: value.user?.uid);
        await FbUser.create(userM);
      });

      await FirebaseAuth.instance.signOut();
    } on FirebaseException catch (e) {
      throw ("Error creating FirebaseException: ${e.message}");
    } catch (e) {
      throw ("createUser error: $e");
    }
  }

  static Future signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      if (email.isEmpty || password.isEmpty) {
        throw ("Email or password is null");
      } else {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      }
    } on FirebaseException catch (e) {
      throw ("Error creating FirebaseException: ${e.message}");
    } on PlatformException catch (e) {
      throw ("PlatformException error: $e");
    } catch (e) {
      throw ("createUser error: $e");
    }
  }

  static Future signOut(BuildContext context) async {
    try {
      await FbUser.updateOnline(Auth.currentUser!.uid, false);
      final bool isGoogleSignedIn = currentUser!.providerData
          .any((element) => element.providerId == "google.com");
      if (isGoogleSignedIn) {
        await GoogleSignIn().signOut();
      } else {
        await FirebaseAuth.instance.signOut();
      }
      Navigator.pushNamedAndRemoveUntil(
          context, RoutesName.DEFAULT, (route) => false);
    } on FirebaseException catch (e) {
      throw ("Error creating FirebaseException: ${e.message}");
    } catch (e) {
      throw ("createUser error: $e");
    }
  }

  static Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignInAccount?.authentication;

      final AuthCredential authCredential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(authCredential);

      final User? user = userCredential.user;
      return user;
    } catch (e) {
      throw ("SignInWithGoole failed: $e");
    }
  }

  static Future<bool> isEmailRegistered(String email) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // Nếu danh sách phương thức liên kết email không trống,
      // nghĩa là địa chỉ email này đã được đăng ký với tài khoản khác.
      if (methods.isNotEmpty) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      // Xử lý lỗi nếu có
      throw ("Error FirebaseAuthException isEmailRegistered:\nCode: ${e.code}\nMessage: ${e.message}");
    } catch (e) {
      throw ("Error Exception isEmailRegistered $e");
    }
  }
}
