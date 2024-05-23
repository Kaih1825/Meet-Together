import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:meet/screens/meeting_screen.dart';

import '../utils/snackBar.dart';

show_AlertDialog_join_Meet(BuildContext context, String name, String photoURL) {
  // Init
  TextEditingController roomNameCon = TextEditingController();
  AlertDialog dialog = AlertDialog(
    title: Text("加入會議室"),
    content: TextField(
      controller: roomNameCon,
      decoration: InputDecoration(
        hintText: "請輸入會議代碼",
      ),
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    actions: [
      ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 0.8),
          child: Text(
            "關閉",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.8),
            child: Text(
              "加入",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          onPressed: () async {
            if (roomNameCon.text.isEmpty) {
              showSnackBar(context, "會議代碼為空，請新增會議代碼");
            } else if (roomNameCon.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>/\，。、：;；~`ˇˋˊ˙=+]')) ||
                roomNameCon.text.contains(RegExp(r"'"))) {
              showSnackBar(context, "請勿輸入特殊字元");
            } else {
              Navigator.pop(context);
              await availableCameras().then((value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => meeting_screen(
                              roomName: roomNameCon.text,
                              name: name,
                              photoURL: photoURL,
                              cameras: value,
                            )),
                  ));
            }
          }),
    ],
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}
// Show the dialog
