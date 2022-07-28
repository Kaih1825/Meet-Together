import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meet/firebase_options.dart';
import 'package:meet/screens/about_screen.dart';
import 'package:meet/screens/login.dart';
import 'package:meet/screens/no_Internet.dart';
import '../utils/information.dart';
import 'utils/color.dart';
import 'screens/home_screen.dart';
import 'auth/firebase_auth_google.dart';
import 'screens/set_information_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'screens/meeting_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/painting.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(Meet_App());
}

class Meet_App extends StatefulWidget {
  Meet_App({Key? key}) : super(key: key);
  @override
  State<Meet_App> createState() => _Meet_AppState();
}

class _Meet_AppState extends State<Meet_App> {
  //static final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: Colors.amber,brightness: Brightness.light,backgroundColor: Colors.white);
  static final _defaultLightColorScheme = ColorScheme.fromSwatch(primarySwatch: black,brightness: Brightness.light,backgroundColor: Colors.white);
  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(primarySwatch: white, brightness: Brightness.dark,backgroundColor: Colors.grey.shade800);
  static bool isInternet = false;

  Future<void> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      var res = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      setState(() {
        isInternet = true;
      });
    } on SocketException catch (_) {

      setState(() {
        isInternet = false;
      });
    }
  }

  @override
  void initState(){
    super.initState();
    isInternetConnected();
  }

  @override
  Widget build(BuildContext context) {
      return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true, //開啟material you(3)
            colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          ),
          home: isInternet==false
          ?noInternet()
          : StreamBuilder(
            stream: AuthMethods().authChanges,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.hasData) {
                return const home_screen();
              }
              return const login_screen();
            },
          ),
          routes: {
            '/main': ((context) => Meet_App()),
            '/login': ((context) => const login_screen()),
            '/setInfo': ((context) => const set_information_screen()),
            '/home': ((context) => const home_screen()),
          },
        );
      });
  }
}
