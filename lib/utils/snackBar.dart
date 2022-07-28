import 'package:flutter/material.dart';
//snackBar就下面會出現的短通知
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}
