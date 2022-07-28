import 'dart:io';

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../main.dart';

class noInternet extends StatefulWidget {
  noInternet({Key? key}) : super(key: key);

  @override
  State<noInternet> createState() => _noInternetState();
}

class _noInternetState extends State<noInternet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Theme.of(context).colorScheme.surfaceVariant,
              ),
              child: Icon(
                Icons.wifi_off,
                size: 50,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: Container(
                  width: 130,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0.8),
                      child: Text(
                        "請連接網路",
                        style: TextStyle(
                            fontSize: 20.0,
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  final result = await InternetAddress.lookup('example.com');
                  var res =
                      result.isNotEmpty && result[0].rawAddress.isNotEmpty;
                  Navigator.of(context).pushAndRemoveUntil(
                      new MaterialPageRoute(builder: (context) => new Meet_App()),
                      (route) => route == null);
                } on SocketException catch (_) {}
              },
              child: Text("重整"),
            ),
          ],
        ),
      ),
    );
  }
}
