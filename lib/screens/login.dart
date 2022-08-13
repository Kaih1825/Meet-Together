import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meet/auth/firebase_auth_google.dart';
import 'package:meet/screens/no_Internet.dart';
import 'package:meet/utils/snackBar.dart';
import 'package:page_animation_transition/animations/right_to_left_faded_transition.dart';
import 'package:page_animation_transition/animations/right_to_left_transition.dart';
import '../utils/color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/firebase_auth_custom_name.dart';
import '../utils/show_AlertDialog.dart';
import '../screens/home_screen.dart';
import '../main.dart';
import 'set_information_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:page_animation_transition/page_animation_transition.dart';

class login_screen extends StatefulWidget {
  const login_screen({Key? key}) : super(key: key);

  @override
  State<login_screen> createState() => _login_screenState();
}

class _login_screenState extends State<login_screen> {
  final AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        // 觸摸收起鍵盤
        //FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        //resizeToAvoidBottomInset: false,  //鍵盤彈出時不會圖片超出
        body: Center(
            child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Theme.of(context).colorScheme.background,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                child:
                    Image.asset('images/meet_login.png', fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "登入",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                  top: 50.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: 0.8),
                        child: Text(
                          "使用 Google 登入",
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          final result =
                              await InternetAddress.lookup('example.com');
                          var ans = result.isNotEmpty &&
                              result[0].rawAddress.isNotEmpty;
                          bool res =
                              await _authMethods.signInWithGoogle(context);
                          if (res) {
                            Navigator.pushNamed(context, '/home');
                          }
                        } on SocketException catch (_) {
                          Navigator.of(context).pushAndRemoveUntil(
                              new MaterialPageRoute(
                                  builder: (context) => new noInternet()),
                              (route) => route == null);
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                  right: 50.0,
                  top: 20.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 0.8),
                      child: Text(
                        "使用自訂名稱登入",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('example.com');
                        var ans = result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty;
                        bool res = await signInAnonymously(context);
                        if (res) {
                          /*Navigator.of(context).pushAndRemoveUntil(
                          PageAnimationTransition(
                              page: set_information_screen(),
                              pageAnimationType: RightToLeftTransition()),
                          (route) => route == null);*/
                          Navigator.of(context).push(PageAnimationTransition(
                              page: set_information_screen(),
                              pageAnimationType: RightToLeftTransition()));

                          //Navigator.pushNamed(context, '/setInfo');
                        }
                      } on SocketException catch (_) {
                        Navigator.of(context).pushAndRemoveUntil(
                            new MaterialPageRoute(
                                builder: (context) => new noInternet()),
                            (route) => route == null);
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      showSnackBar(context, "此頁圖片來自於 Freepik.com");
                    });
                  },
                  child: Text(
                    "圖片版權說明",
                    style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.3),
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
