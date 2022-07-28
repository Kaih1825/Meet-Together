import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/snackBar.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null){
        //如果線上有人
        if (userCredential.additionalUserInfo!.isNewUser) {
          //如果他是新用戶
          _firestore.collection("user").doc(user.uid).set({
            "username": user.displayName,
            "uid": user.uid,
            "profilePhoto": user.photoURL,
          });
        }
        res = true; //身份驗證已完成
      }
    } on FirebaseAuthException catch (e) //只會抓到驗證錯誤的東西
    {
      showSnackBar(context, e.message!);
      res = false;
    }
    return res;
  }
}
