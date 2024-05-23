import 'package:flutter/material.dart';

show_AlertDialog_save_list(BuildContext context) {
  // Init
  TextEditingController roomNameCon = TextEditingController();
  TextEditingController customNameCon = TextEditingController();

  void dispose() {
    roomNameCon.dispose();
    customNameCon.dispose();
  }

  AlertDialog dialog = AlertDialog(
    title: Text("請輸入資訊"),
    content: SizedBox(
      height: 101.0,
      child: Column(children: [
        TextField(
          controller: customNameCon,
          decoration: InputDecoration(
            hintText: "請輸入自訂名稱",
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0),
          child: TextField(
            controller: roomNameCon,
            decoration: InputDecoration(
              hintText: "請輸入會議代碼",
            ),
          ),
        ),
      ]),
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
          onPressed: () {
            Navigator.of(context).pop(true);
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
