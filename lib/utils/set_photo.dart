import 'package:flutter/material.dart';

import '../utils/information.dart';

/*set_photoURL_dialog(BuildContext context) {
  // Init
  
}*/
/*Future<bool?> set_photoURL_dialog(BuildContext context){
  TextEditingController urlCon = TextEditingController();
  AlertDialog dialog = AlertDialog(
    title: const Text("設定頭貼"),
    content: TextField(
      controller: urlCon,
      decoration: InputDecoration(hintText: "圖片URL"),
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    actions: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondaryContainer),
          child: Text(
            "關閉",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          onPressed: () {
            urlCon.text.isEmpty
                ? information.photoURL =
                    "https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png"
                : information.photoURL = urlCon.text;
            Navigator.of(context).pop(true);
          }),
    ],
  );
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}*/

Future set_photoURL_dialog(BuildContext context) async {
  late BuildContext dialogContext;
  TextEditingController urlCon = TextEditingController();
  AlertDialog dialog = AlertDialog(
    title: const Text("設定頭貼"),
    content: TextField(
      controller: urlCon,
      decoration: InputDecoration(hintText: "圖片URL"),
    ),
    backgroundColor: Theme.of(context).colorScheme.background,
    actions: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.secondaryContainer),
          child: Text(
            "關閉",
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          onPressed: () {
            urlCon.text.isEmpty
                ? information.photoURL =
                    "https://upload.wikimedia.org/wikipedia/commons/c/cd/Portrait_Placeholder_Square.png"
                : information.photoURL = urlCon.text;
            Navigator.of(context).pop(true);
          }),
    ],
  );
  showDialog(
      context: context,
      builder: (dialogContext) {
        return dialog;
      });
  return null;
}
