import 'package:flutter/material.dart';
import 'color.dart';

showAlertDialog(BuildContext context,String text,String buttonText,Function() onPressed) {
  // Init
  AlertDialog dialog = AlertDialog(
    content: Text(text),
    backgroundColor: Theme.of(context).colorScheme.background,
    /*actions: [
      ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Theme.of(context).colorScheme.secondaryContainer),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0.8),
            child: Text(
              buttonText,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          onPressed: onPressed
          ),
    ],*/
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}
  // Show the dialog
  