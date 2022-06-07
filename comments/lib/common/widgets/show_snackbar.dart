// show a message to enter comment text if the text is empty
import 'package:flutter/material.dart';

void showEnterCommentMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 200,
          right: 20,
          left: 20),
    ),
  );
}
