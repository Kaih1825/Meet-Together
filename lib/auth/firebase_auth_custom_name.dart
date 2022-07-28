import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/information.dart';

Future<bool> signInAnonymously(BuildContext context) async {
  
  bool res=false;
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
    res=true;
    information.name="匿名";
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print(e.message);
    }
  }
  return res;
}
